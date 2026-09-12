package com.amyanhlu.admin.dto;

public class DonorSearchDTO {

    private String keyword;
    private String status;   // AccountStatus enum name
    private Long bloodTypeId;
    private int page = 0;
    private int size = 15;

    // --- Getters and Setters ---

    public String getKeyword() { return keyword; }
    public void setKeyword(String keyword) { this.keyword = keyword; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public Long getBloodTypeId() { return bloodTypeId; }
    public void setBloodTypeId(Long bloodTypeId) { this.bloodTypeId = bloodTypeId; }

    public int getPage() { return page; }
    public void setPage(int page) { this.page = page; }

    public int getSize() { return size; }
    public void setSize(int size) { this.size = size; }
}
