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
                                                            <img src="<asset:asset-url value="${h.profilePicture}"/>" alt=""
                                                                class="table-avatar" />
                                                        </c:if>
                                                        <strong>${fn:escapeXml(h.name)}</strong>
                                                    </div>
                                                </td>
                                                <td>${fn:escapeXml(h.phone)}</td>
                                                <td>${fn:escapeXml(h.email)}</td>
                                                <td><span
                                                        class="badge badge-status badge-status--${fn:toLowerCase(h.status.toString())}">${h.status}</span>
                                                </td>
                                                <td class="text-muted text-sm">
                                                    <c:choose>
                                                        <c:when test="${not empty h.createdAt}">
                                                            ${h.createdAt.toLocalDate()}
                                                        </c:when>
                                                        <c:otherwise>-</c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td>
                                                    <a href="<c:url value='/admin/hospitals/${h.id}'/>"
                                                        class="btn btn-sm btn-outline">View</a>
                                                    <a href="<c:url value='/admin/hospitals/${h.id}/edit'/>"
                                                        class="btn btn-sm btn-outline">Edit</a>
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
                                        <a href="?page=${hospitalPage.number + 1}" class="btn btn-sm btn-outline">Next
                                            →</a>
                                    </c:if>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>

                <%@ include file="../../layout/footer.jsp" %>
