<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
            <c:set var="pageTitle" value="Staff — Create" scope="request" />
            <%@ include file="../../layout/header.jsp" %>

                <div class="page-header">
                    <div>
                        <h1 class="page-title">Create Staff Account</h1>
                        <p class="page-subtitle">Assign a staff account to a hospital</p>
                    </div>
                    <a href="<c:url value='/admin/staff'/>" class="btn btn-secondary">← Back</a>
                </div>

                <c:if test="${not empty errorMessage}">
                    <div class="alert alert-error">${fn:escapeXml(errorMessage)}</div>
                </c:if>

                <div class="card" style="max-width:580px">
                    <div class="card-header">Staff Account Details</div>
                    <div class="card-body">
                        <div class="alert alert-info mb-4">
                            Each hospital can only have <strong>one staff account</strong>. Hospitals already assigned
                            to staff will not appear below.
                        </div>
                        <form method="post" action="<c:url value='/admin/staff/create'/>" novalidate>
                            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />

                            <div class="form-group">
                                <label for="name" class="form-label">Full Name <span class="required">*</span></label>
                                <input type="text" id="name" name="name" value="${fn:escapeXml(staffCreateDTO.name)}"
                                    class="form-control" required />
                            </div>

                            <div class="form-group">
                                <label for="email" class="form-label">Email Address <span
                                        class="required">*</span></label>
                                <input type="email" id="email" name="email"
                                    value="${fn:escapeXml(staffCreateDTO.email)}" class="form-control" required />
                            </div>

                            <div class="form-group">
                                <label for="phone" class="form-label">Phone Number <span
                                        class="required">*</span></label>
                                <input type="tel" id="phone" name="phone" value="${fn:escapeXml(staffCreateDTO.phone)}"
                                    class="form-control" required />
                            </div>

                            <div class="form-group">
                                <label for="hospitalId" class="form-label">Assign to Hospital <span
                                        class="required">*</span></label>
                                <select id="hospitalId" name="hospitalId" class="form-control" required>
                                    <option value="">— Select Hospital —</option>
                                    <c:forEach items="${hospitals}" var="h">
                                        <option value="${h.id}" ${staffCreateDTO.hospitalId==h.id ? 'selected' : '' }>
                                            ${fn:escapeXml(h.name)}
                                        </option>
                                    </c:forEach>
                                </select>
                                <c:if test="${empty hospitals}">
                                    <p class="text-muted text-sm mt-1">All active hospitals already have staff assigned.
                                    </p>
                                </c:if>
                            </div>

                            <div class="form-actions">
                                <button type="submit" class="btn btn-primary" ${empty hospitals ? 'disabled' : ''
                                    }>Create Staff Account</button>
                                <a href="<c:url value='/admin/staff'/>" class="btn btn-secondary">Cancel</a>
                            </div>
                        </form>
                    </div>
                </div>

                <%@ include file="../../layout/footer.jsp" %>