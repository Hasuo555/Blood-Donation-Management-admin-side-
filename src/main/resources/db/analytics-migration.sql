-- Apply once to an existing amyanhlu_db installation.
-- Fresh installations are already covered by amyanhlu_db.sql.

ALTER TABLE donations
    ADD COLUMN units INT NOT NULL DEFAULT 1 AFTER donation_type;

CREATE TABLE blood_inventory (
    id BIGINT NOT NULL AUTO_INCREMENT,
    hospital_id BIGINT NOT NULL,
    blood_type_id INT NOT NULL,
    units_available INT NOT NULL DEFAULT 0,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    UNIQUE KEY uk_inventory_hospital_type (hospital_id, blood_type_id),
    KEY fk_inventory_hospital (hospital_id),
    KEY fk_inventory_blood_type (blood_type_id),
    CONSTRAINT fk_inventory_hospital FOREIGN KEY (hospital_id) REFERENCES hospitals (id) ON UPDATE CASCADE,
    CONSTRAINT fk_inventory_blood_type FOREIGN KEY (blood_type_id) REFERENCES blood_types (id) ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
