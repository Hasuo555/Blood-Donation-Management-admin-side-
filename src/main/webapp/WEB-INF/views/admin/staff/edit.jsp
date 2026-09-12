<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<c:set var="pageTitle" value="Staff — Edit" scope="request"/>
<%@ include file="../../layout/header.jsp" %>

<div class="page-header">
    <div>
        <h1 class="page-title">Edit: ${fn:escapeXml(staff.name)}</h1>
        <p class="page-subtitle">Update staff account and hospital assignment</p>
    </div>
    <a href="<c:url value='/admin/staff/${staff.id}'/>" class="btn btn-secondary">← Back</a>
</div>

<c:if test="${not empty errorMessage}">
    <div class="alert alert-error">${fn:escapeXml(errorMessage)}</div>
</c:if>

<div class="card" style="max-width:640px">
    <div class="card-header">Staff Information</div>
    <div class="card-body">
        <form method="post" action="<c:url value='/admin/staff/${staff.id}/edit'/>" novalidate>
            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
            <div class="form-group">
                <label for="name" class="form-label">Full Name <span class="required">*</span></label>
                <input type="text" id="name" name="name" value="${fn:escapeXml(staffUpdateDTO.name)}"
                       class="form-control" maxlength="100" required/>
            </div>
            <div class="form-row">
                <div class="form-group">
                    <label for="email" class="form-label">Email <span class="required">*</span></label>
                    <input type="email" id="email" name="email" value="${fn:escapeXml(staffUpdateDTO.email)}"
                           class="form-control" maxlength="255" required/>
                </div>
                <div class="form-group">
                    <label for="phone" class="form-label">Phone <span class="required">*</span></label>
                    <input type="tel" id="phone" name="phone" value="${fn:escapeXml(staffUpdateDTO.phone)}"
                           class="form-control" maxlength="20" required/>
                </div>
            </div>
            <div class="form-group">
                <label for="hospitalId" class="form-label">Assigned Hospital <span class="required">*</span></label>
                <select id="hospitalId" name="hospitalId" class="form-control" required>
                    <c:forEach items="${hospitals}" var="h">
                        <option value="${h.id}" ${staffUpdateDTO.hospitalId == h.id ? 'selected' : ''}>
                            ${fn:escapeXml(h.name)}
                        </option>
                    </c:forEach>
                </select>
            </div>
            <div class="form-group">
                <label for="status" class="form-label">Staff Status <span class="required">*</span></label>
                <select id="status" name="status" class="form-control" required>
                    <c:forEach items="${staffStatuses}" var="status">
                        <option value="${status}" ${staffUpdateDTO.status == status.toString() ? 'selected' : ''}>${status}</option>
                    </c:forEach>
                </select>
            </div>
            <div class="form-actions">
                <a href="<c:url value='/admin/staff/${staff.id}'/>" class="btn btn-secondary">Cancel</a>
                <button type="submit" class="btn btn-primary">Save Changes</button>
            </div>
        </form>
    </div>
</div>

<%@ include file="../../layout/footer.jsp" %>
