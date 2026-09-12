package com.amyanhlu.admin.repository;

import com.amyanhlu.admin.entity.BloodType;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface BloodTypeRepository extends JpaRepository<BloodType, Long> {

    Optional<BloodType> findByDisplayName(String displayName);
}
