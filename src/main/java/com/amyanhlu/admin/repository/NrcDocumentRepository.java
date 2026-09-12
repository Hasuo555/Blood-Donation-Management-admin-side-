package com.amyanhlu.admin.repository;

import com.amyanhlu.admin.entity.NrcDocument;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;

/**
 * Repository for {@link NrcDocument} entities.
 */
@Repository
public interface NrcDocumentRepository extends JpaRepository<NrcDocument, Long> {

    Optional<NrcDocument> findByDonorId(Long donorId);

    /**
     * Check whether an NRC number already exists in the {@code extracted_text} column
     * (used for Rule R01 — one account per donor identity).
     */
    boolean existsByExtractedText(String extractedText);
}
