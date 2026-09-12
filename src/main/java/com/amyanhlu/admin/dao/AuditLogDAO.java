package com.amyanhlu.admin.dao;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;

import javax.sql.DataSource;

/**
 * JDBC insert-only audit log DAO.
 *
 * <p>The {@code audit_logs} table enforces {@code CHECK (json_valid(old_value))}
 * and {@code CHECK (json_valid(new_value))} constraints in MySQL. MySQL's
 * {@code json_valid(NULL)} evaluates to {@code NULL} (not {@code TRUE}), which
 * causes a constraint-check failure. Therefore <strong>both columns must always
 * contain a syntactically valid JSON string</strong> — we never send SQL NULL.
 *
 * <p>Use {@link #jsonObject(String...)} to build the JSON payload. For CREATE
 * operations where no prior state exists, pass {@code null} or {@code ""} for
 * {@code oldValueJson}; this DAO substitutes {@link #EMPTY_JSON} automatically.
 */
@Repository
public class AuditLogDAO {

    /** Canonical empty-object JSON used when no prior/new state exists. */
    public static final String EMPTY_JSON = "{}";

    private static final ObjectMapper JSON = new ObjectMapper();

    private final JdbcTemplate jdbcTemplate;

    public AuditLogDAO(DataSource dataSource) {
        this.jdbcTemplate = new JdbcTemplate(dataSource);
    }

    /**
     * Insert one audit-log row.
     *
     * @param accountId    the admin account performing the action
     * @param action       action label (e.g. {@code "CREATE"}, {@code "STATUS_CHANGE"})
     * @param entityType   entity type label (e.g. {@code "HOSPITAL"}, {@code "donors"})
     * @param entityId     PK of the affected row
     * @param oldValueJson previous state as a JSON string, or {@code null}/{@code ""} for new records
     * @param newValueJson new state as a JSON string (must not be blank)
     * @param ipAddress    requester IP, may be {@code null}
     */
    public void insert(Long accountId, String action, String entityType, long entityId,
                       String oldValueJson, String newValueJson, String ipAddress) {
        String sql = """
                INSERT INTO audit_logs (account_id, action, entity_type, entity_id, old_value, new_value, ip_address)
                VALUES (?, ?, ?, ?, ?, ?, ?)
                """;
        jdbcTemplate.update(sql,
                accountId,
                action,
                entityType,
                entityId,
                normalizeJson(oldValueJson),
                normalizeJson(newValueJson),
                ipAddress);
    }

    /**
     * Build a JSON object string from alternating key-value pairs.
     *
     * <pre>{@code
     * AuditLogDAO.jsonObject("name", "Mg Mg", "phone", "09791234567")
     * // → {"name":"Mg Mg","phone":"09791234567"}
     * }</pre>
     *
     * <ul>
     *   <li>String values are double-quoted and JSON-escaped.</li>
     *   <li>Values are always quoted and escaped by Jackson, including phone numbers with leading zeroes.</li>
     *   <li>Java {@code null} values are serialised as JSON {@code null}.</li>
     * </ul>
     */
    public static String jsonObject(String... keysAndValues) {
        if (keysAndValues.length % 2 != 0) {
            throw new IllegalArgumentException("jsonObject requires an even number of arguments (key-value pairs)");
        }
        java.util.Map<String, String> values = new java.util.LinkedHashMap<>();
        for (int i = 0; i < keysAndValues.length; i += 2) {
            values.put(keysAndValues[i], keysAndValues[i + 1]);
        }
        try {
            return JSON.writeValueAsString(values);
        } catch (JsonProcessingException ex) {
            throw new IllegalArgumentException("Unable to serialize audit log JSON", ex);
        }
    }

    // -----------------------------------------------------------------------
    // private helpers
    // -----------------------------------------------------------------------

    /**
     * Normalizes a caller-supplied payload and guarantees that {@code json_valid()}
     * always receives a valid JSON string and never SQL NULL. Plain text is wrapped
     * as {@code {"value":"..."}} so a legacy caller cannot violate the constraint.
     */
    private static String normalizeJson(String value) {
        if (value == null || value.isBlank()) {
            return EMPTY_JSON;
        }
        try {
            JsonNode parsed = JSON.readTree(value);
            if (parsed == null) {
                return EMPTY_JSON;
            }
            return JSON.writeValueAsString(parsed);
        } catch (JsonProcessingException ex) {
            // Keep the audit row valid even if a caller supplied plain text.
            try {
                return JSON.writeValueAsString(java.util.Map.of("value", value));
            } catch (JsonProcessingException impossible) {
                throw new IllegalArgumentException("Unable to serialize audit log JSON", impossible);
            }
        }
    }
}
