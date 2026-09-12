package com.amyanhlu.admin.repository;

import com.amyanhlu.admin.entity.Article;
import com.amyanhlu.admin.enums.ArticleStatus;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.EntityGraph;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface ArticleRepository extends JpaRepository<Article, Long> {

    @Override
    @EntityGraph(attributePaths = "hospital")
    Page<Article> findAll(Pageable pageable);

    @EntityGraph(attributePaths = "hospital")
    Page<Article> findByStatus(ArticleStatus status, Pageable pageable);

    @Override
    @EntityGraph(attributePaths = "hospital")
    Optional<Article> findById(Long id);

    Page<Article> findByHospitalIsNull(Pageable pageable);

    long countByStatus(ArticleStatus status);
}