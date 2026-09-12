package com.amyanhlu.admin.service;

import com.amyanhlu.admin.dao.AuditLogDAO;
import com.amyanhlu.admin.entity.Account;
import com.amyanhlu.admin.entity.Address;
import com.amyanhlu.admin.entity.Hospital;
import com.amyanhlu.admin.enums.HospitalStatus;
import com.amyanhlu.admin.repository.AddressRepository;
import com.amyanhlu.admin.repository.HospitalRepository;
import com.amyanhlu.admin.repository.StaffRepository;
import jakarta.persistence.EntityNotFoundException;
import jakarta.servlet.http.HttpServletRequest;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
public class HospitalService {

    private final HospitalRepository hospitalRepository;
    private final AddressRepository addressRepository;
    private final AuditLogService auditLogService;
    private final NotificationService notificationService;
    private final StaffRepository staffRepository;

    public HospitalService(HospitalRepository hospitalRepository,
                           AddressRepository addressRepository,
                           AuditLogService auditLogService,
                           NotificationService notificationService,
                           StaffRepository staffRepository) {
        this.hospitalRepository = hospitalRepository;
        this.addressRepository = addressRepository;
        this.auditLogService = auditLogService;
        this.notificationService = notificationService;
        this.staffRepository = staffRepository;
    }

    @Transactional(readOnly = true)
    public Page<Hospital> findAll(Pageable pageable) {
        return hospitalRepository.findAll(pageable);
    }

    @Transactional(readOnly = true)
    public Hospital findById(Long id) {
        return hospitalRepository.findById(id)
                .orElseThrow(() -> new EntityNotFoundException("Hospital not found with ID: " + id));
    }

    @Transactional(readOnly = true)
    public List<Hospital> findActiveHospitals() {
        return hospitalRepository.findByStatus(HospitalStatus.ACTIVE);
    }

    @Transactional(readOnly = true)
    public List<Hospital> findAllHospitals() {
        return hospitalRepository.findAll();
    }

    @Transactional
    public Hospital create(String name, String phone, String email,
                           String detailAddress, String country,
                           String division, String township,
                           Account adminAccount, HttpServletRequest request) {
        // Create address
        Address address = new Address();
        address.setDetailAddress(detailAddress);
        address.setCountry(country);
        address.setDivision(division);
        address.setTownship(township);
        address = addressRepository.save(address);

        // Create hospital
        Hospital hospital = new Hospital();
        hospital.setName(name);
        hospital.setPhone(phone);
        hospital.setEmail(email);
        hospital.setAddress(address);
        hospital.setStatus(HospitalStatus.ACTIVE);
        hospital = hospitalRepository.save(hospital);

        // Audit — use jsonObject() to ensure valid JSON and safe escaping
        auditLogService.log(adminAccount, "CREATE", "HOSPITAL", hospital.getId(),
                AuditLogDAO.EMPTY_JSON,
                AuditLogDAO.jsonObject("name", name, "phone", phone, "email", email),
                request);

        return hospital;
    }

    @Transactional
    public Hospital update(Long id, String name, String phone, String email,
                           String detailAddress, String country,
                           String division, String township,
                           Account adminAccount, HttpServletRequest request) {
        Hospital hospital = findById(id);

        // Capture old values for audit before mutation
        String oldJson = AuditLogDAO.jsonObject(
                "name", hospital.getName(),
                "phone", hospital.getPhone(),
                "email", hospital.getEmail());

        hospital.setName(name);
        hospital.setPhone(phone);
        hospital.setEmail(email);

        // Update address
        Address address = hospital.getAddress();
        if (address == null) {
            address = new Address();
        }
        address.setDetailAddress(detailAddress);
        address.setCountry(country);
        address.setDivision(division);
        address.setTownship(township);
        addressRepository.save(address);
        hospital.setAddress(address);

        hospital = hospitalRepository.save(hospital);

        String newJson = AuditLogDAO.jsonObject(
                "name", name, "phone", phone, "email", email);

        auditLogService.log(adminAccount, "UPDATE", "HOSPITAL", hospital.getId(),
                oldJson, newJson, request);

        notifyHospitalAccount(id, adminAccount,
                "Hospital Profile Updated",
                "Your hospital details have been updated by an administrator.");

        return hospital;
    }

    @Transactional
    public void changeStatus(Long hospitalId, HospitalStatus newStatus,
                             Account adminAccount, HttpServletRequest request) {
        Hospital hospital = findById(hospitalId);
        HospitalStatus oldStatus = hospital.getStatus();

        hospital.setStatus(newStatus);
        hospitalRepository.save(hospital);

        auditLogService.log(adminAccount, "STATUS_CHANGE", "HOSPITAL", hospitalId,
                AuditLogDAO.jsonObject("status", oldStatus.name()),
                AuditLogDAO.jsonObject("status", newStatus.name()),
                request);

        notifyHospitalAccount(hospitalId, adminAccount,
                "Hospital Status Changed",
                "The status of your hospital \"" + hospital.getName()
                        + "\" has been changed to " + newStatus.name() + " by an administrator.");
    }

    @Transactional
    public void updateProfilePicture(Long hospitalId, String imageUrl,
                                     Account adminAccount, HttpServletRequest request) {
        Hospital hospital = findById(hospitalId);
        hospital.setProfilePicture(imageUrl);
        hospitalRepository.save(hospital);

        auditLogService.log(adminAccount, "UPDATE_PICTURE", "HOSPITAL", hospitalId,
                null,
                AuditLogDAO.jsonObject("profilePicture", imageUrl),
                request);

    }

    /**
     * Notify the assigned hospital staff account and the admin who performed
     * the update. The latter guarantees that the event appears on the Admin
     * Notifications management page even when staff notifications are viewed
     * separately by the recipient application.
     */
    private void notifyHospitalAccount(Long hospitalId, Account adminAccount,
                                       String title, String message) {
        staffRepository.findByHospitalId(hospitalId).ifPresentOrElse(staff -> {
            Account staffAccount = staff.getAccount();
            if (staffAccount != null) {
                notificationService.sendNotification(staffAccount.getId(), title, message, "SYSTEM");
            }

            if (adminAccount != null
                    && (staffAccount == null || !adminAccount.getId().equals(staffAccount.getId()))) {
                notificationService.sendNotification(adminAccount.getId(), title, message, "SYSTEM");
            }
        }, () -> {
            if (adminAccount != null) {
                notificationService.sendNotification(adminAccount.getId(), title, message, "SYSTEM");
            }
        });
    }
}
