<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
            <c:set var="pageTitle" value="Admin Profile" scope="request" />
            <%@ include file="../../layout/header.jsp" %>

                <div class="page-header">
                    <h1 class="page-title">My Profile</h1>
                    <p class="page-subtitle">View and update account</p>
                </div>

                <c:if test="${not empty successMessage}">
                    <div class="alert alert-success">${fn:escapeXml(successMessage)}</div>
                </c:if>
                <c:if test="${not empty errorMessage}">
                    <div class="alert alert-error">${fn:escapeXml(errorMessage)}</div>
                </c:if>
                <c:if test="${not empty passwordError}">
                    <div class="alert alert-error">${fn:escapeXml(passwordError)}</div>
                </c:if>

                <div class="detail-grid">
                    <div class="card">
                        <div class="card-header">Profile Information</div>
                        <div class="card-body">
                            <form method="post" action="<c:url value='/admin/profile/update-name'/>">
                                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />

                                <div class="form-group">
                                    <label for="name" class="form-label">Display Name</label>
                                    <input type="text" id="name" name="name" value="${fn:escapeXml(admin.name)}"
                                        class="form-control" required />
                                </div>

                                <dl class="detail-list mt-3">
                                    <dt>Email</dt>
                                    <dd>${fn:escapeXml(admin.account.email)}</dd>
                                    <dt>Phone</dt>
                                    <dd>${fn:escapeXml(admin.account.phone)}</dd>

                                    <dt>Account Created</dt>
                                    <dd>${admin.account.createdAt != null ? admin.account.createdAt.format(adminDateTimeFormatter) : '—'}</dd>
                                    <dt>Last Login</dt>
                                    <dd>${admin.account.lastLoginAt != null ? admin.account.lastLoginAt.format(adminDateTimeFormatter) : '—'}</dd>
                                </dl>

                                <div class="form-actions mt-3">
                                    <button type="submit" class="btn btn-primary">Update Name</button>
                                </div>
                            </form>
                        </div>
                    </div>

                    <div class="card">
                        <div class="card-header">Change Password</div>
                        <div class="card-body">
                            <form method="post" action="<c:url value='/admin/profile/change-password'/>" novalidate>
                                <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />

                                <div class="form-group">
                                    <label for="currentPassword" class="form-label">Current Password <span
                                            class="required">*</span></label>
                                    <input type="password" id="currentPassword" name="currentPassword"
                                        class="form-control" required autocomplete="current-password" />
                                </div>

                                <div class="form-group">
                                    <label for="newPassword" class="form-label">New Password <span
                                            class="required">*</span></label>
                                    <input type="password" id="newPassword" name="newPassword" class="form-control"
                                        required minlength="8" autocomplete="new-password" />
                                    <p class="text-muted text-sm mt-1">Minimum 8 characters.</p>
                                </div>

                                <div class="form-group">
                                    <label for="confirmPassword" class="form-label">Confirm New Password <span
                                            class="required">*</span></label>
                                    <input type="password" id="confirmPassword" name="confirmPassword"
                                        class="form-control" required autocomplete="new-password" />
                                </div>

                                <div class="form-actions">
                                    <button type="submit" class="btn btn-warning">Change Password</button>
                                </div>
                            </form>
                        </div>
                    </div>
                </div>

                <%@ include file="../../layout/footer.jsp" %>
