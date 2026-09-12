package com.amyanhlu.admin.service;

import com.amyanhlu.admin.dao.AuditLogDAO;
import com.amyanhlu.admin.dao.DonorDAO;
import com.amyanhlu.admin.dto.DonorCreateDTO;
import com.amyanhlu.admin.dto.DonorUpdateDTO;
import com.amyanhlu.admin.entity.Account;
import com.amyanhlu.admin.entity.Address;
import com.amyanhlu.admin.entity.Donor;
import com.amyanhlu.admin.entity.NrcDocument;
import com.amyanhlu.admin.enums.AccountStatus;
import com.amyanhlu.admin.enums.Gender;
import com.amyanhlu.admin.repository.AccountRepository;
import com.amyanhlu.admin.repository.AddressRepository;
import com.amyanhlu.admin.repository.BloodTypeRepository;
import com.amyanhlu.admin.repository.DonorRepository;
import com.amyanhlu.admin.repository.NrcDocumentRepository;
import jakarta.persistence.EntityNotFoundException;
import jakarta.servlet.http.HttpServletRequest;
import org.mindrot.jbcrypt.BCrypt;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.security.SecureRandom;
import java.util.UUID;

/**
 * Donor management. Create uses JDBC DAOs (parameter binding) plus R2 uploads.
 */
@Service
public class DonorService {

    private static final Logger log = LoggerFactory.getLogger(DonorService.class);

    private static final String PASSWORD_CHARS = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";
    private static final int TEMP_PASSWORD_LENGTH = 10;

    private final DonorRepository donorRepository;
    private final DonorDAO donorDAO;
    private final AuditLogDAO auditLogDAO;
    private final R2StorageService r2StorageService;
    private final AddressRepository addressRepository;
    private final AccountRepository accountRepository;
    private final BloodTypeRepository bloodTypeRepository;
    private final NrcDocumentRepository nrcDocumentRepository;
    private final NotificationService notificationService;

    public DonorService(DonorRepository donorRepository,
            DonorDAO donorDAO,
            AuditLogDAO auditLogDAO,
            R2StorageService r2StorageService,
            AddressRepository addressRepository,
            AccountRepository accountRepository,
            BloodTypeRepository bloodTypeRepository,
            NrcDocumentRepository nrcDocumentRepository,
            NotificationService notificationService) {
        this.donorRepository = donorRepository;
        this.donorDAO = donorDAO;
        this.auditLogDAO = auditLogDAO;
        this.r2StorageService = r2StorageService;
        this.addressRepository = addressRepository;
        this.accountRepository = accountRepository;
        this.bloodTypeRepository = bloodTypeRepository;
        this.nrcDocumentRepository = nrcDocumentRepository;
        this.notificationService = notificationService;
    }

    @Transactional(readOnly = true)
    public Page<Donor> findAll(Pageable pageable) {
        return donorRepository.findAll(pageable);
    }

    @Transactional(readOnly = true)
    public Page<Donor> searchByKeyword(String keyword, Pageable pageable) {
        if (keyword == null || keyword.isBlank()) {
            return donorRepository.findAll(pageable);
        }
        return donorRepository.searchByKeyword(keyword.trim(), pageable);
    }

    @Transactional(readOnly = true)
    public Donor findById(Long id) {
        return donorRepository.findById(id)
                .orElseThrow(() -> new EntityNotFoundException("Donor not found: " + id));
    }

    /**
     * Create a donor: uniqueness (R01), image validation, BCrypt hash, ACTIVE
     * account,
     * R2 upload, then nrc_documents. Uploaded objects are deleted if the NRC insert
     * fails.
     *
     * @return plaintext temporary password (shown once)
     */
    @Transactional(rollbackFor = Exception.class)
    public String createDonor(DonorCreateDTO dto,
            Account adminAccount,
            HttpServletRequest request) throws IOException {

        String cleanName = trim(dto.getName());
        String cleanPhone = trim(dto.getPhone());
        String cleanNrc = trim(dto.getNrcNumber());
        String gender = parseGender(dto.getGender());

        if (cleanName.isEmpty() || cleanPhone.isEmpty() || cleanNrc.isEmpty()) {
            throw new IllegalArgumentException("Full name, phone number, and NRC number are required.");
        }
        if (dto.getDateOfBirth() == null) {
            throw new IllegalArgumentException("Date of birth is required.");
        }

        String detailAddress = trim(dto.getDetailAddress());
        String township = trim(dto.getTownship());
        String division = trim(dto.getDivision());
        String country = isNotBlank(dto.getCountry()) ? trim(dto.getCountry()) : "Myanmar";

        if (detailAddress.isEmpty() || township.isEmpty() || division.isEmpty()) {
            throw new IllegalArgumentException("Detail address, township, and division are required.");
        }

        if (donorDAO.existsByPhone(cleanPhone)) {
            throw new IllegalArgumentException(
                    "An account with phone number '" + cleanPhone + "' already exists.");
        }

        String cleanEmail = resolveEmail(dto.getEmail(), cleanPhone);
        if (!cleanEmail.contains("@placeholder.") && donorDAO.existsByEmail(cleanEmail)) {
            throw new IllegalArgumentException(
                    "An account with email '" + cleanEmail + "' already exists.");
        }

        if (donorDAO.existsByNrcNumber(cleanNrc)) {
            throw new IllegalArgumentException(
                    "An NRC document with number '" + cleanNrc + "' already exists.");
        }

        MultipartFile nrcFront = dto.getNrcFront();
        MultipartFile nrcBack = dto.getNrcBack();
        if (!r2StorageService.hasContent(nrcFront) || !r2StorageService.hasContent(nrcBack)) {
            throw new IllegalArgumentException("Both NRC front and back images are required.");
        }
        r2StorageService.validateImageFile(nrcFront);
        r2StorageService.validateImageFile(nrcBack);

        Integer bloodTypeId = null;
        if (dto.getBloodTypeId() != null) {
            int id = dto.getBloodTypeId().intValue();
            if (!donorDAO.bloodTypeExists(id)) {
                throw new IllegalArgumentException("Selected blood type is invalid.");
            }
            bloodTypeId = id;
        }

        String rawPassword = resolvePassword(dto);
        String passwordHash = BCrypt.hashpw(rawPassword, BCrypt.gensalt(10));

        long accountId = donorDAO.insertAccount(cleanPhone, cleanEmail, passwordHash, "DONOR", "ACTIVE");
        long addressId = donorDAO.insertAddress(detailAddress, country, division, township);
        long donorId = donorDAO.insertDonor(accountId, cleanName, dto.getDateOfBirth(), gender,
                addressId, bloodTypeId, false);

        String frontUrl = null;
        String backUrl = null;
        try {
            frontUrl = r2StorageService.uploadFile(nrcFront, "nrc");
            backUrl = r2StorageService.uploadFile(nrcBack, "nrc");
            donorDAO.insertNrcDocument(donorId, frontUrl, backUrl, cleanNrc);
        } catch (Exception ex) {
            log.error("NRC upload or insert failed — removing R2 objects", ex);
            r2StorageService.deleteFile(frontUrl);
            r2StorageService.deleteFile(backUrl);
            if (ex instanceof IllegalArgumentException || ex instanceof IOException) {
                throw ex;
            }
            throw new IOException("Failed to store NRC documents: " + ex.getMessage(), ex);
        }

        if (adminAccount != null) {
            String newValue = AuditLogDAO.jsonObject(
                    "donor_id", String.valueOf(donorId),
                    "name", cleanName,
                    "phone", cleanPhone);
            auditLogDAO.insert(adminAccount.getId(), "CREATE_DONOR", "donors",
                    donorId, AuditLogDAO.EMPTY_JSON, newValue, clientIp(request));
        }

        log.info("Donor account created: donorId={}, phone={}", donorId, cleanPhone);
        return rawPassword;
    }

    @Transactional(rollbackFor = Exception.class)
    public void changeStatus(Long donorId, AccountStatus newStatus,
            Account adminAccount, HttpServletRequest request) {
        Donor donor = findById(donorId);
        Account donorAccount = donor.getAccount();
        if (donorAccount == null) {
            throw new IllegalStateException("Donor account is missing for donor ID: " + donorId);
        }
        AccountStatus oldStatus = donorAccount.getStatus();

        donorDAO.updateAccountStatus(donorAccount.getId(), newStatus.name());
        donorAccount.setStatus(newStatus);

        if (adminAccount != null) {
            String oldValue = AuditLogDAO.jsonObject("status", String.valueOf(oldStatus));
            String newValue = AuditLogDAO.jsonObject("status", String.valueOf(newStatus));
            auditLogDAO.insert(adminAccount.getId(), "STATUS_CHANGE", "donors",
                    donorId, oldValue, newValue, clientIp(request));
        }

        // Notify the donor of the status change
        notificationService.createForAccount(
                donorAccount,
                "Your Account Status Has Changed",
                "Your donor account status has been updated to " + newStatus.name()
                        + " by an administrator.",
                "SYSTEM");

        log.info("Donor {} status changed: {} → {}", donorId, oldStatus, newStatus);
    }

    @Transactional(rollbackFor = Exception.class)
    public void updateDonor(Long donorId, DonorUpdateDTO dto,
            Account adminAccount, HttpServletRequest request) {
        Donor donor = findById(donorId);
        Account donorAccount = donor.getAccount();
        if (donorAccount == null) {
            throw new IllegalStateException("Donor account is missing for donor ID: " + donorId);
        }

        String cleanName = trim(dto.getName());
        String cleanPhone = trim(dto.getPhone());
        String cleanEmail = trim(dto.getEmail());
        String gender = parseGender(dto.getGender());
        AccountStatus newStatus = parseAccountStatus(dto.getAccountStatus());

        if (cleanName.isEmpty() || cleanPhone.isEmpty() || dto.getDateOfBirth() == null) {
            throw new IllegalArgumentException("Name, phone, and date of birth are required.");
        }

        if (donorDAO.existsByPhoneExcludingAccount(cleanPhone, donorAccount.getId())) {
            throw new IllegalArgumentException(
                    "An account with phone number '" + cleanPhone + "' already exists.");
        }

        if (!cleanEmail.isEmpty()
                && donorDAO.existsByEmailExcludingAccount(cleanEmail, donorAccount.getId())) {
            throw new IllegalArgumentException(
                    "An account with email '" + cleanEmail + "' already exists.");
        }

        nrcDocumentRepository.findByDonorId(donorId).map(NrcDocument::getExtractedText)
                .filter(nrc -> nrc != null && !nrc.isBlank())
                .ifPresent(nrc -> {
                    if (donorDAO.existsByNrcNumberExcludingDonor(nrc, donorId)) {
                        throw new IllegalArgumentException(
                                "An NRC document with number '" + nrc + "' already exists.");
                    }
                });

        String detailAddress = trim(dto.getDetailAddress());
        String township = trim(dto.getTownship());
        String division = trim(dto.getDivision());
        String country = isNotBlank(dto.getCountry()) ? trim(dto.getCountry()) : "Myanmar";
        if (detailAddress.isEmpty() || township.isEmpty() || division.isEmpty()) {
            throw new IllegalArgumentException("Detail address, township, and division are required.");
        }

        String oldValue = AuditLogDAO.jsonObject(
                "name", donor.getName(),
                "phone", donorAccount.getPhone(),
                "email", donorAccount.getEmail(),
                "status", String.valueOf(donorAccount.getStatus()),
                "gender", donor.getGender() != null ? donor.getGender().name() : null);

        donor.setName(cleanName);
        donor.setDateOfBirth(dto.getDateOfBirth());
        donor.setGender(Gender.valueOf(gender));

        // Blood type update (null = clear / unset)
        if (dto.getBloodTypeId() != null) {
            bloodTypeRepository.findById(dto.getBloodTypeId())
                    .ifPresent(donor::setBloodType);
        } else {
            donor.setBloodType(null);
        }

        Address address = donor.getAddress();
        if (address == null) {
            address = new Address();
        }
        address.setDetailAddress(detailAddress);
        address.setTownship(township);
        address.setDivision(division);
        address.setCountry(country);
        addressRepository.save(address);
        donor.setAddress(address);

        donorAccount.setPhone(cleanPhone);
        if (!cleanEmail.isEmpty()) {
            donorAccount.setEmail(cleanEmail);
        }
        donorAccount.setStatus(newStatus);
        accountRepository.save(donorAccount);

        donorRepository.save(donor);

        if (adminAccount != null) {
            String newValue = AuditLogDAO.jsonObject(
                    "name", cleanName,
                    "phone", cleanPhone,
                    "email", donorAccount.getEmail(),
                    "status", newStatus.name(),
                    "gender", gender);
            auditLogDAO.insert(adminAccount.getId(), "UPDATE_DONOR", "donors",
                    donorId, oldValue, newValue, clientIp(request));
        }

        // Notify the donor that their profile was updated
        notificationService.sendNotification(
                donorAccount.getId(),
                "Profile Updated",
                "Your donor profile details have been updated by an administrator.",
                "SYSTEM");

        log.info("Donor {} updated by admin", donorId);
    }

    private AccountStatus parseAccountStatus(String raw) {
        if (raw == null || raw.isBlank()) {
            throw new IllegalArgumentException("Account status is required.");
        }
        try {
            return AccountStatus.valueOf(raw.trim().toUpperCase());
        } catch (IllegalArgumentException ex) {
            throw new IllegalArgumentException("Account status must be ACTIVE, SUSPENDED, or INACTIVE.");
        }
    }

    private String resolvePassword(DonorCreateDTO dto) {
        String pw = dto.getPassword();
        if (pw != null && !pw.isBlank()) {
            if (!pw.equals(dto.getConfirmPassword())) {
                throw new IllegalArgumentException("Password and Confirm Password do not match.");
            }
            return pw;
        }
        return generateTempPassword();
    }

    private String generateTempPassword() {
        SecureRandom random = new SecureRandom();
        StringBuilder sb = new StringBuilder(TEMP_PASSWORD_LENGTH);
        for (int i = 0; i < TEMP_PASSWORD_LENGTH; i++) {
            sb.append(PASSWORD_CHARS.charAt(random.nextInt(PASSWORD_CHARS.length())));
        }
        return sb.toString();
    }

    private String resolveEmail(String rawEmail, String phone) {
        if (rawEmail != null && !rawEmail.isBlank()) {
            return rawEmail.trim();
        }
        return "donor." + phone + "." + UUID.randomUUID().toString().replace("-", "").substring(0, 8)
                + "@placeholder.amyanhlu";
    }

    private String parseGender(String raw) {
        if (raw == null || raw.isBlank()) {
            throw new IllegalArgumentException("Gender is required.");
        }
        try {
            return Gender.valueOf(raw.trim().toUpperCase()).name();
        } catch (IllegalArgumentException ex) {
            throw new IllegalArgumentException("Gender must be MALE, FEMALE, or OTHER.");
        }
    }

    private static String clientIp(HttpServletRequest request) {
        if (request == null) {
            return null;
        }
        String forwarded = request.getHeader("X-Forwarded-For");
        if (forwarded != null && !forwarded.isBlank()) {
            return forwarded.split(",")[0].trim();
        }
        return request.getRemoteAddr();
    }

    private static String trim(String s) {
        return s == null ? "" : s.trim();
    }

    private static boolean isNotBlank(String s) {
        return s != null && !s.isBlank();
    }
}
