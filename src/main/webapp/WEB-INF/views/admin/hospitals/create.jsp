<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
            <c:set var="pageTitle" value="Hospitals — Create" scope="request" />
            <%@ include file="../../layout/header.jsp" %>

                <div class="page-header">
                    <div>
                        <h1 class="page-title">Create Hospital</h1>
                        <p class="page-subtitle">Register a new hospital on the platform</p>
                    </div>
                    <a href="<c:url value='/admin/hospitals'/>" class="btn btn-secondary">← Back</a>
                </div>

                <c:if test="${not empty errorMessage}">
                    <div class="alert alert-error">${fn:escapeXml(errorMessage)}</div>
                </c:if>

                <div class="card" style="max-width:640px">
                    <div class="card-header">Hospital Information</div>
                    <div class="card-body">
                        <form method="post" action="<c:url value='/admin/hospitals/create'/>"
                            enctype="multipart/form-data" novalidate>
                            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />

                            <div class="form-group">
                                <label for="name" class="form-label">Hospital Name <span
                                        class="required">*</span></label>
                                <input type="text" id="name" name="name" value="${fn:escapeXml(hospitalCreateDTO.name)}"
                                    class="form-control" required />
                            </div>
                            <div class="form-row">
                                <div class="form-group">
                                    <label for="phone" class="form-label">Phone <span class="required">*</span></label>
                                    <input type="tel" id="phone" name="phone"
                                        value="${fn:escapeXml(hospitalCreateDTO.phone)}" class="form-control"
                                        required />
                                </div>
                                <div class="form-group">
                                    <label for="email" class="form-label">Email</label>
                                    <input type="email" id="email" name="email"
                                        value="${fn:escapeXml(hospitalCreateDTO.email)}" class="form-control" />
                                </div>
                            </div>

                            <hr class="form-divider" />
                            <h3 class="form-section-title">Address</h3>

                            <div class="form-group">
                                <label for="detailAddress" class="form-label">Street Address <span
                                        class="required">*</span></label>
                                <input type="text" id="detailAddress" name="detailAddress"
                                    value="${fn:escapeXml(hospitalCreateDTO.detailAddress)}" class="form-control"
                                    required />
                            </div>
                            <div class="form-row">
                                <div class="form-group">
                                    <label for="township" class="form-label">Township</label>
                                    <input type="text" id="township" name="township"
                                        value="${fn:escapeXml(hospitalCreateDTO.township)}" class="form-control" />
                                </div>
                                <div class="form-group">
                                    <label for="division" class="form-label">State / Division</label>
                                    <input type="text" id="division" name="division"
                                        value="${fn:escapeXml(hospitalCreateDTO.division)}" class="form-control" />
                                </div>
                            </div>
                            <%-- Country is always Myanmar; not user-editable --%>
                                <input type="hidden" name="country" value="Myanmar" />

                                <hr class="form-divider" />
                                <div class="form-group">
                                    <label for="profilePicture" class="form-label">Profile Picture</label>
                                    <input type="file" id="profilePicture" name="profilePicture"
                                        class="form-control-file" accept="image/*"
                                        data-image-preview-target="profilePicturePreview" />
                                    <img id="profilePicturePreview" class="preview-image image-preview"
                                        alt="Selected hospital profile preview" hidden />
                                    <p class="text-muted text-sm mt-1">Upload Size: Max 10MB.</p>
                                </div>

                                <div class="form-actions">
                                    <button type="submit" class="btn btn-primary">Create Hospital</button>
                                    <a href="<c:url value='/admin/hospitals'/>" class="btn btn-secondary">Cancel</a>
                                </div>
                        </form>
                    </div>
                </div>

                <%@ include file="../../layout/footer.jsp" %>
