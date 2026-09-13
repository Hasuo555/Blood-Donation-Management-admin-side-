package com.amyanhlu.admin.config;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.ResourceHandlerRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

import java.nio.file.Path;
import java.nio.file.Paths;

/**
 * MVC configuration for serving static resources from the webapp/static directory.
 */
@Configuration
public class WebMvcConfig implements WebMvcConfigurer {

    /** Root used when legacy/local upload paths are present in the database. */
    @Value("${app.upload-dir:uploads}")
    private String uploadDirectory;

    @Override
    public void addResourceHandlers(ResourceHandlerRegistry registry) {
        registry.addResourceHandler("/static/**")
                .addResourceLocations(
                        "/static/",
                        "classpath:/META-INF/resources/",
                        "classpath:/resources/",
                        "classpath:/static/",
                        "classpath:/public/");

        // Keep old/local database paths usable while new uploads use R2 URLs.
        Path uploadRoot = Paths.get(uploadDirectory).toAbsolutePath().normalize();
        registry.addResourceHandler("/uploads/**")
                .addResourceLocations(uploadRoot.toUri().toString());

        registry.addResourceHandler("/images/**")
                .addResourceLocations("/images/", "classpath:/static/images/");
    }
}
