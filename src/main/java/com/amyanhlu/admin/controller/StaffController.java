package com.amyanhlu.admin.controller;

import com.amyanhlu.admin.dto.StaffCreateDTO;
import com.amyanhlu.admin.dto.StaffUpdateDTO;
import com.amyanhlu.admin.entity.Staff;
import com.amyanhlu.admin.enums.StaffStatus;
import com.amyanhlu.admin.security.AdminUserDetails;
import com.amyanhlu.admin.service.HospitalService;
import com.amyanhlu.admin.service.StaffService;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.validation.Valid;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

@Controller
@RequestMapping("/admin/staff")
public class StaffController {

    private final StaffService staffService;
    private final HospitalService hospitalService;

    public StaffController(StaffService staffService, HospitalService hospitalService) {
        this.staffService = staffService;
        this.hospitalService = hospitalService;
    }

    @GetMapping
    public String list(@RequestParam(defaultValue = "0") int page, HttpServletRequest request, Model model) {
        request.setAttribute("activeMenu", "staff");
        Page<Staff> staffPage = staffService.findAll(PageRequest.of(page, 15));
        model.addAttribute("staffPage", staffPage);
        return "admin/staff/list";
    }

    @GetMapping("/{id:\\d+}")
    public String detail(@PathVariable Long id, HttpServletRequest request, Model model) {
        request.setAttribute("activeMenu", "staff");
        // Direct call without .orElseThrow() since StaffService handles exception
        model.addAttribute("staff", staffService.findById(id));
        return "admin/staff/detail";
    }

    @GetMapping("/create")
    public String createForm(HttpServletRequest request, Model model) {
        request.setAttribute("activeMenu", "staff-create");
        model.addAttribute("staffCreateDTO", new StaffCreateDTO());
        model.addAttribute("hospitals", hospitalService.findActiveHospitals());
        return "admin/staff/create";
    }

    @PostMapping("/create")
    public String create(@Valid @ModelAttribute StaffCreateDTO dto,
            BindingResult result,
            @AuthenticationPrincipal AdminUserDetails principal,
            HttpServletRequest request,
            Model model,
            RedirectAttributes redirectAttributes) {
        request.setAttribute("activeMenu", "staff-create");
        if (result.hasErrors()) {
            model.addAttribute("hospitals", hospitalService.findActiveHospitals());
            return "admin/staff/create";
        }
        try {
            String tempPassword = staffService.createStaff(
                    dto.getName(), dto.getEmail(), dto.getPhone(),
                    dto.getHospitalId(), principal.getAccount(), request);
            redirectAttributes.addFlashAttribute("successMessage",
                    "Staff account created. Temporary password: " + tempPassword);
            return "redirect:/admin/staff";
        } catch (IllegalArgumentException e) {
            model.addAttribute("errorMessage", e.getMessage());
            model.addAttribute("hospitals", hospitalService.findActiveHospitals());
            return "admin/staff/create";
        }
    }

    @GetMapping("/{id:\\d+}/edit")
    public String editForm(@PathVariable Long id, HttpServletRequest request, Model model) {
        request.setAttribute("activeMenu", "staff");
        Staff staff = staffService.findById(id);
        StaffUpdateDTO dto = new StaffUpdateDTO();
        dto.setName(staff.getName());
        dto.setEmail(staff.getAccount().getEmail());
        dto.setPhone(staff.getAccount().getPhone());
        dto.setHospitalId(staff.getHospital().getId());
        dto.setStatus(staff.getStatus() != null ? staff.getStatus().name() : StaffStatus.ACTIVE.name());
        model.addAttribute("staff", staff);
        model.addAttribute("staffUpdateDTO", dto);
        model.addAttribute("hospitals", hospitalService.findAllHospitals());
        model.addAttribute("staffStatuses", StaffStatus.values());
        return "admin/staff/edit";
    }

    @PostMapping("/{id:\\d+}/edit")
    public String update(@PathVariable Long id,
            @Valid @ModelAttribute StaffUpdateDTO dto,
            BindingResult result,
            @AuthenticationPrincipal AdminUserDetails principal,
            HttpServletRequest request,
            Model model,
            RedirectAttributes redirectAttributes) {
        request.setAttribute("activeMenu", "staff");
        if (result.hasErrors()) {
            addEditModel(id, dto, model);
            return "admin/staff/edit";
        }
        try {
            staffService.updateStaff(id, dto,
                    principal != null ? principal.getAccount() : null, request);
            redirectAttributes.addFlashAttribute("successMessage", "Staff account updated successfully.");
            return "redirect:/admin/staff/" + id;
        } catch (Exception ex) {
            model.addAttribute("errorMessage",
                    ex.getMessage() != null ? ex.getMessage() : "Staff update failed.");
            addEditModel(id, dto, model);
            return "admin/staff/edit";
        }
    }

    @PostMapping("/{id}/status")
    public String changeStatus(@PathVariable Long id,
            @RequestParam StaffStatus status,
            @AuthenticationPrincipal AdminUserDetails principal,
            HttpServletRequest request,
            RedirectAttributes redirectAttributes) {
        try {
            staffService.changeStatus(id, status, principal.getAccount(), request);
            redirectAttributes.addFlashAttribute("successMessage", "Staff status updated to " + status);
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("errorMessage", e.getMessage());
        }
        return "redirect:/admin/staff/" + id;
    }

    private void addEditModel(Long id, StaffUpdateDTO dto, Model model) {
        Staff staff = staffService.findById(id);
        model.addAttribute("staff", staff);
        model.addAttribute("staffUpdateDTO", dto);
        model.addAttribute("hospitals", hospitalService.findAllHospitals());
        model.addAttribute("staffStatuses", StaffStatus.values());
    }
}
