package com.amyanhlu.admin.service;

import com.amyanhlu.admin.dao.AuditLogDAO;
import com.amyanhlu.admin.entity.Account;
import com.amyanhlu.admin.entity.Admin;
import com.amyanhlu.admin.repository.AccountRepository;
import com.amyanhlu.admin.repository.AdminRepository;
import jakarta.persistence.EntityNotFoundException;
import jakarta.servlet.http.HttpServletRequest;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
public class AdminProfileService {

    private final AccountRepository accountRepository;
    private final AdminRepository adminRepository;
    private final PasswordEncoder passwordEncoder;
    private final AuditLogService auditLogService;

    public AdminProfileService(AccountRepository accountRepository,
                               AdminRepository adminRepository,
                               PasswordEncoder passwordEncoder,
                               AuditLogService auditLogService) {
        this.accountRepository = accountRepository;
        this.adminRepository = adminRepository;
        this.passwordEncoder = passwordEncoder;
        this.auditLogService = auditLogService;
    }

    @Transactional(readOnly = true)
    public Admin findByAccountId(Long accountId) {
        return adminRepository.findByAccountId(accountId)
                .orElseThrow(() -> new EntityNotFoundException("Admin profile not found"));
    }

    @Transactional
    public void updateName(Long accountId, String newName,
                           Account adminAccount, HttpServletRequest request) {
        Admin admin = findByAccountId(accountId);
        String oldName = admin.getName();
        admin.setName(newName);
        adminRepository.save(admin);

        // Use jsonObject() so special characters in names are safely escaped
        auditLogService.log(adminAccount, "UPDATE_PROFILE", "ADMIN", admin.getId(),
                AuditLogDAO.jsonObject("name", oldName),
                AuditLogDAO.jsonObject("name", newName),
                request);
    }

    @Transactional
    public void changePassword(Long accountId, String currentPassword,
                               String newPassword, Account adminAccount,
                               HttpServletRequest request) {
        Account account = accountRepository.findById(accountId)
                .orElseThrow(() -> new EntityNotFoundException("Account not found"));

        if (!passwordEncoder.matches(currentPassword, account.getPasswordHash())) {
            throw new IllegalArgumentException("Current password is incorrect");
        }

        account.setPasswordHash(passwordEncoder.encode(newPassword));
        account.setPasswordChangedAt(java.time.LocalDateTime.now());
        accountRepository.save(account);

        // Audit log — never log the actual password value
        auditLogService.log(adminAccount, "PASSWORD_CHANGE", "ACCOUNT", accountId,
                null,
                AuditLogDAO.jsonObject("passwordChanged", "true"),
                request);
    }
}
