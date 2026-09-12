package com.amyanhlu.admin.dto;

import jakarta.validation.constraints.*;

public class BloodRequestCreateDTO {

    @NotNull(message = "Hospital is required")
    private Long hospitalId;

    @NotNull(message = "Blood type is required")
    private Long bloodTypeId;

    @NotNull(message = "Units required is required")
    @Min(value = 1, message = "At least 1 unit is required")
    private Integer unitsRequired;

    @NotBlank(message = "Urgency is required")
    private String urgency; // NORMAL, URGENT, CRITICAL

    @Size(max = 500, message = "Reason must not exceed 500 characters")
    private String reason;

    // ISO datetime string — controller will parse it
    private String expiresAt;

    // --- Getters and Setters ---

    public Long getHospitalId() { return hospitalId; }
    public void setHospitalId(Long hospitalId) { this.hospitalId = hospitalId; }

    public Long getBloodTypeId() { return bloodTypeId; }
    public void setBloodTypeId(Long bloodTypeId) { this.bloodTypeId = bloodTypeId; }

    public Integer getUnitsRequired() { return unitsRequired; }
    public void setUnitsRequired(Integer unitsRequired) { this.unitsRequired = unitsRequired; }

    public String getUrgency() { return urgency; }
    public void setUrgency(String urgency) { this.urgency = urgency; }

    public String getReason() { return reason; }
    public void setReason(String reason) { this.reason = reason; }

    public String getExpiresAt() { return expiresAt; }
    public void setExpiresAt(String expiresAt) { this.expiresAt = expiresAt; }
}
