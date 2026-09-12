package com.amyanhlu.admin.controller;

import com.amyanhlu.admin.service.AuditLogService;
import jakarta.servlet.http.HttpServletRequest;
import org.springframework.data.domain.PageRequest;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

/**
 * Audit log controller — read-only. No create/edit/delete actions exposed.
 */
@Controller
@RequestMapping("/admin/audit-logs")
public class AuditLogController {

    private static final DateTimeFormatter DATETIME_LOCAL_FMT =
            DateTimeFormatter.ofPattern("yyyy-MM-dd'T'HH:mm");

    private final AuditLogService auditLogService;

    public AuditLogController(AuditLogService auditLogService) {
        this.auditLogService = auditLogService;
    }

    @GetMapping
    public String list(@RequestParam(defaultValue = "0") int page,
                       @RequestParam(required = false) String entityType,
                       @RequestParam(required = false) String action,
                       @RequestParam(required = false)
                       @DateTimeFormat(iso = DateTimeFormat.ISO.DATE_TIME) LocalDateTime startDate,
                       @RequestParam(required = false)
                       @DateTimeFormat(iso = DateTimeFormat.ISO.DATE_TIME) LocalDateTime endDate,
                       @RequestParam(required = false) String performer,
                       HttpServletRequest request,
                       Model model) {
        request.setAttribute("activeMenu", "audit-logs");
        model.addAttribute("logPage",
                auditLogService.findByFilters(entityType, action, startDate, endDate,
                        performer, PageRequest.of(page, 20)));
        model.addAttribute("entityType", entityType);
        model.addAttribute("action",     action);
        // Format back to "yyyy-MM-ddTHH:mm" so <input type="datetime-local"> retains the value
        model.addAttribute("startDate",
                startDate != null ? startDate.format(DATETIME_LOCAL_FMT) : "");
        model.addAttribute("endDate",
                endDate   != null ? endDate.format(DATETIME_LOCAL_FMT)   : "");
        model.addAttribute("performer",  performer != null ? performer : "");
        return "admin/audit-logs/list";
    }
}
