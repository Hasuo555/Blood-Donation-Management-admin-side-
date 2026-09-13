package com.amyanhlu.admin.servlet;

import com.amyanhlu.admin.dto.DonorCreateDTO;
import com.amyanhlu.admin.entity.Account;
import com.amyanhlu.admin.security.AdminUserDetails;
import com.amyanhlu.admin.service.DonorService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.context.support.SpringBeanAutowiringSupport;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.io.InputStream;
import java.time.LocalDate;
import java.time.format.DateTimeParseException;
import java.util.Collection;
import java.util.LinkedHashMap;
import java.util.Map;

/**
 * Admin create-donor controller. Authorization is also enforced by Spring
 * Security
 * ({@code ROLE_ADMIN}); this servlet double-checks the session principal.
 */
@WebServlet(name = "AdminCreateDonorServlet", urlPatterns = { "/admin/donors/create" })
@MultipartConfig(fileSizeThreshold = 1024 * 1024, maxFileSize = 5L * 1024 * 1024, maxRequestSize = 12L * 1024 * 1024)
public class AdminCreateDonorServlet extends HttpServlet {

    private static final String VIEW = "/WEB-INF/views/admin/donors/create-donor.jsp";
    private static final String LOGIN = "/admin/login?error=unauthorized";

    @Autowired
    private DonorService donorService;

    @Override
    public void init() {
        SpringBeanAutowiringSupport.processInjectionBasedOnServletContext(this, getServletContext());
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if (!requireAdmin(request, response)) {
            return;
        }

        HttpSession session = request.getSession(false);
        if (session != null) {
            Object username = session.getAttribute("credUsername");
            Object password = session.getAttribute("credPassword");
            if (username != null && password != null) {
                request.setAttribute("credUsername", username);
                request.setAttribute("credPassword", password);
                request.setAttribute("successMessage", session.getAttribute("successMessage"));
                session.removeAttribute("credUsername");
                session.removeAttribute("credPassword");
                session.removeAttribute("successMessage");
            }
        }

        if (request.getAttribute("donorCreateDTO") == null) {
            request.setAttribute("donorCreateDTO", new DonorCreateDTO());
        }
        request.setAttribute("bloodTypes", donorService.findAllBloodTypes());
        request.setAttribute("activeMenu", "donors-create");
        request.getRequestDispatcher(VIEW).forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if (!requireAdmin(request, response)) {
            return;
        }

        DonorCreateDTO dto = bindDto(request);
        Map<String, String> fieldErrors = validateRequired(dto, request);

        if (!fieldErrors.isEmpty()) {
            request.setAttribute("fieldErrors", fieldErrors);
            request.setAttribute("errorMessage", "Please correct the highlighted fields.");
            request.setAttribute("donorCreateDTO", dto);
            request.setAttribute("bloodTypes", donorService.findAllBloodTypes());
            request.setAttribute("activeMenu", "donors-create");
            request.getRequestDispatcher(VIEW).forward(request, response);
            return;
        }

        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        Account adminAccount = null;
        if (auth != null && auth.getPrincipal() instanceof AdminUserDetails details) {
            adminAccount = details.getAccount();
        }

        try {
            String tempPassword = donorService.createDonor(dto, adminAccount, request);
            HttpSession session = request.getSession(true);
            session.setAttribute("credUsername", dto.getPhone().trim());
            session.setAttribute("credPassword", tempPassword);
            session.setAttribute("successMessage", "Donor account created successfully.");
            response.sendRedirect(request.getContextPath() + "/admin/donors/create?success=1");
        } catch (IllegalArgumentException ex) {
            request.setAttribute("errorMessage", ex.getMessage());
            request.setAttribute("donorCreateDTO", dto);
            request.setAttribute("bloodTypes", donorService.findAllBloodTypes());
            request.setAttribute("activeMenu", "donors-create");
            request.getRequestDispatcher(VIEW).forward(request, response);
        } catch (Exception ex) {
            String msg = ex.getMessage() != null ? ex.getMessage() : "An unexpected error occurred.";
            request.setAttribute("errorMessage", "Failed to create donor account: " + msg);
            request.setAttribute("donorCreateDTO", dto);
            request.setAttribute("bloodTypes", donorService.findAllBloodTypes());
            request.setAttribute("activeMenu", "donors-create");
            request.getRequestDispatcher(VIEW).forward(request, response);
        }
    }

    private boolean requireAdmin(HttpServletRequest request, HttpServletResponse response) throws IOException {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        if (auth == null || !auth.isAuthenticated() || !hasAdminRole(auth.getAuthorities())) {
            response.sendRedirect(request.getContextPath() + LOGIN);
            return false;
        }
        return true;
    }

    private static boolean hasAdminRole(Collection<? extends GrantedAuthority> authorities) {
        if (authorities == null) {
            return false;
        }
        for (GrantedAuthority authority : authorities) {
            String value = authority.getAuthority();
            if ("ROLE_ADMIN".equals(value) || "ADMIN".equals(value)) {
                return true;
            }
        }
        return false;
    }

    private DonorCreateDTO bindDto(HttpServletRequest request) throws ServletException, IOException {
        DonorCreateDTO dto = new DonorCreateDTO();
        dto.setName(param(request, "name"));
        dto.setPhone(param(request, "phone"));
        dto.setEmail(param(request, "email"));
        dto.setGender(param(request, "gender"));
        dto.setNrcNumber(param(request, "nrcNumber"));
        dto.setDetailAddress(param(request, "detailAddress"));
        dto.setTownship(param(request, "township"));
        dto.setDivision(param(request, "division"));
        dto.setCountry(param(request, "country"));
        dto.setPassword(param(request, "password"));
        dto.setConfirmPassword(param(request, "confirmPassword"));

        String dob = param(request, "dateOfBirth");
        if (!dob.isBlank()) {
            try {
                dto.setDateOfBirth(LocalDate.parse(dob));
            } catch (DateTimeParseException ignored) {
                dto.setDateOfBirth(null);
            }
        }

        String bloodTypeId = param(request, "bloodTypeId");
        if (!bloodTypeId.isBlank()) {
            try {
                dto.setBloodTypeId(Long.parseLong(bloodTypeId));
            } catch (NumberFormatException ignored) {
                dto.setBloodTypeId(null);
            }
        }

        dto.setNrcFront(toMultipart(safePart(request, "nrcFront")));
        dto.setNrcBack(toMultipart(safePart(request, "nrcBack")));
        return dto;
    }

    private Map<String, String> validateRequired(DonorCreateDTO dto, HttpServletRequest request) {
        Map<String, String> errors = new LinkedHashMap<>();
        if (isBlank(dto.getName())) {
            errors.put("name", "Full name is required.");
        }
        if (isBlank(dto.getPhone())) {
            errors.put("phone", "Phone number is required.");
        }
        if (dto.getDateOfBirth() == null) {
            errors.put("dateOfBirth", "Date of birth is required.");
        }
        if (isBlank(dto.getGender())) {
            errors.put("gender", "Gender is required.");
        }
        if (isBlank(dto.getNrcNumber())) {
            errors.put("nrcNumber", "NRC number is required.");
        }
        if (isBlank(dto.getDetailAddress())) {
            errors.put("detailAddress", "Address is required.");
        }
        if (isBlank(dto.getTownship())) {
            errors.put("township", "Township is required.");
        }
        if (isBlank(dto.getDivision())) {
            errors.put("division", "Division / region is required.");
        }

        try {
            Part front = safePart(request, "nrcFront");
            if (front == null) {
                errors.put("nrcFront", "NRC front image is required.");
            }
            Part back = safePart(request, "nrcBack");
            if (back == null) {
                errors.put("nrcBack", "NRC back image is required.");
            }
        } catch (Exception ex) {
            errors.put("nrcFront", "Could not read uploaded files.");
        }
        return errors;
    }

    private static Part safePart(HttpServletRequest request, String name) {
        try {
            Part part = request.getPart(name);
            if (part != null && part.getSize() > 0
                    && part.getSubmittedFileName() != null
                    && !part.getSubmittedFileName().isBlank()) {
                return part;
            }
            return null;
        } catch (Exception ex) {
            return null;
        }
    }

    private static MultipartFile toMultipart(Part part) {
        if (part == null || part.getSize() <= 0) {
            return null;
        }
        return new PartMultipartFile(part);
    }

    private static String param(HttpServletRequest request, String name) {
        String value = request.getParameter(name);
        return value == null ? "" : value.trim();
    }

    private static boolean isBlank(String s) {
        return s == null || s.isBlank();
    }

    private static final class PartMultipartFile implements MultipartFile {
        private final Part part;

        private PartMultipartFile(Part part) {
            this.part = part;
        }

        @Override
        public String getName() {
            return part.getName();
        }

        @Override
        public String getOriginalFilename() {
            return part.getSubmittedFileName();
        }

        @Override
        public String getContentType() {
            return part.getContentType();
        }

        @Override
        public boolean isEmpty() {
            return part.getSize() <= 0;
        }

        @Override
        public long getSize() {
            return part.getSize();
        }

        @Override
        public byte[] getBytes() throws IOException {
            try (InputStream in = part.getInputStream()) {
                return in.readAllBytes();
            }
        }

        @Override
        public InputStream getInputStream() throws IOException {
            return part.getInputStream();
        }

        @Override
        public void transferTo(java.io.File dest) throws IOException {
            part.write(dest.getAbsolutePath());
        }
    }
}
