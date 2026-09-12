-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Sep 06, 2026 at 05:46 PM
-- Server version: 10.4.28-MariaDB
-- PHP Version: 8.2.4

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `amyanhlu_db`
--

-- --------------------------------------------------------

--
-- Table structure for table `accounts`
--

CREATE TABLE `accounts` (
  `id` bigint(20) NOT NULL,
  `phone` varchar(20) NOT NULL,
  `email` varchar(255) NOT NULL,
  `password_hash` varchar(255) NOT NULL,
  `role` enum('DONOR','STAFF','ADMIN') NOT NULL,
  `status` enum('ACTIVE','SUSPENDED','INACTIVE') NOT NULL DEFAULT 'ACTIVE',
  `biometric_enabled` tinyint(1) NOT NULL DEFAULT 0,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `last_login_at` timestamp NULL DEFAULT NULL,
  `password_changed_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `accounts`
--

INSERT INTO `accounts` (`id`, `phone`, `email`, `password_hash`, `role`, `status`, `biometric_enabled`, `created_at`, `updated_at`, `last_login_at`, `password_changed_at`) VALUES
(1, '09790000001', 'admin@amyanhlu.org', '$2a$10$JN3vSw1YfkIYZLz8HKd8FOWuUBa8Y4vok1pOPv4tsx5lu2swPYfA6', 'ADMIN', 'ACTIVE', 0, '2026-08-28 16:32:01', '2026-09-06 12:30:47', '2026-08-28 16:32:01', NULL),
(2, '09790000002', 'staff.ygh@amyanhlu.org', '$2y$10$e8R6.fJ3k0k1H7U5Z2X.1uQ/gV0/K2m0W3x4Y5z6A7b8C9d0E1f2G', 'STAFF', 'ACTIVE', 0, '2026-08-28 16:32:01', '2026-08-28 16:32:01', '2026-08-28 16:32:01', NULL),
(3, '09790000003', 'staff.ychn@amyanhlu.org', '$2y$10$e8R6.fJ3k0k1H7U5Z2X.1uQ/gV0/K2m0W3x4Y5z6A7b8C9d0E1f2G', 'STAFF', 'ACTIVE', 0, '2026-08-28 16:32:01', '2026-08-28 16:32:01', '2026-08-28 16:32:01', NULL),
(4, '09790000004', 'donor.mgmg@gmail.com', '$2y$10$e8R6.fJ3k0k1H7U5Z2X.1uQ/gV0/K2m0W3x4Y5z6A7b8C9d0E1f2G', 'DONOR', 'ACTIVE', 1, '2026-08-28 16:32:01', '2026-08-28 16:32:01', '2026-08-28 16:32:01', NULL),
(5, '09790000005', 'donor.suhsu@gmail.com', '$2y$10$e8R6.fJ3k0k1H7U5Z2X.1uQ/gV0/K2m0W3x4Y5z6A7b8C9d0E1f2G', 'DONOR', 'ACTIVE', 0, '2026-08-28 16:32:01', '2026-08-28 16:32:01', '2026-08-28 16:32:01', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `addresses`
--

CREATE TABLE `addresses` (
  `id` bigint(20) NOT NULL,
  `detail_address` text NOT NULL,
  `country` varchar(100) NOT NULL DEFAULT 'Myanmar',
  `division` varchar(100) NOT NULL,
  `township` varchar(100) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `addresses`
--

INSERT INTO `addresses` (`id`, `detail_address`, `country`, `division`, `township`, `created_at`, `updated_at`) VALUES
(1, 'No. 123, Pyay Road, Kamayut Township', 'Myanmar', 'Yangon Region', 'Kamayut', '2026-08-28 16:32:01', '2026-08-28 16:32:01'),
(2, 'No. 45, Bogyoke Aung San Road, Latha Township', 'Myanmar', 'Yangon Region', 'Latha', '2026-08-28 16:32:01', '2026-08-28 16:32:01'),
(3, 'No. 78, University Avenue Road, Bahan Township', 'Myanmar', 'Yangon Region', 'Bahan', '2026-08-28 16:32:01', '2026-08-28 16:32:01'),
(4, 'No. 12, Strand Road, Ahlone Township', 'Myanmar', 'Yangon Region', 'Ahlone', '2026-08-28 16:32:01', '2026-08-28 16:32:01');

-- --------------------------------------------------------

--
-- Table structure for table `admins`
--

CREATE TABLE `admins` (
  `id` bigint(20) NOT NULL,
  `account_id` bigint(20) NOT NULL,
  `name` varchar(255) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `admins`
--

INSERT INTO `admins` (`id`, `account_id`, `name`, `created_at`, `updated_at`) VALUES
(1, 1, 'System Administrator', '2026-08-28 16:33:04', '2026-08-28 16:33:04');

-- --------------------------------------------------------

--
-- Table structure for table `appointments`
--

CREATE TABLE `appointments` (
  `id` bigint(20) NOT NULL,
  `donor_id` bigint(20) NOT NULL,
  `hospital_id` bigint(20) NOT NULL,
  `appointment_date` date NOT NULL,
  `appointment_time` time NOT NULL,
  `status` enum('PENDING','CONFIRMED','CANCELLED','COMPLETED','MISSED','REJECTED') NOT NULL DEFAULT 'PENDING',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `cancelled_at` timestamp NULL DEFAULT NULL,
  `cancellation_reason` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `appointments`
--

INSERT INTO `appointments` (`id`, `donor_id`, `hospital_id`, `appointment_date`, `appointment_time`, `status`, `created_at`, `updated_at`, `cancelled_at`, `cancellation_reason`) VALUES
(1, 1, 1, '2026-08-20', '09:00:00', 'COMPLETED', '2026-08-28 16:34:03', '2026-08-28 16:34:03', NULL, NULL),
(2, 2, 2, '2026-08-28', '10:30:00', 'CONFIRMED', '2026-08-28 16:34:03', '2026-08-28 16:34:03', NULL, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `articles`
--

CREATE TABLE `articles` (
  `id` bigint(20) NOT NULL,
  `title` varchar(255) NOT NULL,
  `content` longtext NOT NULL,
  `cover_image` varchar(512) DEFAULT NULL,
  `hospital_id` bigint(20) DEFAULT NULL,
  `status` enum('DRAFT','PUBLISHED','ARCHIVED') NOT NULL DEFAULT 'DRAFT',
  `published_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `articles`
--

INSERT INTO `articles` (`id`, `title`, `content`, `cover_image`, `hospital_id`, `status`, `published_at`, `created_at`, `updated_at`) VALUES
(1, 'World Blood Donor Day Announcement', 'Join us in celebrating World Blood Donor Day. Donate blood and save lives across Myanmar.', '/articles/wbdd.png', NULL, 'PUBLISHED', '2026-06-14 02:30:00', '2026-08-28 16:34:36', '2026-09-06 12:32:51'),
(2, 'Urgent Need for B+ Blood Types', 'Yangon General Hospital is experiencing a shortage of B+ blood units.', '/articles/ygh_b_plus.png', 1, 'PUBLISHED', '2026-08-22 03:30:00', '2026-08-28 16:34:36', '2026-09-06 12:32:51');

-- --------------------------------------------------------

--
-- Table structure for table `audit_logs`
--

CREATE TABLE `audit_logs` (
  `id` bigint(20) NOT NULL,
  `account_id` bigint(20) DEFAULT NULL,
  `action` varchar(255) NOT NULL,
  `entity_type` varchar(100) NOT NULL,
  `entity_id` bigint(20) NOT NULL,
  `old_value` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`old_value`)),
  `new_value` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`new_value`)),
  `ip_address` varchar(45) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `audit_logs`
--

INSERT INTO `audit_logs` (`id`, `account_id`, `action`, `entity_type`, `entity_id`, `old_value`, `new_value`, `ip_address`, `created_at`) VALUES
(1, 2, 'VERIFY_DONOR_BLOOD_TYPE', 'donors', 1, '{\"blood_type_id\": null, \"verified\": false}', '{\"blood_type_id\": 3, \"verified\": true}', '192.168.1.105', '2026-08-28 16:37:00');

-- --------------------------------------------------------

--
-- Table structure for table `blood_requests`
--

CREATE TABLE `blood_requests` (
  `id` bigint(20) NOT NULL,
  `hospital_id` bigint(20) NOT NULL,
  `blood_type_id` int(11) NOT NULL,
  `units_required` int(11) NOT NULL DEFAULT 1,
  `urgency` enum('NORMAL','URGENT','CRITICAL') NOT NULL DEFAULT 'NORMAL',
  `reason` text DEFAULT NULL,
  `status` enum('OPEN','PARTIALLY_FULFILLED','FULFILLED','CANCELLED','EXPIRED') NOT NULL DEFAULT 'OPEN',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `expires_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `blood_requests`
--

INSERT INTO `blood_requests` (`id`, `hospital_id`, `blood_type_id`, `units_required`, `urgency`, `reason`, `status`, `created_at`, `expires_at`) VALUES
(1, 1, 3, 5, 'URGENT', 'Emergency trauma surgery requirement.', 'OPEN', '2026-08-28 16:34:36', '2026-08-30 17:29:59');

-- --------------------------------------------------------

--
-- Table structure for table `blood_test_results`
--

CREATE TABLE `blood_test_results` (
  `id` bigint(20) NOT NULL,
  `donor_id` bigint(20) NOT NULL,
  `donation_id` bigint(20) DEFAULT NULL,
  `hospital_id` bigint(20) NOT NULL,
  `blood_type_id` int(11) NOT NULL,
  `test_date` date NOT NULL,
  `document_file` varchar(512) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `blood_test_results`
--

INSERT INTO `blood_test_results` (`id`, `donor_id`, `donation_id`, `hospital_id`, `blood_type_id`, `test_date`, `document_file`, `created_at`) VALUES
(1, 1, 1, 1, 3, '2026-08-21', '/results/btr_001.pdf', '2026-08-28 16:34:36');

-- --------------------------------------------------------

--
-- Table structure for table `blood_types`
--

CREATE TABLE `blood_types` (
  `id` int(11) NOT NULL,
  `abo_type` enum('A','B','AB','O') NOT NULL,
  `rh_factor` enum('+','-') NOT NULL,
  `display_name` varchar(10) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `blood_types`
--

INSERT INTO `blood_types` (`id`, `abo_type`, `rh_factor`, `display_name`) VALUES
(1, 'A', '+', 'A+'),
(2, 'A', '-', 'A-'),
(3, 'B', '+', 'B+'),
(4, 'B', '-', 'B-'),
(5, 'AB', '+', 'AB+'),
(6, 'AB', '-', 'AB-'),
(7, 'O', '+', 'O+'),
(8, 'O', '-', 'O-');

-- --------------------------------------------------------

--
-- Table structure for table `certificates`
--

CREATE TABLE `certificates` (
  `id` bigint(20) NOT NULL,
  `donor_id` bigint(20) NOT NULL,
  `donation_id` bigint(20) NOT NULL,
  `hospital_id` bigint(20) NOT NULL,
  `certificate_type` varchar(100) NOT NULL DEFAULT 'DONATION_COMPLETION',
  `certificate_number` varchar(100) NOT NULL,
  `issued_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `file_path` varchar(512) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `certificates`
--

INSERT INTO `certificates` (`id`, `donor_id`, `donation_id`, `hospital_id`, `certificate_type`, `certificate_number`, `issued_at`, `file_path`, `created_at`) VALUES
(1, 1, 1, 1, 'DONATION_COMPLETION', 'CERT-YGH-2026-000820', '2026-08-28 16:34:36', '/uploads/certificates/cert_001.pdf', '2026-08-28 16:34:36');

-- --------------------------------------------------------

--
-- Table structure for table `donations`
--

CREATE TABLE `donations` (
  `id` bigint(20) NOT NULL,
  `donor_id` bigint(20) NOT NULL,
  `hospital_id` bigint(20) NOT NULL,
  `appointment_id` bigint(20) DEFAULT NULL,
  `donation_date` date NOT NULL,
  `donation_type` enum('WHOLE_BLOOD','PLASMA','PLATELETS','OTHER') NOT NULL DEFAULT 'WHOLE_BLOOD',
  `units` int(11) NOT NULL DEFAULT 1,
  `status` enum('STARTED','COMPLETED','FAILED','CANCELLED','DEFERRED') NOT NULL DEFAULT 'STARTED',
  `checkin_nfc_card_id` bigint(20) DEFAULT NULL,
  `checked_in_at` timestamp NULL DEFAULT NULL,
  `eligibility_status` enum('ELIGIBLE','NOT_ELIGIBLE','REQUIRES_REVIEW') DEFAULT NULL,
  `checkin_notes` text DEFAULT NULL,
  `checkout_nfc_card_id` bigint(20) DEFAULT NULL,
  `checked_out_at` timestamp NULL DEFAULT NULL,
  `checkout_notes` text DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `donations`
--

INSERT INTO `donations` (`id`, `donor_id`, `hospital_id`, `appointment_id`, `donation_date`, `donation_type`, `units`, `status`, `checkin_nfc_card_id`, `checked_in_at`, `eligibility_status`, `checkin_notes`, `checkout_nfc_card_id`, `checked_out_at`, `checkout_notes`, `created_at`, `updated_at`) VALUES
(1, 1, 1, 1, '2026-08-20', 'WHOLE_BLOOD', 1, 'COMPLETED', 1, '2026-08-20 02:25:00', 'ELIGIBLE', 'NFC card verified successfully. Screening passed.', 1, '2026-08-20 03:15:00', 'Donation process completed. Donor rested for 15 minutes.', '2026-08-28 16:34:04', '2026-09-06 12:41:29');

-- --------------------------------------------------------

--
-- Table structure for table `blood_inventory`
--

CREATE TABLE `blood_inventory` (
  `id` bigint(20) NOT NULL,
  `hospital_id` bigint(20) NOT NULL,
  `blood_type_id` int(11) NOT NULL,
  `units_available` int(11) NOT NULL DEFAULT 0,
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_inventory_hospital_type` (`hospital_id`, `blood_type_id`),
  KEY `fk_inventory_blood_type` (`blood_type_id`),
  KEY `fk_inventory_hospital` (`hospital_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `donation_events`
--

CREATE TABLE `donation_events` (
  `id` bigint(20) NOT NULL,
  `request_id` bigint(20) NOT NULL,
  `hospital_id` bigint(20) NOT NULL,
  `title` varchar(255) NOT NULL,
  `location` varchar(255) NOT NULL,
  `event_date` date NOT NULL,
  `start_time` time NOT NULL,
  `end_time` time NOT NULL,
  `status` enum('UPCOMING','ONGOING','COMPLETED','CANCELLED') NOT NULL DEFAULT 'UPCOMING',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `donation_events`
--

INSERT INTO `donation_events` (`id`, `request_id`, `hospital_id`, `title`, `location`, `event_date`, `start_time`, `end_time`, `status`, `created_at`, `updated_at`) VALUES
(1, 1, 1, 'Community Blood Drive at Dagon Center', 'Dagon Center II, Pyay Road', '2026-09-15', '09:00:00', '16:00:00', 'UPCOMING', '2026-08-28 16:34:36', '2026-08-28 16:34:36');

-- --------------------------------------------------------

--
-- Table structure for table `donation_event_requests`
--

CREATE TABLE `donation_event_requests` (
  `id` bigint(20) NOT NULL,
  `requested_by_donor_id` bigint(20) NOT NULL,
  `title` varchar(255) NOT NULL,
  `description` text DEFAULT NULL,
  `proposed_location` varchar(255) NOT NULL,
  `proposed_date` date NOT NULL,
  `expected_donors` int(11) DEFAULT NULL,
  `reason` text DEFAULT NULL,
  `status` enum('PENDING','APPROVED','REJECTED','CANCELLED') NOT NULL DEFAULT 'PENDING',
  `reviewed_by_staff_id` bigint(20) DEFAULT NULL,
  `reviewed_at` timestamp NULL DEFAULT NULL,
  `review_notes` text DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `donation_event_requests`
--

INSERT INTO `donation_event_requests` (`id`, `requested_by_donor_id`, `title`, `description`, `proposed_location`, `proposed_date`, `expected_donors`, `reason`, `status`, `reviewed_by_staff_id`, `reviewed_at`, `review_notes`, `created_at`, `updated_at`) VALUES
(1, 1, 'Community Blood Drive at Dagon Center', 'Organizing a neighborhood blood donation campaign with youth volunteers.', 'Dagon Center II, Pyay Road', '2026-09-15', 50, 'To support local hospital blood bank reserves.', 'APPROVED', 1, '2026-08-25 07:30:00', 'Approved. YGH mobile medical team will be assigned.', '2026-08-28 16:34:36', '2026-08-28 16:34:36');

-- --------------------------------------------------------

--
-- Table structure for table `donors`
--

CREATE TABLE `donors` (
  `id` bigint(20) NOT NULL,
  `account_id` bigint(20) NOT NULL,
  `name` varchar(255) NOT NULL,
  `date_of_birth` date NOT NULL,
  `gender` enum('MALE','FEMALE','OTHER') NOT NULL,
  `address_id` bigint(20) DEFAULT NULL,
  `blood_type_id` int(11) DEFAULT NULL,
  `blood_type_verified` tinyint(1) NOT NULL DEFAULT 0,
  `blood_type_verified_at` timestamp NULL DEFAULT NULL,
  `verified_by_staff_id` bigint(20) DEFAULT NULL,
  `profile_picture` varchar(512) DEFAULT NULL,
  `last_donation_date` date DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `donors`
--

INSERT INTO `donors` (`id`, `account_id`, `name`, `date_of_birth`, `gender`, `address_id`, `blood_type_id`, `blood_type_verified`, `blood_type_verified_at`, `verified_by_staff_id`, `profile_picture`, `last_donation_date`, `created_at`, `updated_at`) VALUES
(1, 4, 'Mg Mg', '2000-05-15', 'MALE', 3, 3, 1, '2026-01-10 03:00:00', 1, '/uploads/donors/mgmg.png', NULL, '2026-08-28 16:33:04', '2026-08-28 16:33:04'),
(2, 5, 'Su Su', '2002-11-20', 'FEMALE', 4, 7, 1, '2026-02-14 04:45:00', 2, '/uploads/donors/susu.png', NULL, '2026-08-28 16:33:04', '2026-08-28 16:33:04');

-- --------------------------------------------------------

--
-- Table structure for table `donor_blood_type_history`
--

CREATE TABLE `donor_blood_type_history` (
  `id` bigint(20) NOT NULL,
  `donor_id` bigint(20) NOT NULL,
  `blood_type_id` int(11) NOT NULL,
  `verified_by_staff_id` bigint(20) DEFAULT NULL,
  `verified_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `reason` varchar(255) DEFAULT NULL,
  `notes` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `hospitals`
--

CREATE TABLE `hospitals` (
  `id` bigint(20) NOT NULL,
  `name` varchar(255) NOT NULL,
  `address_id` bigint(20) NOT NULL,
  `profile_picture` varchar(512) DEFAULT NULL,
  `phone` varchar(20) NOT NULL,
  `email` varchar(255) NOT NULL,
  `status` enum('ACTIVE','INACTIVE','SUSPENDED') NOT NULL DEFAULT 'ACTIVE',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `hospitals`
--

INSERT INTO `hospitals` (`id`, `name`, `address_id`, `profile_picture`, `phone`, `email`, `status`, `created_at`, `updated_at`) VALUES
(1, 'Yangon General Hospital', 1, '/hospitals/ygh.png', '01256112', 'info@ygh.gov.mm', 'ACTIVE', '2026-08-28 16:33:04', '2026-09-06 12:33:06'),
(2, 'Yankin Children Hospital', 2, '/hospitals/ych.png', '01541234', 'info@ych.gov.mm', 'ACTIVE', '2026-08-28 16:33:04', '2026-09-06 12:33:06');

-- --------------------------------------------------------

--
-- Table structure for table `nfc_cards`
--

CREATE TABLE `nfc_cards` (
  `id` bigint(20) NOT NULL,
  `card_uid` varchar(100) NOT NULL,
  `donor_id` bigint(20) NOT NULL,
  `issued_by_hospital_id` bigint(20) NOT NULL,
  `issued_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `valid_until` date NOT NULL,
  `status` enum('ACTIVE','EXPIRED','LOST','BLOCKED','REPLACED') NOT NULL DEFAULT 'ACTIVE',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `nfc_cards`
--

INSERT INTO `nfc_cards` (`id`, `card_uid`, `donor_id`, `issued_by_hospital_id`, `issued_at`, `valid_until`, `status`, `created_at`, `updated_at`) VALUES
(1, 'NFC-YGH-2026-0001', 1, 1, '2026-08-28 16:33:04', '2028-01-10', 'ACTIVE', '2026-08-28 16:33:04', '2026-08-28 16:33:04'),
(2, 'NFC-YCH-2026-0002', 2, 2, '2026-08-28 16:33:04', '2028-02-14', 'ACTIVE', '2026-08-28 16:33:04', '2026-08-28 16:33:04');

-- --------------------------------------------------------

--
-- Table structure for table `notifications`
--

CREATE TABLE `notifications` (
  `id` bigint(20) NOT NULL,
  `account_id` bigint(20) NOT NULL,
  `title` varchar(255) NOT NULL,
  `message` text NOT NULL,
  `type` enum('APPOINTMENT_CONFIRMED','APPOINTMENT_REMINDER','APPOINTMENT_CANCELLED','DONATION_COMPLETED','BLOOD_TEST_AVAILABLE','CERTIFICATE_AVAILABLE','CARD_EXPIRING','CARD_EXPIRED','ELIGIBLE_TO_DONATE','EVENT_REQUEST_UPDATED','BLOOD_REQUEST','SYSTEM') NOT NULL DEFAULT 'SYSTEM',
  `reference_type` varchar(100) DEFAULT NULL,
  `reference_id` bigint(20) DEFAULT NULL,
  `is_read` tinyint(1) NOT NULL DEFAULT 0,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `read_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `notifications`
--

INSERT INTO `notifications` (`id`, `account_id`, `title`, `message`, `type`, `reference_type`, `reference_id`, `is_read`, `created_at`, `read_at`) VALUES
(1, 4, 'Donation Certificate Available', 'Your blood donation certificate for your donation on 2026-08-20 is now available.', 'CERTIFICATE_AVAILABLE', 'certificates', 1, 1, '2026-08-28 16:34:36', NULL),
(2, 4, 'Event Request Approved', 'Your event request \"Community Blood Drive at Dagon Center\" has been approved.', 'EVENT_REQUEST_UPDATED', 'donation_events', 1, 0, '2026-08-28 16:34:36', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `nrc_documents`
--

CREATE TABLE `nrc_documents` (
  `id` bigint(20) NOT NULL,
  `donor_id` bigint(20) NOT NULL,
  `front_image` varchar(512) NOT NULL,
  `back_image` varchar(512) NOT NULL,
  `extracted_text` text DEFAULT NULL,
  `verified` tinyint(1) NOT NULL DEFAULT 0,
  `verified_at` timestamp NULL DEFAULT NULL,
  `verified_by_staff_id` bigint(20) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `nrc_documents`
--

INSERT INTO `nrc_documents` (`id`, `donor_id`, `front_image`, `back_image`, `extracted_text`, `verified`, `verified_at`, `verified_by_staff_id`, `created_at`, `updated_at`) VALUES
(1, 1, '/uploads/nrc/d1_front.png', '/uploads/nrc/d1_back.png', '12/KAMAYU(N)012345', 1, '2026-01-10 03:00:00', 1, '2026-08-28 16:33:04', '2026-08-28 16:33:04'),
(2, 2, '/uploads/nrc/d2_front.png', '/uploads/nrc/d2_back.png', '12/LATHA(N)067890', 1, '2026-02-14 04:45:00', 2, '2026-08-28 16:33:04', '2026-08-28 16:33:04');

-- --------------------------------------------------------

--
-- Table structure for table `questionnaires`
--

CREATE TABLE `questionnaires` (
  `id` bigint(20) NOT NULL,
  `hospital_id` bigint(20) NOT NULL,
  `title` varchar(255) NOT NULL,
  `description` text DEFAULT NULL,
  `version` int(11) NOT NULL DEFAULT 1,
  `status` enum('DRAFT','PUBLISHED','ARCHIVED') NOT NULL DEFAULT 'DRAFT',
  `created_by_staff_id` bigint(20) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `published_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `questionnaires`
--

INSERT INTO `questionnaires` (`id`, `hospital_id`, `title`, `description`, `version`, `status`, `created_by_staff_id`, `created_at`, `updated_at`, `published_at`) VALUES
(1, 1, 'Pre-Donation Health Screening Form', 'Standard medical screening questionnaire for whole blood donation.', 1, 'PUBLISHED', 1, '2026-08-28 16:34:03', '2026-08-28 16:34:03', '2026-01-15 01:30:00');

-- --------------------------------------------------------

--
-- Table structure for table `questionnaire_answers`
--

CREATE TABLE `questionnaire_answers` (
  `id` bigint(20) NOT NULL,
  `response_id` bigint(20) NOT NULL,
  `question_id` bigint(20) NOT NULL,
  `selected_option_id` bigint(20) DEFAULT NULL,
  `answer_text` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `questionnaire_answers`
--

INSERT INTO `questionnaire_answers` (`id`, `response_id`, `question_id`, `selected_option_id`, `answer_text`) VALUES
(1, 1, 1, 1, 'YES'),
(2, 1, 2, 4, 'NO'),
(3, 1, 3, 6, 'NO');

-- --------------------------------------------------------

--
-- Table structure for table `questionnaire_options`
--

CREATE TABLE `questionnaire_options` (
  `id` bigint(20) NOT NULL,
  `question_id` bigint(20) NOT NULL,
  `option_text` varchar(255) NOT NULL,
  `option_value` varchar(255) NOT NULL,
  `option_order` int(11) NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `questionnaire_options`
--

INSERT INTO `questionnaire_options` (`id`, `question_id`, `option_text`, `option_value`, `option_order`) VALUES
(1, 1, 'Yes', 'YES', 1),
(2, 1, 'No', 'NO', 2),
(3, 2, 'Yes', 'YES', 1),
(4, 2, 'No', 'NO', 2),
(5, 3, 'Yes', 'YES', 1),
(6, 3, 'No', 'NO', 2);

-- --------------------------------------------------------

--
-- Table structure for table `questionnaire_questions`
--

CREATE TABLE `questionnaire_questions` (
  `id` bigint(20) NOT NULL,
  `questionnaire_id` bigint(20) NOT NULL,
  `question_text` text NOT NULL,
  `question_type` enum('YES_NO','SINGLE_CHOICE','MULTIPLE_CHOICE','TEXT','NUMBER','DATE') NOT NULL,
  `question_order` int(11) NOT NULL DEFAULT 1,
  `required` tinyint(1) NOT NULL DEFAULT 1,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `questionnaire_questions`
--

INSERT INTO `questionnaire_questions` (`id`, `questionnaire_id`, `question_text`, `question_type`, `question_order`, `required`, `created_at`, `updated_at`) VALUES
(1, 1, 'Are you feeling healthy and well today?', 'YES_NO', 1, 1, '2026-08-28 16:34:04', '2026-08-28 16:34:04'),
(2, 1, 'Have you taken any antibiotics in the last 48 hours?', 'YES_NO', 2, 1, '2026-08-28 16:34:04', '2026-08-28 16:34:04'),
(3, 1, 'Have you donated blood in the last 4 months?', 'YES_NO', 3, 1, '2026-08-28 16:34:04', '2026-08-28 16:34:04');

-- --------------------------------------------------------

--
-- Table structure for table `questionnaire_responses`
--

CREATE TABLE `questionnaire_responses` (
  `id` bigint(20) NOT NULL,
  `questionnaire_id` bigint(20) NOT NULL,
  `appointment_id` bigint(20) DEFAULT NULL,
  `donor_id` bigint(20) NOT NULL,
  `submitted_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `status` enum('DRAFT','SUBMITTED','REVIEWED') NOT NULL DEFAULT 'SUBMITTED'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `questionnaire_responses`
--

INSERT INTO `questionnaire_responses` (`id`, `questionnaire_id`, `appointment_id`, `donor_id`, `submitted_at`, `status`) VALUES
(1, 1, 1, 1, '2026-08-28 16:34:04', 'REVIEWED');

-- --------------------------------------------------------

--
-- Table structure for table `refresh_tokens`
--

CREATE TABLE `refresh_tokens` (
  `id` bigint(20) NOT NULL,
  `account_id` bigint(20) NOT NULL,
  `token` varchar(255) NOT NULL,
  `expiry_date` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `is_revoked` tinyint(1) NOT NULL DEFAULT 0,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `staff`
--

CREATE TABLE `staff` (
  `id` bigint(20) NOT NULL,
  `account_id` bigint(20) NOT NULL,
  `hospital_id` bigint(20) NOT NULL,
  `name` varchar(255) NOT NULL,
  `status` enum('ACTIVE','INACTIVE','SUSPENDED') NOT NULL DEFAULT 'ACTIVE',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `staff`
--

INSERT INTO `staff` (`id`, `account_id`, `hospital_id`, `name`, `status`, `created_at`, `updated_at`) VALUES
(1, 2, 1, 'Dr. Aung Kyaw', 'ACTIVE', '2026-08-28 16:33:04', '2026-08-28 16:33:04'),
(2, 3, 2, 'Dr. Nilar Win', 'ACTIVE', '2026-08-28 16:33:04', '2026-08-28 16:33:04');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `accounts`
--
ALTER TABLE `accounts`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `phone` (`phone`),
  ADD UNIQUE KEY `email` (`email`);

--
-- Indexes for table `addresses`
--
ALTER TABLE `addresses`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `admins`
--
ALTER TABLE `admins`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `account_id` (`account_id`);

--
-- Indexes for table `appointments`
--
ALTER TABLE `appointments`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_appointments_donor` (`donor_id`),
  ADD KEY `fk_appointments_hospital` (`hospital_id`);

--
-- Indexes for table `articles`
--
ALTER TABLE `articles`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_articles_hospital` (`hospital_id`);

--
-- Indexes for table `audit_logs`
--
ALTER TABLE `audit_logs`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_audit_account` (`account_id`);

--
-- Indexes for table `blood_requests`
--
ALTER TABLE `blood_requests`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_br_hospital` (`hospital_id`),
  ADD KEY `fk_br_blood_type` (`blood_type_id`);

--
-- Indexes for table `blood_test_results`
--
ALTER TABLE `blood_test_results`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_btr_donor` (`donor_id`),
  ADD KEY `fk_btr_donation` (`donation_id`),
  ADD KEY `fk_btr_hospital` (`hospital_id`),
  ADD KEY `fk_btr_blood_type` (`blood_type_id`);

--
-- Indexes for table `blood_types`
--
ALTER TABLE `blood_types`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `display_name` (`display_name`);

--
-- Indexes for table `certificates`
--
ALTER TABLE `certificates`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `certificate_number` (`certificate_number`),
  ADD KEY `fk_cert_donor` (`donor_id`),
  ADD KEY `fk_cert_donation` (`donation_id`),
  ADD KEY `fk_cert_hospital` (`hospital_id`);

--
-- Indexes for table `donations`
--
ALTER TABLE `donations`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_donations_donor` (`donor_id`),
  ADD KEY `fk_donations_hospital` (`hospital_id`),
  ADD KEY `fk_donations_appointment` (`appointment_id`),
  ADD KEY `fk_donations_checkin_nfc` (`checkin_nfc_card_id`),
  ADD KEY `fk_donations_checkout_nfc` (`checkout_nfc_card_id`);

--
-- Indexes for table `donation_events`
--
ALTER TABLE `donation_events`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `request_id` (`request_id`),
  ADD KEY `fk_de_hospital` (`hospital_id`);

--
-- Indexes for table `donation_event_requests`
--
ALTER TABLE `donation_event_requests`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_der_donor` (`requested_by_donor_id`),
  ADD KEY `fk_der_staff` (`reviewed_by_staff_id`);

--
-- Indexes for table `donors`
--
ALTER TABLE `donors`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `account_id` (`account_id`),
  ADD KEY `fk_donors_address` (`address_id`),
  ADD KEY `fk_donors_blood_type` (`blood_type_id`),
  ADD KEY `fk_donors_verified_by_staff` (`verified_by_staff_id`);

--
-- Indexes for table `donor_blood_type_history`
--
ALTER TABLE `donor_blood_type_history`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_bth_donor` (`donor_id`),
  ADD KEY `fk_bth_blood_type` (`blood_type_id`),
  ADD KEY `fk_bth_verified_by_staff` (`verified_by_staff_id`);

--
-- Indexes for table `hospitals`
--
ALTER TABLE `hospitals`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_hospitals_address` (`address_id`);

--
-- Indexes for table `nfc_cards`
--
ALTER TABLE `nfc_cards`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `card_uid` (`card_uid`),
  ADD UNIQUE KEY `donor_id` (`donor_id`),
  ADD KEY `fk_nfc_hospital` (`issued_by_hospital_id`);

--
-- Indexes for table `notifications`
--
ALTER TABLE `notifications`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_notifications_account` (`account_id`);

--
-- Indexes for table `nrc_documents`
--
ALTER TABLE `nrc_documents`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `donor_id` (`donor_id`),
  ADD KEY `fk_nrc_verified_by_staff` (`verified_by_staff_id`);

--
-- Indexes for table `questionnaires`
--
ALTER TABLE `questionnaires`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_questionnaires_hospital` (`hospital_id`),
  ADD KEY `fk_questionnaires_staff` (`created_by_staff_id`);

--
-- Indexes for table `questionnaire_answers`
--
ALTER TABLE `questionnaire_answers`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_qa_response` (`response_id`),
  ADD KEY `fk_qa_question` (`question_id`),
  ADD KEY `fk_qa_option` (`selected_option_id`);

--
-- Indexes for table `questionnaire_options`
--
ALTER TABLE `questionnaire_options`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_qo_question` (`question_id`);

--
-- Indexes for table `questionnaire_questions`
--
ALTER TABLE `questionnaire_questions`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_qq_questionnaire` (`questionnaire_id`);

--
-- Indexes for table `questionnaire_responses`
--
ALTER TABLE `questionnaire_responses`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_qr_questionnaire` (`questionnaire_id`),
  ADD KEY `fk_qr_appointment` (`appointment_id`),
  ADD KEY `fk_qr_donor` (`donor_id`);

--
-- Indexes for table `refresh_tokens`
--
ALTER TABLE `refresh_tokens`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uq_refresh_tokens_token` (`token`),
  ADD KEY `idx_refresh_tokens_account_id` (`account_id`),
  ADD KEY `idx_refresh_tokens_token` (`token`);

--
-- Indexes for table `staff`
--
ALTER TABLE `staff`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `account_id` (`account_id`),
  ADD UNIQUE KEY `hospital_id` (`hospital_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `accounts`
--
ALTER TABLE `accounts`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `addresses`
--
ALTER TABLE `addresses`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `admins`
--
ALTER TABLE `admins`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `appointments`
--
ALTER TABLE `appointments`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `articles`
--
ALTER TABLE `articles`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `audit_logs`
--
ALTER TABLE `audit_logs`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `blood_requests`
--
ALTER TABLE `blood_requests`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `blood_test_results`
--
ALTER TABLE `blood_test_results`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `blood_types`
--
ALTER TABLE `blood_types`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT for table `blood_inventory`
--
ALTER TABLE `blood_inventory`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `certificates`
--
ALTER TABLE `certificates`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `donations`
--
ALTER TABLE `donations`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `donation_events`
--
ALTER TABLE `donation_events`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `donation_event_requests`
--
ALTER TABLE `donation_event_requests`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `donors`
--
ALTER TABLE `donors`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `donor_blood_type_history`
--
ALTER TABLE `donor_blood_type_history`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `hospitals`
--
ALTER TABLE `hospitals`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `nfc_cards`
--
ALTER TABLE `nfc_cards`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `notifications`
--
ALTER TABLE `notifications`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `nrc_documents`
--
ALTER TABLE `nrc_documents`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `questionnaires`
--
ALTER TABLE `questionnaires`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `questionnaire_answers`
--
ALTER TABLE `questionnaire_answers`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `questionnaire_options`
--
ALTER TABLE `questionnaire_options`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `questionnaire_questions`
--
ALTER TABLE `questionnaire_questions`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `questionnaire_responses`
--
ALTER TABLE `questionnaire_responses`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `refresh_tokens`
--
ALTER TABLE `refresh_tokens`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `staff`
--
ALTER TABLE `staff`
  MODIFY `id` bigint(20) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `admins`
--
ALTER TABLE `admins`
  ADD CONSTRAINT `fk_admins_account` FOREIGN KEY (`account_id`) REFERENCES `accounts` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `appointments`
--
ALTER TABLE `appointments`
  ADD CONSTRAINT `fk_appointments_donor` FOREIGN KEY (`donor_id`) REFERENCES `donors` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_appointments_hospital` FOREIGN KEY (`hospital_id`) REFERENCES `hospitals` (`id`) ON UPDATE CASCADE;

--
-- Constraints for table `articles`
--
ALTER TABLE `articles`
  ADD CONSTRAINT `fk_articles_hospital` FOREIGN KEY (`hospital_id`) REFERENCES `hospitals` (`id`) ON DELETE SET NULL ON UPDATE CASCADE;

--
-- Constraints for table `audit_logs`
--
ALTER TABLE `audit_logs`
  ADD CONSTRAINT `fk_audit_account` FOREIGN KEY (`account_id`) REFERENCES `accounts` (`id`) ON DELETE SET NULL ON UPDATE CASCADE;

--
-- Constraints for table `blood_requests`
--
ALTER TABLE `blood_requests`
  ADD CONSTRAINT `fk_br_blood_type` FOREIGN KEY (`blood_type_id`) REFERENCES `blood_types` (`id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_br_hospital` FOREIGN KEY (`hospital_id`) REFERENCES `hospitals` (`id`) ON UPDATE CASCADE;

--
-- Constraints for table `blood_inventory`
--
ALTER TABLE `blood_inventory`
  ADD CONSTRAINT `fk_inventory_blood_type` FOREIGN KEY (`blood_type_id`) REFERENCES `blood_types` (`id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_inventory_hospital` FOREIGN KEY (`hospital_id`) REFERENCES `hospitals` (`id`) ON UPDATE CASCADE;

--
-- Constraints for table `blood_test_results`
--
ALTER TABLE `blood_test_results`
  ADD CONSTRAINT `fk_btr_blood_type` FOREIGN KEY (`blood_type_id`) REFERENCES `blood_types` (`id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_btr_donation` FOREIGN KEY (`donation_id`) REFERENCES `donations` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_btr_donor` FOREIGN KEY (`donor_id`) REFERENCES `donors` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_btr_hospital` FOREIGN KEY (`hospital_id`) REFERENCES `hospitals` (`id`) ON UPDATE CASCADE;

--
-- Constraints for table `certificates`
--
ALTER TABLE `certificates`
  ADD CONSTRAINT `fk_cert_donation` FOREIGN KEY (`donation_id`) REFERENCES `donations` (`id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_cert_donor` FOREIGN KEY (`donor_id`) REFERENCES `donors` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_cert_hospital` FOREIGN KEY (`hospital_id`) REFERENCES `hospitals` (`id`) ON UPDATE CASCADE;

--
-- Constraints for table `donations`
--
ALTER TABLE `donations`
  ADD CONSTRAINT `fk_donations_appointment` FOREIGN KEY (`appointment_id`) REFERENCES `appointments` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_donations_checkin_nfc` FOREIGN KEY (`checkin_nfc_card_id`) REFERENCES `nfc_cards` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_donations_checkout_nfc` FOREIGN KEY (`checkout_nfc_card_id`) REFERENCES `nfc_cards` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_donations_donor` FOREIGN KEY (`donor_id`) REFERENCES `donors` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_donations_hospital` FOREIGN KEY (`hospital_id`) REFERENCES `hospitals` (`id`) ON UPDATE CASCADE;

--
-- Constraints for table `donation_events`
--
ALTER TABLE `donation_events`
  ADD CONSTRAINT `fk_de_hospital` FOREIGN KEY (`hospital_id`) REFERENCES `hospitals` (`id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_de_request` FOREIGN KEY (`request_id`) REFERENCES `donation_event_requests` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `donation_event_requests`
--
ALTER TABLE `donation_event_requests`
  ADD CONSTRAINT `fk_der_donor` FOREIGN KEY (`requested_by_donor_id`) REFERENCES `donors` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_der_staff` FOREIGN KEY (`reviewed_by_staff_id`) REFERENCES `staff` (`id`) ON DELETE SET NULL ON UPDATE CASCADE;

--
-- Constraints for table `donors`
--
ALTER TABLE `donors`
  ADD CONSTRAINT `fk_donors_account` FOREIGN KEY (`account_id`) REFERENCES `accounts` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_donors_address` FOREIGN KEY (`address_id`) REFERENCES `addresses` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_donors_blood_type` FOREIGN KEY (`blood_type_id`) REFERENCES `blood_types` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_donors_verified_by_staff` FOREIGN KEY (`verified_by_staff_id`) REFERENCES `staff` (`id`) ON DELETE SET NULL ON UPDATE CASCADE;

--
-- Constraints for table `donor_blood_type_history`
--
ALTER TABLE `donor_blood_type_history`
  ADD CONSTRAINT `fk_bth_blood_type` FOREIGN KEY (`blood_type_id`) REFERENCES `blood_types` (`id`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_bth_donor` FOREIGN KEY (`donor_id`) REFERENCES `donors` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_bth_verified_by_staff` FOREIGN KEY (`verified_by_staff_id`) REFERENCES `staff` (`id`) ON DELETE SET NULL ON UPDATE CASCADE;

--
-- Constraints for table `hospitals`
--
ALTER TABLE `hospitals`
  ADD CONSTRAINT `fk_hospitals_address` FOREIGN KEY (`address_id`) REFERENCES `addresses` (`id`) ON UPDATE CASCADE;

--
-- Constraints for table `nfc_cards`
--
ALTER TABLE `nfc_cards`
  ADD CONSTRAINT `fk_nfc_donor` FOREIGN KEY (`donor_id`) REFERENCES `donors` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_nfc_hospital` FOREIGN KEY (`issued_by_hospital_id`) REFERENCES `hospitals` (`id`) ON UPDATE CASCADE;

--
-- Constraints for table `notifications`
--
ALTER TABLE `notifications`
  ADD CONSTRAINT `fk_notifications_account` FOREIGN KEY (`account_id`) REFERENCES `accounts` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `nrc_documents`
--
ALTER TABLE `nrc_documents`
  ADD CONSTRAINT `fk_nrc_donor` FOREIGN KEY (`donor_id`) REFERENCES `donors` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_nrc_verified_by_staff` FOREIGN KEY (`verified_by_staff_id`) REFERENCES `staff` (`id`) ON DELETE SET NULL ON UPDATE CASCADE;

--
-- Constraints for table `questionnaires`
--
ALTER TABLE `questionnaires`
  ADD CONSTRAINT `fk_questionnaires_hospital` FOREIGN KEY (`hospital_id`) REFERENCES `hospitals` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_questionnaires_staff` FOREIGN KEY (`created_by_staff_id`) REFERENCES `staff` (`id`) ON UPDATE CASCADE;

--
-- Constraints for table `questionnaire_answers`
--
ALTER TABLE `questionnaire_answers`
  ADD CONSTRAINT `fk_qa_option` FOREIGN KEY (`selected_option_id`) REFERENCES `questionnaire_options` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_qa_question` FOREIGN KEY (`question_id`) REFERENCES `questionnaire_questions` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_qa_response` FOREIGN KEY (`response_id`) REFERENCES `questionnaire_responses` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `questionnaire_options`
--
ALTER TABLE `questionnaire_options`
  ADD CONSTRAINT `fk_qo_question` FOREIGN KEY (`question_id`) REFERENCES `questionnaire_questions` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `questionnaire_questions`
--
ALTER TABLE `questionnaire_questions`
  ADD CONSTRAINT `fk_qq_questionnaire` FOREIGN KEY (`questionnaire_id`) REFERENCES `questionnaires` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `questionnaire_responses`
--
ALTER TABLE `questionnaire_responses`
  ADD CONSTRAINT `fk_qr_appointment` FOREIGN KEY (`appointment_id`) REFERENCES `appointments` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_qr_donor` FOREIGN KEY (`donor_id`) REFERENCES `donors` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_qr_questionnaire` FOREIGN KEY (`questionnaire_id`) REFERENCES `questionnaires` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `refresh_tokens`
--
ALTER TABLE `refresh_tokens`
  ADD CONSTRAINT `fk_refresh_tokens_account` FOREIGN KEY (`account_id`) REFERENCES `accounts` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `staff`
--
ALTER TABLE `staff`
  ADD CONSTRAINT `fk_staff_account` FOREIGN KEY (`account_id`) REFERENCES `accounts` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_staff_hospital` FOREIGN KEY (`hospital_id`) REFERENCES `hospitals` (`id`) ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
