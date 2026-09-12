package com.amyanhlu.admin.dto;

import jakarta.validation.constraints.*;

public class HospitalUpdateDTO {

    @NotBlank(message = "Hospital name is required")
    @Size(max = 150)
    private String name;

    @NotBlank(message = "Phone is required")
    private String phone;

    @Email(message = "Invalid email format")
    private String email;

    @NotBlank(message = "Address detail is required")
    private String detailAddress;

    private String country;
    private String division;
    private String township;

    // --- Getters and Setters ---

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public String getPhone() { return phone; }
    public void setPhone(String phone) { this.phone = phone; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public String getDetailAddress() { return detailAddress; }
    public void setDetailAddress(String detailAddress) { this.detailAddress = detailAddress; }

    public String getCountry() { return country; }
    public void setCountry(String country) { this.country = country; }

    public String getDivision() { return division; }
    public void setDivision(String division) { this.division = division; }

    public String getTownship() { return township; }
    public void setTownship(String township) { this.township = township; }
}
