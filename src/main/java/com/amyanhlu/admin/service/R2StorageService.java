package com.amyanhlu.admin.service;

import jakarta.annotation.PostConstruct;
import jakarta.annotation.PreDestroy;
import jakarta.servlet.http.Part;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;
import software.amazon.awssdk.auth.credentials.AwsBasicCredentials;
import software.amazon.awssdk.auth.credentials.StaticCredentialsProvider;
import software.amazon.awssdk.core.client.config.ClientOverrideConfiguration;
import software.amazon.awssdk.core.sync.RequestBody;
import software.amazon.awssdk.core.exception.SdkClientException;
import software.amazon.awssdk.core.retry.backoff.FullJitterBackoffStrategy;
import software.amazon.awssdk.core.retry.RetryPolicy;
import software.amazon.awssdk.http.apache.ApacheHttpClient;
import software.amazon.awssdk.regions.Region;
import software.amazon.awssdk.services.s3.S3Client;
import software.amazon.awssdk.services.s3.S3Configuration;
import software.amazon.awssdk.services.s3.model.DeleteObjectRequest;
import software.amazon.awssdk.services.s3.model.PutObjectRequest;
import software.amazon.awssdk.services.s3.model.S3Exception;

import java.io.IOException;
import java.io.InputStream;
import java.net.URI;
import java.nio.file.Files;
import java.nio.file.Path;
import java.time.Duration;
import java.util.Locale;
import java.util.Set;
import java.util.UUID;

/**
 * Cloudflare R2 helper (S3-compatible). Uploads images and deletes
 * objects when a later database insert fails.
 */
@Service
public class R2StorageService {

    private static final Logger log = LoggerFactory.getLogger(R2StorageService.class);

    private static final Set<String> ALLOWED_IMAGE_TYPES = Set.of(
            "image/jpeg", "image/jpg", "image/png", "image/webp");

    private static final long MAX_FILE_SIZE_BYTES = 5 * 1024 * 1024L;

    @Value("${cloudflare.r2.endpoint}")
    private String endpoint;

    @Value("${cloudflare.r2.access-key}")
    private String accessKey;

    @Value("${cloudflare.r2.secret-key}")
    private String secretKey;

    @Value("${cloudflare.r2.bucket-name}")
    private String bucketName;

    @Value("${cloudflare.r2.public-url-prefix}")
    private String publicUrlPrefix;

    private S3Client s3Client;

    @PostConstruct
    public void init() {
        System.setProperty("aws.requestChecksumCalculation", "WHEN_REQUIRED");
        System.setProperty("aws.responseChecksumValidation", "WHEN_REQUIRED");

        s3Client = S3Client.builder()
                .endpointOverride(URI.create(endpoint))
                .credentialsProvider(StaticCredentialsProvider.create(
                        AwsBasicCredentials.create(accessKey, secretKey)))
                .region(Region.of("auto"))
                .httpClientBuilder(ApacheHttpClient.builder()
                        .connectionTimeout(Duration.ofSeconds(10))
                        .socketTimeout(Duration.ofSeconds(60))
                        .connectionMaxIdleTime(Duration.ofSeconds(5)))
                .overrideConfiguration(ClientOverrideConfiguration.builder()
                        .retryPolicy(RetryPolicy.builder()
                                .numRetries(5)
                                .backoffStrategy(FullJitterBackoffStrategy.builder()
                                        .baseDelay(Duration.ofMillis(500))
                                        .maxBackoffTime(Duration.ofSeconds(10))
                                        .build())
                                .build())
                        .build())
                .serviceConfiguration(S3Configuration.builder()
                        .pathStyleAccessEnabled(true)
                        .checksumValidationEnabled(false)
                        .build())
                .build();
        log.info("R2StorageService initialised → bucket={}, endpoint={}", bucketName, endpoint);
    }

    @PreDestroy
    public void shutdown() {
        if (s3Client != null) {
            s3Client.close();
        }
    }

    public boolean hasContent(MultipartFile file) {
        return file != null && !file.isEmpty() && file.getSize() > 0;
    }

    public boolean hasContent(Part part) {
        if (part == null || part.getSize() <= 0) {
            return false;
        }
        String submitted = part.getSubmittedFileName();
        return submitted != null && !submitted.isBlank();
    }

    public String uploadFile(MultipartFile file, String directory) throws IOException {
        if (!hasContent(file)) {
            throw new IllegalArgumentException("Upload file must not be empty.");
        }
        Path temp = null;
        try {
            temp = Files.createTempFile("r2-upload-", sanitizeExtension(file.getOriginalFilename()));
            file.transferTo(temp);
            byte[] bytes = Files.readAllBytes(temp);
            return uploadBytes(bytes, file.getContentType(), file.getOriginalFilename(), directory);
        } catch (Exception ex) {
            throw wrapUploadFailure(ex);
        } finally {
            deleteQuietly(temp);
        }
    }

    public String uploadFile(Part part, String directory) throws IOException {
        if (!hasContent(part)) {
            throw new IllegalArgumentException("Upload file must not be empty.");
        }
        Path temp = null;
        try {
            temp = Files.createTempFile("r2-upload-", sanitizeExtension(part.getSubmittedFileName()));
            try (InputStream in = part.getInputStream()) {
                Files.copy(in, temp, java.nio.file.StandardCopyOption.REPLACE_EXISTING);
            }
            byte[] bytes = Files.readAllBytes(temp);
            return uploadBytes(bytes, part.getContentType(), part.getSubmittedFileName(), directory);
        } catch (Exception ex) {
            throw wrapUploadFailure(ex);
        } finally {
            deleteQuietly(temp);
        }
    }

    public String uploadBytes(byte[] fileBytes, String contentType, String originalFilename, String directory)
            throws IOException {
        if (fileBytes == null || fileBytes.length == 0) {
            throw new IOException("Cannot upload an empty file.");
        }
        if (s3Client == null) {
            throw new IOException("R2 client is not initialised. Check Cloudflare R2 configuration.");
        }

        String resolvedType = resolveContentType(contentType, originalFilename);
        String extension = sanitizeExtension(originalFilename);
        String key = directory + "/" + UUID.randomUUID() + extension;

        PutObjectRequest putRequest = PutObjectRequest.builder()
                .bucket(bucketName)
                .key(key)
                .contentType(resolvedType)
                .contentLength((long) fileBytes.length)
                .build();

        try {
            putObject(putRequest, fileBytes, key);
        } catch (S3Exception ex) {
            int status = ex.statusCode();
            String awsMsg = ex.awsErrorDetails() != null
                    ? ex.awsErrorDetails().errorMessage()
                    : ex.getMessage();
            log.error("R2 putObject failed bucket={} key={} status={}: {}",
                    bucketName, key, status, awsMsg, ex);
            if (status == 403 || status == 401) {
                throw new IOException(
                        "Cloudflare R2 denied PutObject access to bucket '" + bucketName
                                + "'. Check that the configured R2 S3 Access Key ID and Secret Access Key "
                                + "have Object Write permission for this bucket. " + awsMsg,
                        ex);
            }
            throw new IOException("Failed to upload to Cloudflare R2 bucket '" + bucketName + "': " + awsMsg, ex);
        } catch (IOException ex) {
            log.warn("Transient R2 upload failure bucket={} key={}: {}", bucketName, key, ex.getMessage());
            throw ex;
        } catch (Exception ex) {
            throw wrapUploadFailure(ex);
        }

        String prefix = publicUrlPrefix == null ? "" : publicUrlPrefix;
        if (prefix.endsWith("/")) {
            prefix = prefix.substring(0, prefix.length() - 1);
        }

        String publicUrl = prefix + "/" + key;
        log.debug("Uploaded file to R2: key={}, url={}", key, publicUrl);
        return publicUrl;
    }

    /**
     * Executes one SDK upload and translates client-side transport failures into
     * the checked exception expected by the service callers.
     */
    private void putObject(PutObjectRequest putRequest, byte[] fileBytes, String key) throws IOException {
        try {
            s3Client.putObject(putRequest, RequestBody.fromBytes(fileBytes));
        } catch (SdkClientException ex) {
            log.warn("R2 transport failure after retries bucket={} key={}: {}",
                    bucketName, key, ex.getMessage());
            throw new IOException(
                    "Cloudflare R2 upload failed because the network connection was interrupted. "
                            + "Please retry the upload.",
                    ex);
        }
    }

    /**
     * Delete an object by R2 key or full public URL. Failures are logged and not
     * rethrown
     * so callers can still roll back the database transaction.
     */
    public void deleteFile(String keyOrUrl) {
        if (keyOrUrl == null || keyOrUrl.isBlank()) {
            log.warn("deleteFile called with blank key — skipping.");
            return;
        }

        String key = extractKey(keyOrUrl);

        try {
            DeleteObjectRequest deleteRequest = DeleteObjectRequest.builder()
                    .bucket(bucketName)
                    .key(key)
                    .build();
            s3Client.deleteObject(deleteRequest);
            log.info("Deleted R2 object: key={}", key);
        } catch (S3Exception ex) {
            log.error("Failed to delete R2 object key={}: {} ({})",
                    key,
                    ex.awsErrorDetails() != null ? ex.awsErrorDetails().errorMessage() : ex.getMessage(),
                    ex.statusCode());
        } catch (Exception ex) {
            log.error("Unexpected error deleting R2 object key={}: {}", key, ex.getMessage(), ex);
        }
    }

    public void validateImageFile(MultipartFile file) {
        if (!hasContent(file)) {
            throw new IllegalArgumentException("NRC image file must not be empty.");
        }
        validateImage(file.getContentType(), file.getSize(), file.getOriginalFilename());
    }

    public void validateImageFile(Part part) {
        if (!hasContent(part)) {
            throw new IllegalArgumentException("NRC image file must not be empty.");
        }
        validateImage(part.getContentType(), part.getSize(), part.getSubmittedFileName());
    }

    public void validateImage(String contentType, long size, String filename) {
        String resolved = resolveContentType(contentType, filename);
        if (resolved == null || !ALLOWED_IMAGE_TYPES.contains(resolved.toLowerCase(Locale.ROOT))) {
            throw new IllegalArgumentException(
                    "Invalid file type '" + contentType + "'. Only JPEG, PNG, and WebP images are accepted.");
        }
        if (size > MAX_FILE_SIZE_BYTES) {
            throw new IllegalArgumentException(
                    "File '" + filename + "' exceeds the 5 MB limit.");
        }
    }

    private String resolveContentType(String contentType, String filename) {
        if (contentType != null && !contentType.isBlank()
                && !"application/octet-stream".equalsIgnoreCase(contentType)) {
            return contentType.toLowerCase(Locale.ROOT).split(";")[0].trim();
        }
        String ext = sanitizeExtension(filename).toLowerCase(Locale.ROOT);
        return switch (ext) {
            case ".jpg", ".jpeg" -> "image/jpeg";
            case ".png" -> "image/png";
            case ".webp" -> "image/webp";
            default -> contentType;
        };
    }

    private String sanitizeExtension(String originalFilename) {
        if (originalFilename != null && originalFilename.contains(".")) {
            String ext = originalFilename.substring(originalFilename.lastIndexOf('.'));
            return ext.replaceAll("[^A-Za-z0-9.]", "");
        }
        return ".bin";
    }

    private IOException wrapUploadFailure(Exception ex) {
        if (ex instanceof IOException io) {
            return io;
        }
        if (ex instanceof IllegalArgumentException iae) {
            return new IOException(iae.getMessage(), iae);
        }
        log.error("R2 upload failed for bucket {}", bucketName, ex);
        return new IOException(
                "Failed to upload to Cloudflare R2 bucket '" + bucketName + "': " + ex.getMessage(), ex);
    }

    private void deleteQuietly(Path temp) {
        if (temp == null) {
            return;
        }
        try {
            Files.deleteIfExists(temp);
        } catch (Exception ex) {
            log.warn("Could not delete temporary upload file {}: {}", temp, ex.getMessage());
        }
    }

    private String extractKey(String keyOrUrl) {
        if (!keyOrUrl.startsWith("http")) {
            return keyOrUrl;
        }
        String prefix = publicUrlPrefix.endsWith("/")
                ? publicUrlPrefix
                : publicUrlPrefix + "/";
        if (keyOrUrl.startsWith(prefix)) {
            return keyOrUrl.substring(prefix.length());
        }
        int bucketIndex = keyOrUrl.indexOf("/" + bucketName + "/");
        if (bucketIndex >= 0) {
            return keyOrUrl.substring(bucketIndex + bucketName.length() + 2);
        }
        log.warn("Could not extract R2 key from URL '{}', using as-is", keyOrUrl);
        return keyOrUrl;
    }
}
