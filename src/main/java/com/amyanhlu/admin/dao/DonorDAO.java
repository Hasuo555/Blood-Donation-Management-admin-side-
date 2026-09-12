package com.amyanhlu.admin.dao;

import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.support.GeneratedKeyHolder;
import org.springframework.jdbc.support.KeyHolder;
import org.springframework.stereotype.Repository;

import javax.sql.DataSource;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.Statement;
import java.time.LocalDate;

/**
 * JDBC DAO for donor account creation. Uses bound parameters (no string
 * concatenation)
 * and the application DataSource (HikariCP connection pool).
 */
@Repository
public class DonorDAO {

    private final JdbcTemplate jdbcTemplate;

    public DonorDAO(DataSource dataSource) {
        this.jdbcTemplate = new JdbcTemplate(dataSource);
    }

    public boolean existsByPhone(String phone) {
        Integer count = jdbcTemplate.queryForObject(
                "SELECT COUNT(*) FROM accounts WHERE phone = ?",
                Integer.class,
                phone);
        return count != null && count > 0;
    }

    public boolean existsByPhoneExcludingAccount(String phone, long accountId) {
        Integer count = jdbcTemplate.queryForObject(
                "SELECT COUNT(*) FROM accounts WHERE phone = ? AND id <> ?",
                Integer.class,
                phone, accountId);
        return count != null && count > 0;
    }

    public boolean existsByEmail(String email) {
        Integer count = jdbcTemplate.queryForObject(
                "SELECT COUNT(*) FROM accounts WHERE email = ?",
                Integer.class,
                email);
        return count != null && count > 0;
    }

    public boolean existsByEmailExcludingAccount(String email, long accountId) {
        Integer count = jdbcTemplate.queryForObject(
                "SELECT COUNT(*) FROM accounts WHERE email = ? AND id <> ?",
                Integer.class,
                email, accountId);
        return count != null && count > 0;
    }

    public boolean existsByNrcNumber(String nrcNumber) {
        Integer count = jdbcTemplate.queryForObject(
                "SELECT COUNT(*) FROM nrc_documents WHERE extracted_text = ?",
                Integer.class,
                nrcNumber);
        return count != null && count > 0;
    }

    public boolean existsByNrcNumberExcludingDonor(String nrcNumber, long donorId) {
        Integer count = jdbcTemplate.queryForObject(
                "SELECT COUNT(*) FROM nrc_documents WHERE extracted_text = ? AND donor_id <> ?",
                Integer.class,
                nrcNumber, donorId);
        return count != null && count > 0;
    }

    public long insertAccount(String phone, String email, String passwordHash, String role, String status) {
        String sql = """
                INSERT INTO accounts (phone, email, password_hash, role, status, biometric_enabled)
                VALUES (?, ?, ?, ?, ?, 0)
                """;
        KeyHolder keyHolder = new GeneratedKeyHolder();
        jdbcTemplate.update(connection -> {
            PreparedStatement ps = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            ps.setString(1, phone);
            ps.setString(2, email);
            ps.setString(3, passwordHash);
            ps.setString(4, role);
            ps.setString(5, status);
            return ps;
        }, keyHolder);
        return requireGeneratedId(keyHolder, "account");
    }

    public long insertAddress(String detailAddress, String country, String division, String township) {
        String sql = """
                INSERT INTO addresses (detail_address, country, division, township)
                VALUES (?, ?, ?, ?)
                """;
        KeyHolder keyHolder = new GeneratedKeyHolder();
        jdbcTemplate.update(connection -> {
            PreparedStatement ps = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            ps.setString(1, detailAddress);
            ps.setString(2, country);
            ps.setString(3, division);
            ps.setString(4, township);
            return ps;
        }, keyHolder);
        return requireGeneratedId(keyHolder, "address");
    }

    public long insertDonor(long accountId, String name, LocalDate dateOfBirth, String gender,
            long addressId, Integer bloodTypeId, boolean bloodTypeVerified) {
        String sql = """
                INSERT INTO donors (account_id, name, date_of_birth, gender, address_id,
                                    blood_type_id, blood_type_verified)
                VALUES (?, ?, ?, ?, ?, ?, ?)
                """;
        KeyHolder keyHolder = new GeneratedKeyHolder();
        jdbcTemplate.update(connection -> {
            PreparedStatement ps = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            ps.setLong(1, accountId);
            ps.setString(2, name);
            ps.setDate(3, Date.valueOf(dateOfBirth));
            ps.setString(4, gender);
            ps.setLong(5, addressId);
            if (bloodTypeId != null) {
                ps.setInt(6, bloodTypeId);
            } else {
                ps.setNull(6, java.sql.Types.INTEGER);
            }
            ps.setBoolean(7, bloodTypeVerified);
            return ps;
        }, keyHolder);
        return requireGeneratedId(keyHolder, "donor");
    }

    public long insertNrcDocument(long donorId, String frontImageUrl, String backImageUrl, String nrcNumber) {
        String sql = """
                INSERT INTO nrc_documents (donor_id, front_image, back_image, extracted_text, verified)
                VALUES (?, ?, ?, ?, 0)
                """;
        KeyHolder keyHolder = new GeneratedKeyHolder();
        jdbcTemplate.update(connection -> {
            PreparedStatement ps = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            ps.setLong(1, donorId);
            ps.setString(2, frontImageUrl);
            ps.setString(3, backImageUrl);
            ps.setString(4, nrcNumber);
            return ps;
        }, keyHolder);
        return requireGeneratedId(keyHolder, "nrc_document");
    }

    public void updateAccountStatus(long accountId, String status) {
        jdbcTemplate.update("UPDATE accounts SET status = ? WHERE id = ?", status, accountId);
    }

    public boolean bloodTypeExists(int bloodTypeId) {
        Integer count = jdbcTemplate.queryForObject(
                "SELECT COUNT(*) FROM blood_types WHERE id = ?",
                Integer.class,
                bloodTypeId);
        return count != null && count > 0;
    }

    private static long requireGeneratedId(KeyHolder keyHolder, String entity) {
        Number key = keyHolder.getKey();
        if (key == null) {
            throw new IllegalStateException("Failed to obtain generated id for " + entity);
        }
        return key.longValue();
    }
}
