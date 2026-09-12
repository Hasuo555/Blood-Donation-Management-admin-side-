package com.amyanhlu.admin.repository;

import com.amyanhlu.admin.entity.NfcCard;
import org.springframework.data.jpa.repository.EntityGraph;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface NfcCardRepository extends JpaRepository<NfcCard, Long> {

    @EntityGraph(attributePaths = {"issuedByHospital"})
    List<NfcCard> findByDonorIdOrderByIssuedAtDesc(Long donorId);

    @EntityGraph(attributePaths = {"donor", "issuedByHospital"})
    Optional<NfcCard> findByIdAndDonorId(Long id, Long donorId);
}
