<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<c:set var="pageTitle" value="Hospital — Detail" scope="request"/>
<%@ include file="../../layout/header.jsp" %>

<div class="page-header">
    <div>
        <h1 class="page-title">${fn:escapeXml(hospital.name)}</h1>
        <p class="page-subtitle">Hospital Details</p>
    </div>
    <div class="action-buttons">
        <a href="<c:url value='/admin/hospitals/${hospital.id}/edit'/>" class="btn btn-secondary">Edit</a>
        <a href="<c:url value='/admin/hospitals'/>" class="btn btn-outline">← Back</a>
    </div>
</div>

<c:if test="${not empty successMessage}">
    <div class="alert alert-success">${fn:escapeXml(successMessage)}</div>
</c:if>
<c:if test="${not empty errorMessage}">
    <div class="alert alert-error">${fn:escapeXml(errorMessage)}</div>
</c:if>

<div class="detail-grid">
    <div class="card">
        <div class="card-body text-center">
            <c:choose>
                <c:when test="${not empty hospital.profilePicture}">
                    <img src="${fn:escapeXml(hospital.profilePicture)}" alt="Hospital photo"
                         class="detail-avatar"/>
                </c:when>
                <c:otherwise>
                    <div class="detail-avatar-placeholder">
                        <svg viewBox="0 0 24 24" width="48" height="48"><path d="M19 3H5a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2V5a2 2 0 0 0-2-2zm-7 14v-4H8v-2h4V7h2v4h4v2h-4v4h-2z"/></svg>
                    </div>
                </c:otherwise>
            </c:choose>
            <h2 class="mt-3">${fn:escapeXml(hospital.name)}</h2>
            <span class="badge badge-status badge-status--${fn:toLowerCase(hospital.status.toString())}">${hospital.status}</span>
        </div>
    </div>

    <div class="card">
        <div class="card-header">Contact & Location</div>
        <div class="card-body">
            <dl class="detail-list">
                <dt>Phone</dt><dd>${fn:escapeXml(hospital.phone)}</dd>
                <dt>Email</dt><dd>${fn:escapeXml(hospital.email)}</dd>
                <c:if test="${hospital.address != null}">
                    <dt>Address</dt>
                    <dd>${fn:escapeXml(hospital.address.detailAddress)}<br/>
                        ${fn:escapeXml(hospital.address.township)},
                        ${fn:escapeXml(hospital.address.division)}<br/>
                        ${fn:escapeXml(hospital.address.country)}</dd>
                </c:if>
                <dt>Created</dt><dd>${hospital.createdAt.toLocalDate()}</dd>
            </dl>
        </div>
    </div>
</div>

<div class="card mt-4">
    <div class="card-header">Status Management</div>
    <div class="card-body">
        <p class="text-muted mb-3">Current status: <strong>${hospital.status}</strong></p>
        <div class="action-buttons">
            <c:if test="${hospital.status != 'ACTIVE'}">
                <form method="post" action="<c:url value='/admin/hospitals/${hospital.id}/status'/>"
                      onsubmit="return confirm('Activate this hospital?')">
                    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                    <input type="hidden" name="status" value="ACTIVE"/>
                    <button type="submit" class="btn btn-success">Activate</button>
                </form>
            </c:if>
            <c:if test="${hospital.status != 'SUSPENDED'}">
                <form method="post" action="<c:url value='/admin/hospitals/${hospital.id}/status'/>"
                      onsubmit="return confirm('Suspend this hospital?')">
                    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                    <input type="hidden" name="status" value="SUSPENDED"/>
                    <button type="submit" class="btn btn-warning">Suspend</button>
                </form>
            </c:if>
            <c:if test="${hospital.status != 'INACTIVE'}">
                <form method="post" action="<c:url value='/admin/hospitals/${hospital.id}/status'/>"
                      onsubmit="return confirm('Deactivate this hospital?')">
                    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                    <input type="hidden" name="status" value="INACTIVE"/>
                    <button type="submit" class="btn btn-danger">Deactivate</button>
                </form>
            </c:if>
        </div>
    </div>
</div>

<%@ include file="../../layout/footer.jsp" %>
