package com.amyanhlu.admin.controller;

import com.amyanhlu.admin.entity.BloodRequest;
import com.amyanhlu.admin.enums.BloodRequestStatus;
import com.amyanhlu.admin.security.AdminUserDetails;
import com.amyanhlu.admin.service.BloodRequestService;
import jakarta.servlet.http.HttpServletRequest;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Sort;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

@Controller
@RequestMapping("/admin/emergency-blood")
public class BloodRequestController {

    private final BloodRequestService bloodRequestService;

    public BloodRequestController(BloodRequestService bloodRequestService) {
        this.bloodRequestService = bloodRequestService;
    }

    @GetMapping
    public String list(@RequestParam(defaultValue = "0") int page, HttpServletRequest request, Model model) {
        request.setAttribute("activeMenu", "emergency-blood");
        Page<BloodRequest> requestPage = bloodRequestService.findAll(
                PageRequest.of(page, 15, Sort.by(Sort.Direction.DESC, "createdAt")));
        model.addAttribute("requestPage", requestPage);
        model.addAttribute("statuses", BloodRequestStatus.values());
        return "admin/emergency-blood/list";
    }

    @PostMapping("/{id}/status")
    public String changeStatus(@PathVariable Long id,
                               @RequestParam String status,
                               @AuthenticationPrincipal AdminUserDetails principal,
                               HttpServletRequest request,
                               RedirectAttributes redirectAttributes) {
        try {
            bloodRequestService.changeStatus(id, BloodRequestStatus.valueOf(status),
                    principal.getAccount(), request);
            redirectAttributes.addFlashAttribute("successMessage", "Request status updated");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("errorMessage", e.getMessage());
        }
        return "redirect:/admin/emergency-blood";
    }
}
