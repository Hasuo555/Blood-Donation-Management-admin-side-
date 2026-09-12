package com.amyanhlu.admin.service;

import com.amyanhlu.admin.dao.AuditLogDAO;
import com.amyanhlu.admin.entity.Account;
import com.amyanhlu.admin.entity.BloodRequest;
import com.amyanhlu.admin.entity.BloodType;
import com.amyanhlu.admin.entity.Hospital;
import com.amyanhlu.admin.enums.BloodRequestStatus;
import com.amyanhlu.admin.enums.Urgency;
import com.amyanhlu.admin.repository.BloodRequestRepository;
import com.amyanhlu.admin.repository.BloodTypeRepository;
import com.amyanhlu.admin.repository.HospitalRepository;
import jakarta.persistence.EntityNotFoundException;
import jakarta.servlet.http.HttpServletRequest;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;

@Service
public class BloodRequestService {

    private final BloodRequestRepository bloodRequestRepository;
    private final HospitalRepository hospitalRepository;
    private final BloodTypeRepository bloodTypeRepository;
    private final AuditLogService auditLogService;

    public BloodRequestService(BloodRequestRepository bloodRequestRepository,
                               HospitalRepository hospitalRepository,
                               BloodTypeRepository bloodTypeRepository,
                               AuditLogService auditLogService) {
        this.bloodRequestRepository = bloodRequestRepository;
        this.hospitalRepository = hospitalRepository;
        this.bloodTypeRepository = bloodTypeRepository;
        this.auditLogService = auditLogService;
    }

    @Transactional(readOnly = true)
    public Page<BloodRequest> findAll(Pageable pageable) {
        return bloodRequestRepository.findAll(pageable);
    }

    @Transactional(readOnly = true)
    public BloodRequest findById(Long id) {
        return bloodRequestRepository.findById(id)
                .orElseThrow(() -> new EntityNotFoundException("Blood request not found with ID: " + id));
    }

    @Transactional
    public BloodRequest create(Long hospitalId, Long bloodTypeId,
                               Integer unitsRequired, Urgency urgency,
                               String reason, LocalDateTime expiresAt,
                               Account adminAccount, HttpServletRequest request) {
        Hospital hospital = hospitalRepository.findById(hospitalId)
                .orElseThrow(() -> new EntityNotFoundException("Hospital not found"));
        BloodType bloodType = bloodTypeRepository.findById(bloodTypeId)
                .orElseThrow(() -> new EntityNotFoundException("Blood type not found"));

        BloodRequest bloodRequest = new BloodRequest();
        bloodRequest.setHospital(hospital);
        bloodRequest.setBloodType(bloodType);
        bloodRequest.setUnitsRequired(unitsRequired);
        bloodRequest.setUrgency(urgency);
        bloodRequest.setReason(reason);
        bloodRequest.setStatus(BloodRequestStatus.OPEN);
        bloodRequest.setExpiresAt(expiresAt);
        bloodRequest = bloodRequestRepository.save(bloodRequest);

        // Use jsonObject() so hospital names / blood type labels with special
        // characters (quotes, backslashes) do not produce invalid JSON
        auditLogService.log(adminAccount, "CREATE", "BLOOD_REQUEST", bloodRequest.getId(),
                null,
                AuditLogDAO.jsonObject(
                        "hospital", hospital.getName(),
                        "bloodType", bloodType.getDisplayName(),
                        "units", String.valueOf(unitsRequired),
                        "urgency", urgency != null ? urgency.name() : null),
                request);

        return bloodRequest;
    }

    @Transactional
    public void changeStatus(Long id, BloodRequestStatus newStatus,
                             Account adminAccount, HttpServletRequest request) {
        BloodRequest bloodRequest = findById(id);
        BloodRequestStatus oldStatus = bloodRequest.getStatus();

        bloodRequest.setStatus(newStatus);
        bloodRequestRepository.save(bloodRequest);

        auditLogService.log(adminAccount, "STATUS_CHANGE", "BLOOD_REQUEST", id,
                AuditLogDAO.jsonObject("status", oldStatus != null ? oldStatus.name() : null),
                AuditLogDAO.jsonObject("status", newStatus != null ? newStatus.name() : null),
                request);
    }
}
