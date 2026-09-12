package com.amyanhlu.admin.controller;

import com.amyanhlu.admin.dto.ArticleCreateDTO;
import com.amyanhlu.admin.dto.ArticleUpdateDTO;
import com.amyanhlu.admin.entity.Article;
import com.amyanhlu.admin.enums.ArticleStatus;
import com.amyanhlu.admin.security.AdminUserDetails;
import com.amyanhlu.admin.service.ArticleService;
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
@RequestMapping("/admin/articles")
public class ArticleController {

    private final ArticleService articleService;
    private final HospitalService hospitalService;
    private final R2StorageService storageService;

    public ArticleController(ArticleService articleService,
            HospitalService hospitalService,
            R2StorageService storageService) {
        this.articleService = articleService;
        this.hospitalService = hospitalService;
        this.storageService = storageService;
    }

    @GetMapping
    public String list(@RequestParam(defaultValue = "0") int page,
            @RequestParam(required = false) String status,
            HttpServletRequest request,
            Model model) {
        request.setAttribute("activeMenu", "articles");
        Page<Article> articlePage = (status != null && !status.isBlank())
                ? articleService.findByStatus(ArticleStatus.valueOf(status), PageRequest.of(page, 15))
                : articleService.findAll(PageRequest.of(page, 15));
        model.addAttribute("articlePage", articlePage);
        model.addAttribute("statusFilter", status);
        model.addAttribute("statuses", ArticleStatus.values());
        return "admin/articles/list";
    }

    @GetMapping("/{id:\\d+}")
    public String detail(@PathVariable Long id, HttpServletRequest request, Model model) {
        request.setAttribute("activeMenu", "articles");
        model.addAttribute("article", articleService.findById(id));
        return "admin/articles/detail";
    }

    @GetMapping("/create")
    public String createForm(HttpServletRequest request, Model model) {
        request.setAttribute("activeMenu", "articles-create");
        model.addAttribute("articleCreateDTO", new ArticleCreateDTO());
        model.addAttribute("hospitals", hospitalService.findActiveHospitals());
        return "admin/articles/create";
    }

    @PostMapping("/create")
    public String create(@Valid @ModelAttribute ArticleCreateDTO dto,
            BindingResult result,
            @RequestParam(required = false) MultipartFile coverImage,
            @AuthenticationPrincipal AdminUserDetails principal,
            HttpServletRequest request,
            Model model,
            RedirectAttributes redirectAttributes) {
        request.setAttribute("activeMenu", "articles-create");
        if (result.hasErrors()) {
            model.addAttribute("hospitals", hospitalService.findActiveHospitals());
            return "admin/articles/create";
        }
        String uploadedUrl = null;
        try {
            Article article = articleService.create(
                    dto.getTitle(), dto.getContent(),
                    principal.getAccount(), request);

            if (storageService.hasContent(coverImage)) {
                try {
                    uploadedUrl = storageService.uploadFile(coverImage, "articles");
                    articleService.updateCoverImage(article.getId(), uploadedUrl,
                            principal.getAccount(), request);
                } catch (Exception uploadEx) {
                    storageService.deleteFile(uploadedUrl);
                    model.addAttribute("errorMessage",
                            "Cover image upload to Cloudflare R2 bucket 'amyanhlu-storage' failed: "
                                    + uploadEx.getMessage());
                    model.addAttribute("hospitals", hospitalService.findActiveHospitals());
                    return "admin/articles/create";
                }
            }
            redirectAttributes.addFlashAttribute("successMessage",
                    "Article saved as draft");
            return "redirect:/admin/articles/" + article.getId();
        } catch (Exception e) {
            storageService.deleteFile(uploadedUrl);
            model.addAttribute("errorMessage", e.getMessage());
            model.addAttribute("hospitals", hospitalService.findActiveHospitals());
            return "admin/articles/create";
        }
    }

    @GetMapping("/{id}/edit")
    public String editForm(@PathVariable Long id, HttpServletRequest request, Model model) {
        request.setAttribute("activeMenu", "articles");
        Article article = articleService.findById(id);
        ArticleUpdateDTO dto = new ArticleUpdateDTO();
        dto.setTitle(article.getTitle());
        dto.setContent(article.getContent());
        model.addAttribute("article", article);
        model.addAttribute("articleUpdateDTO", dto);
        return "admin/articles/edit";
    }

    @PostMapping("/{id}/edit")
    public String update(@PathVariable Long id,
            @Valid @ModelAttribute ArticleUpdateDTO dto,
            BindingResult result,
            @RequestParam(required = false) MultipartFile coverImage,
            @AuthenticationPrincipal AdminUserDetails principal,
            HttpServletRequest request,
            Model model,
            RedirectAttributes redirectAttributes) {
        request.setAttribute("activeMenu", "articles");
        if (result.hasErrors()) {
            model.addAttribute("article", articleService.findById(id));
            return "admin/articles/edit";
        }
        String uploadedUrl = null;
        try {
            articleService.update(id, dto.getTitle(), dto.getContent(),
                    principal.getAccount(), request);
            if (storageService.hasContent(coverImage)) {
                try {
                    uploadedUrl = storageService.uploadFile(coverImage, "articles");
                    articleService.updateCoverImage(id, uploadedUrl, principal.getAccount(), request);
                } catch (Exception uploadEx) {
                    storageService.deleteFile(uploadedUrl);
                    model.addAttribute("errorMessage",
                            "Cover image upload to Cloudflare R2 bucket 'amyanhlu-storage' failed: "
                                    + uploadEx.getMessage());
                    model.addAttribute("article", articleService.findById(id));
                    return "admin/articles/edit";
                }
            }
            redirectAttributes.addFlashAttribute("successMessage", "Article updated");
            return "redirect:/admin/articles/" + id;
        } catch (Exception e) {
            storageService.deleteFile(uploadedUrl);
            model.addAttribute("errorMessage", e.getMessage());
            model.addAttribute("article", articleService.findById(id));
            return "admin/articles/edit";
        }
    }

    @PostMapping("/{id}/publish")
    public String publish(@PathVariable Long id,
            @AuthenticationPrincipal AdminUserDetails principal,
            HttpServletRequest request,
            RedirectAttributes redirectAttributes) {
        try {
            articleService.publish(id, principal.getAccount(), request);
            redirectAttributes.addFlashAttribute("successMessage", "Article published");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("errorMessage", e.getMessage());
        }
        return "redirect:/admin/articles/" + id;
    }

    @PostMapping("/{id}/archive")
    public String archive(@PathVariable Long id,
            @AuthenticationPrincipal AdminUserDetails principal,
            HttpServletRequest request,
            RedirectAttributes redirectAttributes) {
        try {
            articleService.archive(id, principal.getAccount(), request);
            redirectAttributes.addFlashAttribute("successMessage", "Article archived");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("errorMessage", e.getMessage());
        }
        return "redirect:/admin/articles/" + id;
    }

    @PostMapping("/{id}/delete")
    public String delete(@PathVariable Long id,
            @AuthenticationPrincipal AdminUserDetails principal,
            HttpServletRequest request,
            RedirectAttributes redirectAttributes) {
        try {
            articleService.delete(id, principal.getAccount(), request);
            redirectAttributes.addFlashAttribute("successMessage", "Article deleted");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("errorMessage", e.getMessage());
        }
        return "redirect:/admin/articles";
    }
}
