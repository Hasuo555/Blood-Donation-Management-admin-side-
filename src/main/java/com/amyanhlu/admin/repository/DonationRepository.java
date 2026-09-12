package com.amyanhlu.admin.repository;

import com.amyanhlu.admin.entity.Donation;
import com.amyanhlu.admin.enums.DonationStatus;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface DonationRepository extends JpaRepository<Donation, Long> {

    long countByStatus(DonationStatus status);
}
