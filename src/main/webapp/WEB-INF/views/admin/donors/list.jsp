<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
            <c:set var="pageTitle" value="Donors — List" scope="request" />
            <%@ include file="../../layout/header.jsp" %>

                <div class="page-header">
                    <div>
                        <h1 class="page-title">Donors</h1>
                        <p class="page-subtitle">Search and manage donor accounts</p>
                    </div>

                </div>

                <c:if test="${not empty successMessage}">
                    <div class="alert alert-success">${fn:escapeXml(successMessage)}</div>
                </c:if>
                <c:if test="${not empty errorMessage}">
                    <div class="alert alert-error">${fn:escapeXml(errorMessage)}</div>
                </c:if>

                <div class="card">
                    <div class="card-body">
                        <form method="get" action="<c:url value='/admin/donors'/>" class="search-form">
                            <div class="search-row">
                                <input type="text" name="keyword" value="${fn:escapeXml(keyword)}"
                                    class="form-control search-input" placeholder="Search by name, email, or phone…" />
                                <button type="submit" class="btn btn-primary">Search</button>
                                <c:if test="${not empty keyword}">
                                    <a href="<c:url value='/admin/donors'/>" class="btn btn-secondary">Clear</a>
                                </c:if>
                            </div>
                        </form>
                    </div>
                </div>

                <div class="card mt-4">
                    <div class="card-body p-0">
                        <c:choose>
                            <c:when test="${donorPage.totalElements == 0}">
                                <div class="empty-state">
                                    <svg width="48" height="48" viewBox="0 0 24 24" opacity=".3">
                                        <path
                                            d="M12 12c2.7 0 5-2.3 5-5s-2.3-5-5-5-5 2.3-5 5 2.3 5 5 5zm0 2c-3.3 0-10 1.7-10 5v2h20v-2c0-3.3-6.7-5-10-5z" />
                                    </svg>
                                    <p>No donors found.</p>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <table class="data-table">
                                    <thead>
                                        <tr>
                                            <th>#</th>
                                            <th>Name</th>
                                            <th>Email</th>
                                            <th>Phone</th>
                                            <th>Blood Type</th>
                                            <th>Status</th>
                                            <th>Joined</th>
                                            <th>Actions</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach items="${donorPage.content}" var="donor">
                                            <tr>
                                                <td>${donor.id}</td>
                                                <td><strong>${fn:escapeXml(donor.name)}</strong></td>
                                                <td>${fn:escapeXml(donor.account.email)}</td>
                                                <td>${fn:escapeXml(donor.account.phone)}</td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${donor.bloodType != null}">
                                                            <span
                                                                class="badge badge-blood">${fn:escapeXml(donor.bloodType.displayName)}</span>
                                                        </c:when>
                                                        <c:otherwise><span class="text-muted">—</span></c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td><span
                                                        class="badge badge-status badge-status--${fn:toLowerCase(donor.account.status.toString())}">${donor.account.status}</span>
                                                </td>
                                                <td class="text-muted text-sm text-nowrap">${donor.createdAt != null ?
                                                    donor.createdAt.format(adminDateTimeFormatter) : '—'}</td>
                                                <td>
                                                    <a href="<c:url value='/admin/donors/${donor.id}'/>"
                                                        class="btn btn-sm btn-outline icon-action" title="View donor"
                                                        aria-label="View donor">
                                                        <svg viewBox="0 0 24 24">
                                                            <path
                                                                d="M12 5c-5 0-9 7-9 7s4 7 9 7 9-7 9-7-4-7-9-7zm0 11a4 4 0 1 1 0-8 4 4 0 0 1 0 8zm0-2.2A1.8 1.8 0 1 0 12 10a1.8 1.8 0 0 0 0 3.8z" />
                                                        </svg>
                                                    </a>
                                                    <a href="<c:url value='/admin/donors/${donor.id}/edit'/>"
                                                        class="btn btn-sm btn-primary icon-action" title="Edit donor"
                                                        aria-label="Edit donor">
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

                                <%@ include file="../../layout/pagination.jsp" %>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>

                <%@ include file="../../layout/footer.jsp" %>