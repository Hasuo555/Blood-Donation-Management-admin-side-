package com.amyanhlu.admin.entity;

import jakarta.persistence.*;
import java.time.LocalDateTime;

/**
 * Maps to the {@code nrc_documents} table.
 * Stores front/back images of a donor's NRC (National Registration Card)
 * uploaded to Cloudflare R2, plus the raw extracted text and verification status.
 */
@Entity
@Table(name = "nrc_documents")
public class NrcDocument {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    /** Owning donor — one NRC document record per donor. */
    @OneToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "donor_id", unique = true, nullable = false)
    private Donor donor;

    /** Full public URL of the NRC front image stored in R2. */
    @Column(name = "front_image", nullable = false, length = 512)
    private String frontImage;

    /** Full public URL of the NRC back image stored in R2. */
    @Column(name = "back_image", nullable = false, length = 512)
    private String backImage;

    /**
     * Raw NRC number text (e.g. "12/KAMAYU(N)012345").
     * Stored in extracted_text column. Nullable — OCR or manual entry.
     */
    @Column(name = "extracted_text", columnDefinition = "TEXT")
    private String extractedText;

    /** Whether the document has been verified by staff. Defaults to false. */
    @Column(name = "verified", nullable = false)
    private Boolean verified = false;

    @Column(name = "verified_at")
    private LocalDateTime verifiedAt;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "verified_by_staff_id")
    private Staff verifiedByStaff;

    @Column(name = "created_at", updatable = false)
    private LocalDateTime createdAt;

    @Column(name = "updated_at")
    private LocalDateTime updatedAt;

    @PrePersist
    protected void onCreate() {
        createdAt = LocalDateTime.now();
        updatedAt = LocalDateTime.now();
        if (verified == null) {
            verified = false;
        }
    }

    @PreUpdate
    protected void onUpdate() {
        updatedAt = LocalDateTime.now();
    }

    // --- Getters and Setters ---

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public Donor getDonor() { return donor; }
    public void setDonor(Donor donor) { this.donor = donor; }

    public String getFrontImage() { return frontImage; }
    public void setFrontImage(String frontImage) { this.frontImage = frontImage; }

    public String getBackImage() { return backImage; }
    public void setBackImage(String backImage) { this.backImage = backImage; }

    public String getExtractedText() { return extractedText; }
    public void setExtractedText(String extractedText) { this.extractedText = extractedText; }

    public Boolean getVerified() { return verified; }
    public void setVerified(Boolean verified) { this.verified = verified; }

    public LocalDateTime getVerifiedAt() { return verifiedAt; }
    public void setVerifiedAt(LocalDateTime verifiedAt) { this.verifiedAt = verifiedAt; }

    public Staff getVerifiedByStaff() { return verifiedByStaff; }
    public void setVerifiedByStaff(Staff verifiedByStaff) { this.verifiedByStaff = verifiedByStaff; }

    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }

    public LocalDateTime getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(LocalDateTime updatedAt) { this.updatedAt = updatedAt; }
}
