package com.amyanhlu.admin.repository;

import com.amyanhlu.admin.entity.Hospital;
import com.amyanhlu.admin.enums.HospitalStatus;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.EntityGraph;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface HospitalRepository extends JpaRepository<Hospital, Long> {

    @EntityGraph(attributePaths = {"address"})
    Page<Hospital> findAll(Pageable pageable);

    @EntityGraph(attributePaths = {"address"})
    Page<Hospital> findByNameContainingIgnoreCase(String keyword, Pageable pageable);

    List<Hospital> findByStatus(HospitalStatus status);
}