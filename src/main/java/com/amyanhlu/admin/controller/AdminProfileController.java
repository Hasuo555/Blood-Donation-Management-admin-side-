package com.amyanhlu.admin.controller;

import com.amyanhlu.admin.dto.PasswordChangeDTO;
import com.amyanhlu.admin.security.AdminUserDetails;
import com.amyanhlu.admin.service.AdminProfileService;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.validation.Valid;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

@Controller
@RequestMapping("/admin/profile")
public class AdminProfileController {

    private final AdminProfileService adminProfileService;

    public AdminProfileController(AdminProfileService adminProfileService) {
        this.adminProfileService = adminProfileService;
    }

    @GetMapping
    public String profilePage(@AuthenticationPrincipal AdminUserDetails principal, Model model,
                              HttpServletRequest request) {
        request.setAttribute("activeMenu", "profile");
        model.addAttribute("admin",
                adminProfileService.findByAccountId(principal.getAccountId()));
        model.addAttribute("passwordChangeDTO", new PasswordChangeDTO());
        return "admin/profile/profile";
    }

    @PostMapping("/update-name")
    public String updateName(@RequestParam String name,
                             @AuthenticationPrincipal AdminUserDetails principal,
                             HttpServletRequest request,
                             RedirectAttributes redirectAttributes) {
        try {
            adminProfileService.updateName(principal.getAccountId(), name,
                    principal.getAccount(), request);
            redirectAttributes.addFlashAttribute("successMessage", "Profile updated");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("errorMessage", e.getMessage());
        }
        return "redirect:/admin/profile";
    }

    @PostMapping("/change-password")
    public String changePassword(@Valid @ModelAttribute PasswordChangeDTO dto,
                                 BindingResult result,
                                 @AuthenticationPrincipal AdminUserDetails principal,
                                 HttpServletRequest request,
                                 Model model,
                                 RedirectAttributes redirectAttributes) {
        if (result.hasErrors()) {
            model.addAttribute("admin",
                    adminProfileService.findByAccountId(principal.getAccountId()));
            return "admin/profile/profile";
        }
        if (!dto.isPasswordMatching()) {
            model.addAttribute("admin",
                    adminProfileService.findByAccountId(principal.getAccountId()));
            model.addAttribute("passwordError", "New passwords do not match");
            return "admin/profile/profile";
        }
        try {
            adminProfileService.changePassword(
                    principal.getAccountId(),
                    dto.getCurrentPassword(),
                    dto.getNewPassword(),
                    principal.getAccount(), request);
            redirectAttributes.addFlashAttribute("successMessage", "Password changed successfully");
        } catch (IllegalArgumentException e) {
            redirectAttributes.addFlashAttribute("errorMessage", e.getMessage());
        }
        return "redirect:/admin/profile";
    }
}
