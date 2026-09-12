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
                                                <td><span
                                                        class="badge badge-status badge-status--${fn:toLowerCase(s.status.toString())}">${s.status}</span>
                                                </td>
                                                <td class="text-muted text-sm">${s.createdAt.toLocalDate()}</td>
                                                <td>
                                                    <div class="action-buttons">
                                                        <a href="<c:url value='/admin/staff/${s.id}'/>"
                                                           class="btn btn-sm btn-outline">View</a>
                                                        <a href="<c:url value='/admin/staff/${s.id}/edit'/>"
                                                           class="btn btn-sm btn-primary">Edit</a>
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
