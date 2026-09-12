package com.amyanhlu.admin.service;

import com.amyanhlu.admin.dao.AuditLogDAO;
import com.amyanhlu.admin.entity.Account;
import com.amyanhlu.admin.entity.AuditLog;
import com.amyanhlu.admin.repository.AuditLogRepository;
import jakarta.servlet.http.HttpServletRequest;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;

/**
 * Immutable audit logging — records are created but never updated or deleted
 * through the normal admin UI.
 *
 * <p><strong>JSON constraint:</strong> The {@code audit_logs} table enforces
 * {@code CHECK (json_valid(old_value))} and {@code CHECK (json_valid(new_value))}.
 * MySQL evaluates {@code json_valid(NULL)} as {@code NULL} (not {@code TRUE}),
 * which fails the constraint. All writes are therefore routed through
 * {@link AuditLogDAO#insert} which substitutes {@code "{}"} for any null/blank
 * value, guaranteeing the constraint is always satisfied.
 *
 * <p>Use {@link #jsonObject(String...)} (delegating to
 * {@link AuditLogDAO#jsonObject(String...)}) to safely build JSON strings with
 * proper escaping before passing them to {@link #log}.
 */
@Service
public class AuditLogService {

    private final AuditLogDAO auditLogDAO;
    private final AuditLogRepository auditLogRepository;

    public AuditLogService(AuditLogDAO auditLogDAO,
                           AuditLogRepository auditLogRepository) {
        this.auditLogDAO = auditLogDAO;
        this.auditLogRepository = auditLogRepository;
    }

    /**
     * Convenience alias for {@link AuditLogDAO#jsonObject(String...)} so callers
     * that go through this service don't need to import the DAO directly.
     */
    public static String jsonObject(String... keysAndValues) {
        return AuditLogDAO.jsonObject(keysAndValues);
    }

    /**
     * Write one audit-log entry.
     *
     * <p>Uses JDBC ({@link AuditLogDAO#insert}) rather than JPA so that
     * null/blank {@code oldValue} and {@code newValue} are automatically
     * converted to {@code "{}"} before the SQL is executed — avoiding the
     * {@code json_valid(NULL)} CHECK constraint failure.
     *
     * @param account    the admin account performing the action (may be {@code null})
     * @param action     action label, e.g. {@code "CREATE"}, {@code "STATUS_CHANGE"}
     * @param entityType entity type label, e.g. {@code "HOSPITAL"}, {@code "donors"}
     * @param entityId   PK of the affected row
     * @param oldValue   previous state as JSON built with {@link #jsonObject}, or {@code null} for new records
     * @param newValue   new state as JSON built with {@link #jsonObject}
     * @param request    HTTP request used to extract the client IP (may be {@code null})
     */
    @Transactional
    public void log(Account account, String action, String entityType,
                    Long entityId, String oldValue, String newValue,
                    HttpServletRequest request) {
        Long accountId = (account != null) ? account.getId() : null;
        auditLogDAO.insert(
                accountId,
                action,
                entityType,
                entityId != null ? entityId : 0L,
                oldValue,   // AuditLogDAO normalizes null/blank/non-JSON values before INSERT
                newValue,
                getClientIpAddress(request));
    }

    @Transactional(readOnly = true)
    public Page<AuditLog> findAll(Pageable pageable) {
        return auditLogRepository.findAllByOrderByCreatedAtDesc(pageable);
    }

    @Transactional(readOnly = true)
    public Page<AuditLog> findByFilters(String entityType, String action,
                                         LocalDateTime startDate, LocalDateTime endDate,
                                         String performer,
                                         Pageable pageable) {
        // Convert blank/empty strings to null so the JPQL ":param IS NULL" branch
        // correctly skips the condition instead of matching "WHERE col = ''".
        String entityTypeParam  = (entityType  != null && !entityType.isBlank())  ? entityType.trim()  : null;
        String actionParam      = (action      != null && !action.isBlank())      ? action.trim()      : null;
        String performerParam   = (performer   != null && !performer.isBlank())
                ? "%" + performer.toLowerCase().trim() + "%" : null;
        return auditLogRepository.findByFiltersOrderByCreatedAtDesc(
                entityTypeParam, actionParam, startDate, endDate, performerParam, pageable);
    }

    private String getClientIpAddress(HttpServletRequest request) {
        if (request == null) return null;
        String xForwardedFor = request.getHeader("X-Forwarded-For");
        if (xForwardedFor != null && !xForwardedFor.isEmpty()) {
            return xForwardedFor.split(",")[0].trim();
        }
        return request.getRemoteAddr();
    }
}
