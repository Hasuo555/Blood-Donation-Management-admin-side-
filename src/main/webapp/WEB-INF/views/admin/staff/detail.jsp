<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<c:set var="pageTitle" value="Staff — Detail" scope="request"/>
<%@ include file="../../layout/header.jsp" %>

<div class="page-header">
    <div>
        <h1 class="page-title">${fn:escapeXml(staff.name)}</h1>
        <p class="page-subtitle">Staff Profile</p>
    </div>
    <div class="action-buttons">
        <a href="<c:url value='/admin/staff/${staff.id}/edit'/>" class="btn btn-primary">Edit</a>
        <a href="<c:url value='/admin/staff'/>" class="btn btn-secondary">← Back to Staff</a>
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
        <div class="card-header">Account Information</div>
        <div class="card-body">
            <dl class="detail-list">
                <dt>Email</dt><dd>${fn:escapeXml(staff.account.email)}</dd>
                <dt>Phone</dt><dd>${fn:escapeXml(staff.account.phone)}</dd>
                <dt>Account Status</dt>
                <dd><span class="badge badge-status badge-status--${fn:toLowerCase(staff.account.status.toString())}">${staff.account.status}</span></dd>
                <dt>Last Login</dt>
                <dd>${staff.account.lastLoginAt != null ? staff.account.lastLoginAt : '—'}</dd>
            </dl>
        </div>
    </div>

    <div class="card">
        <div class="card-header">Staff Profile</div>
        <div class="card-body">
            <dl class="detail-list">
                <dt>Name</dt><dd>${fn:escapeXml(staff.name)}</dd>
                <dt>Staff Status</dt>
                <dd><span class="badge badge-status badge-status--${fn:toLowerCase(staff.status.toString())}">${staff.status}</span></dd>
                <dt>Hospital</dt><dd>${fn:escapeXml(staff.hospital.name)}</dd>
                <dt>Assigned Since</dt><dd>${staff.createdAt.toLocalDate()}</dd>
            </dl>
        </div>
    </div>
</div>

<div class="card mt-4">
    <div class="card-header">Status Management</div>
    <div class="card-body">
        <p class="text-muted mb-3">Current status: <strong>${staff.status}</strong></p>
        <div class="action-buttons">
            <c:if test="${staff.status != 'ACTIVE'}">
                <form method="post" action="<c:url value='/admin/staff/${staff.id}/status'/>"
                      onsubmit="return confirm('Activate this staff account?')">
                    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                    <input type="hidden" name="status" value="ACTIVE"/>
                    <button type="submit" class="btn btn-success">Activate</button>
                </form>
            </c:if>
            <c:if test="${staff.status != 'SUSPENDED'}">
                <form method="post" action="<c:url value='/admin/staff/${staff.id}/status'/>"
                      onsubmit="return confirm('Suspend this staff account?')">
                    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                    <input type="hidden" name="status" value="SUSPENDED"/>
                    <button type="submit" class="btn btn-warning">Suspend</button>
                </form>
            </c:if>
            <c:if test="${staff.status != 'INACTIVE'}">
                <form method="post" action="<c:url value='/admin/staff/${staff.id}/status'/>"
                      onsubmit="return confirm('Deactivate this staff account?')">
                    <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                    <input type="hidden" name="status" value="INACTIVE"/>
                    <button type="submit" class="btn btn-danger">Deactivate</button>
                </form>
            </c:if>
        </div>
    </div>
</div>

<%@ include file="../../layout/footer.jsp" %>
