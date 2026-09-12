package com.amyanhlu.admin.service;

import com.amyanhlu.admin.dao.AuditLogDAO;
import com.amyanhlu.admin.entity.Account;
import com.amyanhlu.admin.entity.Article;
import com.amyanhlu.admin.enums.ArticleStatus;
import com.amyanhlu.admin.repository.ArticleRepository;
import jakarta.persistence.EntityNotFoundException;
import jakarta.servlet.http.HttpServletRequest;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;

@Service
public class ArticleService {

    private final ArticleRepository articleRepository;
    private final AuditLogService auditLogService;

    public ArticleService(ArticleRepository articleRepository,
                          AuditLogService auditLogService) {
        this.articleRepository = articleRepository;
        this.auditLogService = auditLogService;
    }

    @Transactional(readOnly = true)
    public Page<Article> findAll(Pageable pageable) {
        return articleRepository.findAll(pageable);
    }

    @Transactional(readOnly = true)
    public Page<Article> findByStatus(ArticleStatus status, Pageable pageable) {
        return articleRepository.findByStatus(status, pageable);
    }

    @Transactional(readOnly = true)
    public Article findById(Long id) {
        return articleRepository.findById(id)
                .orElseThrow(() -> new EntityNotFoundException("Article not found with ID: " + id));
    }

    @Transactional
    public Article create(String title, String content, Account adminAccount,
                          HttpServletRequest request) {
        Article article = new Article();
        article.setTitle(title);
        article.setContent(content);
        article.setStatus(ArticleStatus.DRAFT);
        article = articleRepository.save(article);

        // Use jsonObject() for safe JSON with proper escaping of special characters
        auditLogService.log(adminAccount, "CREATE", "ARTICLE", article.getId(),
                null,
                AuditLogDAO.jsonObject("title", title, "status", "DRAFT"),
                request);

        return article;
    }

    @Transactional
    public Article update(Long id, String title, String content,
                          Account adminAccount, HttpServletRequest request) {
        Article article = findById(id);
        String oldTitle = article.getTitle();

        article.setTitle(title);
        article.setContent(content);
        article = articleRepository.save(article);

        auditLogService.log(adminAccount, "UPDATE", "ARTICLE", id,
                AuditLogDAO.jsonObject("title", oldTitle),
                AuditLogDAO.jsonObject("title", title),
                request);

        return article;
    }

    @Transactional
    public void publish(Long id, Account adminAccount, HttpServletRequest request) {
        Article article = findById(id);
        ArticleStatus oldStatus = article.getStatus();

        article.setStatus(ArticleStatus.PUBLISHED);
        article.setPublishedAt(LocalDateTime.now());
        articleRepository.save(article);

        auditLogService.log(adminAccount, "PUBLISH", "ARTICLE", id,
                AuditLogDAO.jsonObject("status", oldStatus != null ? oldStatus.name() : "UNKNOWN"),
                AuditLogDAO.jsonObject("status", "PUBLISHED"),
                request);
    }

    @Transactional
    public void archive(Long id, Account adminAccount, HttpServletRequest request) {
        Article article = findById(id);
        ArticleStatus oldStatus = article.getStatus();

        article.setStatus(ArticleStatus.ARCHIVED);
        articleRepository.save(article);

        auditLogService.log(adminAccount, "ARCHIVE", "ARTICLE", id,
                AuditLogDAO.jsonObject("status", oldStatus != null ? oldStatus.name() : "UNKNOWN"),
                AuditLogDAO.jsonObject("status", "ARCHIVED"),
                request);
    }

    @Transactional
    public void delete(Long id, Account adminAccount, HttpServletRequest request) {
        Article article = findById(id);

        auditLogService.log(adminAccount, "DELETE_ARTICLE", "articles", id,
                AuditLogDAO.jsonObject(
                        "title", article.getTitle(),
                        "status", article.getStatus() != null ? article.getStatus().name() : "UNKNOWN"),
                null,
                request);

        articleRepository.delete(article);
    }

    @Transactional
    public void updateCoverImage(Long articleId, String imageUrl,
                                 Account adminAccount, HttpServletRequest request) {
        Article article = findById(articleId);
        article.setCoverImage(imageUrl);
        articleRepository.save(article);
    }
}
