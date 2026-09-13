package com.amyanhlu.admin.controller;

import com.amyanhlu.admin.dto.DonorUpdateDTO;
import com.amyanhlu.admin.entity.Account;
import com.amyanhlu.admin.entity.Donor;
import com.amyanhlu.admin.enums.AccountStatus;
import com.amyanhlu.admin.enums.NfcCardStatus;
import com.amyanhlu.admin.security.AdminUserDetails;
import com.amyanhlu.admin.service.DonorService;
import com.amyanhlu.admin.service.NfcCardService;
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

/**
 * Donor list/detail/status/update. Create is handled by {@code AdminCreateDonorServlet}.
 */
@Controller
@RequestMapping("/admin/donors")
public class DonorController {

    private final DonorService donorService;
    private final NfcCardService nfcCardService;

    public DonorController(DonorService donorService,
                           NfcCardService nfcCardService) {
        this.donorService = donorService;
        this.nfcCardService = nfcCardService;
    }

    @GetMapping
    public String list(@RequestParam(defaultValue = "") String keyword,
                       @RequestParam(defaultValue = "0") int page,
                       HttpServletRequest request,
                       Model model) {
        request.setAttribute("activeMenu", "donors");
        Page<Donor> donorPage = donorService.searchByKeyword(keyword, PageRequest.of(page, 15));
        model.addAttribute("donorPage", donorPage);
        model.addAttribute("keyword", keyword);
        model.addAttribute("bloodTypes", donorService.findAllBloodTypes());
        return "admin/donors/list";
    }

    @GetMapping("/{id:\\d+}")
    public String detail(@PathVariable Long id, HttpServletRequest request, Model model) {
        request.setAttribute("activeMenu", "donors");
        model.addAttribute("donor", donorService.findById(id));
        model.addAttribute("nrcDocument", donorService.findNrcDocument(id));
        model.addAttribute("nfcCards", nfcCardService.findByDonorId(id));
        model.addAttribute("nfcStatuses", NfcCardStatus.values());
        return "admin/donors/detail";
    }

    @GetMapping("/{id:\\d+}/edit")
    public String editForm(@PathVariable Long id, HttpServletRequest request, Model model) {
        request.setAttribute("activeMenu", "donors");
        Donor donor = donorService.findById(id);
        model.addAttribute("donor", donor);
        model.addAttribute("nrcDocument", donorService.findNrcDocument(id));
        model.addAttribute("donorUpdateDTO", toDto(donor));
        model.addAttribute("accountStatuses", AccountStatus.values());
        model.addAttribute("bloodTypes", donorService.findAllBloodTypes());
        return "admin/donors/edit";
    }

    @PostMapping("/{id:\\d+}/edit")
    public String update(@PathVariable Long id,
                         @Valid @ModelAttribute DonorUpdateDTO donorUpdateDTO,
                         BindingResult result,
                         @AuthenticationPrincipal AdminUserDetails principal,
                         HttpServletRequest request,
                         Model model,
                         RedirectAttributes redirectAttributes) {
        request.setAttribute("activeMenu", "donors");
        if (result.hasErrors()) {
            model.addAttribute("donor", donorService.findById(id));
            model.addAttribute("nrcDocument", donorService.findNrcDocument(id));
            model.addAttribute("donorUpdateDTO", donorUpdateDTO);
            model.addAttribute("accountStatuses", AccountStatus.values());
            model.addAttribute("bloodTypes", donorService.findAllBloodTypes());
            return "admin/donors/edit";
        }
        try {
            Account adminAccount = (principal != null) ? principal.getAccount() : null;
            donorService.updateDonor(id, donorUpdateDTO, adminAccount, request);
            redirectAttributes.addFlashAttribute("successMessage", "Donor updated successfully.");
            return "redirect:/admin/donors";
        } catch (Exception ex) {
            model.addAttribute("errorMessage",
                    ex.getMessage() != null ? ex.getMessage() : "Update failed.");
            model.addAttribute("donor", donorService.findById(id));
            model.addAttribute("nrcDocument", donorService.findNrcDocument(id));
            model.addAttribute("donorUpdateDTO", donorUpdateDTO);
            model.addAttribute("accountStatuses", AccountStatus.values());
            model.addAttribute("bloodTypes", donorService.findAllBloodTypes());
            return "admin/donors/edit";
        }
    }

    @PostMapping("/{id:\\d+}/nfc-cards/{cardId}/status")
    public String updateNfcStatus(@PathVariable Long id,
                                  @PathVariable Long cardId,
                                  @RequestParam String status,
                                  @AuthenticationPrincipal AdminUserDetails principal,
                                  HttpServletRequest request,
                                  RedirectAttributes redirectAttributes) {
        try {
            NfcCardStatus cardStatus = NfcCardStatus.valueOf(status);
            Account adminAccount = (principal != null) ? principal.getAccount() : null;
            nfcCardService.updateStatus(id, cardId, cardStatus, adminAccount, request);
            redirectAttributes.addFlashAttribute("successMessage",
                    "NFC card status updated to " + cardStatus + ".");
        } catch (IllegalArgumentException ex) {
            redirectAttributes.addFlashAttribute("errorMessage", "Invalid NFC card status.");
        } catch (Exception ex) {
            redirectAttributes.addFlashAttribute("errorMessage",
                    ex.getMessage() != null ? ex.getMessage() : "NFC status update failed.");
        }
        return "redirect:/admin/donors/" + id;
    }

    @PostMapping("/{id:\\d+}/status")
    public String changeStatus(
            @PathVariable Long id,
            @RequestParam AccountStatus status,
            @AuthenticationPrincipal AdminUserDetails principal,
            HttpServletRequest request,
            RedirectAttributes redirectAttributes) {

        try {
            Account adminAccount = (principal != null) ? principal.getAccount() : null;
            donorService.changeStatus(id, status, adminAccount, request);
            redirectAttributes.addFlashAttribute("successMessage",
                    "Donor status updated to " + status + ".");
        } catch (Exception ex) {
            redirectAttributes.addFlashAttribute("errorMessage",
                    ex.getMessage() != null ? ex.getMessage() : "Status change failed.");
        }
        return "redirect:/admin/donors/" + id;
    }

    private static DonorUpdateDTO toDto(Donor donor) {
        DonorUpdateDTO dto = new DonorUpdateDTO();
        dto.setName(donor.getName());
        dto.setDateOfBirth(donor.getDateOfBirth());
        dto.setGender(donor.getGender() != null ? donor.getGender().name() : "");
        if (donor.getAccount() != null) {
            dto.setPhone(donor.getAccount().getPhone());
            dto.setEmail(donor.getAccount().getEmail());
            dto.setAccountStatus(donor.getAccount().getStatus() != null
                    ? donor.getAccount().getStatus().name() : "ACTIVE");
        }
        if (donor.getAddress() != null) {
            dto.setDetailAddress(donor.getAddress().getDetailAddress());
            dto.setTownship(donor.getAddress().getTownship());
            dto.setDivision(donor.getAddress().getDivision());
            dto.setCountry(donor.getAddress().getCountry());
        }
        if (donor.getBloodType() != null) {
            dto.setBloodTypeId(donor.getBloodType().getId());
        }
        return dto;
    }
}
