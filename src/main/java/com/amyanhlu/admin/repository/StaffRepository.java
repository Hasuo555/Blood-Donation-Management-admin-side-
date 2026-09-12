package com.amyanhlu.admin.repository;

import com.amyanhlu.admin.entity.Staff;
import com.amyanhlu.admin.enums.StaffStatus;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.EntityGraph;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface StaffRepository extends JpaRepository<Staff, Long> {

    @Override
    @EntityGraph(attributePaths = { "account", "hospital" })
    Page<Staff> findAll(Pageable pageable);

    @Override
    @EntityGraph(attributePaths = { "account", "hospital" })
    Optional<Staff> findById(Long id);

    @EntityGraph(attributePaths = { "account", "hospital" })
    Page<Staff> findByStatus(StaffStatus status, Pageable pageable);

    Optional<Staff> findByHospitalId(Long hospitalId);

    Optional<Staff> findByAccountId(Long accountId);

    boolean existsByHospitalId(Long hospitalId);

    boolean existsByHospitalIdAndIdNot(Long hospitalId, Long id);

    long countByStatus(StaffStatus status);
}
