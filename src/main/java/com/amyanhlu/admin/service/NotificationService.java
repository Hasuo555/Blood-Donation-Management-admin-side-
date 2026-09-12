package com.amyanhlu.admin.service;

import com.amyanhlu.admin.entity.Account;
import com.amyanhlu.admin.entity.Notification;
import com.amyanhlu.admin.repository.AccountRepository;
import com.amyanhlu.admin.repository.NotificationRepository;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Set;


@Service
public class NotificationService {

    private static final Set<String> ALLOWED_TYPES = Set.of(
            "APPOINTMENT_CONFIRMED", "APPOINTMENT_REMINDER", "APPOINTMENT_CANCELLED",
            "DONATION_COMPLETED", "BLOOD_TEST_AVAILABLE", "CERTIFICATE_AVAILABLE",
            "CARD_EXPIRING", "CARD_EXPIRED", "ELIGIBLE_TO_DONATE", "EVENT_REQUEST_UPDATED",
            "BLOOD_REQUEST", "SYSTEM");

    private final NotificationRepository notificationRepository;
    private final AccountRepository accountRepository;

    public NotificationService(NotificationRepository notificationRepository,
                               AccountRepository accountRepository) {
        this.notificationRepository = notificationRepository;
        this.accountRepository = accountRepository;
    }

    @Transactional(readOnly = true)
    public Page<Notification> findAll(Pageable pageable) {
        // Include targeted donor, staff, and hospital update notifications.
        return notificationRepository.findAllByOrderByCreatedAtDesc(pageable);
    }

    /**
     * Broadcast a single system-wide notification record.
     * The DB enforces NOT NULL on account_id, so the broadcast row is stored
     * under the admin account (id = 1). The admin list page queries only
     * type = 'SYSTEM', so individual user rows never appear there.
     */
    @Transactional
    public void createBroadcast(String title, String message) {
        Account adminAccount = accountRepository.findById(1L)
                .orElseThrow(() -> new IllegalStateException("Admin account (id=1) not found"));
        Notification notification = new Notification();
        notification.setTitle(title);
        notification.setMessage(message);
        notification.setType("SYSTEM");
        notification.setAccount(adminAccount);
        notification.setIsRead(false);
        notificationRepository.save(notification);
    }

    /**
     * Send a targeted notification to a single account.
     * Used by admin workflows when updating donor / staff / hospital records.
     *
     * @param account the recipient account (must not be {@code null})
     * @param title   notification title
     * @param message notification body
     * @param type    must be one of the DB enum values; falls back to "SYSTEM"
     */
    @Transactional
    public void createForAccount(Account account, String title, String message, String type) {
        if (account == null) {
            return; // defensive – do not throw; audit path should not abort on notification failure
        }
        String dbType = (type != null && ALLOWED_TYPES.contains(type)) ? type : "SYSTEM";
        Notification notification = new Notification();
        notification.setAccount(account);
        notification.setTitle(title);
        notification.setMessage(message);
        notification.setType(dbType);
        notification.setIsRead(false);
        notificationRepository.save(notification);
    }

    /** Send a targeted notification using the recipient's account/user id. */
    @Transactional
    public void sendNotification(Long userId, String title, String message, String type) {
        if (userId == null) {
            return;
        }
        accountRepository.findById(userId)
                .ifPresent(account -> createForAccount(account, title, message, type));
    }
}
