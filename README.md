# AMyanHlu Admin Module

> Server-rendered Spring Boot admin panel for the **AMyanHlu Blood Donation Platform**.

---

## Tech Stack

| Layer | Technology |
|---|---|
| Language | Java 21 |
| Framework | Spring Boot 3.3.5 |
| Security | Spring Security 6 (BCrypt, session-based) |
| Persistence | Spring Data JPA + Hibernate (MySQL dialect) |
| Database | MySQL 8 |
| Connection Pool | HikariCP |
| View Layer | JSP + JSTL (Jakarta EE) |
| File Storage | Cloudflare R2 (AWS S3-compatible SDK v2) |
| Build | Maven (WAR packaging) |
| Dev Reload | Spring Boot DevTools |

---

## Prerequisites

- **JDK 21** (`java -version` must report `21.x`)
- **Maven 3.9+**
- **MySQL 8** running locally on port `3306`
- A Cloudflare R2 bucket (credentials already set in `application.properties`)

---

## Local Setup

### 1. Database

```bash
# Create the schema
mysql -u root -p -e "CREATE DATABASE IF NOT EXISTS amyanhlu_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;"

# Import the full schema + seed data
mysql -u root -p amyanhlu_db < amyanhlu_db.sql

# Apply any pending migrations (analytics tables etc.)
mysql -u root -p amyanhlu_db < src/main/resources/db/analytics-migration.sql
```

Default credentials used by the app (see `application.properties`):
- **User:** `root`
- **Password:** `root`

> Change these before deploying to any shared or production environment.

### 2. Configuration

All runtime config lives in [`src/main/resources/application.properties`](src/main/resources/application.properties).  
**Do not commit secrets.** For production, override with environment variables or an external config file:

```bash
# Example — override datasource without editing the file
export SPRING_DATASOURCE_PASSWORD=your_secure_password
```

Key properties to review before first run:

| Property | Default | Notes |
|---|---|---|
| `server.port` | `8080` | Change if port is occupied |
| `spring.datasource.url` | `localhost:3306/amyanhlu_db` | Point to your MySQL instance |
| `spring.jpa.hibernate.ddl-auto` | `none` | Schema is managed manually via SQL scripts |
| `cloudflare.r2.*` | (set) | R2 bucket credentials for media uploads |
| `cloudflare.r2.public-url-prefix` | `https://amyanhlu-storage.r2.dev` | Public CDN prefix for uploaded files |

### 3. Run

```bash
mvn spring-boot:run
```

The admin panel will be available at: **http://localhost:8080/admin/login**

Default login: use the admin account seeded by `amyanhlu_db.sql` (account with `role = 'ADMIN'`).

---

## Project Structure

```
src/main/java/com/amyanhlu/admin/
│
├── AMyanHluAdminApplication.java   # Spring Boot entry point (also WAR initializer)
│
├── config/
│   ├── SecurityConfig.java         # Spring Security filter chain, BCrypt bean
│   └── WebMvcConfig.java           # MVC extras (static resources, etc.)
│
├── security/
│   ├── AdminUserDetailsService.java # Loads admin account by email for Spring Security
│   └── AdminUserDetails.java        # UserDetails wrapper exposing Account entity
│
├── entity/                          # JPA entities (one class per DB table)
│   ├── Account.java                 # Unified login record (role = ADMIN | DONOR | STAFF)
│   ├── Donor.java / Staff.java      # Role-specific profile tables
│   ├── Hospital.java                # Hospital + address
│   ├── BloodRequest.java            # Emergency blood requests
│   ├── Notification.java            # System & per-user notifications
│   ├── AuditLog.java                # Immutable change log
│   ├── Article.java                 # CMS articles
│   └── ...                          # NfcCard, Donation, Appointment, BloodType, etc.
│
├── enums/                           # DB enum mirrors (AccountStatus, Role, Urgency …)
│
├── repository/                      # Spring Data JPA interfaces (one per entity)
│
├── dao/
│   └── AuditLogDAO.java             # Raw JDBC insert-only DAO (avoids JPA NULL/JSON issues)
│
├── service/                         # Business logic layer
│   ├── NotificationService.java
│   ├── BloodRequestService.java
│   ├── AuditLogService.java
│   ├── DonorService.java
│   ├── HospitalService.java
│   ├── StaffService.java
│   ├── ArticleService.java
│   ├── R2StorageService.java        # File upload / delete against Cloudflare R2
│   └── ...
│
├── controller/                      # Spring MVC @Controller classes (one per feature)
│
├── servlet/
│   └── AdminCreateDonorServlet.java # Legacy HttpServlet for multi-step donor creation
│
└── dto/                             # Form-binding POJOs with Bean Validation annotations

src/main/webapp/WEB-INF/views/admin/
├── layout/
│   ├── header.jsp                   # Shared nav, sidebar, CSS includes
│   └── footer.jsp                   # Shared scripts, closing tags
├── dashboard.jsp
├── login.jsp
├── donors/          list.jsp · create.jsp · edit.jsp · detail.jsp
├── staff/           list.jsp · create.jsp · edit.jsp
├── hospitals/       list.jsp · create.jsp · edit.jsp
├── articles/        list.jsp · create.jsp · edit.jsp
├── emergency-blood/ list.jsp
├── notifications/   list.jsp · create.jsp
├── audit-logs/      list.jsp
└── profile/         edit.jsp
```

---

## Key Conventions

### Audit Logging
Every create / update / status change must write one row to `audit_logs` via `AuditLogService.log(...)`.  
Use `AuditLogDAO.jsonObject(...)` to build the JSON payloads — this ensures values are properly escaped and the DB `json_valid()` CHECK constraint is satisfied.

```java
auditLogService.log(
    adminAccount,
    "STATUS_CHANGE",          // action
    "DONOR",                  // entity type
    donor.getId(),            // entity id
    AuditLogDAO.jsonObject("status", oldStatus.name()),
    AuditLogDAO.jsonObject("status", newStatus.name()),
    httpRequest
);
```

### Notification Conventions
| Scenario | `account_id` | `type` |
|---|---|---|
| Admin system-wide broadcast | `1` (admin account) | `SYSTEM` |
| User-specific (status change, appointment, etc.) | Target user's account ID | Relevant type enum value |

Broadcasts are created via `NotificationService.createBroadcast(title, message)`.  
Per-user notifications use `NotificationService.createForAccount(account, title, message, type)`.

### Pagination
All list endpoints receive `?page=N` (zero-indexed).  
Use `PageRequest.of(page, size, Sort.by(Sort.Direction.DESC, "fieldName"))` to default to newest-first.

### File Uploads
All media goes through `R2StorageService`. Call `uploadFile(MultipartFile, folder)` which returns the public URL to persist.  
File deletion is handled by `deleteFile(publicUrl)`.

### `ddl-auto = none`
Hibernate will **never** modify the schema automatically. All DB changes must be made via SQL scripts in `src/main/resources/db/` and applied manually.

---

## Building a WAR

```bash
mvn clean package -DskipTests
# Output: target/amyanhlu-admin-1.0.0-SNAPSHOT.war
```

Deploy to any Jakarta EE-compatible servlet container (Tomcat 10+).

---

## Common Issues

| Symptom | Likely Cause | Fix |
|---|---|---|
| `Column 'account_id' cannot be null` | Notification inserted without an account reference | Always pass a valid `Account` — use `accountRepository.findById(1L)` for broadcasts |
| `json_valid()` constraint failure | Null or plain-text passed to audit log columns | Use `AuditLogDAO.jsonObject(...)` — never pass raw strings or `null` |
| Filters return zero rows | Empty string (`""`) passed to JPQL `= :param` instead of `null` | Sanitize blank params to `null` before calling repository methods |
| JSP 404 after adding a new view | View resolver prefix/suffix mismatch | Ensure file is at `WEB-INF/views/<path>.jsp` matching the controller return string |
| DevTools not reloading | IDE not compiling on save | Enable "Build project automatically" in IDE, or run `mvn compile` manually |
