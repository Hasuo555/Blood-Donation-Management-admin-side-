<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
            <c:set var="pageTitle" value="Notifications — Create" scope="request" />
            <%@ include file="../../layout/header.jsp" %>

                <div class="page-header">
                    <div>
                        <h1 class="page-title">Create System Notification</h1>
                        <p class="page-subtitle">Broadcast to all platform users</p>
                    </div>
                    <a href="<c:url value='/admin/notifications'/>" class="btn btn-secondary">← Back</a>
                </div>

                <c:if test="${not empty errorMessage}">
                    <div class="alert alert-error">${fn:escapeXml(errorMessage)}</div>
                </c:if>

                <div class="card" style="max-width:580px">
                    <div class="card-header">Notification Details</div>
                    <div class="card-body">
                        <form method="post" action="<c:url value='/admin/notifications/create'/>" novalidate>
                            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />

                            <div class="form-group">
                                <label for="title" class="form-label">Title <span class="required">*</span></label>
                                <input type="text" id="title" name="title"
                                    value="${fn:escapeXml(notificationCreateDTO.title)}" class="form-control"
                                    required />
                            </div>

                            <%-- Type is always SYSTEM for admin broadcasts; not user-selectable --%>
                                <input type="hidden" name="type" value="SYSTEM" />


                                <div class="form-group">
                                    <label for="message" class="form-label">Message <span
                                            class="required">*</span></label>
                                    <textarea id="message" name="message" class="form-control" rows="5"
                                        placeholder="Enter notification message…"
                                        required>${fn:escapeXml(notificationCreateDTO.message)}</textarea>
                                </div>

                                <div class="form-actions">
                                    <button type="submit" class="btn btn-primary"
                                        onclick="return confirm('Send this notification to all users?')">Send
                                        Notification</button>
                                    <a href="<c:url value='/admin/notifications'/>" class="btn btn-secondary">Cancel</a>
                                </div>
                        </form>
                    </div>
                </div>

                <%@ include file="../../layout/footer.jsp" %>