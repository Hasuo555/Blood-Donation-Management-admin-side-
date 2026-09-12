package com.amyanhlu.admin.controller;

import com.amyanhlu.admin.dto.HospitalCreateDTO;
import com.amyanhlu.admin.dto.HospitalUpdateDTO;
import com.amyanhlu.admin.entity.Hospital;
import com.amyanhlu.admin.enums.HospitalStatus;
import com.amyanhlu.admin.security.AdminUserDetails;
import com.amyanhlu.admin.service.HospitalService;
import com.amyanhlu.admin.service.R2StorageService;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.validation.Valid;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

@Controller
@RequestMapping("/admin/hospitals")
public class HospitalController {

    private final HospitalService hospitalService;
    private final R2StorageService storageService;

    public HospitalController(HospitalService hospitalService,
            R2StorageService storageService) {
        this.hospitalService = hospitalService;
        this.storageService = storageService;
    }

    @GetMapping
    public String list(@RequestParam(defaultValue = "0") int page, HttpServletRequest request, Model model) {
        request.setAttribute("activeMenu", "hospitals");
        Page<Hospital> hospitalPage = hospitalService.findAll(PageRequest.of(page, 15));
        model.addAttribute("hospitalPage", hospitalPage);
        return "admin/hospitals/list";
    }

    @GetMapping("/{id:\\d+}")
    public String detail(@PathVariable Long id, HttpServletRequest request, Model model) {
        request.setAttribute("activeMenu", "hospitals");
        model.addAttribute("hospital", hospitalService.findById(id));
        return "admin/hospitals/detail";
    }

    @GetMapping("/create")
    public String createForm(HttpServletRequest request, Model model) {
        request.setAttribute("activeMenu", "hospitals-create");
        model.addAttribute("hospitalCreateDTO", new HospitalCreateDTO());
        return "admin/hospitals/create";
    }

    @PostMapping("/create")
    public String create(@Valid @ModelAttribute HospitalCreateDTO dto,
            BindingResult result,
            @RequestParam(required = false) MultipartFile profilePicture,
            @AuthenticationPrincipal AdminUserDetails principal,
            HttpServletRequest request,
            Model model,
            RedirectAttributes redirectAttributes) {
        request.setAttribute("activeMenu", "hospitals-create");
        if (result.hasErrors()) {
            return "admin/hospitals/create";
        }
        String uploadedUrl = null;
        try {
            if (storageService.hasContent(profilePicture)) {
                try {
                    uploadedUrl = storageService.uploadFile(profilePicture, "hospitals");
                } catch (Exception uploadEx) {
                    model.addAttribute("errorMessage",
                            "Hospital image upload to Cloudflare R2 bucket 'hlu-storage' failed: "
                                    + uploadEx.getMessage());
                    return "admin/hospitals/create";
                }
            }

            Hospital hospital = hospitalService.create(
                    dto.getName(), dto.getPhone(), dto.getEmail(),
                    dto.getDetailAddress(), dto.getCountry(),
                    dto.getDivision(), dto.getTownship(),
                    principal.getAccount(), request);

            if (uploadedUrl != null) {
                hospitalService.updateProfilePicture(hospital.getId(), uploadedUrl,
                        principal.getAccount(), request);
            }
            redirectAttributes.addFlashAttribute("successMessage", "Hospital created successfully");
            return "redirect:/admin/hospitals";
        } catch (Exception e) {
            storageService.deleteFile(uploadedUrl);
            model.addAttribute("errorMessage", e.getMessage());
            return "admin/hospitals/create";
        }
    }

    @GetMapping("/{id}/edit")
    public String editForm(@PathVariable Long id, HttpServletRequest request, Model model) {
        request.setAttribute("activeMenu", "hospitals");
        Hospital hospital = hospitalService.findById(id);
        HospitalUpdateDTO dto = new HospitalUpdateDTO();
        dto.setName(hospital.getName());
        dto.setPhone(hospital.getPhone());
        dto.setEmail(hospital.getEmail());
        if (hospital.getAddress() != null) {
            dto.setDetailAddress(hospital.getAddress().getDetailAddress());
            dto.setCountry(hospital.getAddress().getCountry());
            dto.setDivision(hospital.getAddress().getDivision());
            dto.setTownship(hospital.getAddress().getTownship());
        }
        model.addAttribute("hospital", hospital);
        model.addAttribute("hospitalUpdateDTO", dto);
        return "admin/hospitals/edit";
    }

    @PostMapping("/{id}/edit")
    public String update(@PathVariable Long id,
            @Valid @ModelAttribute HospitalUpdateDTO dto,
            BindingResult result,
            @RequestParam(required = false) String status,
            @RequestParam(required = false) MultipartFile profilePicture,
            @AuthenticationPrincipal AdminUserDetails principal,
            HttpServletRequest request,
            Model model,
            RedirectAttributes redirectAttributes) {
        request.setAttribute("activeMenu", "hospitals");
        if (result.hasErrors()) {
            model.addAttribute("hospital", hospitalService.findById(id));
            return "admin/hospitals/edit";
        }
        String uploadedUrl = null;
        try {
            hospitalService.update(id, dto.getName(), dto.getPhone(), dto.getEmail(),
                    dto.getDetailAddress(), dto.getCountry(), dto.getDivision(), dto.getTownship(),
                    principal.getAccount(), request);

            // Apply status change inline if the admin changed the dropdown
            if (status != null && !status.isBlank()) {
                Hospital current = hospitalService.findById(id);
                HospitalStatus selected = HospitalStatus.valueOf(status);
                if (current.getStatus() != selected) {
                    hospitalService.changeStatus(id, selected, principal.getAccount(), request);
                }
            }

            if (storageService.hasContent(profilePicture)) {
                try {
                    uploadedUrl = storageService.uploadFile(profilePicture, "hospitals");
                    hospitalService.updateProfilePicture(id, uploadedUrl, principal.getAccount(), request);
                } catch (Exception uploadEx) {
                    storageService.deleteFile(uploadedUrl);
                    model.addAttribute("errorMessage",
                            "Hospital image upload to Cloudflare R2 bucket 'amyanhlu-storage' failed: "
                                    + uploadEx.getMessage());
                    model.addAttribute("hospital", hospitalService.findById(id));
                    return "admin/hospitals/edit";
                }
            }
            redirectAttributes.addFlashAttribute("successMessage", "Hospital updated successfully");
            return "redirect:/admin/hospitals/" + id;
        } catch (Exception e) {
            storageService.deleteFile(uploadedUrl);
            model.addAttribute("errorMessage", e.getMessage());
            model.addAttribute("hospital", hospitalService.findById(id));
            return "admin/hospitals/edit";
        }
    }

    @PostMapping("/{id}/status")
    public String changeStatus(@PathVariable Long id,
            @RequestParam String status,
            @AuthenticationPrincipal AdminUserDetails principal,
            HttpServletRequest request,
            RedirectAttributes redirectAttributes) {
        try {
            HospitalStatus hospitalStatus = HospitalStatus.valueOf(status);
            hospitalService.changeStatus(id, hospitalStatus, principal.getAccount(), request);
            redirectAttributes.addFlashAttribute("successMessage",
                    "Hospital status updated to " + status);
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("errorMessage", e.getMessage());
        }
        return "redirect:/admin/hospitals/" + id;
    }
}
