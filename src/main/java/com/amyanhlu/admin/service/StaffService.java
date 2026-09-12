package com.amyanhlu.admin.service;

import com.amyanhlu.admin.dao.AuditLogDAO;
import com.amyanhlu.admin.dto.StaffUpdateDTO;
import com.amyanhlu.admin.entity.Account;
import com.amyanhlu.admin.entity.Hospital;
import com.amyanhlu.admin.entity.Staff;
import com.amyanhlu.admin.enums.AccountStatus;
import com.amyanhlu.admin.enums.Role;
import com.amyanhlu.admin.enums.StaffStatus;
import com.amyanhlu.admin.repository.AccountRepository;
import com.amyanhlu.admin.repository.HospitalRepository;
import com.amyanhlu.admin.repository.StaffRepository;
import jakarta.persistence.EntityNotFoundException;
import jakarta.servlet.http.HttpServletRequest;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
public class StaffService {

    private final StaffRepository staffRepository;
    private final AccountRepository accountRepository;
    private final HospitalRepository hospitalRepository;
    private final PasswordEncoder passwordEncoder;
    private final AuditLogService auditLogService;
    private final NotificationService notificationService;

    public StaffService(StaffRepository staffRepository,
            AccountRepository accountRepository,
            HospitalRepository hospitalRepository,
            PasswordEncoder passwordEncoder,
            AuditLogService auditLogService,
            NotificationService notificationService) {
        this.staffRepository = staffRepository;
        this.accountRepository = accountRepository;
        this.hospitalRepository = hospitalRepository;
        this.passwordEncoder = passwordEncoder;
        this.auditLogService = auditLogService;
        this.notificationService = notificationService;
    }

    @Transactional(readOnly = true)
    public Page<Staff> findAll(Pageable pageable) {
        return staffRepository.findAll(pageable);
    }

    @Transactional(readOnly = true)
    public Staff findById(Long id) {
        return staffRepository.findById(id)
                .orElseThrow(() -> new EntityNotFoundException("Staff not found with ID: " + id));
    }

    /**
     * Create a staff account assigned to a hospital.
     * Enforces the one-staff-per-hospital constraint.
     * Returns the temporary password.
     */
    @Transactional
    public String createStaff(String name, String email, String phone,
            Long hospitalId, Account adminAccount,
            HttpServletRequest request) {
        // Validate hospital exists
        Hospital hospital = hospitalRepository.findById(hospitalId)
                .orElseThrow(() -> new EntityNotFoundException("Hospital not found with ID: " + hospitalId));

        // Enforce one-staff-per-hospital
        if (staffRepository.existsByHospitalId(hospitalId)) {
            throw new IllegalArgumentException(
                    "Hospital '" + hospital.getName() + "' already has a staff account assigned");
        }

        // Validate unique email/phone
        if (accountRepository.existsByEmail(email)) {
            throw new IllegalArgumentException("An account with this email already exists");
        }
        if (accountRepository.existsByPhone(phone)) {
            throw new IllegalArgumentException("An account with this phone number already exists");
        }

        // Generate temporary password
        String tempPassword = generateTempPassword();

        // Create account
        Account account = new Account();
        account.setEmail(email);
        account.setPhone(phone);
        account.setPasswordHash(passwordEncoder.encode(tempPassword));
        account.setRole(Role.STAFF);
        account.setStatus(AccountStatus.ACTIVE);
        account.setBiometricEnabled(false);
        account = accountRepository.save(account);

        // Create staff profile
        Staff staff = new Staff();
        staff.setAccount(account);
        staff.setHospital(hospital);
        staff.setName(name);
        staff.setStatus(StaffStatus.ACTIVE);
        staffRepository.save(staff);

        // Audit — use jsonObject() for safe, spec-compliant JSON with proper escaping
        auditLogService.log(adminAccount, "CREATE", "STAFF", staff.getId(),
                null,
                AuditLogDAO.jsonObject(
                        "name", name,
                        "hospital", hospital.getName(),
                        "email", email,
                        "phone", phone),
                request);

        return tempPassword;
    }

    @Transactional
    public void changeStatus(Long staffId, StaffStatus newStaffStatus,
            Account adminAccount, HttpServletRequest request) {
        Staff staff = findById(staffId);
        StaffStatus oldStaffStatus = staff.getStatus();

        staff.setStatus(newStaffStatus);
        staffRepository.save(staff);

        // Synchronize account status based on staff status
        AccountStatus newAccountStatus = switch (newStaffStatus) {
            case ACTIVE -> AccountStatus.ACTIVE;
            case SUSPENDED -> AccountStatus.SUSPENDED;
            case INACTIVE -> AccountStatus.INACTIVE;
        };

        Account staffAccount = staff.getAccount();
        staffAccount.setStatus(newAccountStatus);
        accountRepository.save(staffAccount);

        // Audit — use jsonObject() for safe, spec-compliant JSON
        auditLogService.log(adminAccount, "STATUS_CHANGE", "STAFF", staffId,
                AuditLogDAO.jsonObject("status", oldStaffStatus.name()),
                AuditLogDAO.jsonObject("status", newStaffStatus.name()),
                request);

        // Notify the staff account of the status change
        notificationService.createForAccount(
                staffAccount,
                "Your Account Status Has Changed",
                "Your staff account status has been updated to " + newStaffStatus.name()
                        + " by an administrator.",
                "SYSTEM");
    }

    @Transactional
    public void updateStaff(Long staffId, StaffUpdateDTO dto,
            Account adminAccount, HttpServletRequest request) {
        Staff staff = findById(staffId);
        if (staff.getAccount() == null) {
            throw new IllegalStateException("Staff account is missing for staff ID: " + staffId);
        }

        String name = clean(dto.getName());
        String email = clean(dto.getEmail());
        String phone = clean(dto.getPhone());
        if (name.isEmpty() || email.isEmpty() || phone.isEmpty()) {
            throw new IllegalArgumentException("Name, email, and phone are required.");
        }

        StaffStatus newStatus = parseStatus(dto.getStatus());
        Hospital hospital = hospitalRepository.findById(dto.getHospitalId())
                .orElseThrow(() -> new EntityNotFoundException(
                        "Hospital not found with ID: " + dto.getHospitalId()));

        if (staffRepository.existsByHospitalIdAndIdNot(hospital.getId(), staffId)) {
            throw new IllegalArgumentException(
                    "Hospital '" + hospital.getName() + "' already has another staff account assigned.");
        }

        Account staffAccount = staff.getAccount();
        accountRepository.findByEmail(email).ifPresent(existing -> {
            if (!existing.getId().equals(staffAccount.getId())) {
                throw new IllegalArgumentException("An account with this email already exists.");
            }
        });
        accountRepository.findByPhone(phone).ifPresent(existing -> {
            if (!existing.getId().equals(staffAccount.getId())) {
                throw new IllegalArgumentException("An account with this phone number already exists.");
            }
        });

        String oldValue = AuditLogDAO.jsonObject(
                "name", staff.getName(),
                "email", staffAccount.getEmail(),
                "phone", staffAccount.getPhone(),
                "hospital", staff.getHospital() != null ? staff.getHospital().getName() : null,
                "status", staff.getStatus() != null ? staff.getStatus().name() : null);

        staff.setName(name);
        staff.setHospital(hospital);
        staff.setStatus(newStatus);
        staffAccount.setEmail(email);
        staffAccount.setPhone(phone);
        staffAccount.setStatus(accountStatusFor(newStatus));
        accountRepository.save(staffAccount);
        staffRepository.save(staff);

        String newValue = AuditLogDAO.jsonObject(
                "name", name,
                "email", email,
                "phone", phone,
                "hospital", hospital.getName(),
                "status", newStatus.name());
        auditLogService.log(adminAccount, "UPDATE", "STAFF", staffId, oldValue, newValue, request);

        notificationService.sendNotification(
                staffAccount.getId(),
                "Account Details Updated",
                "Your staff account details have been updated by an administrator.",
                "SYSTEM");
    }

    private static StaffStatus parseStatus(String raw) {
        if (raw == null || raw.isBlank()) {
            throw new IllegalArgumentException("Staff status is required.");
        }
        try {
            return StaffStatus.valueOf(raw.trim().toUpperCase());
        } catch (IllegalArgumentException ex) {
            throw new IllegalArgumentException("Invalid staff status.");
        }
    }

    private static AccountStatus accountStatusFor(StaffStatus status) {
        return switch (status) {
            case ACTIVE -> AccountStatus.ACTIVE;
            case SUSPENDED -> AccountStatus.SUSPENDED;
            case INACTIVE -> AccountStatus.INACTIVE;
        };
    }

    private static String clean(String value) {
        return value == null ? "" : value.trim();
    }

    private String generateTempPassword() {
        String chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";
        StringBuilder sb = new StringBuilder(8);
        java.security.SecureRandom random = new java.security.SecureRandom();
        for (int i = 0; i < 8; i++) {
            sb.append(chars.charAt(random.nextInt(chars.length())));
        }
        return sb.toString();
    }
}
