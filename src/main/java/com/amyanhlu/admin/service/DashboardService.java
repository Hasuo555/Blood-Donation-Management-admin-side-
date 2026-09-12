package com.amyanhlu.admin.service;

import com.amyanhlu.admin.enums.DonationStatus;
import com.amyanhlu.admin.enums.StaffStatus;
import com.amyanhlu.admin.repository.*;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.HashMap;
import java.util.Map;

@Service
public class DashboardService {

    private final DonorRepository donorRepository;
    private final StaffRepository staffRepository;
    private final HospitalRepository hospitalRepository;
    private final AppointmentRepository appointmentRepository;
    private final DonationRepository donationRepository;
    private final BloodRequestRepository bloodRequestRepository;
    private final AuditLogRepository auditLogRepository;

    public DashboardService(DonorRepository donorRepository,
                            StaffRepository staffRepository,
                            HospitalRepository hospitalRepository,
                            AppointmentRepository appointmentRepository,
                            DonationRepository donationRepository,
                            BloodRequestRepository bloodRequestRepository,
                            AuditLogRepository auditLogRepository) {
        this.donorRepository = donorRepository;
        this.staffRepository = staffRepository;
        this.hospitalRepository = hospitalRepository;
        this.appointmentRepository = appointmentRepository;
        this.donationRepository = donationRepository;
        this.bloodRequestRepository = bloodRequestRepository;
        this.auditLogRepository = auditLogRepository;
    }

    @Transactional(readOnly = true)
    public Map<String, Long> getDashboardMetrics() {
        Map<String, Long> metrics = new HashMap<>();
        metrics.put("totalDonors", donorRepository.count());
        metrics.put("activeStaff", staffRepository.countByStatus(StaffStatus.ACTIVE));
        metrics.put("totalHospitals", hospitalRepository.count());
        metrics.put("totalAppointments", appointmentRepository.count());
        metrics.put("completedDonations", donationRepository.countByStatus(DonationStatus.COMPLETED));
        metrics.put("emergencyRequests", bloodRequestRepository.countOpenRequests());
        metrics.put("totalAuditLogs", auditLogRepository.count());
        return metrics;
    }
}
