package com.amyanhlu.admin.dto;

import jakarta.validation.constraints.NotBlank;

public class StatusChangeDTO {

    @NotBlank(message = "Status is required")
    private String status;

    private String reason;

    // --- Getters and Setters ---

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public String getReason() { return reason; }
    public void setReason(String reason) { this.reason = reason; }
}
