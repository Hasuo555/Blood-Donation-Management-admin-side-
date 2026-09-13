<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
            <c:set var="pageTitle" value="Staff — List" scope="request" />
            <%@ include file="../../layout/header.jsp" %>

                <div class="page-header">
                    <div>
                        <h1 class="page-title">Staff</h1>
                        <p class="page-subtitle">Manage hospital staff accounts</p>
                    </div>

                </div>

                <c:if test="${not empty successMessage}">
                    <div class="alert alert-success">${fn:escapeXml(successMessage)}</div>
                </c:if>

                <div class="card">
                    <div class="card-body p-0">
                        <c:choose>
                            <c:when test="${staffPage.totalElements == 0}">
                                <div class="empty-state">
                                    <p>No staff accounts found.</p>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <table class="data-table">
                                    <thead>
                                        <tr>
                                            <th>#</th>
                                            <th>Name</th>
                                            <th>Email</th>
                                            <th>Hospital</th>
                                            <th>Status</th>
                                            <th>Created</th>
                                            <th>Actions</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach items="${staffPage.content}" var="s">
                                            <tr>
                                                <td>${s.id}</td>
                                                <td><strong>${fn:escapeXml(s.name)}</strong></td>
                                                <td>${fn:escapeXml(s.account.email)}</td>
                                                <td>${fn:escapeXml(s.hospital.name)}</td>
                                                <td><span class="status-dot status-dot--${fn:toLowerCase(s.status.toString())}"></span><span
                                                        class="badge badge-status badge-status--${fn:toLowerCase(s.status.toString())}">${s.status}</span>
                                                </td>
                                                <td class="text-muted text-sm text-nowrap">${s.createdAt.format(adminDateTimeFormatter)}</td>
                                                <td>
                                                    <div class="action-buttons">
                                                        <a href="<c:url value='/admin/staff/${s.id}'/>"
                                                           class="btn btn-sm btn-outline icon-action" title="View staff member" aria-label="View staff member">
                                                            <svg viewBox="0 0 24 24"><path d="M12 5c-5 0-9 7-9 7s4 7 9 7 9-7 9-7-4-7-9-7zm0 11a4 4 0 1 1 0-8 4 4 0 0 1 0 8zm0-2.2A1.8 1.8 0 1 0 12 10a1.8 1.8 0 0 0 0 3.8z"/></svg>
                                                        </a>
                                                        <a href="<c:url value='/admin/staff/${s.id}/edit'/>"
                                                           class="btn btn-sm btn-primary icon-action" title="Edit staff member" aria-label="Edit staff member">
                                                            <svg viewBox="0 0 24 24"><path d="M4 17.3V21h3.7L18.8 9.9l-3.7-3.7L4 17.3zM21.4 6.3a1 1 0 0 0 0-1.4l-2.3-2.3a1 1 0 0 0-1.4 0l-1.8 1.8 3.7 3.7 1.8-1.8z"/></svg>
                                                        </a>
                                                    </div>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </tbody>
                                </table>
                                <div class="pagination-bar">
                                    <c:if test="${staffPage.hasPrevious()}">
                                        <a href="?page=${staffPage.number - 1}" class="btn btn-sm btn-outline">←
                                            Prev</a>
                                    </c:if>
                                    <span class="pagination-info">Page ${staffPage.number + 1} of
                                        ${staffPage.totalPages}</span>
                                    <c:if test="${staffPage.hasNext()}">
                                        <a href="?page=${staffPage.number + 1}" class="btn btn-sm btn-outline">Next
                                            →</a>
                                    </c:if>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>

                <%@ include file="../../layout/footer.jsp" %>
