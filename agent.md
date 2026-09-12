# agent.md — AMyanHlu Admin Module Boundary Document

This file defines the **scope, constraints, and conventions** that any AI agent (or developer acting as one) must follow when working in this codebase. Read this before making any changes.

---

## What This Project Is

**AMyanHlu Admin** is a **standalone, server-rendered admin panel** for the AMyanHlu Blood Donation Platform.  
It is a single Spring Boot application packaged as a WAR, exposing only the `/admin/**` route namespace.

It is **not**:
- A REST API or microservice
- A mobile backend
- A donor-facing or staff-facing application (those are separate systems)

---

## Hard Boundaries — What Agents Must NOT Do

### 1. Do not modify the database schema via code
`spring.jpa.hibernate.ddl-auto=none` is intentional and must never be changed.  
All schema changes (new columns, tables, constraints) must be done as SQL scripts in `src/main/resources/db/` and applied manually. Never use `create`, `update`, or `create-drop`.

### 2. Do not introduce new dependencies without justification
The dependency set is intentionally minimal. Do not add frameworks, ORMs, or utility libraries without explicit user approval. Prefer using what is already available:
- Spring Data JPA derived queries before writing custom JPQL
- JSTL tags before adding JavaScript templating
- `JdbcTemplate` (already wired via `AuditLogDAO`) for raw SQL when JPA is inappropriate

### 3. Do not touch the `audit_logs` table via JPA
The `audit_logs` table has `CHECK (json_valid(old_value))` and `CHECK (json_valid(new_value))` constraints. JPA cannot safely write `NULL` to these columns. All writes must go through `AuditLogDAO.insert(...)`. Never call `auditLogRepository.save(...)` directly.

### 4. Do not expose endpoints outside `/admin/**`
All controller mappings must be under `/admin/`. The security filter chain grants access to `/admin/**` for `ROLE_ADMIN` only. Adding public endpoints bypasses this protection.

### 5. Do not loop over all users to create broadcast notifications
A system-wide broadcast creates **exactly one row** in `notifications` with `account_id = 1` (the admin account) and `type = 'SYSTEM'`. Never insert one row per user — that was the original bug.

### 6. Do not delete or alter `AuditLogDAO.java` structure
This DAO is the single safe path for audit writes. Its `normalizeJson` and `jsonObject` helpers are critical for satisfying the DB constraint. Changes here require careful review.

### 7. Do not rename or restructure the package hierarchy
The base package `com.amyanhlu.admin` is assumed throughout. The servlet scanner is bound to `com.amyanhlu.admin.servlet`. Restructuring will silently break servlet registration.

---

## Scope — What Agents Are Allowed to Do

| Area | Allowed Actions |
|---|---|
| **Controllers** | Add/modify `@GetMapping` / `@PostMapping` handlers under `/admin/**` |
| **Services** | Add business logic, fix queries, modify broadcast/notification behavior |
| **Repositories** | Add Spring Data derived query methods or `@Query` JPQL |
| **DTOs** | Add/remove fields with Bean Validation annotations |
| **Entities** | Add new `@Column` fields if the DB column already exists |
| **JSP Views** | Edit layout, forms, tables; add/remove filter fields |
| **`application.properties`** | Add new config keys; never delete existing keys |
| **`AuditLogDAO`** | Extend with new helper methods only; never bypass the JSON normalization |
| **SQL migration scripts** | Add new scripts in `src/main/resources/db/`; never modify existing scripts |

---

## Data Ownership Map

Each entity is owned by one service. Agents must not call repository methods for an entity from outside its owning service (use the service API instead).

| Entity | Owning Service | Notes |
|---|---|---|
| `Account` | `AdminUserDetailsService` (read), owning domain service (write) | Never delete accounts; only change `status` |
| `Donor` | `DonorService` | Status changes must audit-log |
| `Staff` | `StaffService` | One staff per hospital enforced at service layer |
| `Hospital` | `HospitalService` | Cannot deactivate if active staff references it |
| `BloodRequest` | `BloodRequestService` | Status changes must audit-log |
| `Notification` | `NotificationService` | Broadcasts → `account_id = 1`; per-user → target account |
| `AuditLog` | `AuditLogService` → `AuditLogDAO` | Insert-only; no updates or deletes ever |
| `Article` | `ArticleService` | Publish/archive must audit-log |
| `NfcCard` | `NfcCardService` | — |
| `Donation` | Read-only in admin | Admin does not create donation records |
| `Appointment` | Read-only in admin | Admin does not create appointment records |

---

## Notification Rules (Exact)

```
createBroadcast(title, message)
  → 1 row: type=SYSTEM, account_id=1, is_read=false

createForAccount(account, title, message, type)
  → 1 row: type=<given>, account_id=<account.id>, is_read=false
```

The admin list page (`/admin/notifications`) queries only `type = 'SYSTEM'` rows, ordered `created_at DESC`. It must never show per-user notification rows.

---

## Audit Log Rules (Exact)

```
auditLogService.log(account, action, entityType, entityId, oldJson, newJson, request)
```

- `action`: `CREATE`, `UPDATE`, `DELETE`, `STATUS_CHANGE`, `PUBLISH`, `ARCHIVE`, `PASSWORD_CHANGE`, `LOGIN`
- `entityType`: `DONOR`, `STAFF`, `HOSPITAL`, `BLOOD_REQUEST`, `ARTICLE`, `ACCOUNT`, `ADMIN`
- `oldJson` / `newJson`: must be built with `AuditLogDAO.jsonObject(...)` — never a raw string or `null`
- For `CREATE` operations where no prior state exists, pass `null` for `oldJson` — the DAO substitutes `{}`

---

## Filter Sanitization Rule

Any filter parameter coming from an HTTP form that could be submitted as an empty string `""` must be sanitized to `null` **before** being passed to a repository method. JPQL uses `:param IS NULL` to skip conditions; passing `""` causes `WHERE col = ''` which returns zero rows.

```java
// Correct
String entityTypeParam = (entityType != null && !entityType.isBlank()) ? entityType.trim() : null;

// Wrong — passes empty string into JPQL
return repo.findByFilters(entityType, ...);
```

---

## Pagination & Sort Rule

All paginated list endpoints must default to newest-first:

```java
PageRequest.of(page, size, Sort.by(Sort.Direction.DESC, "createdAt"))
```

Never use `PageRequest.of(page, size)` without an explicit `Sort` on a time-ordered resource.

---

## File Storage Rule

All media uploads and deletions must go through `R2StorageService`. Never write file bytes directly to the filesystem or call the AWS SDK directly from a controller or service other than `R2StorageService`.

---

## Security Rule

- All `/admin/**` routes are protected by `ROLE_ADMIN` at the `SecurityConfig` level
- CSRF is currently **disabled** (`csrf.disable()`) — do not re-enable without testing all forms
- Passwords are hashed with BCrypt via Spring Security's `BCryptPasswordEncoder` bean — never store plain-text passwords
- Session invalidation on logout is configured — do not add `remember-me` without explicit approval

---

## Out of Scope (Never Touch)

- The donor-facing mobile app or its API
- The staff-facing portal (separate application)
- Any table not listed in `entity/` — do not create new JPA entities for tables this admin panel does not own
- Email sending (not implemented — do not add SMTP dependencies)
- OAuth / SSO (not in scope — admin login is form-based only)
