<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<c:set var="pageTitle" value="Donors — Edit" scope="request"/>
<%@ include file="../../layout/header.jsp" %>

<div class="page-header">
    <div>
        <h1 class="page-title">Edit: ${fn:escapeXml(donor.name)}</h1>
        <p class="page-subtitle">Update donor profile and account fields</p>
    </div>
    <a href="<c:url value='/admin/donors/${donor.id}'/>" class="btn btn-secondary">← Back</a>
</div>

<c:if test="${not empty errorMessage}">
    <div class="alert alert-error">${fn:escapeXml(errorMessage)}</div>
</c:if>

<div class="card" style="max-width:640px">
    <div class="card-header">Donor Information</div>
    <div class="card-body">
        <form method="post" action="<c:url value='/admin/donors/${donor.id}/edit'/>" novalidate>
            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>

            <div class="form-group">
                <label for="name" class="form-label">Full Name <span class="required">*</span></label>
                <input type="text" id="name" name="name"
                       value="${fn:escapeXml(donorUpdateDTO.name)}"
                       class="form-control" maxlength="255" required/>
            </div>
            <div class="form-row">
                <div class="form-group">
                    <label for="phone" class="form-label">Phone <span class="required">*</span></label>
                    <input type="tel" id="phone" name="phone"
                           value="${fn:escapeXml(donorUpdateDTO.phone)}"
                           class="form-control" maxlength="20" required/>
                </div>
                <div class="form-group">
                    <label for="email" class="form-label">Email</label>
                    <input type="email" id="email" name="email"
                           value="${fn:escapeXml(donorUpdateDTO.email)}"
                           class="form-control" maxlength="255"/>
                </div>
            </div>
            <div class="form-row">
                <div class="form-group">
                    <label for="dateOfBirth" class="form-label">Date of Birth <span class="required">*</span></label>
                    <input type="date" id="dateOfBirth" name="dateOfBirth"
                           value="${donorUpdateDTO.dateOfBirth}" class="form-control" required/>
                </div>
                <div class="form-group">
                    <label for="gender" class="form-label">Gender <span class="required">*</span></label>
                    <select id="gender" name="gender" class="form-control" required>
                        <option value="MALE" ${donorUpdateDTO.gender == 'MALE' ? 'selected' : ''}>Male</option>
                        <option value="FEMALE" ${donorUpdateDTO.gender == 'FEMALE' ? 'selected' : ''}>Female</option>
                        <option value="OTHER" ${donorUpdateDTO.gender == 'OTHER' ? 'selected' : ''}>Other</option>
                    </select>
                </div>
            </div>
            <div class="form-group">
                <label for="accountStatus" class="form-label">Account Status <span class="required">*</span></label>
                <select id="accountStatus" name="accountStatus" class="form-control" required>
                    <c:forEach items="${accountStatuses}" var="st">
                        <option value="${st}" ${donorUpdateDTO.accountStatus == st.toString() ? 'selected' : ''}>${st}</option>
                    </c:forEach>
                </select>
            </div>

            <hr class="form-divider"/>
            <h3 class="form-section-title">Address</h3>
            <div class="form-group">
                <label for="detailAddress" class="form-label">Street Address <span class="required">*</span></label>
                <input type="text" id="detailAddress" name="detailAddress"
                       value="${fn:escapeXml(donorUpdateDTO.detailAddress)}"
                       class="form-control" required/>
            </div>
            <div class="form-row">
                <div class="form-group">
                    <label for="township" class="form-label">Township <span class="required">*</span></label>
                    <input type="text" id="township" name="township"
                           value="${fn:escapeXml(donorUpdateDTO.township)}" class="form-control" required/>
                </div>
                <div class="form-group">
                    <label for="division" class="form-label">Division / Region <span class="required">*</span></label>
                    <input type="text" id="division" name="division"
                           value="${fn:escapeXml(donorUpdateDTO.division)}" class="form-control" required/>
                </div>
            </div>
            <div class="form-group">
                <label for="country" class="form-label">Country</label>
                <input type="text" id="country" name="country"
                       value="${fn:escapeXml(donorUpdateDTO.country)}"
                       class="form-control" placeholder="Myanmar"/>
            </div>

            <div class="form-actions">
                <a href="<c:url value='/admin/donors/${donor.id}'/>" class="btn btn-secondary">Cancel</a>
                <button type="submit" class="btn btn-primary">Save Changes</button>
            </div>
        </form>
    </div>
</div>

<%@ include file="../../layout/footer.jsp" %>
