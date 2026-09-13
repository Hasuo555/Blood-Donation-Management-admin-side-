<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
            <%@ taglib prefix="asset" tagdir="/WEB-INF/tags" %>
                <c:set var="pageTitle" value="Article — Detail" scope="request" />
                <%@ include file="../../layout/header.jsp" %>

                    <div class="page-header">
                        <div>
                            <h1 class="page-title">${fn:escapeXml(article.title)}</h1>
                            <p class="page-subtitle">
                                <span
                                    class="badge badge-article badge-article--${fn:toLowerCase(article.status.toString())}">${article.status}</span>
                            </p>
                        </div>
                        <div class="action-buttons">
                            <a href="<c:url value='/admin/articles/${article.id}/edit'/>"
                                class="btn btn-secondary">Edit</a>
                            <a href="<c:url value='/admin/articles'/>" class="btn btn-outline">← Back</a>
                        </div>
                    </div>

                    <c:if test="${not empty successMessage}">
                        <div class="alert alert-success">${fn:escapeXml(successMessage)}</div>
                    </c:if>
                    <c:if test="${not empty errorMessage}">
                        <div class="alert alert-error">${fn:escapeXml(errorMessage)}</div>
                    </c:if>

                    <div class="detail-grid">
                        <div class="card" style="grid-column: 1 / -1">
                            <div class="card-header">Article Actions</div>
                            <div class="card-body">
                                <div class="action-buttons">
                                    <c:if test="${article.status == 'DRAFT' || article.status == 'ARCHIVED'}">
                                        <form method="post"
                                            action="<c:url value='/admin/articles/${article.id}/publish'/>"
                                            onsubmit="return confirm('Publish this article? It will be visible to users.')">
                                            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                                            <button type="submit" class="btn btn-primary">Publish</button>
                                        </form>
                                    </c:if>
                                    <c:if test="${article.status == 'PUBLISHED'}">
                                        <form method="post"
                                            action="<c:url value='/admin/articles/${article.id}/archive'/>"
                                            onsubmit="return confirm('Archive this article?')">
                                            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                                            <button type="submit" class="btn btn-warning">Archive</button>
                                        </form>
                                    </c:if>
                                </div>
                            </div>
                        </div>

                        <div class="card">
                            <div class="card-header">Metadata</div>
                            <div class="card-body">
                                <dl class="detail-list">
                                    <dt>Status</dt>
                                    <dd><span
                                            class="badge badge-article badge-article--${fn:toLowerCase(article.status.toString())}">${article.status}</span>
                                    </dd>

                                    <dt>Created By</dt>
                                    <dd>System admin</dd>
                                    <dt>Published At</dt>
                                    <dd>${article.publishedAt != null ?
                                        article.publishedAt.format(adminDateTimeFormatter) : '—'}</dd>
                                    <dt>Created At</dt>
                                    <dd>${article.createdAt != null ? article.createdAt.format(adminDateTimeFormatter) :
                                        '—'}</dd>
                                    <dt>Updated At</dt>
                                    <dd>${article.updatedAt != null ? article.updatedAt.format(adminDateTimeFormatter) :
                                        '—'}</dd>
                                </dl>
                            </div>
                        </div>

                        <div class="card">
                            <div class="card-header">Cover Image</div>
                            <div class="card-body">
                                <c:choose>
                                    <c:when test="${not empty article.coverImage}">
                                        <img src="<asset:asset-url value=" ${article.coverImage}" />" alt="Cover"
                                        class="article-detail-cover" />
                                    </c:when>
                                    <c:otherwise>
                                        <p class="text-muted">No cover image</p>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </div>

                        <div class="card" style="grid-column: 1 / -1">
                            <div class="card-header">Content</div>
                            <div class="card-body">
                                <div class="article-content">${article.content}</div>
                            </div>
                        </div>
                    </div>

                    <%@ include file="../../layout/footer.jsp" %>