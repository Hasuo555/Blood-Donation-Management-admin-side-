<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
            <c:set var="pageTitle" value="Articles — List" scope="request" />
            <%@ include file="../../layout/header.jsp" %>

                <div class="page-header">
                    <div>
                        <h1 class="page-title">Articles</h1>
                        <p class="page-subtitle">Manage platform articles and announcements</p>
                    </div>

                </div>

                <c:if test="${not empty successMessage}">
                    <div class="alert alert-success">${fn:escapeXml(successMessage)}</div>
                </c:if>
                <c:if test="${not empty errorMessage}">
                    <div class="alert alert-error">${fn:escapeXml(errorMessage)}</div>
                </c:if>

                <div class="filter-bar card mb-4">
                    <div class="card-body">
                        <div class="filter-row">
                            <span class="filter-label">Filter by status:</span>
                            <a href="<c:url value='/admin/articles'/>"
                                class="btn btn-sm ${empty statusFilter ? 'btn-primary' : 'btn-outline'}">All</a>
                            <c:forEach items="${statuses}" var="st">
                                <a href="?status=${st}"
                                    class="btn btn-sm ${statusFilter == st ? 'btn-primary' : 'btn-outline'}">${st}</a>
                            </c:forEach>
                        </div>
                    </div>
                </div>

                <div class="card">
                    <div class="card-body p-0">
                        <c:choose>
                            <c:when test="${articlePage.totalElements == 0}">
                                <div class="empty-state">
                                    <p>No articles found.</p>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <table class="data-table">
                                    <thead>
                                        <tr>
                                            <th>#</th>
                                            <th>Title</th>
                                            <th>Hospital</th>
                                            <th>Status</th>
                                            <th>Published</th>
                                            <th>Created</th>
                                            <th>Actions</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach items="${articlePage.content}" var="a">
                                            <tr>
                                                <td>${a.id}</td>
                                                <td><strong>${fn:escapeXml(a.title)}</strong></td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${a.hospital != null}">
                                                            ${fn:escapeXml(a.hospital.name)}</c:when>
                                                        <c:otherwise><span class="badge badge-gray">System-wide</span>
                                                        </c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td><span
                                                        class="badge badge-article badge-article--${fn:toLowerCase(a.status.toString())}">${a.status}</span>
                                                </td>
                                                <td class="text-muted text-sm">
                                                    <c:choose>
                                                        <c:when test="${a.publishedAt != null}">${a.publishedAt}
                                                        </c:when>
                                                        <c:otherwise>—</c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td class="text-muted text-sm">
                                                    <c:choose>
                                                        <c:when test="${a.createdAt != null}">${a.createdAt}</c:when>
                                                        <c:otherwise>—</c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td>
                                                    <a href="<c:url value='/admin/articles/${a.id}'/>"
                                                        class="btn btn-sm btn-outline">View</a>
                                                    <button type="button"
                                                        class="btn btn-sm btn-danger js-delete-article"
                                                        data-id="${a.id}"
                                                        data-title="${fn:escapeXml(a.title)}">Delete</button>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </tbody>
                                </table>
                                <div class="pagination-bar">
                                    <c:if test="${articlePage.hasPrevious()}">
                                        <a href="?page=${articlePage.number - 1}<c:if test='${not empty statusFilter}'>&status=${statusFilter}</c:if>"
                                            class="btn btn-sm btn-outline">← Prev</a>
                                    </c:if>
                                    <span class="pagination-info">Page ${articlePage.number + 1} of
                                        ${articlePage.totalPages}</span>
                                    <c:if test="${articlePage.hasNext()}">
                                        <a href="?page=${articlePage.number + 1}<c:if test='${not empty statusFilter}'>&status=${statusFilter}</c:if>"
                                            class="btn btn-sm btn-outline">Next →</a>
                                    </c:if>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>

                <div class="confirm-modal-overlay hidden" id="deleteArticleModal" role="dialog" aria-modal="true">
                    <div class="confirm-modal">
                        <h3 class="confirm-modal-title">Delete article?</h3>
                        <p class="text-muted" id="deleteArticleMessage">This action cannot be undone.</p>
                        <form id="deleteArticleForm" method="post">
                            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
                            <div class="confirm-modal-actions">
                                <button type="button" class="btn btn-secondary"
                                    onclick="closeDeleteArticleModal()">Cancel</button>
                                <button type="submit" class="btn btn-danger">Delete</button>
                            </div>
                        </form>
                    </div>
                </div>

                <script>
                    (function () {
                        const modal = document.getElementById('deleteArticleModal');
                        const form = document.getElementById('deleteArticleForm');
                        const msg = document.getElementById('deleteArticleMessage');
                        const base = '<c:url value="/admin/articles"/>';

                        document.querySelectorAll('.js-delete-article').forEach(function (btn) {
                            btn.addEventListener('click', function () {
                                const id = btn.getAttribute('data-id');
                                const title = btn.getAttribute('data-title') || 'this article';
                                form.action = base + '/' + encodeURIComponent(id) + '/delete';
                                msg.textContent = 'Delete "' + title + '"? This cannot be undone.';
                                modal.classList.remove('hidden');
                            });
                        });

                        window.closeDeleteArticleModal = function () {
                            modal.classList.add('hidden');
                        };
                        document.addEventListener('keydown', function (e) {
                            if (e.key === 'Escape') window.closeDeleteArticleModal();
                        });
                    })();
                </script>

                <%@ include file="../../layout/footer.jsp" %>