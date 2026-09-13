<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
            <%@ taglib prefix="asset" tagdir="/WEB-INF/tags" %>
                <c:set var="pageTitle" value="Hospitals — List" scope="request" />
                <%@ include file="../../layout/header.jsp" %>

                    <div class="page-header">
                        <div>
                            <h1 class="page-title">Hospitals</h1>
                            <p class="page-subtitle">Create and manage hospital records</p>
                        </div>

                    </div>

                    <c:if test="${not empty successMessage}">
                        <div class="alert alert-success">${fn:escapeXml(successMessage)}</div>
                    </c:if>

                    <div class="card">
                        <div class="card-body p-0">
                            <c:choose>
                                <c:when test="${hospitalPage.totalElements == 0}">
                                    <div class="empty-state">
                                        <p>No hospitals found.</p>
                                    </div>
                                </c:when>
                                <c:otherwise>
                                    <table class="data-table">
                                        <thead>
                                            <tr>
                                                <th>#</th>
                                                <th>Name</th>
                                                <th>Phone</th>
                                                <th>Email</th>
                                                <th>Status</th>
                                                <th>Created</th>
                                                <th>Actions</th>
                                            </tr>
                                        </thead>
                                        <tbody>
                                            <c:forEach items="${hospitalPage.content}" var="h">
                                                <tr>
                                                    <td>${h.id}</td>
                                                    <td>
                                                        <div class="table-name-cell">
                                                            <c:if test="${not empty h.profilePicture}">
                                                                <img src="<asset:asset-url value="
                                                                    ${h.profilePicture}" />" alt=""
                                                                class="table-avatar hospital-thumb" />
                                                            </c:if>
                                                            <c:if test="${empty h.profilePicture}"><span
                                                                    class="hospital-thumb-placeholder">H</span></c:if>
                                                            <strong>${fn:escapeXml(h.name)}</strong>
                                                        </div>
                                                    </td>
                                                    <td>${fn:escapeXml(h.phone)}</td>
                                                    <td>${fn:escapeXml(h.email)}</td>
                                                    <td><span
                                                            class="status-dot status-dot--${fn:toLowerCase(h.status.toString())}"></span><span
                                                            class="badge badge-status badge-status--${fn:toLowerCase(h.status.toString())}">${h.status}</span>
                                                    </td>
                                                    <td class="text-muted text-sm text-nowrap">
                                                        <c:choose>
                                                            <c:when test="${not empty h.createdAt}">
                                                                ${h.createdAt.format(adminDateTimeFormatter)}
                                                            </c:when>
                                                            <c:otherwise>-</c:otherwise>
                                                        </c:choose>
                                                    </td>
                                                    <td>
                                                        <a href="<c:url value='/admin/hospitals/${h.id}'/>"
                                                            class="btn btn-sm btn-outline icon-action"
                                                            title="View hospital" aria-label="View hospital">
                                                            <svg viewBox="0 0 24 24">
                                                                <path
                                                                    d="M12 5c-5 0-9 7-9 7s4 7 9 7 9-7 9-7-4-7-9-7zm0 11a4 4 0 1 1 0-8 4 4 0 0 1 0 8zm0-2.2A1.8 1.8 0 1 0 12 10a1.8 1.8 0 0 0 0 3.8z" />
                                                            </svg>
                                                        </a>
                                                        <a href="<c:url value='/admin/hospitals/${h.id}/edit'/>"
                                                            class="btn btn-sm btn-primary icon-action"
                                                            title="Edit hospital" aria-label="Edit hospital">
                                                            <svg viewBox="0 0 24 24">
                                                                <path
                                                                    d="M4 17.3V21h3.7L18.8 9.9l-3.7-3.7L4 17.3zM21.4 6.3a1 1 0 0 0 0-1.4l-2.3-2.3a1 1 0 0 0-1.4 0l-1.8 1.8 3.7 3.7 1.8-1.8z" />
                                                            </svg>
                                                        </a>
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                        </tbody>
                                    </table>
                                    <div class="pagination-bar">
                                        <c:if test="${hospitalPage.hasPrevious()}">
                                            <a href="?page=${hospitalPage.number - 1}" class="btn btn-sm btn-outline">←
                                                Prev</a>
                                        </c:if>
                                        <span class="pagination-info">Page ${hospitalPage.number + 1} of
                                            ${hospitalPage.totalPages}</span>
                                        <c:if test="${hospitalPage.hasNext()}">
                                            <a href="?page=${hospitalPage.number + 1}"
                                                class="btn btn-sm btn-outline">Next
                                                →</a>
                                        </c:if>
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </div>

                    <%@ include file="../../layout/footer.jsp" %>