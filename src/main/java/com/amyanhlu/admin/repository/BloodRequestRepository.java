package com.amyanhlu.admin.repository;

import com.amyanhlu.admin.entity.BloodRequest;
import com.amyanhlu.admin.enums.BloodRequestStatus;
import com.amyanhlu.admin.enums.Urgency;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.EntityGraph;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface BloodRequestRepository extends JpaRepository<BloodRequest, Long> {

    @Override
    @EntityGraph(attributePaths = {"hospital", "bloodType"})
    Page<BloodRequest> findAll(Pageable pageable);

    @EntityGraph(attributePaths = {"hospital", "bloodType"})
    Page<BloodRequest> findByStatus(BloodRequestStatus status, Pageable pageable);

    Page<BloodRequest> findByUrgency(Urgency urgency, Pageable pageable);

    @Query("SELECT COUNT(b) FROM BloodRequest b WHERE b.status IN ('OPEN', 'PARTIALLY_FULFILLED')")
    long countOpenRequests();

    List<BloodRequest> findByStatusIn(List<BloodRequestStatus> statuses);
}
