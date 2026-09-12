package com.amyanhlu.admin.dto;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Past;
import jakarta.validation.constraints.Size;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.web.multipart.MultipartFile;

import java.time.LocalDate;

/**
 * DTO for admin-side donor account creation.
 * <p>Required: name, phone, dateOfBirth, gender, nrcNumber, address fields.
 * <p>Optional: email, bloodTypeId, password (auto-generated if blank).
 * <p>NRC images are validated in the service layer (type + size).
 */
public class DonorCreateDTO {

    // --- Personal Info (Required) ---

    @NotBlank(message = "Full name is required")
    @Size(max = 255, message = "Name must be at most 255 characters")
    private String name;

    @NotBlank(message = "Phone number is required")
    @Size(max = 20, message = "Phone must be at most 20 characters")
    private String phone;

    @NotNull(message = "Date of birth is required")
    @Past(message = "Date of birth must be in the past")
    @DateTimeFormat(iso = DateTimeFormat.ISO.DATE)
    private LocalDate dateOfBirth;

    @NotBlank(message = "Gender is required")
    private String gender;

    // --- Identity (Required) ---

    @NotBlank(message = "NRC number is required")
    @Size(max = 50, message = "NRC number must be at most 50 characters")
    private String nrcNumber;

    // --- Optional Fields ---

    /** Optional — a generated placeholder will be used if blank to satisfy DB NOT NULL. */
    private String email;

    // --- Password (auto-generated 10-char if left blank) ---
    private String password;
    private String confirmPassword;

    // --- Blood Type (optional, UNVERIFIED by default) ---
    private Long bloodTypeId;

    // --- Address (required: at least detailAddress) ---

    @NotBlank(message = "Detail address is required")
    private String detailAddress;

    @NotBlank(message = "Township is required")
    private String township;

    @NotBlank(message = "Division / region is required")
    private String division;
    private String country;

    // --- NRC Document Images (required) ---

    private MultipartFile nrcFront;
    private MultipartFile nrcBack;

    // --- Getters and Setters ---

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public String getPhone() { return phone; }
    public void setPhone(String phone) { this.phone = phone; }

    public LocalDate getDateOfBirth() { return dateOfBirth; }
    public void setDateOfBirth(LocalDate dateOfBirth) { this.dateOfBirth = dateOfBirth; }

    public String getGender() { return gender; }
    public void setGender(String gender) { this.gender = gender; }

    public String getNrcNumber() { return nrcNumber; }
    public void setNrcNumber(String nrcNumber) { this.nrcNumber = nrcNumber; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public String getPassword() { return password; }
    public void setPassword(String password) { this.password = password; }

    public String getConfirmPassword() { return confirmPassword; }
    public void setConfirmPassword(String confirmPassword) { this.confirmPassword = confirmPassword; }

    public Long getBloodTypeId() { return bloodTypeId; }
    public void setBloodTypeId(Long bloodTypeId) { this.bloodTypeId = bloodTypeId; }

    public String getDetailAddress() { return detailAddress; }
    public void setDetailAddress(String detailAddress) { this.detailAddress = detailAddress; }

    public String getTownship() { return township; }
    public void setTownship(String township) { this.township = township; }

    public String getDivision() { return division; }
    public void setDivision(String division) { this.division = division; }

    public String getCountry() { return country; }
    public void setCountry(String country) { this.country = country; }

    public MultipartFile getNrcFront() { return nrcFront; }
    public void setNrcFront(MultipartFile nrcFront) { this.nrcFront = nrcFront; }

    public MultipartFile getNrcBack() { return nrcBack; }
    public void setNrcBack(MultipartFile nrcBack) { this.nrcBack = nrcBack; }
}