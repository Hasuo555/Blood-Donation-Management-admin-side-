-- Analytics seed data for AMyanHlu Admin Dashboard
-- Target: existing schema only (MariaDB/MySQL).
-- Safe to run repeatedly: natural keys and seed markers prevent duplicates.
-- No CREATE, ALTER, DROP, or schema changes are performed by this file.
-- Seed range: 2023-09-01 through 2026-09-12.

SET NAMES utf8mb4;
START TRANSACTION;

-- 1) Yangon addresses required by the hospital foreign keys.
INSERT INTO addresses (detail_address, country, division, township, created_at, updated_at)
SELECT s.detail, 'Myanmar', 'Yangon Region', s.township, '2026-09-12 09:00:00', '2026-09-12 09:00:00'
FROM (
SELECT 'No. 68, Bo Gyoke Aung San Road' AS detail, 'Latha' AS township
UNION ALL
SELECT 'No. 22, Anawrahta Road' AS detail, 'Lanmadaw' AS township
UNION ALL
SELECT 'No. 95, University Avenue Road' AS detail, 'Kamayut' AS township
UNION ALL
SELECT 'No. 14, Inya Road' AS detail, 'Bahan' AS township
UNION ALL
SELECT 'No. 11, Pinlon Road' AS detail, 'Mayangone' AS township
UNION ALL
SELECT 'No. 33, Kabar Aye Pagoda Road' AS detail, 'Yankin' AS township
UNION ALL
SELECT 'No. 8, Lay Daungkan Road' AS detail, 'Thingangyun' AS township
UNION ALL
SELECT 'No. 42, Parami Road' AS detail, 'North Okkalapa' AS township
UNION ALL
SELECT 'No. 17, Waizayantar Road' AS detail, 'South Okkalapa' AS township
UNION ALL
SELECT 'No. 120, Bogyoke Aung San Road' AS detail, 'Dagon' AS township
UNION ALL
SELECT 'No. 50, Bayint Naung Road' AS detail, 'Insein' AS township
UNION ALL
SELECT 'No. 77, Thudamar Road' AS detail, 'Shwe Pyi Thar' AS township
UNION ALL
SELECT 'No. 6, Min Nandar Road' AS detail, 'Hlaing Tharyar' AS township
UNION ALL
SELECT 'No. 31, Strand Road' AS detail, 'Ahlone' AS township
) AS s
WHERE NOT EXISTS (
    SELECT 1 FROM addresses a
    WHERE a.detail_address = s.detail
      AND a.division = 'Yangon Region'
      AND a.township = s.township
);

-- 2) Active hospitals across Yangon townships.
INSERT INTO hospitals (name, address_id, profile_picture, phone, email, status, created_at, updated_at)
SELECT s.hospital_name, a.id, NULL, s.phone, s.email, 'ACTIVE',
       '2026-09-12 09:00:00', '2026-09-12 09:00:00'
FROM (
SELECT 'Victoria Hospital' AS hospital_name, 'Kamayut' AS township, '01-6500123' AS phone, 'info@victoria.seed.mm' AS email
UNION ALL
SELECT 'Grand Hantha International Hospital' AS hospital_name, 'Mayangone' AS township, '01-6500456' AS phone, 'info@grandhantha.seed.mm' AS email
UNION ALL
SELECT 'North Okkalapa General Hospital' AS hospital_name, 'North Okkalapa' AS township, '01-6500789' AS phone, 'admin@nogh.seed.mm' AS email
UNION ALL
SELECT 'Thingangyun Sanpya Hospital' AS hospital_name, 'Thingangyun' AS township, '01-6501011' AS phone, 'info@sanpya.seed.mm' AS email
UNION ALL
SELECT 'Bahan Specialist Clinic' AS hospital_name, 'Bahan' AS township, '01-6501212' AS phone, 'info@bahanclinic.seed.mm' AS email
UNION ALL
SELECT 'Latha General Hospital' AS hospital_name, 'Latha' AS township, '01-6501313' AS phone, 'info@lathagh.seed.mm' AS email
UNION ALL
SELECT 'Lanmadaw General Hospital' AS hospital_name, 'Lanmadaw' AS township, '01-6501414' AS phone, 'info@lanmadawgh.seed.mm' AS email
UNION ALL
SELECT 'Insein General Hospital' AS hospital_name, 'Insein' AS township, '01-6501515' AS phone, 'info@inseingh.seed.mm' AS email
UNION ALL
SELECT 'South Okkalapa Women’s Hospital' AS hospital_name, 'South Okkalapa' AS township, '01-6501616' AS phone, 'info@sowh.seed.mm' AS email
UNION ALL
SELECT 'Yangon Central Women’s Hospital' AS hospital_name, 'Dagon' AS township, '01-6501717' AS phone, 'info@ycwh.seed.mm' AS email
UNION ALL
SELECT 'Shwe Pyi Thar General Hospital' AS hospital_name, 'Shwe Pyi Thar' AS township, '01-6501818' AS phone, 'info@spth.seed.mm' AS email
UNION ALL
SELECT 'Hlaing Tharyar Community Hospital' AS hospital_name, 'Hlaing Tharyar' AS township, '01-6501919' AS phone, 'info@htch.seed.mm' AS email
UNION ALL
SELECT 'Ahlone Family Hospital' AS hospital_name, 'Ahlone' AS township, '01-6502020' AS phone, 'info@ahlonefamily.seed.mm' AS email
UNION ALL
SELECT 'Kamayut Teaching Hospital' AS hospital_name, 'Kamayut' AS township, '01-6502121' AS phone, 'info@kth.seed.mm' AS email
) AS s
INNER JOIN addresses a
  ON a.township = s.township
 AND a.division = 'Yangon Region'
 AND a.id = (
     SELECT MAX(a2.id) FROM addresses a2
     WHERE a2.township = s.township
       AND a2.division = 'Yangon Region'
 )
WHERE NOT EXISTS (
    SELECT 1 FROM hospitals h WHERE h.name = s.hospital_name
);

-- 3) Seed donor accounts. Existing account columns and enum values are used.
INSERT INTO accounts (phone, email, password_hash, role, status, biometric_enabled, created_at, updated_at)
SELECT s.phone, s.email,
       '$2a$10$JN3vSw1YfkIYZLz8HKd8FOWuUBa8Y4vok1pOPv4tsx5lu2swPYfA6',
       'DONOR', 'ACTIVE', 0, '2026-09-12 09:00:00', '2026-09-12 09:00:00'
FROM (
SELECT '09870000001' AS phone, 'analytics.donor001@seed.amyanhlu.org' AS email
UNION ALL
SELECT '09870000002' AS phone, 'analytics.donor002@seed.amyanhlu.org' AS email
UNION ALL
SELECT '09870000003' AS phone, 'analytics.donor003@seed.amyanhlu.org' AS email
UNION ALL
SELECT '09870000004' AS phone, 'analytics.donor004@seed.amyanhlu.org' AS email
UNION ALL
SELECT '09870000005' AS phone, 'analytics.donor005@seed.amyanhlu.org' AS email
UNION ALL
SELECT '09870000006' AS phone, 'analytics.donor006@seed.amyanhlu.org' AS email
UNION ALL
SELECT '09870000007' AS phone, 'analytics.donor007@seed.amyanhlu.org' AS email
UNION ALL
SELECT '09870000008' AS phone, 'analytics.donor008@seed.amyanhlu.org' AS email
UNION ALL
SELECT '09870000009' AS phone, 'analytics.donor009@seed.amyanhlu.org' AS email
UNION ALL
SELECT '09870000010' AS phone, 'analytics.donor010@seed.amyanhlu.org' AS email
UNION ALL
SELECT '09870000011' AS phone, 'analytics.donor011@seed.amyanhlu.org' AS email
UNION ALL
SELECT '09870000012' AS phone, 'analytics.donor012@seed.amyanhlu.org' AS email
UNION ALL
SELECT '09870000013' AS phone, 'analytics.donor013@seed.amyanhlu.org' AS email
UNION ALL
SELECT '09870000014' AS phone, 'analytics.donor014@seed.amyanhlu.org' AS email
UNION ALL
SELECT '09870000015' AS phone, 'analytics.donor015@seed.amyanhlu.org' AS email
UNION ALL
SELECT '09870000016' AS phone, 'analytics.donor016@seed.amyanhlu.org' AS email
UNION ALL
SELECT '09870000017' AS phone, 'analytics.donor017@seed.amyanhlu.org' AS email
UNION ALL
SELECT '09870000018' AS phone, 'analytics.donor018@seed.amyanhlu.org' AS email
UNION ALL
SELECT '09870000019' AS phone, 'analytics.donor019@seed.amyanhlu.org' AS email
UNION ALL
SELECT '09870000020' AS phone, 'analytics.donor020@seed.amyanhlu.org' AS email
UNION ALL
SELECT '09870000021' AS phone, 'analytics.donor021@seed.amyanhlu.org' AS email
UNION ALL
SELECT '09870000022' AS phone, 'analytics.donor022@seed.amyanhlu.org' AS email
UNION ALL
SELECT '09870000023' AS phone, 'analytics.donor023@seed.amyanhlu.org' AS email
UNION ALL
SELECT '09870000024' AS phone, 'analytics.donor024@seed.amyanhlu.org' AS email
UNION ALL
SELECT '09870000025' AS phone, 'analytics.donor025@seed.amyanhlu.org' AS email
UNION ALL
SELECT '09870000026' AS phone, 'analytics.donor026@seed.amyanhlu.org' AS email
UNION ALL
SELECT '09870000027' AS phone, 'analytics.donor027@seed.amyanhlu.org' AS email
UNION ALL
SELECT '09870000028' AS phone, 'analytics.donor028@seed.amyanhlu.org' AS email
UNION ALL
SELECT '09870000029' AS phone, 'analytics.donor029@seed.amyanhlu.org' AS email
UNION ALL
SELECT '09870000030' AS phone, 'analytics.donor030@seed.amyanhlu.org' AS email
UNION ALL
SELECT '09870000031' AS phone, 'analytics.donor031@seed.amyanhlu.org' AS email
UNION ALL
SELECT '09870000032' AS phone, 'analytics.donor032@seed.amyanhlu.org' AS email
) AS s
WHERE NOT EXISTS (SELECT 1 FROM accounts a WHERE a.email = s.email);

-- 4) Donors associated with the seeded accounts.
INSERT INTO donors (account_id, name, date_of_birth, gender, address_id, blood_type_id,
                    blood_type_verified, blood_type_verified_at, verified_by_staff_id,
                    last_donation_date, created_at, updated_at)
SELECT a.id, s.donor_name, s.date_of_birth, s.gender, s.address_id, s.blood_type_id,
       1, '2026-09-12 09:00:00', 1, NULL, '2026-09-12 09:00:00', '2026-09-12 09:00:00'
FROM (
SELECT 'analytics.donor001@seed.amyanhlu.org' AS email, 'Aung Naing 1' AS donor_name, '1988-01-01' AS date_of_birth, 'FEMALE' AS gender, 4 AS address_id, 1 AS blood_type_id
UNION ALL
SELECT 'analytics.donor002@seed.amyanhlu.org' AS email, 'Htet Naing 2' AS donor_name, '1989-02-02' AS date_of_birth, 'MALE' AS gender, 3 AS address_id, 2 AS blood_type_id
UNION ALL
SELECT 'analytics.donor003@seed.amyanhlu.org' AS email, 'Thant Naing 3' AS donor_name, '1990-03-03' AS date_of_birth, 'MALE' AS gender, 4 AS address_id, 3 AS blood_type_id
UNION ALL
SELECT 'analytics.donor004@seed.amyanhlu.org' AS email, 'Min Naing 4' AS donor_name, '1991-04-04' AS date_of_birth, 'FEMALE' AS gender, 3 AS address_id, 4 AS blood_type_id
UNION ALL
SELECT 'analytics.donor005@seed.amyanhlu.org' AS email, 'Kyaw Naing 5' AS donor_name, '1992-05-05' AS date_of_birth, 'MALE' AS gender, 4 AS address_id, 5 AS blood_type_id
UNION ALL
SELECT 'analytics.donor006@seed.amyanhlu.org' AS email, 'Zaw Naing 6' AS donor_name, '1993-06-06' AS date_of_birth, 'MALE' AS gender, 3 AS address_id, 6 AS blood_type_id
UNION ALL
SELECT 'analytics.donor007@seed.amyanhlu.org' AS email, 'Myo Naing 7' AS donor_name, '1994-07-07' AS date_of_birth, 'FEMALE' AS gender, 4 AS address_id, 7 AS blood_type_id
UNION ALL
SELECT 'analytics.donor008@seed.amyanhlu.org' AS email, 'Lin Naing 8' AS donor_name, '1995-08-08' AS date_of_birth, 'MALE' AS gender, 3 AS address_id, 8 AS blood_type_id
UNION ALL
SELECT 'analytics.donor009@seed.amyanhlu.org' AS email, 'Aung Wai 9' AS donor_name, '1996-09-09' AS date_of_birth, 'MALE' AS gender, 4 AS address_id, 1 AS blood_type_id
UNION ALL
SELECT 'analytics.donor010@seed.amyanhlu.org' AS email, 'Htet Wai 10' AS donor_name, '1997-10-10' AS date_of_birth, 'FEMALE' AS gender, 3 AS address_id, 2 AS blood_type_id
UNION ALL
SELECT 'analytics.donor011@seed.amyanhlu.org' AS email, 'Thant Wai 11' AS donor_name, '1998-11-11' AS date_of_birth, 'MALE' AS gender, 4 AS address_id, 3 AS blood_type_id
UNION ALL
SELECT 'analytics.donor012@seed.amyanhlu.org' AS email, 'Min Wai 12' AS donor_name, '1999-12-12' AS date_of_birth, 'MALE' AS gender, 3 AS address_id, 4 AS blood_type_id
UNION ALL
SELECT 'analytics.donor013@seed.amyanhlu.org' AS email, 'Kyaw Wai 13' AS donor_name, '1988-01-13' AS date_of_birth, 'FEMALE' AS gender, 4 AS address_id, 5 AS blood_type_id
UNION ALL
SELECT 'analytics.donor014@seed.amyanhlu.org' AS email, 'Zaw Wai 14' AS donor_name, '1989-02-14' AS date_of_birth, 'MALE' AS gender, 3 AS address_id, 6 AS blood_type_id
UNION ALL
SELECT 'analytics.donor015@seed.amyanhlu.org' AS email, 'Myo Wai 15' AS donor_name, '1990-03-15' AS date_of_birth, 'MALE' AS gender, 4 AS address_id, 7 AS blood_type_id
UNION ALL
SELECT 'analytics.donor016@seed.amyanhlu.org' AS email, 'Lin Wai 16' AS donor_name, '1991-04-16' AS date_of_birth, 'FEMALE' AS gender, 3 AS address_id, 8 AS blood_type_id
UNION ALL
SELECT 'analytics.donor017@seed.amyanhlu.org' AS email, 'Aung Oo 17' AS donor_name, '1992-05-17' AS date_of_birth, 'MALE' AS gender, 4 AS address_id, 1 AS blood_type_id
UNION ALL
SELECT 'analytics.donor018@seed.amyanhlu.org' AS email, 'Htet Oo 18' AS donor_name, '1993-06-18' AS date_of_birth, 'MALE' AS gender, 3 AS address_id, 2 AS blood_type_id
UNION ALL
SELECT 'analytics.donor019@seed.amyanhlu.org' AS email, 'Thant Oo 19' AS donor_name, '1994-07-19' AS date_of_birth, 'FEMALE' AS gender, 4 AS address_id, 3 AS blood_type_id
UNION ALL
SELECT 'analytics.donor020@seed.amyanhlu.org' AS email, 'Min Oo 20' AS donor_name, '1995-08-20' AS date_of_birth, 'MALE' AS gender, 3 AS address_id, 4 AS blood_type_id
UNION ALL
SELECT 'analytics.donor021@seed.amyanhlu.org' AS email, 'Kyaw Oo 21' AS donor_name, '1996-09-21' AS date_of_birth, 'MALE' AS gender, 4 AS address_id, 5 AS blood_type_id
UNION ALL
SELECT 'analytics.donor022@seed.amyanhlu.org' AS email, 'Zaw Oo 22' AS donor_name, '1997-10-22' AS date_of_birth, 'FEMALE' AS gender, 3 AS address_id, 6 AS blood_type_id
UNION ALL
SELECT 'analytics.donor023@seed.amyanhlu.org' AS email, 'Myo Oo 23' AS donor_name, '1998-11-23' AS date_of_birth, 'MALE' AS gender, 4 AS address_id, 7 AS blood_type_id
UNION ALL
SELECT 'analytics.donor024@seed.amyanhlu.org' AS email, 'Lin Oo 24' AS donor_name, '1999-12-24' AS date_of_birth, 'MALE' AS gender, 3 AS address_id, 8 AS blood_type_id
UNION ALL
SELECT 'analytics.donor025@seed.amyanhlu.org' AS email, 'Aung Tun 25' AS donor_name, '1988-01-01' AS date_of_birth, 'FEMALE' AS gender, 4 AS address_id, 1 AS blood_type_id
UNION ALL
SELECT 'analytics.donor026@seed.amyanhlu.org' AS email, 'Htet Tun 26' AS donor_name, '1989-02-02' AS date_of_birth, 'MALE' AS gender, 3 AS address_id, 2 AS blood_type_id
UNION ALL
SELECT 'analytics.donor027@seed.amyanhlu.org' AS email, 'Thant Tun 27' AS donor_name, '1990-03-03' AS date_of_birth, 'MALE' AS gender, 4 AS address_id, 3 AS blood_type_id
UNION ALL
SELECT 'analytics.donor028@seed.amyanhlu.org' AS email, 'Min Tun 28' AS donor_name, '1991-04-04' AS date_of_birth, 'FEMALE' AS gender, 3 AS address_id, 4 AS blood_type_id
UNION ALL
SELECT 'analytics.donor029@seed.amyanhlu.org' AS email, 'Kyaw Tun 29' AS donor_name, '1992-05-05' AS date_of_birth, 'MALE' AS gender, 4 AS address_id, 5 AS blood_type_id
UNION ALL
SELECT 'analytics.donor030@seed.amyanhlu.org' AS email, 'Zaw Tun 30' AS donor_name, '1993-06-06' AS date_of_birth, 'MALE' AS gender, 3 AS address_id, 6 AS blood_type_id
UNION ALL
SELECT 'analytics.donor031@seed.amyanhlu.org' AS email, 'Myo Tun 31' AS donor_name, '1994-07-07' AS date_of_birth, 'FEMALE' AS gender, 4 AS address_id, 7 AS blood_type_id
UNION ALL
SELECT 'analytics.donor032@seed.amyanhlu.org' AS email, 'Lin Tun 32' AS donor_name, '1995-08-08' AS date_of_birth, 'MALE' AS gender, 3 AS address_id, 8 AS blood_type_id
) AS s
INNER JOIN accounts a ON a.email = s.email
WHERE NOT EXISTS (SELECT 1 FROM donors d WHERE d.account_id = a.id);

-- 5) 180 blood requests: 150 weekly historical rows + 30 daily recent rows.
INSERT INTO blood_requests (hospital_id, blood_type_id, units_required, urgency, reason, status, created_at, expires_at)
SELECT h.id, s.blood_type_id, s.units_required, s.urgency,
       CONCAT('Analytics seed request ', LPAD(s.seed_no, 3, '0')),
       s.status, s.created_at, s.expires_at
FROM (
SELECT 1 AS seed_no, 'Yangon General Hospital' AS hospital_name, 1 AS blood_type_id, 2 AS units_required, 'NORMAL' AS urgency, 'OPEN' AS status, '2023-09-01 07:00:00' AS created_at, '2023-09-08' AS expires_at
UNION ALL
SELECT 2 AS seed_no, 'Victoria Hospital' AS hospital_name, 2 AS blood_type_id, 3 AS units_required, 'NORMAL' AS urgency, 'PARTIALLY_FULFILLED' AS status, '2023-09-08 08:07:00' AS created_at, '2023-09-16' AS expires_at
UNION ALL
SELECT 3 AS seed_no, 'Grand Hantha International Hospital' AS hospital_name, 3 AS blood_type_id, 4 AS units_required, 'NORMAL' AS urgency, 'FULFILLED' AS status, '2023-09-15 09:14:00' AS created_at, '2023-09-24' AS expires_at
UNION ALL
SELECT 4 AS seed_no, 'North Okkalapa General Hospital' AS hospital_name, 4 AS blood_type_id, 5 AS units_required, 'URGENT' AS urgency, 'CANCELLED' AS status, '2023-09-22 10:21:00' AS created_at, '2023-10-02' AS expires_at
UNION ALL
SELECT 5 AS seed_no, 'Thingangyun Sanpya Hospital' AS hospital_name, 5 AS blood_type_id, 6 AS units_required, 'CRITICAL' AS urgency, 'EXPIRED' AS status, '2023-09-29 11:28:00' AS created_at, '2023-10-10' AS expires_at
UNION ALL
SELECT 6 AS seed_no, 'Bahan Specialist Clinic' AS hospital_name, 6 AS blood_type_id, 7 AS units_required, 'NORMAL' AS urgency, 'OPEN' AS status, '2023-10-06 12:35:00' AS created_at, '2023-10-18' AS expires_at
UNION ALL
SELECT 7 AS seed_no, 'Latha General Hospital' AS hospital_name, 7 AS blood_type_id, 8 AS units_required, 'NORMAL' AS urgency, 'PARTIALLY_FULFILLED' AS status, '2023-10-13 13:42:00' AS created_at, '2023-10-26' AS expires_at
UNION ALL
SELECT 8 AS seed_no, 'Lanmadaw General Hospital' AS hospital_name, 8 AS blood_type_id, 9 AS units_required, 'NORMAL' AS urgency, 'FULFILLED' AS status, '2023-10-20 14:49:00' AS created_at, '2023-11-03' AS expires_at
UNION ALL
SELECT 9 AS seed_no, 'Insein General Hospital' AS hospital_name, 1 AS blood_type_id, 10 AS units_required, 'URGENT' AS urgency, 'CANCELLED' AS status, '2023-10-27 15:56:00' AS created_at, '2023-11-11' AS expires_at
UNION ALL
SELECT 10 AS seed_no, 'South Okkalapa Women’s Hospital' AS hospital_name, 2 AS blood_type_id, 11 AS units_required, 'CRITICAL' AS urgency, 'EXPIRED' AS status, '2023-11-03 16:03:00' AS created_at, '2023-11-19' AS expires_at
UNION ALL
SELECT 11 AS seed_no, 'Yangon Central Women’s Hospital' AS hospital_name, 3 AS blood_type_id, 12 AS units_required, 'NORMAL' AS urgency, 'OPEN' AS status, '2023-11-10 07:10:00' AS created_at, '2023-11-27' AS expires_at
UNION ALL
SELECT 12 AS seed_no, 'Shwe Pyi Thar General Hospital' AS hospital_name, 4 AS blood_type_id, 2 AS units_required, 'NORMAL' AS urgency, 'PARTIALLY_FULFILLED' AS status, '2023-11-17 08:17:00' AS created_at, '2023-12-05' AS expires_at
UNION ALL
SELECT 13 AS seed_no, 'Hlaing Tharyar Community Hospital' AS hospital_name, 5 AS blood_type_id, 3 AS units_required, 'NORMAL' AS urgency, 'FULFILLED' AS status, '2023-11-24 09:24:00' AS created_at, '2023-12-13' AS expires_at
UNION ALL
SELECT 14 AS seed_no, 'Ahlone Family Hospital' AS hospital_name, 6 AS blood_type_id, 4 AS units_required, 'URGENT' AS urgency, 'CANCELLED' AS status, '2023-12-01 10:31:00' AS created_at, '2023-12-21' AS expires_at
UNION ALL
SELECT 15 AS seed_no, 'Kamayut Teaching Hospital' AS hospital_name, 7 AS blood_type_id, 5 AS units_required, 'CRITICAL' AS urgency, 'EXPIRED' AS status, '2023-12-08 11:38:00' AS created_at, '2023-12-15' AS expires_at
UNION ALL
SELECT 16 AS seed_no, 'Yangon General Hospital' AS hospital_name, 8 AS blood_type_id, 6 AS units_required, 'NORMAL' AS urgency, 'OPEN' AS status, '2023-12-15 12:45:00' AS created_at, '2023-12-23' AS expires_at
UNION ALL
SELECT 17 AS seed_no, 'Victoria Hospital' AS hospital_name, 1 AS blood_type_id, 7 AS units_required, 'NORMAL' AS urgency, 'PARTIALLY_FULFILLED' AS status, '2023-12-22 13:52:00' AS created_at, '2023-12-31' AS expires_at
UNION ALL
SELECT 18 AS seed_no, 'Grand Hantha International Hospital' AS hospital_name, 2 AS blood_type_id, 8 AS units_required, 'NORMAL' AS urgency, 'FULFILLED' AS status, '2023-12-29 14:59:00' AS created_at, '2024-01-08' AS expires_at
UNION ALL
SELECT 19 AS seed_no, 'North Okkalapa General Hospital' AS hospital_name, 3 AS blood_type_id, 9 AS units_required, 'URGENT' AS urgency, 'CANCELLED' AS status, '2024-01-05 15:06:00' AS created_at, '2024-01-16' AS expires_at
UNION ALL
SELECT 20 AS seed_no, 'Thingangyun Sanpya Hospital' AS hospital_name, 4 AS blood_type_id, 10 AS units_required, 'CRITICAL' AS urgency, 'EXPIRED' AS status, '2024-01-12 16:13:00' AS created_at, '2024-01-24' AS expires_at
UNION ALL
SELECT 21 AS seed_no, 'Bahan Specialist Clinic' AS hospital_name, 5 AS blood_type_id, 11 AS units_required, 'NORMAL' AS urgency, 'OPEN' AS status, '2024-01-19 07:20:00' AS created_at, '2024-02-01' AS expires_at
UNION ALL
SELECT 22 AS seed_no, 'Latha General Hospital' AS hospital_name, 6 AS blood_type_id, 12 AS units_required, 'NORMAL' AS urgency, 'PARTIALLY_FULFILLED' AS status, '2024-01-26 08:27:00' AS created_at, '2024-02-09' AS expires_at
UNION ALL
SELECT 23 AS seed_no, 'Lanmadaw General Hospital' AS hospital_name, 7 AS blood_type_id, 2 AS units_required, 'NORMAL' AS urgency, 'FULFILLED' AS status, '2024-02-02 09:34:00' AS created_at, '2024-02-17' AS expires_at
UNION ALL
SELECT 24 AS seed_no, 'Insein General Hospital' AS hospital_name, 8 AS blood_type_id, 3 AS units_required, 'URGENT' AS urgency, 'CANCELLED' AS status, '2024-02-09 10:41:00' AS created_at, '2024-02-25' AS expires_at
UNION ALL
SELECT 25 AS seed_no, 'South Okkalapa Women’s Hospital' AS hospital_name, 1 AS blood_type_id, 4 AS units_required, 'CRITICAL' AS urgency, 'EXPIRED' AS status, '2024-02-16 11:48:00' AS created_at, '2024-03-04' AS expires_at
UNION ALL
SELECT 26 AS seed_no, 'Yangon Central Women’s Hospital' AS hospital_name, 2 AS blood_type_id, 5 AS units_required, 'NORMAL' AS urgency, 'OPEN' AS status, '2024-02-23 12:55:00' AS created_at, '2024-03-12' AS expires_at
UNION ALL
SELECT 27 AS seed_no, 'Shwe Pyi Thar General Hospital' AS hospital_name, 3 AS blood_type_id, 6 AS units_required, 'NORMAL' AS urgency, 'PARTIALLY_FULFILLED' AS status, '2024-03-01 13:02:00' AS created_at, '2024-03-20' AS expires_at
UNION ALL
SELECT 28 AS seed_no, 'Hlaing Tharyar Community Hospital' AS hospital_name, 4 AS blood_type_id, 7 AS units_required, 'NORMAL' AS urgency, 'FULFILLED' AS status, '2024-03-08 14:09:00' AS created_at, '2024-03-28' AS expires_at
UNION ALL
SELECT 29 AS seed_no, 'Ahlone Family Hospital' AS hospital_name, 5 AS blood_type_id, 8 AS units_required, 'URGENT' AS urgency, 'CANCELLED' AS status, '2024-03-15 15:16:00' AS created_at, '2024-03-22' AS expires_at
UNION ALL
SELECT 30 AS seed_no, 'Kamayut Teaching Hospital' AS hospital_name, 6 AS blood_type_id, 9 AS units_required, 'CRITICAL' AS urgency, 'EXPIRED' AS status, '2024-03-22 16:23:00' AS created_at, '2024-03-30' AS expires_at
UNION ALL
SELECT 31 AS seed_no, 'Yangon General Hospital' AS hospital_name, 7 AS blood_type_id, 10 AS units_required, 'NORMAL' AS urgency, 'OPEN' AS status, '2024-03-29 07:30:00' AS created_at, '2024-04-07' AS expires_at
UNION ALL
SELECT 32 AS seed_no, 'Victoria Hospital' AS hospital_name, 8 AS blood_type_id, 11 AS units_required, 'NORMAL' AS urgency, 'PARTIALLY_FULFILLED' AS status, '2024-04-05 08:37:00' AS created_at, '2024-04-15' AS expires_at
UNION ALL
SELECT 33 AS seed_no, 'Grand Hantha International Hospital' AS hospital_name, 1 AS blood_type_id, 12 AS units_required, 'NORMAL' AS urgency, 'FULFILLED' AS status, '2024-04-12 09:44:00' AS created_at, '2024-04-23' AS expires_at
UNION ALL
SELECT 34 AS seed_no, 'North Okkalapa General Hospital' AS hospital_name, 2 AS blood_type_id, 2 AS units_required, 'URGENT' AS urgency, 'CANCELLED' AS status, '2024-04-19 10:51:00' AS created_at, '2024-05-01' AS expires_at
UNION ALL
SELECT 35 AS seed_no, 'Thingangyun Sanpya Hospital' AS hospital_name, 3 AS blood_type_id, 3 AS units_required, 'CRITICAL' AS urgency, 'EXPIRED' AS status, '2024-04-26 11:58:00' AS created_at, '2024-05-09' AS expires_at
UNION ALL
SELECT 36 AS seed_no, 'Bahan Specialist Clinic' AS hospital_name, 4 AS blood_type_id, 4 AS units_required, 'NORMAL' AS urgency, 'OPEN' AS status, '2024-05-03 12:05:00' AS created_at, '2024-05-17' AS expires_at
UNION ALL
SELECT 37 AS seed_no, 'Latha General Hospital' AS hospital_name, 5 AS blood_type_id, 5 AS units_required, 'NORMAL' AS urgency, 'PARTIALLY_FULFILLED' AS status, '2024-05-10 13:12:00' AS created_at, '2024-05-25' AS expires_at
UNION ALL
SELECT 38 AS seed_no, 'Lanmadaw General Hospital' AS hospital_name, 6 AS blood_type_id, 6 AS units_required, 'NORMAL' AS urgency, 'FULFILLED' AS status, '2024-05-17 14:19:00' AS created_at, '2024-06-02' AS expires_at
UNION ALL
SELECT 39 AS seed_no, 'Insein General Hospital' AS hospital_name, 7 AS blood_type_id, 7 AS units_required, 'URGENT' AS urgency, 'CANCELLED' AS status, '2024-05-24 15:26:00' AS created_at, '2024-06-10' AS expires_at
UNION ALL
SELECT 40 AS seed_no, 'South Okkalapa Women’s Hospital' AS hospital_name, 8 AS blood_type_id, 8 AS units_required, 'CRITICAL' AS urgency, 'EXPIRED' AS status, '2024-05-31 16:33:00' AS created_at, '2024-06-18' AS expires_at
UNION ALL
SELECT 41 AS seed_no, 'Yangon Central Women’s Hospital' AS hospital_name, 1 AS blood_type_id, 9 AS units_required, 'NORMAL' AS urgency, 'OPEN' AS status, '2024-06-07 07:40:00' AS created_at, '2024-06-26' AS expires_at
UNION ALL
SELECT 42 AS seed_no, 'Shwe Pyi Thar General Hospital' AS hospital_name, 2 AS blood_type_id, 10 AS units_required, 'NORMAL' AS urgency, 'PARTIALLY_FULFILLED' AS status, '2024-06-14 08:47:00' AS created_at, '2024-07-04' AS expires_at
UNION ALL
SELECT 43 AS seed_no, 'Hlaing Tharyar Community Hospital' AS hospital_name, 3 AS blood_type_id, 11 AS units_required, 'NORMAL' AS urgency, 'FULFILLED' AS status, '2024-06-21 09:54:00' AS created_at, '2024-06-28' AS expires_at
UNION ALL
SELECT 44 AS seed_no, 'Ahlone Family Hospital' AS hospital_name, 4 AS blood_type_id, 12 AS units_required, 'URGENT' AS urgency, 'CANCELLED' AS status, '2024-06-28 10:01:00' AS created_at, '2024-07-06' AS expires_at
UNION ALL
SELECT 45 AS seed_no, 'Kamayut Teaching Hospital' AS hospital_name, 5 AS blood_type_id, 2 AS units_required, 'CRITICAL' AS urgency, 'EXPIRED' AS status, '2024-07-05 11:08:00' AS created_at, '2024-07-14' AS expires_at
UNION ALL
SELECT 46 AS seed_no, 'Yangon General Hospital' AS hospital_name, 6 AS blood_type_id, 3 AS units_required, 'NORMAL' AS urgency, 'OPEN' AS status, '2024-07-12 12:15:00' AS created_at, '2024-07-22' AS expires_at
UNION ALL
SELECT 47 AS seed_no, 'Victoria Hospital' AS hospital_name, 7 AS blood_type_id, 4 AS units_required, 'NORMAL' AS urgency, 'PARTIALLY_FULFILLED' AS status, '2024-07-19 13:22:00' AS created_at, '2024-07-30' AS expires_at
UNION ALL
SELECT 48 AS seed_no, 'Grand Hantha International Hospital' AS hospital_name, 8 AS blood_type_id, 5 AS units_required, 'NORMAL' AS urgency, 'FULFILLED' AS status, '2024-07-26 14:29:00' AS created_at, '2024-08-07' AS expires_at
UNION ALL
SELECT 49 AS seed_no, 'North Okkalapa General Hospital' AS hospital_name, 1 AS blood_type_id, 6 AS units_required, 'URGENT' AS urgency, 'CANCELLED' AS status, '2024-08-02 15:36:00' AS created_at, '2024-08-15' AS expires_at
UNION ALL
SELECT 50 AS seed_no, 'Thingangyun Sanpya Hospital' AS hospital_name, 2 AS blood_type_id, 7 AS units_required, 'CRITICAL' AS urgency, 'EXPIRED' AS status, '2024-08-09 16:43:00' AS created_at, '2024-08-23' AS expires_at
UNION ALL
SELECT 51 AS seed_no, 'Bahan Specialist Clinic' AS hospital_name, 3 AS blood_type_id, 8 AS units_required, 'NORMAL' AS urgency, 'OPEN' AS status, '2024-08-16 07:50:00' AS created_at, '2024-08-31' AS expires_at
UNION ALL
SELECT 52 AS seed_no, 'Latha General Hospital' AS hospital_name, 4 AS blood_type_id, 9 AS units_required, 'NORMAL' AS urgency, 'PARTIALLY_FULFILLED' AS status, '2024-08-23 08:57:00' AS created_at, '2024-09-08' AS expires_at
UNION ALL
SELECT 53 AS seed_no, 'Lanmadaw General Hospital' AS hospital_name, 5 AS blood_type_id, 10 AS units_required, 'NORMAL' AS urgency, 'FULFILLED' AS status, '2024-08-30 09:04:00' AS created_at, '2024-09-16' AS expires_at
UNION ALL
SELECT 54 AS seed_no, 'Insein General Hospital' AS hospital_name, 6 AS blood_type_id, 11 AS units_required, 'URGENT' AS urgency, 'CANCELLED' AS status, '2024-09-06 10:11:00' AS created_at, '2024-09-24' AS expires_at
UNION ALL
SELECT 55 AS seed_no, 'South Okkalapa Women’s Hospital' AS hospital_name, 7 AS blood_type_id, 12 AS units_required, 'CRITICAL' AS urgency, 'EXPIRED' AS status, '2024-09-13 11:18:00' AS created_at, '2024-10-02' AS expires_at
UNION ALL
SELECT 56 AS seed_no, 'Yangon Central Women’s Hospital' AS hospital_name, 8 AS blood_type_id, 2 AS units_required, 'NORMAL' AS urgency, 'OPEN' AS status, '2024-09-20 12:25:00' AS created_at, '2024-10-10' AS expires_at
UNION ALL
SELECT 57 AS seed_no, 'Shwe Pyi Thar General Hospital' AS hospital_name, 1 AS blood_type_id, 3 AS units_required, 'NORMAL' AS urgency, 'PARTIALLY_FULFILLED' AS status, '2024-09-27 13:32:00' AS created_at, '2024-10-04' AS expires_at
UNION ALL
SELECT 58 AS seed_no, 'Hlaing Tharyar Community Hospital' AS hospital_name, 2 AS blood_type_id, 4 AS units_required, 'NORMAL' AS urgency, 'FULFILLED' AS status, '2024-10-04 14:39:00' AS created_at, '2024-10-12' AS expires_at
UNION ALL
SELECT 59 AS seed_no, 'Ahlone Family Hospital' AS hospital_name, 3 AS blood_type_id, 5 AS units_required, 'URGENT' AS urgency, 'CANCELLED' AS status, '2024-10-11 15:46:00' AS created_at, '2024-10-20' AS expires_at
UNION ALL
SELECT 60 AS seed_no, 'Kamayut Teaching Hospital' AS hospital_name, 4 AS blood_type_id, 6 AS units_required, 'CRITICAL' AS urgency, 'EXPIRED' AS status, '2024-10-18 16:53:00' AS created_at, '2024-10-28' AS expires_at
UNION ALL
SELECT 61 AS seed_no, 'Yangon General Hospital' AS hospital_name, 5 AS blood_type_id, 7 AS units_required, 'NORMAL' AS urgency, 'OPEN' AS status, '2024-10-25 07:00:00' AS created_at, '2024-11-05' AS expires_at
UNION ALL
SELECT 62 AS seed_no, 'Victoria Hospital' AS hospital_name, 6 AS blood_type_id, 8 AS units_required, 'NORMAL' AS urgency, 'PARTIALLY_FULFILLED' AS status, '2024-11-01 08:07:00' AS created_at, '2024-11-13' AS expires_at
UNION ALL
SELECT 63 AS seed_no, 'Grand Hantha International Hospital' AS hospital_name, 7 AS blood_type_id, 9 AS units_required, 'NORMAL' AS urgency, 'FULFILLED' AS status, '2024-11-08 09:14:00' AS created_at, '2024-11-21' AS expires_at
UNION ALL
SELECT 64 AS seed_no, 'North Okkalapa General Hospital' AS hospital_name, 8 AS blood_type_id, 10 AS units_required, 'URGENT' AS urgency, 'CANCELLED' AS status, '2024-11-15 10:21:00' AS created_at, '2024-11-29' AS expires_at
UNION ALL
SELECT 65 AS seed_no, 'Thingangyun Sanpya Hospital' AS hospital_name, 1 AS blood_type_id, 11 AS units_required, 'CRITICAL' AS urgency, 'EXPIRED' AS status, '2024-11-22 11:28:00' AS created_at, '2024-12-07' AS expires_at
UNION ALL
SELECT 66 AS seed_no, 'Bahan Specialist Clinic' AS hospital_name, 2 AS blood_type_id, 12 AS units_required, 'NORMAL' AS urgency, 'OPEN' AS status, '2024-11-29 12:35:00' AS created_at, '2024-12-15' AS expires_at
UNION ALL
SELECT 67 AS seed_no, 'Latha General Hospital' AS hospital_name, 3 AS blood_type_id, 2 AS units_required, 'NORMAL' AS urgency, 'PARTIALLY_FULFILLED' AS status, '2024-12-06 13:42:00' AS created_at, '2024-12-23' AS expires_at
UNION ALL
SELECT 68 AS seed_no, 'Lanmadaw General Hospital' AS hospital_name, 4 AS blood_type_id, 3 AS units_required, 'NORMAL' AS urgency, 'FULFILLED' AS status, '2024-12-13 14:49:00' AS created_at, '2024-12-31' AS expires_at
UNION ALL
SELECT 69 AS seed_no, 'Insein General Hospital' AS hospital_name, 5 AS blood_type_id, 4 AS units_required, 'URGENT' AS urgency, 'CANCELLED' AS status, '2024-12-20 15:56:00' AS created_at, '2025-01-08' AS expires_at
UNION ALL
SELECT 70 AS seed_no, 'South Okkalapa Women’s Hospital' AS hospital_name, 6 AS blood_type_id, 5 AS units_required, 'CRITICAL' AS urgency, 'EXPIRED' AS status, '2024-12-27 16:03:00' AS created_at, '2025-01-16' AS expires_at
UNION ALL
SELECT 71 AS seed_no, 'Yangon Central Women’s Hospital' AS hospital_name, 7 AS blood_type_id, 6 AS units_required, 'NORMAL' AS urgency, 'OPEN' AS status, '2025-01-03 07:10:00' AS created_at, '2025-01-10' AS expires_at
UNION ALL
SELECT 72 AS seed_no, 'Shwe Pyi Thar General Hospital' AS hospital_name, 8 AS blood_type_id, 7 AS units_required, 'NORMAL' AS urgency, 'PARTIALLY_FULFILLED' AS status, '2025-01-10 08:17:00' AS created_at, '2025-01-18' AS expires_at
UNION ALL
SELECT 73 AS seed_no, 'Hlaing Tharyar Community Hospital' AS hospital_name, 1 AS blood_type_id, 8 AS units_required, 'NORMAL' AS urgency, 'FULFILLED' AS status, '2025-01-17 09:24:00' AS created_at, '2025-01-26' AS expires_at
UNION ALL
SELECT 74 AS seed_no, 'Ahlone Family Hospital' AS hospital_name, 2 AS blood_type_id, 9 AS units_required, 'URGENT' AS urgency, 'CANCELLED' AS status, '2025-01-24 10:31:00' AS created_at, '2025-02-03' AS expires_at
UNION ALL
SELECT 75 AS seed_no, 'Kamayut Teaching Hospital' AS hospital_name, 3 AS blood_type_id, 10 AS units_required, 'CRITICAL' AS urgency, 'EXPIRED' AS status, '2025-01-31 11:38:00' AS created_at, '2025-02-11' AS expires_at
UNION ALL
SELECT 76 AS seed_no, 'Yangon General Hospital' AS hospital_name, 4 AS blood_type_id, 11 AS units_required, 'NORMAL' AS urgency, 'OPEN' AS status, '2025-02-07 12:45:00' AS created_at, '2025-02-19' AS expires_at
UNION ALL
SELECT 77 AS seed_no, 'Victoria Hospital' AS hospital_name, 5 AS blood_type_id, 12 AS units_required, 'NORMAL' AS urgency, 'PARTIALLY_FULFILLED' AS status, '2025-02-14 13:52:00' AS created_at, '2025-02-27' AS expires_at
UNION ALL
SELECT 78 AS seed_no, 'Grand Hantha International Hospital' AS hospital_name, 6 AS blood_type_id, 2 AS units_required, 'NORMAL' AS urgency, 'FULFILLED' AS status, '2025-02-21 14:59:00' AS created_at, '2025-03-07' AS expires_at
UNION ALL
SELECT 79 AS seed_no, 'North Okkalapa General Hospital' AS hospital_name, 7 AS blood_type_id, 3 AS units_required, 'URGENT' AS urgency, 'CANCELLED' AS status, '2025-02-28 15:06:00' AS created_at, '2025-03-15' AS expires_at
UNION ALL
SELECT 80 AS seed_no, 'Thingangyun Sanpya Hospital' AS hospital_name, 8 AS blood_type_id, 4 AS units_required, 'CRITICAL' AS urgency, 'EXPIRED' AS status, '2025-03-07 16:13:00' AS created_at, '2025-03-23' AS expires_at
UNION ALL
SELECT 81 AS seed_no, 'Bahan Specialist Clinic' AS hospital_name, 1 AS blood_type_id, 5 AS units_required, 'NORMAL' AS urgency, 'OPEN' AS status, '2025-03-14 07:20:00' AS created_at, '2025-03-31' AS expires_at
UNION ALL
SELECT 82 AS seed_no, 'Latha General Hospital' AS hospital_name, 2 AS blood_type_id, 6 AS units_required, 'NORMAL' AS urgency, 'PARTIALLY_FULFILLED' AS status, '2025-03-21 08:27:00' AS created_at, '2025-04-08' AS expires_at
UNION ALL
SELECT 83 AS seed_no, 'Lanmadaw General Hospital' AS hospital_name, 3 AS blood_type_id, 7 AS units_required, 'NORMAL' AS urgency, 'FULFILLED' AS status, '2025-03-28 09:34:00' AS created_at, '2025-04-16' AS expires_at
UNION ALL
SELECT 84 AS seed_no, 'Insein General Hospital' AS hospital_name, 4 AS blood_type_id, 8 AS units_required, 'URGENT' AS urgency, 'CANCELLED' AS status, '2025-04-04 10:41:00' AS created_at, '2025-04-24' AS expires_at
UNION ALL
SELECT 85 AS seed_no, 'South Okkalapa Women’s Hospital' AS hospital_name, 5 AS blood_type_id, 9 AS units_required, 'CRITICAL' AS urgency, 'EXPIRED' AS status, '2025-04-11 11:48:00' AS created_at, '2025-04-18' AS expires_at
UNION ALL
SELECT 86 AS seed_no, 'Yangon Central Women’s Hospital' AS hospital_name, 6 AS blood_type_id, 10 AS units_required, 'NORMAL' AS urgency, 'OPEN' AS status, '2025-04-18 12:55:00' AS created_at, '2025-04-26' AS expires_at
UNION ALL
SELECT 87 AS seed_no, 'Shwe Pyi Thar General Hospital' AS hospital_name, 7 AS blood_type_id, 11 AS units_required, 'NORMAL' AS urgency, 'PARTIALLY_FULFILLED' AS status, '2025-04-25 13:02:00' AS created_at, '2025-05-04' AS expires_at
UNION ALL
SELECT 88 AS seed_no, 'Hlaing Tharyar Community Hospital' AS hospital_name, 8 AS blood_type_id, 12 AS units_required, 'NORMAL' AS urgency, 'FULFILLED' AS status, '2025-05-02 14:09:00' AS created_at, '2025-05-12' AS expires_at
UNION ALL
SELECT 89 AS seed_no, 'Ahlone Family Hospital' AS hospital_name, 1 AS blood_type_id, 2 AS units_required, 'URGENT' AS urgency, 'CANCELLED' AS status, '2025-05-09 15:16:00' AS created_at, '2025-05-20' AS expires_at
UNION ALL
SELECT 90 AS seed_no, 'Kamayut Teaching Hospital' AS hospital_name, 2 AS blood_type_id, 3 AS units_required, 'CRITICAL' AS urgency, 'EXPIRED' AS status, '2025-05-16 16:23:00' AS created_at, '2025-05-28' AS expires_at
UNION ALL
SELECT 91 AS seed_no, 'Yangon General Hospital' AS hospital_name, 3 AS blood_type_id, 4 AS units_required, 'NORMAL' AS urgency, 'OPEN' AS status, '2025-05-23 07:30:00' AS created_at, '2025-06-05' AS expires_at
UNION ALL
SELECT 92 AS seed_no, 'Victoria Hospital' AS hospital_name, 4 AS blood_type_id, 5 AS units_required, 'NORMAL' AS urgency, 'PARTIALLY_FULFILLED' AS status, '2025-05-30 08:37:00' AS created_at, '2025-06-13' AS expires_at
UNION ALL
SELECT 93 AS seed_no, 'Grand Hantha International Hospital' AS hospital_name, 5 AS blood_type_id, 6 AS units_required, 'NORMAL' AS urgency, 'FULFILLED' AS status, '2025-06-06 09:44:00' AS created_at, '2025-06-21' AS expires_at
UNION ALL
SELECT 94 AS seed_no, 'North Okkalapa General Hospital' AS hospital_name, 6 AS blood_type_id, 7 AS units_required, 'URGENT' AS urgency, 'CANCELLED' AS status, '2025-06-13 10:51:00' AS created_at, '2025-06-29' AS expires_at
UNION ALL
SELECT 95 AS seed_no, 'Thingangyun Sanpya Hospital' AS hospital_name, 7 AS blood_type_id, 8 AS units_required, 'CRITICAL' AS urgency, 'EXPIRED' AS status, '2025-06-20 11:58:00' AS created_at, '2025-07-07' AS expires_at
UNION ALL
SELECT 96 AS seed_no, 'Bahan Specialist Clinic' AS hospital_name, 8 AS blood_type_id, 9 AS units_required, 'NORMAL' AS urgency, 'OPEN' AS status, '2025-06-27 12:05:00' AS created_at, '2025-07-15' AS expires_at
UNION ALL
SELECT 97 AS seed_no, 'Latha General Hospital' AS hospital_name, 1 AS blood_type_id, 10 AS units_required, 'NORMAL' AS urgency, 'PARTIALLY_FULFILLED' AS status, '2025-07-04 13:12:00' AS created_at, '2025-07-23' AS expires_at
UNION ALL
SELECT 98 AS seed_no, 'Lanmadaw General Hospital' AS hospital_name, 2 AS blood_type_id, 11 AS units_required, 'NORMAL' AS urgency, 'FULFILLED' AS status, '2025-07-11 14:19:00' AS created_at, '2025-07-31' AS expires_at
UNION ALL
SELECT 99 AS seed_no, 'Insein General Hospital' AS hospital_name, 3 AS blood_type_id, 12 AS units_required, 'URGENT' AS urgency, 'CANCELLED' AS status, '2025-07-18 15:26:00' AS created_at, '2025-07-25' AS expires_at
UNION ALL
SELECT 100 AS seed_no, 'South Okkalapa Women’s Hospital' AS hospital_name, 4 AS blood_type_id, 2 AS units_required, 'CRITICAL' AS urgency, 'EXPIRED' AS status, '2025-07-25 16:33:00' AS created_at, '2025-08-02' AS expires_at
UNION ALL
SELECT 101 AS seed_no, 'Yangon Central Women’s Hospital' AS hospital_name, 5 AS blood_type_id, 3 AS units_required, 'NORMAL' AS urgency, 'OPEN' AS status, '2025-08-01 07:40:00' AS created_at, '2025-08-10' AS expires_at
UNION ALL
SELECT 102 AS seed_no, 'Shwe Pyi Thar General Hospital' AS hospital_name, 6 AS blood_type_id, 4 AS units_required, 'NORMAL' AS urgency, 'PARTIALLY_FULFILLED' AS status, '2025-08-08 08:47:00' AS created_at, '2025-08-18' AS expires_at
UNION ALL
SELECT 103 AS seed_no, 'Hlaing Tharyar Community Hospital' AS hospital_name, 7 AS blood_type_id, 5 AS units_required, 'NORMAL' AS urgency, 'FULFILLED' AS status, '2025-08-15 09:54:00' AS created_at, '2025-08-26' AS expires_at
UNION ALL
SELECT 104 AS seed_no, 'Ahlone Family Hospital' AS hospital_name, 8 AS blood_type_id, 6 AS units_required, 'URGENT' AS urgency, 'CANCELLED' AS status, '2025-08-22 10:01:00' AS created_at, '2025-09-03' AS expires_at
UNION ALL
SELECT 105 AS seed_no, 'Kamayut Teaching Hospital' AS hospital_name, 1 AS blood_type_id, 7 AS units_required, 'CRITICAL' AS urgency, 'EXPIRED' AS status, '2025-08-29 11:08:00' AS created_at, '2025-09-11' AS expires_at
UNION ALL
SELECT 106 AS seed_no, 'Yangon General Hospital' AS hospital_name, 2 AS blood_type_id, 8 AS units_required, 'NORMAL' AS urgency, 'OPEN' AS status, '2025-09-05 12:15:00' AS created_at, '2025-09-19' AS expires_at
UNION ALL
SELECT 107 AS seed_no, 'Victoria Hospital' AS hospital_name, 3 AS blood_type_id, 9 AS units_required, 'NORMAL' AS urgency, 'PARTIALLY_FULFILLED' AS status, '2025-09-12 13:22:00' AS created_at, '2025-09-27' AS expires_at
UNION ALL
SELECT 108 AS seed_no, 'Grand Hantha International Hospital' AS hospital_name, 4 AS blood_type_id, 10 AS units_required, 'NORMAL' AS urgency, 'FULFILLED' AS status, '2025-09-19 14:29:00' AS created_at, '2025-10-05' AS expires_at
UNION ALL
SELECT 109 AS seed_no, 'North Okkalapa General Hospital' AS hospital_name, 5 AS blood_type_id, 11 AS units_required, 'URGENT' AS urgency, 'CANCELLED' AS status, '2025-09-26 15:36:00' AS created_at, '2025-10-13' AS expires_at
UNION ALL
SELECT 110 AS seed_no, 'Thingangyun Sanpya Hospital' AS hospital_name, 6 AS blood_type_id, 12 AS units_required, 'CRITICAL' AS urgency, 'EXPIRED' AS status, '2025-10-03 16:43:00' AS created_at, '2025-10-21' AS expires_at
UNION ALL
SELECT 111 AS seed_no, 'Bahan Specialist Clinic' AS hospital_name, 7 AS blood_type_id, 2 AS units_required, 'NORMAL' AS urgency, 'OPEN' AS status, '2025-10-10 07:50:00' AS created_at, '2025-10-29' AS expires_at
UNION ALL
SELECT 112 AS seed_no, 'Latha General Hospital' AS hospital_name, 8 AS blood_type_id, 3 AS units_required, 'NORMAL' AS urgency, 'PARTIALLY_FULFILLED' AS status, '2025-10-17 08:57:00' AS created_at, '2025-11-06' AS expires_at
UNION ALL
SELECT 113 AS seed_no, 'Lanmadaw General Hospital' AS hospital_name, 1 AS blood_type_id, 4 AS units_required, 'NORMAL' AS urgency, 'FULFILLED' AS status, '2025-10-24 09:04:00' AS created_at, '2025-10-31' AS expires_at
UNION ALL
SELECT 114 AS seed_no, 'Insein General Hospital' AS hospital_name, 2 AS blood_type_id, 5 AS units_required, 'URGENT' AS urgency, 'CANCELLED' AS status, '2025-10-31 10:11:00' AS created_at, '2025-11-08' AS expires_at
UNION ALL
SELECT 115 AS seed_no, 'South Okkalapa Women’s Hospital' AS hospital_name, 3 AS blood_type_id, 6 AS units_required, 'CRITICAL' AS urgency, 'EXPIRED' AS status, '2025-11-07 11:18:00' AS created_at, '2025-11-16' AS expires_at
UNION ALL
SELECT 116 AS seed_no, 'Yangon Central Women’s Hospital' AS hospital_name, 4 AS blood_type_id, 7 AS units_required, 'NORMAL' AS urgency, 'OPEN' AS status, '2025-11-14 12:25:00' AS created_at, '2025-11-24' AS expires_at
UNION ALL
SELECT 117 AS seed_no, 'Shwe Pyi Thar General Hospital' AS hospital_name, 5 AS blood_type_id, 8 AS units_required, 'NORMAL' AS urgency, 'PARTIALLY_FULFILLED' AS status, '2025-11-21 13:32:00' AS created_at, '2025-12-02' AS expires_at
UNION ALL
SELECT 118 AS seed_no, 'Hlaing Tharyar Community Hospital' AS hospital_name, 6 AS blood_type_id, 9 AS units_required, 'NORMAL' AS urgency, 'FULFILLED' AS status, '2025-11-28 14:39:00' AS created_at, '2025-12-10' AS expires_at
UNION ALL
SELECT 119 AS seed_no, 'Ahlone Family Hospital' AS hospital_name, 7 AS blood_type_id, 10 AS units_required, 'URGENT' AS urgency, 'CANCELLED' AS status, '2025-12-05 15:46:00' AS created_at, '2025-12-18' AS expires_at
UNION ALL
SELECT 120 AS seed_no, 'Kamayut Teaching Hospital' AS hospital_name, 8 AS blood_type_id, 11 AS units_required, 'CRITICAL' AS urgency, 'EXPIRED' AS status, '2025-12-12 16:53:00' AS created_at, '2025-12-26' AS expires_at
UNION ALL
SELECT 121 AS seed_no, 'Yangon General Hospital' AS hospital_name, 1 AS blood_type_id, 12 AS units_required, 'NORMAL' AS urgency, 'OPEN' AS status, '2025-12-19 07:00:00' AS created_at, '2026-01-03' AS expires_at
UNION ALL
SELECT 122 AS seed_no, 'Victoria Hospital' AS hospital_name, 2 AS blood_type_id, 2 AS units_required, 'NORMAL' AS urgency, 'PARTIALLY_FULFILLED' AS status, '2025-12-26 08:07:00' AS created_at, '2026-01-11' AS expires_at
UNION ALL
SELECT 123 AS seed_no, 'Grand Hantha International Hospital' AS hospital_name, 3 AS blood_type_id, 3 AS units_required, 'NORMAL' AS urgency, 'FULFILLED' AS status, '2026-01-02 09:14:00' AS created_at, '2026-01-19' AS expires_at
UNION ALL
SELECT 124 AS seed_no, 'North Okkalapa General Hospital' AS hospital_name, 4 AS blood_type_id, 4 AS units_required, 'URGENT' AS urgency, 'CANCELLED' AS status, '2026-01-09 10:21:00' AS created_at, '2026-01-27' AS expires_at
UNION ALL
SELECT 125 AS seed_no, 'Thingangyun Sanpya Hospital' AS hospital_name, 5 AS blood_type_id, 5 AS units_required, 'CRITICAL' AS urgency, 'EXPIRED' AS status, '2026-01-16 11:28:00' AS created_at, '2026-02-04' AS expires_at
UNION ALL
SELECT 126 AS seed_no, 'Bahan Specialist Clinic' AS hospital_name, 6 AS blood_type_id, 6 AS units_required, 'NORMAL' AS urgency, 'OPEN' AS status, '2026-01-23 12:35:00' AS created_at, '2026-02-12' AS expires_at
UNION ALL
SELECT 127 AS seed_no, 'Latha General Hospital' AS hospital_name, 7 AS blood_type_id, 7 AS units_required, 'NORMAL' AS urgency, 'PARTIALLY_FULFILLED' AS status, '2026-01-30 13:42:00' AS created_at, '2026-02-06' AS expires_at
UNION ALL
SELECT 128 AS seed_no, 'Lanmadaw General Hospital' AS hospital_name, 8 AS blood_type_id, 8 AS units_required, 'NORMAL' AS urgency, 'FULFILLED' AS status, '2026-02-06 14:49:00' AS created_at, '2026-02-14' AS expires_at
UNION ALL
SELECT 129 AS seed_no, 'Insein General Hospital' AS hospital_name, 1 AS blood_type_id, 9 AS units_required, 'URGENT' AS urgency, 'CANCELLED' AS status, '2026-02-13 15:56:00' AS created_at, '2026-02-22' AS expires_at
UNION ALL
SELECT 130 AS seed_no, 'South Okkalapa Women’s Hospital' AS hospital_name, 2 AS blood_type_id, 10 AS units_required, 'CRITICAL' AS urgency, 'EXPIRED' AS status, '2026-02-20 16:03:00' AS created_at, '2026-03-02' AS expires_at
UNION ALL
SELECT 131 AS seed_no, 'Yangon Central Women’s Hospital' AS hospital_name, 3 AS blood_type_id, 11 AS units_required, 'NORMAL' AS urgency, 'OPEN' AS status, '2026-02-27 07:10:00' AS created_at, '2026-03-10' AS expires_at
UNION ALL
SELECT 132 AS seed_no, 'Shwe Pyi Thar General Hospital' AS hospital_name, 4 AS blood_type_id, 12 AS units_required, 'NORMAL' AS urgency, 'PARTIALLY_FULFILLED' AS status, '2026-03-06 08:17:00' AS created_at, '2026-03-18' AS expires_at
UNION ALL
SELECT 133 AS seed_no, 'Hlaing Tharyar Community Hospital' AS hospital_name, 5 AS blood_type_id, 2 AS units_required, 'NORMAL' AS urgency, 'FULFILLED' AS status, '2026-03-13 09:24:00' AS created_at, '2026-03-26' AS expires_at
UNION ALL
SELECT 134 AS seed_no, 'Ahlone Family Hospital' AS hospital_name, 6 AS blood_type_id, 3 AS units_required, 'URGENT' AS urgency, 'CANCELLED' AS status, '2026-03-20 10:31:00' AS created_at, '2026-04-03' AS expires_at
UNION ALL
SELECT 135 AS seed_no, 'Kamayut Teaching Hospital' AS hospital_name, 7 AS blood_type_id, 4 AS units_required, 'CRITICAL' AS urgency, 'EXPIRED' AS status, '2026-03-27 11:38:00' AS created_at, '2026-04-11' AS expires_at
UNION ALL
SELECT 136 AS seed_no, 'Yangon General Hospital' AS hospital_name, 8 AS blood_type_id, 5 AS units_required, 'NORMAL' AS urgency, 'OPEN' AS status, '2026-04-03 12:45:00' AS created_at, '2026-04-19' AS expires_at
UNION ALL
SELECT 137 AS seed_no, 'Victoria Hospital' AS hospital_name, 1 AS blood_type_id, 6 AS units_required, 'NORMAL' AS urgency, 'PARTIALLY_FULFILLED' AS status, '2026-04-10 13:52:00' AS created_at, '2026-04-27' AS expires_at
UNION ALL
SELECT 138 AS seed_no, 'Grand Hantha International Hospital' AS hospital_name, 2 AS blood_type_id, 7 AS units_required, 'NORMAL' AS urgency, 'FULFILLED' AS status, '2026-04-17 14:59:00' AS created_at, '2026-05-05' AS expires_at
UNION ALL
SELECT 139 AS seed_no, 'North Okkalapa General Hospital' AS hospital_name, 3 AS blood_type_id, 8 AS units_required, 'URGENT' AS urgency, 'CANCELLED' AS status, '2026-04-24 15:06:00' AS created_at, '2026-05-13' AS expires_at
UNION ALL
SELECT 140 AS seed_no, 'Thingangyun Sanpya Hospital' AS hospital_name, 4 AS blood_type_id, 9 AS units_required, 'CRITICAL' AS urgency, 'EXPIRED' AS status, '2026-05-01 16:13:00' AS created_at, '2026-05-21' AS expires_at
UNION ALL
SELECT 141 AS seed_no, 'Bahan Specialist Clinic' AS hospital_name, 5 AS blood_type_id, 10 AS units_required, 'NORMAL' AS urgency, 'OPEN' AS status, '2026-05-08 07:20:00' AS created_at, '2026-05-15' AS expires_at
UNION ALL
SELECT 142 AS seed_no, 'Latha General Hospital' AS hospital_name, 6 AS blood_type_id, 11 AS units_required, 'NORMAL' AS urgency, 'PARTIALLY_FULFILLED' AS status, '2026-05-15 08:27:00' AS created_at, '2026-05-23' AS expires_at
UNION ALL
SELECT 143 AS seed_no, 'Lanmadaw General Hospital' AS hospital_name, 7 AS blood_type_id, 12 AS units_required, 'NORMAL' AS urgency, 'FULFILLED' AS status, '2026-05-22 09:34:00' AS created_at, '2026-05-31' AS expires_at
UNION ALL
SELECT 144 AS seed_no, 'Insein General Hospital' AS hospital_name, 8 AS blood_type_id, 2 AS units_required, 'URGENT' AS urgency, 'CANCELLED' AS status, '2026-05-29 10:41:00' AS created_at, '2026-06-08' AS expires_at
UNION ALL
SELECT 145 AS seed_no, 'South Okkalapa Women’s Hospital' AS hospital_name, 1 AS blood_type_id, 3 AS units_required, 'CRITICAL' AS urgency, 'EXPIRED' AS status, '2026-06-05 11:48:00' AS created_at, '2026-06-16' AS expires_at
UNION ALL
SELECT 146 AS seed_no, 'Yangon Central Women’s Hospital' AS hospital_name, 2 AS blood_type_id, 4 AS units_required, 'NORMAL' AS urgency, 'OPEN' AS status, '2026-06-12 12:55:00' AS created_at, '2026-06-24' AS expires_at
UNION ALL
SELECT 147 AS seed_no, 'Shwe Pyi Thar General Hospital' AS hospital_name, 3 AS blood_type_id, 5 AS units_required, 'NORMAL' AS urgency, 'PARTIALLY_FULFILLED' AS status, '2026-06-19 13:02:00' AS created_at, '2026-07-02' AS expires_at
UNION ALL
SELECT 148 AS seed_no, 'Hlaing Tharyar Community Hospital' AS hospital_name, 4 AS blood_type_id, 6 AS units_required, 'NORMAL' AS urgency, 'FULFILLED' AS status, '2026-06-26 14:09:00' AS created_at, '2026-07-10' AS expires_at
UNION ALL
SELECT 149 AS seed_no, 'Ahlone Family Hospital' AS hospital_name, 5 AS blood_type_id, 7 AS units_required, 'URGENT' AS urgency, 'CANCELLED' AS status, '2026-07-03 15:16:00' AS created_at, '2026-07-18' AS expires_at
UNION ALL
SELECT 150 AS seed_no, 'Kamayut Teaching Hospital' AS hospital_name, 6 AS blood_type_id, 8 AS units_required, 'CRITICAL' AS urgency, 'EXPIRED' AS status, '2026-07-10 16:23:00' AS created_at, '2026-07-26' AS expires_at
UNION ALL
SELECT 151 AS seed_no, 'Yangon General Hospital' AS hospital_name, 7 AS blood_type_id, 3 AS units_required, 'NORMAL' AS urgency, 'OPEN' AS status, '2026-08-14 08:00:00' AS created_at, '2026-08-19' AS expires_at
UNION ALL
SELECT 152 AS seed_no, 'Victoria Hospital' AS hospital_name, 8 AS blood_type_id, 4 AS units_required, 'NORMAL' AS urgency, 'PARTIALLY_FULFILLED' AS status, '2026-08-15 09:11:00' AS created_at, '2026-08-21' AS expires_at
UNION ALL
SELECT 153 AS seed_no, 'Grand Hantha International Hospital' AS hospital_name, 1 AS blood_type_id, 5 AS units_required, 'NORMAL' AS urgency, 'FULFILLED' AS status, '2026-08-16 10:22:00' AS created_at, '2026-08-23' AS expires_at
UNION ALL
SELECT 154 AS seed_no, 'North Okkalapa General Hospital' AS hospital_name, 2 AS blood_type_id, 6 AS units_required, 'URGENT' AS urgency, 'CANCELLED' AS status, '2026-08-17 11:33:00' AS created_at, '2026-08-25' AS expires_at
UNION ALL
SELECT 155 AS seed_no, 'Thingangyun Sanpya Hospital' AS hospital_name, 3 AS blood_type_id, 7 AS units_required, 'CRITICAL' AS urgency, 'EXPIRED' AS status, '2026-08-18 12:44:00' AS created_at, '2026-08-27' AS expires_at
UNION ALL
SELECT 156 AS seed_no, 'Bahan Specialist Clinic' AS hospital_name, 4 AS blood_type_id, 8 AS units_required, 'NORMAL' AS urgency, 'OPEN' AS status, '2026-08-19 13:55:00' AS created_at, '2026-08-29' AS expires_at
UNION ALL
SELECT 157 AS seed_no, 'Latha General Hospital' AS hospital_name, 5 AS blood_type_id, 9 AS units_required, 'NORMAL' AS urgency, 'PARTIALLY_FULFILLED' AS status, '2026-08-20 14:06:00' AS created_at, '2026-08-31' AS expires_at
UNION ALL
SELECT 158 AS seed_no, 'Lanmadaw General Hospital' AS hospital_name, 6 AS blood_type_id, 10 AS units_required, 'NORMAL' AS urgency, 'FULFILLED' AS status, '2026-08-21 15:17:00' AS created_at, '2026-09-02' AS expires_at
UNION ALL
SELECT 159 AS seed_no, 'Insein General Hospital' AS hospital_name, 7 AS blood_type_id, 11 AS units_required, 'URGENT' AS urgency, 'CANCELLED' AS status, '2026-08-22 16:28:00' AS created_at, '2026-09-04' AS expires_at
UNION ALL
SELECT 160 AS seed_no, 'South Okkalapa Women’s Hospital' AS hospital_name, 8 AS blood_type_id, 12 AS units_required, 'CRITICAL' AS urgency, 'EXPIRED' AS status, '2026-08-23 08:39:00' AS created_at, '2026-09-06' AS expires_at
UNION ALL
SELECT 161 AS seed_no, 'Yangon Central Women’s Hospital' AS hospital_name, 1 AS blood_type_id, 3 AS units_required, 'NORMAL' AS urgency, 'OPEN' AS status, '2026-08-24 09:50:00' AS created_at, '2026-09-08' AS expires_at
UNION ALL
SELECT 162 AS seed_no, 'Shwe Pyi Thar General Hospital' AS hospital_name, 2 AS blood_type_id, 4 AS units_required, 'NORMAL' AS urgency, 'PARTIALLY_FULFILLED' AS status, '2026-08-25 10:01:00' AS created_at, '2026-09-10' AS expires_at
UNION ALL
SELECT 163 AS seed_no, 'Hlaing Tharyar Community Hospital' AS hospital_name, 3 AS blood_type_id, 5 AS units_required, 'NORMAL' AS urgency, 'FULFILLED' AS status, '2026-08-26 11:12:00' AS created_at, '2026-08-31' AS expires_at
UNION ALL
SELECT 164 AS seed_no, 'Ahlone Family Hospital' AS hospital_name, 4 AS blood_type_id, 6 AS units_required, 'URGENT' AS urgency, 'CANCELLED' AS status, '2026-08-27 12:23:00' AS created_at, '2026-09-02' AS expires_at
UNION ALL
SELECT 165 AS seed_no, 'Kamayut Teaching Hospital' AS hospital_name, 5 AS blood_type_id, 7 AS units_required, 'CRITICAL' AS urgency, 'EXPIRED' AS status, '2026-08-28 13:34:00' AS created_at, '2026-09-04' AS expires_at
UNION ALL
SELECT 166 AS seed_no, 'Yangon General Hospital' AS hospital_name, 6 AS blood_type_id, 8 AS units_required, 'NORMAL' AS urgency, 'OPEN' AS status, '2026-08-29 14:45:00' AS created_at, '2026-09-06' AS expires_at
UNION ALL
SELECT 167 AS seed_no, 'Victoria Hospital' AS hospital_name, 7 AS blood_type_id, 9 AS units_required, 'NORMAL' AS urgency, 'PARTIALLY_FULFILLED' AS status, '2026-08-30 15:56:00' AS created_at, '2026-09-08' AS expires_at
UNION ALL
SELECT 168 AS seed_no, 'Grand Hantha International Hospital' AS hospital_name, 8 AS blood_type_id, 10 AS units_required, 'NORMAL' AS urgency, 'FULFILLED' AS status, '2026-08-31 16:07:00' AS created_at, '2026-09-10' AS expires_at
UNION ALL
SELECT 169 AS seed_no, 'North Okkalapa General Hospital' AS hospital_name, 1 AS blood_type_id, 11 AS units_required, 'URGENT' AS urgency, 'CANCELLED' AS status, '2026-09-01 08:18:00' AS created_at, '2026-09-12' AS expires_at
UNION ALL
SELECT 170 AS seed_no, 'Thingangyun Sanpya Hospital' AS hospital_name, 2 AS blood_type_id, 12 AS units_required, 'CRITICAL' AS urgency, 'EXPIRED' AS status, '2026-09-02 09:29:00' AS created_at, '2026-09-14' AS expires_at
UNION ALL
SELECT 171 AS seed_no, 'Bahan Specialist Clinic' AS hospital_name, 3 AS blood_type_id, 3 AS units_required, 'NORMAL' AS urgency, 'OPEN' AS status, '2026-09-03 10:40:00' AS created_at, '2026-09-16' AS expires_at
UNION ALL
SELECT 172 AS seed_no, 'Latha General Hospital' AS hospital_name, 4 AS blood_type_id, 4 AS units_required, 'NORMAL' AS urgency, 'PARTIALLY_FULFILLED' AS status, '2026-09-04 11:51:00' AS created_at, '2026-09-18' AS expires_at
UNION ALL
SELECT 173 AS seed_no, 'Lanmadaw General Hospital' AS hospital_name, 5 AS blood_type_id, 5 AS units_required, 'NORMAL' AS urgency, 'FULFILLED' AS status, '2026-09-05 12:02:00' AS created_at, '2026-09-20' AS expires_at
UNION ALL
SELECT 174 AS seed_no, 'Insein General Hospital' AS hospital_name, 6 AS blood_type_id, 6 AS units_required, 'URGENT' AS urgency, 'CANCELLED' AS status, '2026-09-06 13:13:00' AS created_at, '2026-09-22' AS expires_at
UNION ALL
SELECT 175 AS seed_no, 'South Okkalapa Women’s Hospital' AS hospital_name, 7 AS blood_type_id, 7 AS units_required, 'CRITICAL' AS urgency, 'EXPIRED' AS status, '2026-09-07 14:24:00' AS created_at, '2026-09-12' AS expires_at
UNION ALL
SELECT 176 AS seed_no, 'Yangon Central Women’s Hospital' AS hospital_name, 8 AS blood_type_id, 8 AS units_required, 'NORMAL' AS urgency, 'OPEN' AS status, '2026-09-08 15:35:00' AS created_at, '2026-09-14' AS expires_at
UNION ALL
SELECT 177 AS seed_no, 'Shwe Pyi Thar General Hospital' AS hospital_name, 1 AS blood_type_id, 9 AS units_required, 'NORMAL' AS urgency, 'PARTIALLY_FULFILLED' AS status, '2026-09-09 16:46:00' AS created_at, '2026-09-16' AS expires_at
UNION ALL
SELECT 178 AS seed_no, 'Hlaing Tharyar Community Hospital' AS hospital_name, 2 AS blood_type_id, 10 AS units_required, 'NORMAL' AS urgency, 'FULFILLED' AS status, '2026-09-10 08:57:00' AS created_at, '2026-09-18' AS expires_at
UNION ALL
SELECT 179 AS seed_no, 'Ahlone Family Hospital' AS hospital_name, 3 AS blood_type_id, 11 AS units_required, 'URGENT' AS urgency, 'CANCELLED' AS status, '2026-09-11 09:08:00' AS created_at, '2026-09-20' AS expires_at
UNION ALL
SELECT 180 AS seed_no, 'Kamayut Teaching Hospital' AS hospital_name, 4 AS blood_type_id, 12 AS units_required, 'CRITICAL' AS urgency, 'EXPIRED' AS status, '2026-09-12 10:19:00' AS created_at, '2026-09-22' AS expires_at
) AS s
INNER JOIN hospitals h ON h.name = s.hospital_name
INNER JOIN addresses a ON a.id = h.address_id
WHERE h.status = 'ACTIVE'
  AND a.division = 'Yangon Region'
  AND h.id = (SELECT MIN(h2.id) FROM hospitals h2 WHERE h2.name = s.hospital_name)
  AND NOT EXISTS (
      SELECT 1 FROM blood_requests r
      WHERE r.hospital_id = h.id
        AND r.reason = CONCAT('Analytics seed request ', LPAD(s.seed_no, 3, '0'))
  );

-- 6) 220 completed donations: weekly history plus dense daily recent activity.
-- Each row is one completed donation; units vary between 1 and 3.
INSERT INTO donations (donor_id, hospital_id, appointment_id, donation_date, donation_type,
                       units, status, eligibility_status, checkin_notes, checkout_notes,
                       created_at, updated_at)
SELECT d.id, h.id, NULL, s.donation_date, 'WHOLE_BLOOD', s.units, 'COMPLETED',
       'ELIGIBLE',
       CONCAT('Analytics seed donation ', LPAD(s.seed_no, 3, '0')),
       'Routine completed donation.',
       s.created_at, s.created_at
FROM (
SELECT 1 AS seed_no, 'analytics.donor001@seed.amyanhlu.org' AS donor_email, 'Yangon General Hospital' AS hospital_name, '2023-09-03' AS donation_date, 1 AS units, '2023-09-03 10:00:00' AS created_at
UNION ALL
SELECT 2 AS seed_no, 'analytics.donor002@seed.amyanhlu.org' AS donor_email, 'North Okkalapa General Hospital' AS hospital_name, '2023-09-10' AS donation_date, 2 AS units, '2023-09-10 10:00:00' AS created_at
UNION ALL
SELECT 3 AS seed_no, 'analytics.donor003@seed.amyanhlu.org' AS donor_email, 'Latha General Hospital' AS hospital_name, '2023-09-17' AS donation_date, 3 AS units, '2023-09-17 10:00:00' AS created_at
UNION ALL
SELECT 4 AS seed_no, 'analytics.donor004@seed.amyanhlu.org' AS donor_email, 'South Okkalapa Women’s Hospital' AS hospital_name, '2023-09-24' AS donation_date, 1 AS units, '2023-09-24 10:00:00' AS created_at
UNION ALL
SELECT 5 AS seed_no, 'analytics.donor005@seed.amyanhlu.org' AS donor_email, 'Hlaing Tharyar Community Hospital' AS hospital_name, '2023-10-01' AS donation_date, 2 AS units, '2023-10-01 10:00:00' AS created_at
UNION ALL
SELECT 6 AS seed_no, 'analytics.donor006@seed.amyanhlu.org' AS donor_email, 'Yangon General Hospital' AS hospital_name, '2023-10-08' AS donation_date, 3 AS units, '2023-10-08 10:00:00' AS created_at
UNION ALL
SELECT 7 AS seed_no, 'analytics.donor007@seed.amyanhlu.org' AS donor_email, 'North Okkalapa General Hospital' AS hospital_name, '2023-10-15' AS donation_date, 1 AS units, '2023-10-15 10:00:00' AS created_at
UNION ALL
SELECT 8 AS seed_no, 'analytics.donor008@seed.amyanhlu.org' AS donor_email, 'Latha General Hospital' AS hospital_name, '2023-10-22' AS donation_date, 2 AS units, '2023-10-22 10:00:00' AS created_at
UNION ALL
SELECT 9 AS seed_no, 'analytics.donor009@seed.amyanhlu.org' AS donor_email, 'South Okkalapa Women’s Hospital' AS hospital_name, '2023-10-29' AS donation_date, 3 AS units, '2023-10-29 10:00:00' AS created_at
UNION ALL
SELECT 10 AS seed_no, 'analytics.donor010@seed.amyanhlu.org' AS donor_email, 'Hlaing Tharyar Community Hospital' AS hospital_name, '2023-11-05' AS donation_date, 1 AS units, '2023-11-05 10:00:00' AS created_at
UNION ALL
SELECT 11 AS seed_no, 'analytics.donor011@seed.amyanhlu.org' AS donor_email, 'Yangon General Hospital' AS hospital_name, '2023-11-12' AS donation_date, 2 AS units, '2023-11-12 10:00:00' AS created_at
UNION ALL
SELECT 12 AS seed_no, 'analytics.donor012@seed.amyanhlu.org' AS donor_email, 'North Okkalapa General Hospital' AS hospital_name, '2023-11-19' AS donation_date, 3 AS units, '2023-11-19 10:00:00' AS created_at
UNION ALL
SELECT 13 AS seed_no, 'analytics.donor013@seed.amyanhlu.org' AS donor_email, 'Latha General Hospital' AS hospital_name, '2023-11-26' AS donation_date, 1 AS units, '2023-11-26 10:00:00' AS created_at
UNION ALL
SELECT 14 AS seed_no, 'analytics.donor014@seed.amyanhlu.org' AS donor_email, 'South Okkalapa Women’s Hospital' AS hospital_name, '2023-12-03' AS donation_date, 2 AS units, '2023-12-03 10:00:00' AS created_at
UNION ALL
SELECT 15 AS seed_no, 'analytics.donor015@seed.amyanhlu.org' AS donor_email, 'Hlaing Tharyar Community Hospital' AS hospital_name, '2023-12-10' AS donation_date, 3 AS units, '2023-12-10 10:00:00' AS created_at
UNION ALL
SELECT 16 AS seed_no, 'analytics.donor016@seed.amyanhlu.org' AS donor_email, 'Yangon General Hospital' AS hospital_name, '2023-12-17' AS donation_date, 1 AS units, '2023-12-17 10:00:00' AS created_at
UNION ALL
SELECT 17 AS seed_no, 'analytics.donor017@seed.amyanhlu.org' AS donor_email, 'North Okkalapa General Hospital' AS hospital_name, '2023-12-24' AS donation_date, 2 AS units, '2023-12-24 10:00:00' AS created_at
UNION ALL
SELECT 18 AS seed_no, 'analytics.donor018@seed.amyanhlu.org' AS donor_email, 'Latha General Hospital' AS hospital_name, '2023-12-31' AS donation_date, 3 AS units, '2023-12-31 10:00:00' AS created_at
UNION ALL
SELECT 19 AS seed_no, 'analytics.donor019@seed.amyanhlu.org' AS donor_email, 'South Okkalapa Women’s Hospital' AS hospital_name, '2024-01-07' AS donation_date, 1 AS units, '2024-01-07 10:00:00' AS created_at
UNION ALL
SELECT 20 AS seed_no, 'analytics.donor020@seed.amyanhlu.org' AS donor_email, 'Hlaing Tharyar Community Hospital' AS hospital_name, '2024-01-14' AS donation_date, 2 AS units, '2024-01-14 10:00:00' AS created_at
UNION ALL
SELECT 21 AS seed_no, 'analytics.donor021@seed.amyanhlu.org' AS donor_email, 'Yangon General Hospital' AS hospital_name, '2024-01-21' AS donation_date, 3 AS units, '2024-01-21 10:00:00' AS created_at
UNION ALL
SELECT 22 AS seed_no, 'analytics.donor022@seed.amyanhlu.org' AS donor_email, 'North Okkalapa General Hospital' AS hospital_name, '2024-01-28' AS donation_date, 1 AS units, '2024-01-28 10:00:00' AS created_at
UNION ALL
SELECT 23 AS seed_no, 'analytics.donor023@seed.amyanhlu.org' AS donor_email, 'Latha General Hospital' AS hospital_name, '2024-02-04' AS donation_date, 2 AS units, '2024-02-04 10:00:00' AS created_at
UNION ALL
SELECT 24 AS seed_no, 'analytics.donor024@seed.amyanhlu.org' AS donor_email, 'South Okkalapa Women’s Hospital' AS hospital_name, '2024-02-11' AS donation_date, 3 AS units, '2024-02-11 10:00:00' AS created_at
UNION ALL
SELECT 25 AS seed_no, 'analytics.donor025@seed.amyanhlu.org' AS donor_email, 'Hlaing Tharyar Community Hospital' AS hospital_name, '2024-02-18' AS donation_date, 1 AS units, '2024-02-18 10:00:00' AS created_at
UNION ALL
SELECT 26 AS seed_no, 'analytics.donor026@seed.amyanhlu.org' AS donor_email, 'Yangon General Hospital' AS hospital_name, '2024-02-25' AS donation_date, 2 AS units, '2024-02-25 10:00:00' AS created_at
UNION ALL
SELECT 27 AS seed_no, 'analytics.donor027@seed.amyanhlu.org' AS donor_email, 'North Okkalapa General Hospital' AS hospital_name, '2024-03-03' AS donation_date, 3 AS units, '2024-03-03 10:00:00' AS created_at
UNION ALL
SELECT 28 AS seed_no, 'analytics.donor028@seed.amyanhlu.org' AS donor_email, 'Latha General Hospital' AS hospital_name, '2024-03-10' AS donation_date, 1 AS units, '2024-03-10 10:00:00' AS created_at
UNION ALL
SELECT 29 AS seed_no, 'analytics.donor029@seed.amyanhlu.org' AS donor_email, 'South Okkalapa Women’s Hospital' AS hospital_name, '2024-03-17' AS donation_date, 2 AS units, '2024-03-17 10:00:00' AS created_at
UNION ALL
SELECT 30 AS seed_no, 'analytics.donor030@seed.amyanhlu.org' AS donor_email, 'Hlaing Tharyar Community Hospital' AS hospital_name, '2024-03-24' AS donation_date, 3 AS units, '2024-03-24 10:00:00' AS created_at
UNION ALL
SELECT 31 AS seed_no, 'analytics.donor031@seed.amyanhlu.org' AS donor_email, 'Yangon General Hospital' AS hospital_name, '2024-03-31' AS donation_date, 1 AS units, '2024-03-31 10:00:00' AS created_at
UNION ALL
SELECT 32 AS seed_no, 'analytics.donor032@seed.amyanhlu.org' AS donor_email, 'North Okkalapa General Hospital' AS hospital_name, '2024-04-07' AS donation_date, 2 AS units, '2024-04-07 10:00:00' AS created_at
UNION ALL
SELECT 33 AS seed_no, 'analytics.donor001@seed.amyanhlu.org' AS donor_email, 'Latha General Hospital' AS hospital_name, '2024-04-14' AS donation_date, 3 AS units, '2024-04-14 10:00:00' AS created_at
UNION ALL
SELECT 34 AS seed_no, 'analytics.donor002@seed.amyanhlu.org' AS donor_email, 'South Okkalapa Women’s Hospital' AS hospital_name, '2024-04-21' AS donation_date, 1 AS units, '2024-04-21 10:00:00' AS created_at
UNION ALL
SELECT 35 AS seed_no, 'analytics.donor003@seed.amyanhlu.org' AS donor_email, 'Hlaing Tharyar Community Hospital' AS hospital_name, '2024-04-28' AS donation_date, 2 AS units, '2024-04-28 10:00:00' AS created_at
UNION ALL
SELECT 36 AS seed_no, 'analytics.donor004@seed.amyanhlu.org' AS donor_email, 'Yangon General Hospital' AS hospital_name, '2024-05-05' AS donation_date, 3 AS units, '2024-05-05 10:00:00' AS created_at
UNION ALL
SELECT 37 AS seed_no, 'analytics.donor005@seed.amyanhlu.org' AS donor_email, 'North Okkalapa General Hospital' AS hospital_name, '2024-05-12' AS donation_date, 1 AS units, '2024-05-12 10:00:00' AS created_at
UNION ALL
SELECT 38 AS seed_no, 'analytics.donor006@seed.amyanhlu.org' AS donor_email, 'Latha General Hospital' AS hospital_name, '2024-05-19' AS donation_date, 2 AS units, '2024-05-19 10:00:00' AS created_at
UNION ALL
SELECT 39 AS seed_no, 'analytics.donor007@seed.amyanhlu.org' AS donor_email, 'South Okkalapa Women’s Hospital' AS hospital_name, '2024-05-26' AS donation_date, 3 AS units, '2024-05-26 10:00:00' AS created_at
UNION ALL
SELECT 40 AS seed_no, 'analytics.donor008@seed.amyanhlu.org' AS donor_email, 'Hlaing Tharyar Community Hospital' AS hospital_name, '2024-06-02' AS donation_date, 1 AS units, '2024-06-02 10:00:00' AS created_at
UNION ALL
SELECT 41 AS seed_no, 'analytics.donor009@seed.amyanhlu.org' AS donor_email, 'Yangon General Hospital' AS hospital_name, '2024-06-09' AS donation_date, 2 AS units, '2024-06-09 10:00:00' AS created_at
UNION ALL
SELECT 42 AS seed_no, 'analytics.donor010@seed.amyanhlu.org' AS donor_email, 'North Okkalapa General Hospital' AS hospital_name, '2024-06-16' AS donation_date, 3 AS units, '2024-06-16 10:00:00' AS created_at
UNION ALL
SELECT 43 AS seed_no, 'analytics.donor011@seed.amyanhlu.org' AS donor_email, 'Latha General Hospital' AS hospital_name, '2024-06-23' AS donation_date, 1 AS units, '2024-06-23 10:00:00' AS created_at
UNION ALL
SELECT 44 AS seed_no, 'analytics.donor012@seed.amyanhlu.org' AS donor_email, 'South Okkalapa Women’s Hospital' AS hospital_name, '2024-06-30' AS donation_date, 2 AS units, '2024-06-30 10:00:00' AS created_at
UNION ALL
SELECT 45 AS seed_no, 'analytics.donor013@seed.amyanhlu.org' AS donor_email, 'Hlaing Tharyar Community Hospital' AS hospital_name, '2024-07-07' AS donation_date, 3 AS units, '2024-07-07 10:00:00' AS created_at
UNION ALL
SELECT 46 AS seed_no, 'analytics.donor014@seed.amyanhlu.org' AS donor_email, 'Yangon General Hospital' AS hospital_name, '2024-07-14' AS donation_date, 1 AS units, '2024-07-14 10:00:00' AS created_at
UNION ALL
SELECT 47 AS seed_no, 'analytics.donor015@seed.amyanhlu.org' AS donor_email, 'North Okkalapa General Hospital' AS hospital_name, '2024-07-21' AS donation_date, 2 AS units, '2024-07-21 10:00:00' AS created_at
UNION ALL
SELECT 48 AS seed_no, 'analytics.donor016@seed.amyanhlu.org' AS donor_email, 'Latha General Hospital' AS hospital_name, '2024-07-28' AS donation_date, 3 AS units, '2024-07-28 10:00:00' AS created_at
UNION ALL
SELECT 49 AS seed_no, 'analytics.donor017@seed.amyanhlu.org' AS donor_email, 'South Okkalapa Women’s Hospital' AS hospital_name, '2024-08-04' AS donation_date, 1 AS units, '2024-08-04 10:00:00' AS created_at
UNION ALL
SELECT 50 AS seed_no, 'analytics.donor018@seed.amyanhlu.org' AS donor_email, 'Hlaing Tharyar Community Hospital' AS hospital_name, '2024-08-11' AS donation_date, 2 AS units, '2024-08-11 10:00:00' AS created_at
UNION ALL
SELECT 51 AS seed_no, 'analytics.donor019@seed.amyanhlu.org' AS donor_email, 'Yangon General Hospital' AS hospital_name, '2024-08-18' AS donation_date, 3 AS units, '2024-08-18 10:00:00' AS created_at
UNION ALL
SELECT 52 AS seed_no, 'analytics.donor020@seed.amyanhlu.org' AS donor_email, 'North Okkalapa General Hospital' AS hospital_name, '2024-08-25' AS donation_date, 1 AS units, '2024-08-25 10:00:00' AS created_at
UNION ALL
SELECT 53 AS seed_no, 'analytics.donor021@seed.amyanhlu.org' AS donor_email, 'Latha General Hospital' AS hospital_name, '2024-09-01' AS donation_date, 2 AS units, '2024-09-01 10:00:00' AS created_at
UNION ALL
SELECT 54 AS seed_no, 'analytics.donor022@seed.amyanhlu.org' AS donor_email, 'South Okkalapa Women’s Hospital' AS hospital_name, '2024-09-08' AS donation_date, 3 AS units, '2024-09-08 10:00:00' AS created_at
UNION ALL
SELECT 55 AS seed_no, 'analytics.donor023@seed.amyanhlu.org' AS donor_email, 'Hlaing Tharyar Community Hospital' AS hospital_name, '2024-09-15' AS donation_date, 1 AS units, '2024-09-15 10:00:00' AS created_at
UNION ALL
SELECT 56 AS seed_no, 'analytics.donor024@seed.amyanhlu.org' AS donor_email, 'Yangon General Hospital' AS hospital_name, '2024-09-22' AS donation_date, 2 AS units, '2024-09-22 10:00:00' AS created_at
UNION ALL
SELECT 57 AS seed_no, 'analytics.donor025@seed.amyanhlu.org' AS donor_email, 'North Okkalapa General Hospital' AS hospital_name, '2024-09-29' AS donation_date, 3 AS units, '2024-09-29 10:00:00' AS created_at
UNION ALL
SELECT 58 AS seed_no, 'analytics.donor026@seed.amyanhlu.org' AS donor_email, 'Latha General Hospital' AS hospital_name, '2024-10-06' AS donation_date, 1 AS units, '2024-10-06 10:00:00' AS created_at
UNION ALL
SELECT 59 AS seed_no, 'analytics.donor027@seed.amyanhlu.org' AS donor_email, 'South Okkalapa Women’s Hospital' AS hospital_name, '2024-10-13' AS donation_date, 2 AS units, '2024-10-13 10:00:00' AS created_at
UNION ALL
SELECT 60 AS seed_no, 'analytics.donor028@seed.amyanhlu.org' AS donor_email, 'Hlaing Tharyar Community Hospital' AS hospital_name, '2024-10-20' AS donation_date, 3 AS units, '2024-10-20 10:00:00' AS created_at
UNION ALL
SELECT 61 AS seed_no, 'analytics.donor029@seed.amyanhlu.org' AS donor_email, 'Yangon General Hospital' AS hospital_name, '2024-10-27' AS donation_date, 1 AS units, '2024-10-27 10:00:00' AS created_at
UNION ALL
SELECT 62 AS seed_no, 'analytics.donor030@seed.amyanhlu.org' AS donor_email, 'North Okkalapa General Hospital' AS hospital_name, '2024-11-03' AS donation_date, 2 AS units, '2024-11-03 10:00:00' AS created_at
UNION ALL
SELECT 63 AS seed_no, 'analytics.donor031@seed.amyanhlu.org' AS donor_email, 'Latha General Hospital' AS hospital_name, '2024-11-10' AS donation_date, 3 AS units, '2024-11-10 10:00:00' AS created_at
UNION ALL
SELECT 64 AS seed_no, 'analytics.donor032@seed.amyanhlu.org' AS donor_email, 'South Okkalapa Women’s Hospital' AS hospital_name, '2024-11-17' AS donation_date, 1 AS units, '2024-11-17 10:00:00' AS created_at
UNION ALL
SELECT 65 AS seed_no, 'analytics.donor001@seed.amyanhlu.org' AS donor_email, 'Hlaing Tharyar Community Hospital' AS hospital_name, '2024-11-24' AS donation_date, 2 AS units, '2024-11-24 10:00:00' AS created_at
UNION ALL
SELECT 66 AS seed_no, 'analytics.donor002@seed.amyanhlu.org' AS donor_email, 'Yangon General Hospital' AS hospital_name, '2024-12-01' AS donation_date, 3 AS units, '2024-12-01 10:00:00' AS created_at
UNION ALL
SELECT 67 AS seed_no, 'analytics.donor003@seed.amyanhlu.org' AS donor_email, 'North Okkalapa General Hospital' AS hospital_name, '2024-12-08' AS donation_date, 1 AS units, '2024-12-08 10:00:00' AS created_at
UNION ALL
SELECT 68 AS seed_no, 'analytics.donor004@seed.amyanhlu.org' AS donor_email, 'Latha General Hospital' AS hospital_name, '2024-12-15' AS donation_date, 2 AS units, '2024-12-15 10:00:00' AS created_at
UNION ALL
SELECT 69 AS seed_no, 'analytics.donor005@seed.amyanhlu.org' AS donor_email, 'South Okkalapa Women’s Hospital' AS hospital_name, '2024-12-22' AS donation_date, 3 AS units, '2024-12-22 10:00:00' AS created_at
UNION ALL
SELECT 70 AS seed_no, 'analytics.donor006@seed.amyanhlu.org' AS donor_email, 'Hlaing Tharyar Community Hospital' AS hospital_name, '2024-12-29' AS donation_date, 1 AS units, '2024-12-29 10:00:00' AS created_at
UNION ALL
SELECT 71 AS seed_no, 'analytics.donor007@seed.amyanhlu.org' AS donor_email, 'Yangon General Hospital' AS hospital_name, '2025-01-05' AS donation_date, 2 AS units, '2025-01-05 10:00:00' AS created_at
UNION ALL
SELECT 72 AS seed_no, 'analytics.donor008@seed.amyanhlu.org' AS donor_email, 'North Okkalapa General Hospital' AS hospital_name, '2025-01-12' AS donation_date, 3 AS units, '2025-01-12 10:00:00' AS created_at
UNION ALL
SELECT 73 AS seed_no, 'analytics.donor009@seed.amyanhlu.org' AS donor_email, 'Latha General Hospital' AS hospital_name, '2025-01-19' AS donation_date, 1 AS units, '2025-01-19 10:00:00' AS created_at
UNION ALL
SELECT 74 AS seed_no, 'analytics.donor010@seed.amyanhlu.org' AS donor_email, 'South Okkalapa Women’s Hospital' AS hospital_name, '2025-01-26' AS donation_date, 2 AS units, '2025-01-26 10:00:00' AS created_at
UNION ALL
SELECT 75 AS seed_no, 'analytics.donor011@seed.amyanhlu.org' AS donor_email, 'Hlaing Tharyar Community Hospital' AS hospital_name, '2025-02-02' AS donation_date, 3 AS units, '2025-02-02 10:00:00' AS created_at
UNION ALL
SELECT 76 AS seed_no, 'analytics.donor012@seed.amyanhlu.org' AS donor_email, 'Yangon General Hospital' AS hospital_name, '2025-02-09' AS donation_date, 1 AS units, '2025-02-09 10:00:00' AS created_at
UNION ALL
SELECT 77 AS seed_no, 'analytics.donor013@seed.amyanhlu.org' AS donor_email, 'North Okkalapa General Hospital' AS hospital_name, '2025-02-16' AS donation_date, 2 AS units, '2025-02-16 10:00:00' AS created_at
UNION ALL
SELECT 78 AS seed_no, 'analytics.donor014@seed.amyanhlu.org' AS donor_email, 'Latha General Hospital' AS hospital_name, '2025-02-23' AS donation_date, 3 AS units, '2025-02-23 10:00:00' AS created_at
UNION ALL
SELECT 79 AS seed_no, 'analytics.donor015@seed.amyanhlu.org' AS donor_email, 'South Okkalapa Women’s Hospital' AS hospital_name, '2025-03-02' AS donation_date, 1 AS units, '2025-03-02 10:00:00' AS created_at
UNION ALL
SELECT 80 AS seed_no, 'analytics.donor016@seed.amyanhlu.org' AS donor_email, 'Hlaing Tharyar Community Hospital' AS hospital_name, '2025-03-09' AS donation_date, 2 AS units, '2025-03-09 10:00:00' AS created_at
UNION ALL
SELECT 81 AS seed_no, 'analytics.donor017@seed.amyanhlu.org' AS donor_email, 'Yangon General Hospital' AS hospital_name, '2025-03-16' AS donation_date, 3 AS units, '2025-03-16 10:00:00' AS created_at
UNION ALL
SELECT 82 AS seed_no, 'analytics.donor018@seed.amyanhlu.org' AS donor_email, 'North Okkalapa General Hospital' AS hospital_name, '2025-03-23' AS donation_date, 1 AS units, '2025-03-23 10:00:00' AS created_at
UNION ALL
SELECT 83 AS seed_no, 'analytics.donor019@seed.amyanhlu.org' AS donor_email, 'Latha General Hospital' AS hospital_name, '2025-03-30' AS donation_date, 2 AS units, '2025-03-30 10:00:00' AS created_at
UNION ALL
SELECT 84 AS seed_no, 'analytics.donor020@seed.amyanhlu.org' AS donor_email, 'South Okkalapa Women’s Hospital' AS hospital_name, '2025-04-06' AS donation_date, 3 AS units, '2025-04-06 10:00:00' AS created_at
UNION ALL
SELECT 85 AS seed_no, 'analytics.donor021@seed.amyanhlu.org' AS donor_email, 'Hlaing Tharyar Community Hospital' AS hospital_name, '2025-04-13' AS donation_date, 1 AS units, '2025-04-13 10:00:00' AS created_at
UNION ALL
SELECT 86 AS seed_no, 'analytics.donor022@seed.amyanhlu.org' AS donor_email, 'Yangon General Hospital' AS hospital_name, '2025-04-20' AS donation_date, 2 AS units, '2025-04-20 10:00:00' AS created_at
UNION ALL
SELECT 87 AS seed_no, 'analytics.donor023@seed.amyanhlu.org' AS donor_email, 'North Okkalapa General Hospital' AS hospital_name, '2025-04-27' AS donation_date, 3 AS units, '2025-04-27 10:00:00' AS created_at
UNION ALL
SELECT 88 AS seed_no, 'analytics.donor024@seed.amyanhlu.org' AS donor_email, 'Latha General Hospital' AS hospital_name, '2025-05-04' AS donation_date, 1 AS units, '2025-05-04 10:00:00' AS created_at
UNION ALL
SELECT 89 AS seed_no, 'analytics.donor025@seed.amyanhlu.org' AS donor_email, 'South Okkalapa Women’s Hospital' AS hospital_name, '2025-05-11' AS donation_date, 2 AS units, '2025-05-11 10:00:00' AS created_at
UNION ALL
SELECT 90 AS seed_no, 'analytics.donor026@seed.amyanhlu.org' AS donor_email, 'Hlaing Tharyar Community Hospital' AS hospital_name, '2025-05-18' AS donation_date, 3 AS units, '2025-05-18 10:00:00' AS created_at
UNION ALL
SELECT 91 AS seed_no, 'analytics.donor027@seed.amyanhlu.org' AS donor_email, 'Yangon General Hospital' AS hospital_name, '2025-05-25' AS donation_date, 1 AS units, '2025-05-25 10:00:00' AS created_at
UNION ALL
SELECT 92 AS seed_no, 'analytics.donor028@seed.amyanhlu.org' AS donor_email, 'North Okkalapa General Hospital' AS hospital_name, '2025-06-01' AS donation_date, 2 AS units, '2025-06-01 10:00:00' AS created_at
UNION ALL
SELECT 93 AS seed_no, 'analytics.donor029@seed.amyanhlu.org' AS donor_email, 'Latha General Hospital' AS hospital_name, '2025-06-08' AS donation_date, 3 AS units, '2025-06-08 10:00:00' AS created_at
UNION ALL
SELECT 94 AS seed_no, 'analytics.donor030@seed.amyanhlu.org' AS donor_email, 'South Okkalapa Women’s Hospital' AS hospital_name, '2025-06-15' AS donation_date, 1 AS units, '2025-06-15 10:00:00' AS created_at
UNION ALL
SELECT 95 AS seed_no, 'analytics.donor031@seed.amyanhlu.org' AS donor_email, 'Hlaing Tharyar Community Hospital' AS hospital_name, '2025-06-22' AS donation_date, 2 AS units, '2025-06-22 10:00:00' AS created_at
UNION ALL
SELECT 96 AS seed_no, 'analytics.donor032@seed.amyanhlu.org' AS donor_email, 'Yangon General Hospital' AS hospital_name, '2025-06-29' AS donation_date, 3 AS units, '2025-06-29 10:00:00' AS created_at
UNION ALL
SELECT 97 AS seed_no, 'analytics.donor001@seed.amyanhlu.org' AS donor_email, 'North Okkalapa General Hospital' AS hospital_name, '2025-07-06' AS donation_date, 1 AS units, '2025-07-06 10:00:00' AS created_at
UNION ALL
SELECT 98 AS seed_no, 'analytics.donor002@seed.amyanhlu.org' AS donor_email, 'Latha General Hospital' AS hospital_name, '2025-07-13' AS donation_date, 2 AS units, '2025-07-13 10:00:00' AS created_at
UNION ALL
SELECT 99 AS seed_no, 'analytics.donor003@seed.amyanhlu.org' AS donor_email, 'South Okkalapa Women’s Hospital' AS hospital_name, '2025-07-20' AS donation_date, 3 AS units, '2025-07-20 10:00:00' AS created_at
UNION ALL
SELECT 100 AS seed_no, 'analytics.donor004@seed.amyanhlu.org' AS donor_email, 'Hlaing Tharyar Community Hospital' AS hospital_name, '2025-07-27' AS donation_date, 1 AS units, '2025-07-27 10:00:00' AS created_at
UNION ALL
SELECT 101 AS seed_no, 'analytics.donor005@seed.amyanhlu.org' AS donor_email, 'Yangon General Hospital' AS hospital_name, '2025-08-03' AS donation_date, 2 AS units, '2025-08-03 10:00:00' AS created_at
UNION ALL
SELECT 102 AS seed_no, 'analytics.donor006@seed.amyanhlu.org' AS donor_email, 'North Okkalapa General Hospital' AS hospital_name, '2025-08-10' AS donation_date, 3 AS units, '2025-08-10 10:00:00' AS created_at
UNION ALL
SELECT 103 AS seed_no, 'analytics.donor007@seed.amyanhlu.org' AS donor_email, 'Latha General Hospital' AS hospital_name, '2025-08-17' AS donation_date, 1 AS units, '2025-08-17 10:00:00' AS created_at
UNION ALL
SELECT 104 AS seed_no, 'analytics.donor008@seed.amyanhlu.org' AS donor_email, 'South Okkalapa Women’s Hospital' AS hospital_name, '2025-08-24' AS donation_date, 2 AS units, '2025-08-24 10:00:00' AS created_at
UNION ALL
SELECT 105 AS seed_no, 'analytics.donor009@seed.amyanhlu.org' AS donor_email, 'Hlaing Tharyar Community Hospital' AS hospital_name, '2025-08-31' AS donation_date, 3 AS units, '2025-08-31 10:00:00' AS created_at
UNION ALL
SELECT 106 AS seed_no, 'analytics.donor010@seed.amyanhlu.org' AS donor_email, 'Yangon General Hospital' AS hospital_name, '2025-09-07' AS donation_date, 1 AS units, '2025-09-07 10:00:00' AS created_at
UNION ALL
SELECT 107 AS seed_no, 'analytics.donor011@seed.amyanhlu.org' AS donor_email, 'North Okkalapa General Hospital' AS hospital_name, '2025-09-14' AS donation_date, 2 AS units, '2025-09-14 10:00:00' AS created_at
UNION ALL
SELECT 108 AS seed_no, 'analytics.donor012@seed.amyanhlu.org' AS donor_email, 'Latha General Hospital' AS hospital_name, '2025-09-21' AS donation_date, 3 AS units, '2025-09-21 10:00:00' AS created_at
UNION ALL
SELECT 109 AS seed_no, 'analytics.donor013@seed.amyanhlu.org' AS donor_email, 'South Okkalapa Women’s Hospital' AS hospital_name, '2025-09-28' AS donation_date, 1 AS units, '2025-09-28 10:00:00' AS created_at
UNION ALL
SELECT 110 AS seed_no, 'analytics.donor014@seed.amyanhlu.org' AS donor_email, 'Hlaing Tharyar Community Hospital' AS hospital_name, '2025-10-05' AS donation_date, 2 AS units, '2025-10-05 10:00:00' AS created_at
UNION ALL
SELECT 111 AS seed_no, 'analytics.donor015@seed.amyanhlu.org' AS donor_email, 'Yangon General Hospital' AS hospital_name, '2025-10-12' AS donation_date, 3 AS units, '2025-10-12 10:00:00' AS created_at
UNION ALL
SELECT 112 AS seed_no, 'analytics.donor016@seed.amyanhlu.org' AS donor_email, 'North Okkalapa General Hospital' AS hospital_name, '2025-10-19' AS donation_date, 1 AS units, '2025-10-19 10:00:00' AS created_at
UNION ALL
SELECT 113 AS seed_no, 'analytics.donor017@seed.amyanhlu.org' AS donor_email, 'Latha General Hospital' AS hospital_name, '2025-10-26' AS donation_date, 2 AS units, '2025-10-26 10:00:00' AS created_at
UNION ALL
SELECT 114 AS seed_no, 'analytics.donor018@seed.amyanhlu.org' AS donor_email, 'South Okkalapa Women’s Hospital' AS hospital_name, '2025-11-02' AS donation_date, 3 AS units, '2025-11-02 10:00:00' AS created_at
UNION ALL
SELECT 115 AS seed_no, 'analytics.donor019@seed.amyanhlu.org' AS donor_email, 'Hlaing Tharyar Community Hospital' AS hospital_name, '2025-11-09' AS donation_date, 1 AS units, '2025-11-09 10:00:00' AS created_at
UNION ALL
SELECT 116 AS seed_no, 'analytics.donor020@seed.amyanhlu.org' AS donor_email, 'Yangon General Hospital' AS hospital_name, '2025-11-16' AS donation_date, 2 AS units, '2025-11-16 10:00:00' AS created_at
UNION ALL
SELECT 117 AS seed_no, 'analytics.donor021@seed.amyanhlu.org' AS donor_email, 'North Okkalapa General Hospital' AS hospital_name, '2025-11-23' AS donation_date, 3 AS units, '2025-11-23 10:00:00' AS created_at
UNION ALL
SELECT 118 AS seed_no, 'analytics.donor022@seed.amyanhlu.org' AS donor_email, 'Latha General Hospital' AS hospital_name, '2025-11-30' AS donation_date, 1 AS units, '2025-11-30 10:00:00' AS created_at
UNION ALL
SELECT 119 AS seed_no, 'analytics.donor023@seed.amyanhlu.org' AS donor_email, 'South Okkalapa Women’s Hospital' AS hospital_name, '2025-12-07' AS donation_date, 2 AS units, '2025-12-07 10:00:00' AS created_at
UNION ALL
SELECT 120 AS seed_no, 'analytics.donor024@seed.amyanhlu.org' AS donor_email, 'Hlaing Tharyar Community Hospital' AS hospital_name, '2025-12-14' AS donation_date, 3 AS units, '2025-12-14 10:00:00' AS created_at
UNION ALL
SELECT 121 AS seed_no, 'analytics.donor025@seed.amyanhlu.org' AS donor_email, 'Yangon General Hospital' AS hospital_name, '2025-12-21' AS donation_date, 1 AS units, '2025-12-21 10:00:00' AS created_at
UNION ALL
SELECT 122 AS seed_no, 'analytics.donor026@seed.amyanhlu.org' AS donor_email, 'North Okkalapa General Hospital' AS hospital_name, '2025-12-28' AS donation_date, 2 AS units, '2025-12-28 10:00:00' AS created_at
UNION ALL
SELECT 123 AS seed_no, 'analytics.donor027@seed.amyanhlu.org' AS donor_email, 'Latha General Hospital' AS hospital_name, '2026-01-04' AS donation_date, 3 AS units, '2026-01-04 10:00:00' AS created_at
UNION ALL
SELECT 124 AS seed_no, 'analytics.donor028@seed.amyanhlu.org' AS donor_email, 'South Okkalapa Women’s Hospital' AS hospital_name, '2026-01-11' AS donation_date, 1 AS units, '2026-01-11 10:00:00' AS created_at
UNION ALL
SELECT 125 AS seed_no, 'analytics.donor029@seed.amyanhlu.org' AS donor_email, 'Hlaing Tharyar Community Hospital' AS hospital_name, '2026-01-18' AS donation_date, 2 AS units, '2026-01-18 10:00:00' AS created_at
UNION ALL
SELECT 126 AS seed_no, 'analytics.donor030@seed.amyanhlu.org' AS donor_email, 'Yangon General Hospital' AS hospital_name, '2026-01-25' AS donation_date, 3 AS units, '2026-01-25 10:00:00' AS created_at
UNION ALL
SELECT 127 AS seed_no, 'analytics.donor031@seed.amyanhlu.org' AS donor_email, 'North Okkalapa General Hospital' AS hospital_name, '2026-02-01' AS donation_date, 1 AS units, '2026-02-01 10:00:00' AS created_at
UNION ALL
SELECT 128 AS seed_no, 'analytics.donor032@seed.amyanhlu.org' AS donor_email, 'Latha General Hospital' AS hospital_name, '2026-02-08' AS donation_date, 2 AS units, '2026-02-08 10:00:00' AS created_at
UNION ALL
SELECT 129 AS seed_no, 'analytics.donor001@seed.amyanhlu.org' AS donor_email, 'South Okkalapa Women’s Hospital' AS hospital_name, '2026-02-15' AS donation_date, 3 AS units, '2026-02-15 10:00:00' AS created_at
UNION ALL
SELECT 130 AS seed_no, 'analytics.donor002@seed.amyanhlu.org' AS donor_email, 'Hlaing Tharyar Community Hospital' AS hospital_name, '2026-02-22' AS donation_date, 1 AS units, '2026-02-22 10:00:00' AS created_at
UNION ALL
SELECT 131 AS seed_no, 'analytics.donor003@seed.amyanhlu.org' AS donor_email, 'Yangon General Hospital' AS hospital_name, '2026-03-01' AS donation_date, 2 AS units, '2026-03-01 10:00:00' AS created_at
UNION ALL
SELECT 132 AS seed_no, 'analytics.donor004@seed.amyanhlu.org' AS donor_email, 'North Okkalapa General Hospital' AS hospital_name, '2026-03-08' AS donation_date, 3 AS units, '2026-03-08 10:00:00' AS created_at
UNION ALL
SELECT 133 AS seed_no, 'analytics.donor005@seed.amyanhlu.org' AS donor_email, 'Latha General Hospital' AS hospital_name, '2026-03-15' AS donation_date, 1 AS units, '2026-03-15 10:00:00' AS created_at
UNION ALL
SELECT 134 AS seed_no, 'analytics.donor006@seed.amyanhlu.org' AS donor_email, 'South Okkalapa Women’s Hospital' AS hospital_name, '2026-03-22' AS donation_date, 2 AS units, '2026-03-22 10:00:00' AS created_at
UNION ALL
SELECT 135 AS seed_no, 'analytics.donor007@seed.amyanhlu.org' AS donor_email, 'Hlaing Tharyar Community Hospital' AS hospital_name, '2026-03-29' AS donation_date, 3 AS units, '2026-03-29 10:00:00' AS created_at
UNION ALL
SELECT 136 AS seed_no, 'analytics.donor008@seed.amyanhlu.org' AS donor_email, 'Yangon General Hospital' AS hospital_name, '2026-04-05' AS donation_date, 1 AS units, '2026-04-05 10:00:00' AS created_at
UNION ALL
SELECT 137 AS seed_no, 'analytics.donor009@seed.amyanhlu.org' AS donor_email, 'North Okkalapa General Hospital' AS hospital_name, '2026-04-12' AS donation_date, 2 AS units, '2026-04-12 10:00:00' AS created_at
UNION ALL
SELECT 138 AS seed_no, 'analytics.donor010@seed.amyanhlu.org' AS donor_email, 'Latha General Hospital' AS hospital_name, '2026-04-19' AS donation_date, 3 AS units, '2026-04-19 10:00:00' AS created_at
UNION ALL
SELECT 139 AS seed_no, 'analytics.donor011@seed.amyanhlu.org' AS donor_email, 'South Okkalapa Women’s Hospital' AS hospital_name, '2026-04-26' AS donation_date, 1 AS units, '2026-04-26 10:00:00' AS created_at
UNION ALL
SELECT 140 AS seed_no, 'analytics.donor012@seed.amyanhlu.org' AS donor_email, 'Hlaing Tharyar Community Hospital' AS hospital_name, '2026-05-03' AS donation_date, 2 AS units, '2026-05-03 10:00:00' AS created_at
UNION ALL
SELECT 141 AS seed_no, 'analytics.donor013@seed.amyanhlu.org' AS donor_email, 'Yangon General Hospital' AS hospital_name, '2026-05-10' AS donation_date, 3 AS units, '2026-05-10 10:00:00' AS created_at
UNION ALL
SELECT 142 AS seed_no, 'analytics.donor014@seed.amyanhlu.org' AS donor_email, 'North Okkalapa General Hospital' AS hospital_name, '2026-05-17' AS donation_date, 1 AS units, '2026-05-17 10:00:00' AS created_at
UNION ALL
SELECT 143 AS seed_no, 'analytics.donor015@seed.amyanhlu.org' AS donor_email, 'Latha General Hospital' AS hospital_name, '2026-05-24' AS donation_date, 2 AS units, '2026-05-24 10:00:00' AS created_at
UNION ALL
SELECT 144 AS seed_no, 'analytics.donor016@seed.amyanhlu.org' AS donor_email, 'South Okkalapa Women’s Hospital' AS hospital_name, '2026-05-31' AS donation_date, 3 AS units, '2026-05-31 10:00:00' AS created_at
UNION ALL
SELECT 145 AS seed_no, 'analytics.donor017@seed.amyanhlu.org' AS donor_email, 'Hlaing Tharyar Community Hospital' AS hospital_name, '2026-06-07' AS donation_date, 1 AS units, '2026-06-07 10:00:00' AS created_at
UNION ALL
SELECT 146 AS seed_no, 'analytics.donor018@seed.amyanhlu.org' AS donor_email, 'Yangon General Hospital' AS hospital_name, '2026-06-14' AS donation_date, 2 AS units, '2026-06-14 10:00:00' AS created_at
UNION ALL
SELECT 147 AS seed_no, 'analytics.donor019@seed.amyanhlu.org' AS donor_email, 'North Okkalapa General Hospital' AS hospital_name, '2026-06-21' AS donation_date, 3 AS units, '2026-06-21 10:00:00' AS created_at
UNION ALL
SELECT 148 AS seed_no, 'analytics.donor020@seed.amyanhlu.org' AS donor_email, 'Latha General Hospital' AS hospital_name, '2026-06-28' AS donation_date, 1 AS units, '2026-06-28 10:00:00' AS created_at
UNION ALL
SELECT 149 AS seed_no, 'analytics.donor021@seed.amyanhlu.org' AS donor_email, 'South Okkalapa Women’s Hospital' AS hospital_name, '2026-07-05' AS donation_date, 2 AS units, '2026-07-05 10:00:00' AS created_at
UNION ALL
SELECT 150 AS seed_no, 'analytics.donor022@seed.amyanhlu.org' AS donor_email, 'Hlaing Tharyar Community Hospital' AS hospital_name, '2026-07-12' AS donation_date, 3 AS units, '2026-07-12 10:00:00' AS created_at
UNION ALL
SELECT 151 AS seed_no, 'analytics.donor023@seed.amyanhlu.org' AS donor_email, 'Yangon General Hospital' AS hospital_name, '2026-07-19' AS donation_date, 1 AS units, '2026-07-19 10:00:00' AS created_at
UNION ALL
SELECT 152 AS seed_no, 'analytics.donor024@seed.amyanhlu.org' AS donor_email, 'North Okkalapa General Hospital' AS hospital_name, '2026-07-26' AS donation_date, 2 AS units, '2026-07-26 10:00:00' AS created_at
UNION ALL
SELECT 153 AS seed_no, 'analytics.donor025@seed.amyanhlu.org' AS donor_email, 'Latha General Hospital' AS hospital_name, '2026-08-02' AS donation_date, 3 AS units, '2026-08-02 10:00:00' AS created_at
UNION ALL
SELECT 154 AS seed_no, 'analytics.donor026@seed.amyanhlu.org' AS donor_email, 'South Okkalapa Women’s Hospital' AS hospital_name, '2026-08-09' AS donation_date, 1 AS units, '2026-08-09 10:00:00' AS created_at
UNION ALL
SELECT 155 AS seed_no, 'analytics.donor027@seed.amyanhlu.org' AS donor_email, 'Hlaing Tharyar Community Hospital' AS hospital_name, '2026-08-16' AS donation_date, 2 AS units, '2026-08-16 10:00:00' AS created_at
UNION ALL
SELECT 156 AS seed_no, 'analytics.donor028@seed.amyanhlu.org' AS donor_email, 'Yangon General Hospital' AS hospital_name, '2026-08-23' AS donation_date, 3 AS units, '2026-08-23 10:00:00' AS created_at
UNION ALL
SELECT 157 AS seed_no, 'analytics.donor029@seed.amyanhlu.org' AS donor_email, 'North Okkalapa General Hospital' AS hospital_name, '2026-08-30' AS donation_date, 1 AS units, '2026-08-30 10:00:00' AS created_at
UNION ALL
SELECT 158 AS seed_no, 'analytics.donor030@seed.amyanhlu.org' AS donor_email, 'Latha General Hospital' AS hospital_name, '2026-09-06' AS donation_date, 2 AS units, '2026-09-06 10:00:00' AS created_at
UNION ALL
SELECT 159 AS seed_no, 'analytics.donor031@seed.amyanhlu.org' AS donor_email, 'South Okkalapa Women’s Hospital' AS hospital_name, '2026-09-11' AS donation_date, 3 AS units, '2026-09-11 10:00:00' AS created_at
UNION ALL
SELECT 160 AS seed_no, 'analytics.donor032@seed.amyanhlu.org' AS donor_email, 'Hlaing Tharyar Community Hospital' AS hospital_name, '2026-09-12' AS donation_date, 1 AS units, '2026-09-12 10:00:00' AS created_at
UNION ALL
SELECT 161 AS seed_no, 'analytics.donor001@seed.amyanhlu.org' AS donor_email, 'Yangon Central Women’s Hospital' AS hospital_name, '2026-08-14' AS donation_date, 1 AS units, '2026-08-14 09:30:00' AS created_at
UNION ALL
SELECT 162 AS seed_no, 'analytics.donor002@seed.amyanhlu.org' AS donor_email, 'Hlaing Tharyar Community Hospital' AS hospital_name, '2026-08-14' AS donation_date, 2 AS units, '2026-08-14 10:30:00' AS created_at
UNION ALL
SELECT 163 AS seed_no, 'analytics.donor003@seed.amyanhlu.org' AS donor_email, 'Kamayut Teaching Hospital' AS hospital_name, '2026-08-15' AS donation_date, 1 AS units, '2026-08-15 11:30:00' AS created_at
UNION ALL
SELECT 164 AS seed_no, 'analytics.donor004@seed.amyanhlu.org' AS donor_email, 'Victoria Hospital' AS hospital_name, '2026-08-15' AS donation_date, 2 AS units, '2026-08-15 12:30:00' AS created_at
UNION ALL
SELECT 165 AS seed_no, 'analytics.donor005@seed.amyanhlu.org' AS donor_email, 'North Okkalapa General Hospital' AS hospital_name, '2026-08-16' AS donation_date, 1 AS units, '2026-08-16 13:30:00' AS created_at
UNION ALL
SELECT 166 AS seed_no, 'analytics.donor006@seed.amyanhlu.org' AS donor_email, 'Bahan Specialist Clinic' AS hospital_name, '2026-08-16' AS donation_date, 2 AS units, '2026-08-16 14:30:00' AS created_at
UNION ALL
SELECT 167 AS seed_no, 'analytics.donor007@seed.amyanhlu.org' AS donor_email, 'Lanmadaw General Hospital' AS hospital_name, '2026-08-17' AS donation_date, 1 AS units, '2026-08-17 15:30:00' AS created_at
UNION ALL
SELECT 168 AS seed_no, 'analytics.donor008@seed.amyanhlu.org' AS donor_email, 'South Okkalapa Women’s Hospital' AS hospital_name, '2026-08-17' AS donation_date, 2 AS units, '2026-08-17 16:30:00' AS created_at
UNION ALL
SELECT 169 AS seed_no, 'analytics.donor009@seed.amyanhlu.org' AS donor_email, 'Shwe Pyi Thar General Hospital' AS hospital_name, '2026-08-18' AS donation_date, 1 AS units, '2026-08-18 09:30:00' AS created_at
UNION ALL
SELECT 170 AS seed_no, 'analytics.donor010@seed.amyanhlu.org' AS donor_email, 'Ahlone Family Hospital' AS hospital_name, '2026-08-18' AS donation_date, 2 AS units, '2026-08-18 10:30:00' AS created_at
UNION ALL
SELECT 171 AS seed_no, 'analytics.donor011@seed.amyanhlu.org' AS donor_email, 'Yangon General Hospital' AS hospital_name, '2026-08-19' AS donation_date, 1 AS units, '2026-08-19 11:30:00' AS created_at
UNION ALL
SELECT 172 AS seed_no, 'analytics.donor012@seed.amyanhlu.org' AS donor_email, 'Grand Hantha International Hospital' AS hospital_name, '2026-08-19' AS donation_date, 2 AS units, '2026-08-19 12:30:00' AS created_at
UNION ALL
SELECT 173 AS seed_no, 'analytics.donor013@seed.amyanhlu.org' AS donor_email, 'Thingangyun Sanpya Hospital' AS hospital_name, '2026-08-20' AS donation_date, 1 AS units, '2026-08-20 13:30:00' AS created_at
UNION ALL
SELECT 174 AS seed_no, 'analytics.donor014@seed.amyanhlu.org' AS donor_email, 'Latha General Hospital' AS hospital_name, '2026-08-20' AS donation_date, 2 AS units, '2026-08-20 14:30:00' AS created_at
UNION ALL
SELECT 175 AS seed_no, 'analytics.donor015@seed.amyanhlu.org' AS donor_email, 'Insein General Hospital' AS hospital_name, '2026-08-21' AS donation_date, 1 AS units, '2026-08-21 15:30:00' AS created_at
UNION ALL
SELECT 176 AS seed_no, 'analytics.donor016@seed.amyanhlu.org' AS donor_email, 'Yangon Central Women’s Hospital' AS hospital_name, '2026-08-21' AS donation_date, 2 AS units, '2026-08-21 16:30:00' AS created_at
UNION ALL
SELECT 177 AS seed_no, 'analytics.donor017@seed.amyanhlu.org' AS donor_email, 'Hlaing Tharyar Community Hospital' AS hospital_name, '2026-08-22' AS donation_date, 1 AS units, '2026-08-22 09:30:00' AS created_at
UNION ALL
SELECT 178 AS seed_no, 'analytics.donor018@seed.amyanhlu.org' AS donor_email, 'Kamayut Teaching Hospital' AS hospital_name, '2026-08-22' AS donation_date, 2 AS units, '2026-08-22 10:30:00' AS created_at
UNION ALL
SELECT 179 AS seed_no, 'analytics.donor019@seed.amyanhlu.org' AS donor_email, 'Victoria Hospital' AS hospital_name, '2026-08-23' AS donation_date, 1 AS units, '2026-08-23 11:30:00' AS created_at
UNION ALL
SELECT 180 AS seed_no, 'analytics.donor020@seed.amyanhlu.org' AS donor_email, 'North Okkalapa General Hospital' AS hospital_name, '2026-08-23' AS donation_date, 2 AS units, '2026-08-23 12:30:00' AS created_at
UNION ALL
SELECT 181 AS seed_no, 'analytics.donor021@seed.amyanhlu.org' AS donor_email, 'Bahan Specialist Clinic' AS hospital_name, '2026-08-24' AS donation_date, 1 AS units, '2026-08-24 13:30:00' AS created_at
UNION ALL
SELECT 182 AS seed_no, 'analytics.donor022@seed.amyanhlu.org' AS donor_email, 'Lanmadaw General Hospital' AS hospital_name, '2026-08-24' AS donation_date, 2 AS units, '2026-08-24 14:30:00' AS created_at
UNION ALL
SELECT 183 AS seed_no, 'analytics.donor023@seed.amyanhlu.org' AS donor_email, 'South Okkalapa Women’s Hospital' AS hospital_name, '2026-08-25' AS donation_date, 1 AS units, '2026-08-25 15:30:00' AS created_at
UNION ALL
SELECT 184 AS seed_no, 'analytics.donor024@seed.amyanhlu.org' AS donor_email, 'Shwe Pyi Thar General Hospital' AS hospital_name, '2026-08-25' AS donation_date, 2 AS units, '2026-08-25 16:30:00' AS created_at
UNION ALL
SELECT 185 AS seed_no, 'analytics.donor025@seed.amyanhlu.org' AS donor_email, 'Ahlone Family Hospital' AS hospital_name, '2026-08-26' AS donation_date, 1 AS units, '2026-08-26 09:30:00' AS created_at
UNION ALL
SELECT 186 AS seed_no, 'analytics.donor026@seed.amyanhlu.org' AS donor_email, 'Yangon General Hospital' AS hospital_name, '2026-08-26' AS donation_date, 2 AS units, '2026-08-26 10:30:00' AS created_at
UNION ALL
SELECT 187 AS seed_no, 'analytics.donor027@seed.amyanhlu.org' AS donor_email, 'Grand Hantha International Hospital' AS hospital_name, '2026-08-27' AS donation_date, 1 AS units, '2026-08-27 11:30:00' AS created_at
UNION ALL
SELECT 188 AS seed_no, 'analytics.donor028@seed.amyanhlu.org' AS donor_email, 'Thingangyun Sanpya Hospital' AS hospital_name, '2026-08-27' AS donation_date, 2 AS units, '2026-08-27 12:30:00' AS created_at
UNION ALL
SELECT 189 AS seed_no, 'analytics.donor029@seed.amyanhlu.org' AS donor_email, 'Latha General Hospital' AS hospital_name, '2026-08-28' AS donation_date, 1 AS units, '2026-08-28 13:30:00' AS created_at
UNION ALL
SELECT 190 AS seed_no, 'analytics.donor030@seed.amyanhlu.org' AS donor_email, 'Insein General Hospital' AS hospital_name, '2026-08-28' AS donation_date, 2 AS units, '2026-08-28 14:30:00' AS created_at
UNION ALL
SELECT 191 AS seed_no, 'analytics.donor031@seed.amyanhlu.org' AS donor_email, 'Yangon Central Women’s Hospital' AS hospital_name, '2026-08-29' AS donation_date, 1 AS units, '2026-08-29 15:30:00' AS created_at
UNION ALL
SELECT 192 AS seed_no, 'analytics.donor032@seed.amyanhlu.org' AS donor_email, 'Hlaing Tharyar Community Hospital' AS hospital_name, '2026-08-29' AS donation_date, 2 AS units, '2026-08-29 16:30:00' AS created_at
UNION ALL
SELECT 193 AS seed_no, 'analytics.donor001@seed.amyanhlu.org' AS donor_email, 'Kamayut Teaching Hospital' AS hospital_name, '2026-08-30' AS donation_date, 1 AS units, '2026-08-30 09:30:00' AS created_at
UNION ALL
SELECT 194 AS seed_no, 'analytics.donor002@seed.amyanhlu.org' AS donor_email, 'Victoria Hospital' AS hospital_name, '2026-08-30' AS donation_date, 2 AS units, '2026-08-30 10:30:00' AS created_at
UNION ALL
SELECT 195 AS seed_no, 'analytics.donor003@seed.amyanhlu.org' AS donor_email, 'North Okkalapa General Hospital' AS hospital_name, '2026-08-31' AS donation_date, 1 AS units, '2026-08-31 11:30:00' AS created_at
UNION ALL
SELECT 196 AS seed_no, 'analytics.donor004@seed.amyanhlu.org' AS donor_email, 'Bahan Specialist Clinic' AS hospital_name, '2026-08-31' AS donation_date, 2 AS units, '2026-08-31 12:30:00' AS created_at
UNION ALL
SELECT 197 AS seed_no, 'analytics.donor005@seed.amyanhlu.org' AS donor_email, 'Lanmadaw General Hospital' AS hospital_name, '2026-09-01' AS donation_date, 1 AS units, '2026-09-01 13:30:00' AS created_at
UNION ALL
SELECT 198 AS seed_no, 'analytics.donor006@seed.amyanhlu.org' AS donor_email, 'South Okkalapa Women’s Hospital' AS hospital_name, '2026-09-01' AS donation_date, 2 AS units, '2026-09-01 14:30:00' AS created_at
UNION ALL
SELECT 199 AS seed_no, 'analytics.donor007@seed.amyanhlu.org' AS donor_email, 'Shwe Pyi Thar General Hospital' AS hospital_name, '2026-09-02' AS donation_date, 1 AS units, '2026-09-02 15:30:00' AS created_at
UNION ALL
SELECT 200 AS seed_no, 'analytics.donor008@seed.amyanhlu.org' AS donor_email, 'Ahlone Family Hospital' AS hospital_name, '2026-09-02' AS donation_date, 2 AS units, '2026-09-02 16:30:00' AS created_at
UNION ALL
SELECT 201 AS seed_no, 'analytics.donor009@seed.amyanhlu.org' AS donor_email, 'Yangon General Hospital' AS hospital_name, '2026-09-03' AS donation_date, 1 AS units, '2026-09-03 09:30:00' AS created_at
UNION ALL
SELECT 202 AS seed_no, 'analytics.donor010@seed.amyanhlu.org' AS donor_email, 'Grand Hantha International Hospital' AS hospital_name, '2026-09-03' AS donation_date, 2 AS units, '2026-09-03 10:30:00' AS created_at
UNION ALL
SELECT 203 AS seed_no, 'analytics.donor011@seed.amyanhlu.org' AS donor_email, 'Thingangyun Sanpya Hospital' AS hospital_name, '2026-09-04' AS donation_date, 1 AS units, '2026-09-04 11:30:00' AS created_at
UNION ALL
SELECT 204 AS seed_no, 'analytics.donor012@seed.amyanhlu.org' AS donor_email, 'Latha General Hospital' AS hospital_name, '2026-09-04' AS donation_date, 2 AS units, '2026-09-04 12:30:00' AS created_at
UNION ALL
SELECT 205 AS seed_no, 'analytics.donor013@seed.amyanhlu.org' AS donor_email, 'Insein General Hospital' AS hospital_name, '2026-09-05' AS donation_date, 1 AS units, '2026-09-05 13:30:00' AS created_at
UNION ALL
SELECT 206 AS seed_no, 'analytics.donor014@seed.amyanhlu.org' AS donor_email, 'Yangon Central Women’s Hospital' AS hospital_name, '2026-09-05' AS donation_date, 2 AS units, '2026-09-05 14:30:00' AS created_at
UNION ALL
SELECT 207 AS seed_no, 'analytics.donor015@seed.amyanhlu.org' AS donor_email, 'Hlaing Tharyar Community Hospital' AS hospital_name, '2026-09-06' AS donation_date, 1 AS units, '2026-09-06 15:30:00' AS created_at
UNION ALL
SELECT 208 AS seed_no, 'analytics.donor016@seed.amyanhlu.org' AS donor_email, 'Kamayut Teaching Hospital' AS hospital_name, '2026-09-06' AS donation_date, 2 AS units, '2026-09-06 16:30:00' AS created_at
UNION ALL
SELECT 209 AS seed_no, 'analytics.donor017@seed.amyanhlu.org' AS donor_email, 'Victoria Hospital' AS hospital_name, '2026-09-07' AS donation_date, 1 AS units, '2026-09-07 09:30:00' AS created_at
UNION ALL
SELECT 210 AS seed_no, 'analytics.donor018@seed.amyanhlu.org' AS donor_email, 'North Okkalapa General Hospital' AS hospital_name, '2026-09-07' AS donation_date, 2 AS units, '2026-09-07 10:30:00' AS created_at
UNION ALL
SELECT 211 AS seed_no, 'analytics.donor019@seed.amyanhlu.org' AS donor_email, 'Bahan Specialist Clinic' AS hospital_name, '2026-09-08' AS donation_date, 1 AS units, '2026-09-08 11:30:00' AS created_at
UNION ALL
SELECT 212 AS seed_no, 'analytics.donor020@seed.amyanhlu.org' AS donor_email, 'Lanmadaw General Hospital' AS hospital_name, '2026-09-08' AS donation_date, 2 AS units, '2026-09-08 12:30:00' AS created_at
UNION ALL
SELECT 213 AS seed_no, 'analytics.donor021@seed.amyanhlu.org' AS donor_email, 'South Okkalapa Women’s Hospital' AS hospital_name, '2026-09-09' AS donation_date, 1 AS units, '2026-09-09 13:30:00' AS created_at
UNION ALL
SELECT 214 AS seed_no, 'analytics.donor022@seed.amyanhlu.org' AS donor_email, 'Shwe Pyi Thar General Hospital' AS hospital_name, '2026-09-09' AS donation_date, 2 AS units, '2026-09-09 14:30:00' AS created_at
UNION ALL
SELECT 215 AS seed_no, 'analytics.donor023@seed.amyanhlu.org' AS donor_email, 'Ahlone Family Hospital' AS hospital_name, '2026-09-10' AS donation_date, 1 AS units, '2026-09-10 15:30:00' AS created_at
UNION ALL
SELECT 216 AS seed_no, 'analytics.donor024@seed.amyanhlu.org' AS donor_email, 'Yangon General Hospital' AS hospital_name, '2026-09-10' AS donation_date, 2 AS units, '2026-09-10 16:30:00' AS created_at
UNION ALL
SELECT 217 AS seed_no, 'analytics.donor025@seed.amyanhlu.org' AS donor_email, 'Grand Hantha International Hospital' AS hospital_name, '2026-09-11' AS donation_date, 1 AS units, '2026-09-11 09:30:00' AS created_at
UNION ALL
SELECT 218 AS seed_no, 'analytics.donor026@seed.amyanhlu.org' AS donor_email, 'Thingangyun Sanpya Hospital' AS hospital_name, '2026-09-11' AS donation_date, 2 AS units, '2026-09-11 10:30:00' AS created_at
UNION ALL
SELECT 219 AS seed_no, 'analytics.donor027@seed.amyanhlu.org' AS donor_email, 'Latha General Hospital' AS hospital_name, '2026-09-12' AS donation_date, 1 AS units, '2026-09-12 11:30:00' AS created_at
UNION ALL
SELECT 220 AS seed_no, 'analytics.donor028@seed.amyanhlu.org' AS donor_email, 'Insein General Hospital' AS hospital_name, '2026-09-12' AS donation_date, 2 AS units, '2026-09-12 12:30:00' AS created_at
) AS s
INNER JOIN donors d ON d.account_id = (SELECT a.id FROM accounts a WHERE a.email = s.donor_email)
INNER JOIN hospitals h ON h.name = s.hospital_name
INNER JOIN addresses a ON a.id = h.address_id
WHERE h.status = 'ACTIVE'
  AND a.division = 'Yangon Region'
  AND h.id = (SELECT MIN(h2.id) FROM hospitals h2 WHERE h2.name = s.hospital_name)
  AND NOT EXISTS (
      SELECT 1 FROM donations x
      WHERE x.checkin_notes = CONCAT('Analytics seed donation ', LPAD(s.seed_no, 3, '0'))
  );

-- 7) Current inventory for all eight blood groups across active Yangon hospitals.
INSERT INTO blood_inventory (hospital_id, blood_type_id, units_available, updated_at)
SELECT h.id, t.blood_type_id, t.units_available, '2026-09-12 09:00:00'
FROM (
SELECT 'Yangon General Hospital' AS hospital_name
UNION ALL
SELECT 'Yankin Children Hospital' AS hospital_name
UNION ALL
SELECT 'Victoria Hospital' AS hospital_name
UNION ALL
SELECT 'Grand Hantha International Hospital' AS hospital_name
UNION ALL
SELECT 'North Okkalapa General Hospital' AS hospital_name
UNION ALL
SELECT 'Thingangyun Sanpya Hospital' AS hospital_name
UNION ALL
SELECT 'Bahan Specialist Clinic' AS hospital_name
UNION ALL
SELECT 'Latha General Hospital' AS hospital_name
UNION ALL
SELECT 'Lanmadaw General Hospital' AS hospital_name
UNION ALL
SELECT 'Insein General Hospital' AS hospital_name
UNION ALL
SELECT 'South Okkalapa Women’s Hospital' AS hospital_name
UNION ALL
SELECT 'Yangon Central Women’s Hospital' AS hospital_name
UNION ALL
SELECT 'Shwe Pyi Thar General Hospital' AS hospital_name
UNION ALL
SELECT 'Hlaing Tharyar Community Hospital' AS hospital_name
UNION ALL
SELECT 'Ahlone Family Hospital' AS hospital_name
UNION ALL
SELECT 'Kamayut Teaching Hospital' AS hospital_name
) AS hs
INNER JOIN hospitals h ON h.name = hs.hospital_name
CROSS JOIN (
SELECT 1 AS blood_type_id, 120 AS units_available
UNION ALL
SELECT 2 AS blood_type_id, 70 AS units_available
UNION ALL
SELECT 3 AS blood_type_id, 130 AS units_available
UNION ALL
SELECT 4 AS blood_type_id, 75 AS units_available
UNION ALL
SELECT 5 AS blood_type_id, 95 AS units_available
UNION ALL
SELECT 6 AS blood_type_id, 55 AS units_available
UNION ALL
SELECT 7 AS blood_type_id, 180 AS units_available
UNION ALL
SELECT 8 AS blood_type_id, 85 AS units_available
) AS t
WHERE h.id = (SELECT MIN(h2.id) FROM hospitals h2 WHERE h2.name = hs.hospital_name)
  AND NOT EXISTS (
    SELECT 1 FROM blood_inventory bi
    WHERE bi.hospital_id = h.id
      AND bi.blood_type_id = t.blood_type_id
);

COMMIT;

-- Verification queries (read-only):
-- SELECT COUNT(*) AS seeded_requests FROM blood_requests WHERE reason LIKE 'Analytics seed request %';
-- SELECT COUNT(*) AS seeded_donations FROM donations WHERE checkin_notes LIKE 'Analytics seed donation %';
-- SELECT bt.display_name, SUM(bi.units_available) AS units
-- FROM blood_inventory bi JOIN blood_types bt ON bt.id = bi.blood_type_id
-- GROUP BY bt.id, bt.display_name ORDER BY bt.id;
