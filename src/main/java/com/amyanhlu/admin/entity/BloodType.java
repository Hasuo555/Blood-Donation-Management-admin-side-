package com.amyanhlu.admin.entity;

import jakarta.persistence.*;

@Entity
@Table(name = "blood_types")
public class BloodType {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "abo_type")
    private String aboType;

    @Column(name = "rh_factor")
    private String rhFactor;

    @Column(name = "display_name", unique = true)
    private String displayName;

    // --- Getters and Setters ---

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getAboType() {
        return aboType;
    }

    public void setAboType(String aboType) {
        this.aboType = aboType;
    }

    public String getRhFactor() {
        return rhFactor;
    }

    public void setRhFactor(String rhFactor) {
        this.rhFactor = rhFactor;
    }

    public String getDisplayName() {
        return displayName;
    }

    public void setDisplayName(String displayName) {
        this.displayName = displayName;
    }
}
