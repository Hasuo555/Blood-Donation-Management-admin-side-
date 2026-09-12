package com.amyanhlu.admin.repository;

import com.amyanhlu.admin.entity.Donor;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.EntityGraph;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface DonorRepository extends JpaRepository<Donor, Long> {

       @Override
       @EntityGraph(attributePaths = { "account", "bloodType", "address" })
       Page<Donor> findAll(Pageable pageable);

       @Override
       @EntityGraph(attributePaths = { "account", "bloodType", "address" })
       Optional<Donor> findById(Long id);

       @EntityGraph(attributePaths = { "account", "bloodType", "address" })
       @Query("SELECT d FROM Donor d JOIN d.account a " +
                     "WHERE (:name IS NULL OR LOWER(d.name) LIKE LOWER(CONCAT('%', :name, '%'))) " +
                     "AND (:status IS NULL OR CAST(a.status AS string) = :status) " +
                     "AND (:bloodTypeId IS NULL OR d.bloodType.id = :bloodTypeId)")
       Page<Donor> searchDonors(@Param("name") String name,
                     @Param("status") String status,
                     @Param("bloodTypeId") Long bloodTypeId,
                     Pageable pageable);

       @EntityGraph(attributePaths = { "account", "bloodType", "address" })
       @Query("SELECT d FROM Donor d JOIN d.account a " +
                     "WHERE LOWER(d.name) LIKE LOWER(CONCAT('%', :keyword, '%')) " +
                     "OR LOWER(a.email) LIKE LOWER(CONCAT('%', :keyword, '%')) " +
                     "OR a.phone LIKE CONCAT('%', :keyword, '%')")
       Page<Donor> searchByKeyword(@Param("keyword") String keyword, Pageable pageable);
}