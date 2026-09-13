<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
            <%@ taglib prefix="asset" tagdir="/WEB-INF/tags" %>
                <c:set var="pageTitle" value="Hospital — Edit" scope="request" />
                <%@ include file="../../layout/header.jsp" %>

                    <div class="page-header">
                        <div>
                            <h1 class="page-title">Edit: ${fn:escapeXml(hospital.name)}</h1>
                            <p class="page-subtitle">Update hospital information</p>
                        </div>
                        <a href="<c:url value='/admin/hospitals/${hospital.id}'/>" class="btn btn-secondary">← Back</a>
                    </div>

                    <c:if test="${not empty errorMessage}">
                        <div class="alert alert-error">${fn:escapeXml(errorMessage)}</div>
                    </c:if>

                    <div class="card" style="max-width:640px">
                        <div class="card-header">Hospital Profile</div>
                        <div class="card-body">
                            <form method="post" action="<c:url value='/admin/hospitals/${hospital.id}/edit'/>"
                                enctype="multipart/form-data" novalidate>
                                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />

                                <div class="form-group">
                                    <label for="name" class="form-label">Hospital Name <span
                                            class="required">*</span></label>
                                    <input type="text" id="name" name="name"
                                        value="${fn:escapeXml(hospitalUpdateDTO.name)}" class="form-control" required />
                                </div>
                                <div class="form-section-heading">Contact Details</div>
                                <div class="form-row">
                                    <div class="form-group">
                                        <label for="phone" class="form-label">Phone <span
                                                class="required">*</span></label>
                                        <input type="tel" id="phone" name="phone"
                                            value="${fn:escapeXml(hospitalUpdateDTO.phone)}" class="form-control"
                                            required />
                                    </div>
                                    <div class="form-group">
                                        <label for="email" class="form-label">Email</label>
                                        <input type="email" id="email" name="email"
                                            value="${fn:escapeXml(hospitalUpdateDTO.email)}" class="form-control" />
                                    </div>
                                </div>

                                <hr class="form-divider" />
                                <h3 class="form-section-heading">Location</h3>
                                <div class="form-group">
                                    <label for="detailAddress" class="form-label">Street Address <span
                                            class="required">*</span></label>
                                    <input type="text" id="detailAddress" name="detailAddress"
                                        value="${fn:escapeXml(hospitalUpdateDTO.detailAddress)}" class="form-control"
                                        required />
                                </div>
                                <div class="form-row">
                                    <div class="form-group">
                                        <label for="township" class="form-label">Township</label>
                                        <input type="text" id="township" name="township"
                                            value="${fn:escapeXml(hospitalUpdateDTO.township)}" class="form-control" />
                                    </div>
                                    <div class="form-group">
                                        <label for="division" class="form-label">State / Division</label>
                                        <input type="text" id="division" name="division"
                                            value="${fn:escapeXml(hospitalUpdateDTO.division)}" class="form-control" />
                                    </div>
                                </div>
                                <%-- Country is always Myanmar; not user-editable --%>
                                    <input type="hidden" name="country" value="Myanmar" />

                                    <hr class="form-divider" />
                                    <h3 class="form-section-heading">Status</h3>
                                    <div class="form-group">
                                        <label for="status" class="form-label">Hospital Status <span
                                                class="required">*</span></label>
                                        <select id="status" name="status" class="form-control" required>
                                            <option value="ACTIVE" ${hospital.status=='ACTIVE' ? 'selected' : '' }>
                                                Active</option>
                                            <option value="INACTIVE" ${hospital.status=='INACTIVE' ? 'selected' : '' }>
                                                Inactive</option>
                                            <option value="SUSPENDED" ${hospital.status=='SUSPENDED' ? 'selected' : ''
                                                }>Suspended</option>
                                        </select>
                                    </div>
                                    <div class="form-group image-upload-field">
                                        <label for="profilePicture" class="form-label">Update Profile Picture</label>
                                        <c:if test="${not empty hospital.profilePicture}">
                                            <div class="mb-2">
                                                <img src="<asset:asset-url value=" ${hospital.profilePicture}" />"
                                                alt="Current photo" class="preview-image"/>
                                                <p class="text-muted text-sm">Current picture</p>
                                            </div>
                                        </c:if>
                                        <input type="file" id="profilePicture" name="profilePicture"
                                            class="form-control-file" accept="image/*"
                                            data-image-preview-target="profilePicturePreview" />
                                        <img id="profilePicturePreview" class="preview-image image-preview" hidden />
                                        <button type="button" class="image-upload-clear"
                                            data-image-preview-clear="profilePicture"
                                            aria-label="Clear hospital profile picture" title="Clear picture">×</button>
                                    </div>

                                    <div class="form-actions">
                                        <button type="submit" class="btn btn-primary">Save Changes</button>
                                        <a href="<c:url value='/admin/hospitals/${hospital.id}'/>"
                                            class="btn btn-secondary">Cancel</a>
                                    </div>
                            </form>
                        </div>
                    </div>

                    <%@ include file="../../layout/footer.jsp" %>