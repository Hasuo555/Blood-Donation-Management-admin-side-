package com.amyanhlu.admin.controller;

import com.amyanhlu.admin.service.DashboardService;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import java.util.Map;

@Controller
@RequestMapping("/admin")
public class DashboardController {

    private final DashboardService dashboardService;

    public DashboardController(DashboardService dashboardService) {
        this.dashboardService = dashboardService;
    }

    @GetMapping({"/", "/dashboard"})
    public String dashboard(Model model, @AuthenticationPrincipal UserDetails principal,
                            jakarta.servlet.http.HttpServletRequest request) {
        request.setAttribute("activeMenu", "dashboard");
        Map<String, Long> metrics = dashboardService.getDashboardMetrics();
        model.addAttribute("metrics", metrics);
        model.addAttribute("adminName", principal.getUsername());
        return "admin/dashboard";
    }
}
