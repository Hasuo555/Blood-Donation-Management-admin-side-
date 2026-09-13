<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
            <c:set var="pageTitle" value="Emergency Blood Requests" scope="request" />
            <%@ include file="../../layout/header.jsp" %>

                <div class="page-header">
                    <div>
                        <h1 class="page-title">Emergency Blood Requests</h1>
                        <p class="page-subtitle">Manage urgent blood needs across hospitals</p>
                    </div>

                </div>

                <c:if test="${not empty successMessage}">
                    <div class="alert alert-success">${fn:escapeXml(successMessage)}</div>
                </c:if>
                <c:if test="${not empty errorMessage}">
                    <div class="alert alert-error">${fn:escapeXml(errorMessage)}</div>
                </c:if>

                <div class="card">
                    <div class="card-body p-0">
                        <c:choose>
                            <c:when test="${requestPage.totalElements == 0}">
                                <div class="empty-state">
                                    <p>No emergency blood requests found.</p>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <table class="data-table">
                                    <thead>
                                        <tr>
                                            <th>#</th>
                                            <th>Hospital</th>
                                            <th>Blood Type</th>
                                            <th>Units</th>
                                            <th>Urgency</th>
                                            <th>Status</th>
                                            <th>Expires</th>
                                            <th>Actions</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach items="${requestPage.content}" var="r">
                                            <tr class="${r.urgency == 'CRITICAL' ? 'row-critical' : ''}">
                                                <td>${r.id}</td>
                                                <td>${fn:escapeXml(r.hospital.name)}</td>
                                                <td><span
                                                        class="badge badge-blood">${fn:escapeXml(r.bloodType.displayName)}</span>
                                                </td>
                                                <td><strong>${r.unitsRequired}</strong></td>
                                                <td><span
                                                        class="badge badge-urgency badge-urgency--${fn:toLowerCase(r.urgency.toString())}">${r.urgency}</span>
                                                </td>
                                                <td><span
                                                        class="badge badge-status badge-status--${fn:toLowerCase(r.status.toString())}">${r.status}</span>
                                                </td>
                                                <td class="text-muted text-sm text-nowrap">${r.expiresAt != null ?
                                                    r.expiresAt.format(adminDateTimeFormatter) : '—'}</td>
                                                <td>
                                                    <c:if
                                                        test="${r.status == 'OPEN' || r.status == 'PARTIALLY_FULFILLED'}">
                                                        <div class="dropdown-actions">
                                                            <form method="post"
                                                                action="<c:url value='/admin/emergency-blood/${r.id}/status'/>"
                                                                onsubmit="return confirm('Mark as fulfilled?')"
                                                                style="display:inline">
                                                                <input type="hidden" name="${_csrf.parameterName}"
                                                                    value="${_csrf.token}" />
                                                                <input type="hidden" name="status" value="FULFILLED" />
                                                                <button type="submit"
                                                                    class="btn btn-sm btn-success">Fulfill</button>
                                                            </form>
                                                            <form method="post"
                                                                action="<c:url value='/admin/emergency-blood/${r.id}/status'/>"
                                                                onsubmit="return confirm('Cancel this request?')"
                                                                style="display:inline">
                                                                <input type="hidden" name="${_csrf.parameterName}"
                                                                    value="${_csrf.token}" />
                                                                <input type="hidden" name="status" value="CANCELLED" />
                                                                <button type="submit"
                                                                    class="btn btn-sm btn-danger">Cancel</button>
                                                            </form>
                                                        </div>
                                                    </c:if>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </tbody>
                                </table>
                                <div class="pagination-bar">
                                    <c:if test="${requestPage.hasPrevious()}">
                                        <a href="?page=${requestPage.number - 1}" class="btn btn-sm btn-outline">←
                                            Prev</a>
                                    </c:if>
                                    <span class="pagination-info">Page ${requestPage.number + 1} of
                                        ${requestPage.totalPages}</span>
                                    <c:if test="${requestPage.hasNext()}">
                                        <a href="?page=${requestPage.number + 1}" class="btn btn-sm btn-outline">Next
                                            →</a>
                                    </c:if>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>

                <%@ include file="../../layout/footer.jsp" %>
