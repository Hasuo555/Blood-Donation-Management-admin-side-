package com.amyanhlu.admin.repository;

import com.amyanhlu.admin.entity.AuditLog;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.EntityGraph;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.time.LocalDateTime;

@Repository
public interface AuditLogRepository extends JpaRepository<AuditLog, Long> {

    @EntityGraph(attributePaths = "account")
    Page<AuditLog> findByEntityType(String entityType, Pageable pageable);

    @EntityGraph(attributePaths = "account")
    Page<AuditLog> findByAction(String action, Pageable pageable);

    @EntityGraph(attributePaths = "account")
    @Query(value = "SELECT a FROM AuditLog a LEFT JOIN a.account acc WHERE " +
           "(:entityType IS NULL OR a.entityType = :entityType) " +
           "AND (:action IS NULL OR a.action = :action) " +
           "AND (:startDate IS NULL OR a.createdAt >= :startDate) " +
           "AND (:endDate IS NULL OR a.createdAt <= :endDate) " +
           "AND (:performer IS NULL OR LOWER(acc.email) LIKE :performer)",
           countQuery = "SELECT COUNT(a) FROM AuditLog a LEFT JOIN a.account acc WHERE " +
           "(:entityType IS NULL OR a.entityType = :entityType) " +
           "AND (:action IS NULL OR a.action = :action) " +
           "AND (:startDate IS NULL OR a.createdAt >= :startDate) " +
           "AND (:endDate IS NULL OR a.createdAt <= :endDate) " +
           "AND (:performer IS NULL OR LOWER(acc.email) LIKE :performer)")
    Page<AuditLog> findByFilters(@Param("entityType") String entityType,
                                  @Param("action") String action,
                                  @Param("startDate") LocalDateTime startDate,
                                  @Param("endDate") LocalDateTime endDate,
                                  @Param("performer") String performer,
                                  Pageable pageable);

    /**
     * Same rich filter as above but always sorted newest-first — used by the admin audit log UI.
     * A dedicated countQuery is required because Spring Data cannot derive a COUNT query from a
     * JPQL statement that contains an explicit ORDER BY clause.
     */
    @EntityGraph(attributePaths = "account")
    @Query(value = "SELECT a FROM AuditLog a LEFT JOIN a.account acc WHERE " +
           "(:entityType IS NULL OR a.entityType = :entityType) " +
           "AND (:action IS NULL OR a.action = :action) " +
           "AND (:startDate IS NULL OR a.createdAt >= :startDate) " +
           "AND (:endDate IS NULL OR a.createdAt <= :endDate) " +
           "AND (:performer IS NULL OR LOWER(acc.email) LIKE :performer) " +
           "ORDER BY a.createdAt DESC, a.id DESC",
           countQuery = "SELECT COUNT(a) FROM AuditLog a LEFT JOIN a.account acc WHERE " +
           "(:entityType IS NULL OR a.entityType = :entityType) " +
           "AND (:action IS NULL OR a.action = :action) " +
           "AND (:startDate IS NULL OR a.createdAt >= :startDate) " +
           "AND (:endDate IS NULL OR a.createdAt <= :endDate) " +
           "AND (:performer IS NULL OR LOWER(acc.email) LIKE :performer)")
    Page<AuditLog> findByFiltersOrderByCreatedAtDesc(@Param("entityType") String entityType,
                                                      @Param("action") String action,
                                                      @Param("startDate") LocalDateTime startDate,
                                                      @Param("endDate") LocalDateTime endDate,
                                                      @Param("performer") String performer,
                                                      Pageable pageable);


    @EntityGraph(attributePaths = "account")
    Page<AuditLog> findAllByOrderByCreatedAtDescIdDesc(Pageable pageable);
}
