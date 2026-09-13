package com.amyanhlu.admin.config;

import com.amyanhlu.admin.service.R2StorageService;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ModelAttribute;

/** Exposes the defensive media resolver to all server-rendered MVC views. */
@ControllerAdvice
public class AssetModelAdvice {

    private final R2StorageService storageService;

    public AssetModelAdvice(R2StorageService storageService) {
        this.storageService = storageService;
    }

    @ModelAttribute
    public void addAssetResolver(Model model) {
        model.addAttribute("assetResolver", storageService);
    }
}
