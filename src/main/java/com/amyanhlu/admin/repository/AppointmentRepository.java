package com.amyanhlu.admin.repository;

import com.amyanhlu.admin.entity.Appointment;
import com.amyanhlu.admin.enums.AppointmentStatus;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface AppointmentRepository extends JpaRepository<Appointment, Long> {

    long countByStatus(AppointmentStatus status);
}
