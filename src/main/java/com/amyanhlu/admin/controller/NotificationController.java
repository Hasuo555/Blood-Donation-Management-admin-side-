package com.amyanhlu.admin.controller;

import com.amyanhlu.admin.dto.NotificationCreateDTO;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.validation.Valid;
import org.springframework.data.domain.PageRequest;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import com.amyanhlu.admin.service.NotificationService;

@Controller
@RequestMapping("/admin/notifications")
public class NotificationController {

    private final NotificationService notificationService;

    public NotificationController(NotificationService notificationService) {
        this.notificationService = notificationService;
    }

    @GetMapping
    public String list(@RequestParam(defaultValue = "0") int page, HttpServletRequest request, Model model) {
        request.setAttribute("activeMenu", "notifications");
        model.addAttribute("notificationPage",
                notificationService.findAll(PageRequest.of(page, 15)));
        return "admin/notifications/list";
    }

    @GetMapping("/create")
    public String createForm(HttpServletRequest request, Model model) {
        request.setAttribute("activeMenu", "notifications");
        model.addAttribute("notificationCreateDTO", new NotificationCreateDTO());
        return "admin/notifications/create";
    }

    @PostMapping("/create")
    public String create(@Valid @ModelAttribute NotificationCreateDTO dto,
                         BindingResult result,
                         RedirectAttributes redirectAttributes) {
        if (result.hasErrors()) {
            return "admin/notifications/create";
        }
        try {
            notificationService.createBroadcast(dto.getTitle(), dto.getMessage());
            redirectAttributes.addFlashAttribute("successMessage", "Notification broadcast sent");
            return "redirect:/admin/notifications";
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("errorMessage", e.getMessage());
            return "redirect:/admin/notifications/create";
        }
    }
}
