<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<c:set var="pageTitle" value="Notifications" scope="request"/>
<%@ include file="../../layout/header.jsp" %>

<div class="page-header">
    <div>
        <h1 class="page-title">System Notifications</h1>
        <p class="page-subtitle">Broadcasts and automated account update notifications</p>
    </div>
    <a href="<c:url value='/admin/notifications/create'/>" class="btn btn-primary">
        <svg width="16" height="16" viewBox="0 0 24 24" style="margin-right:6px"><path d="M19 13h-6v6h-2v-6H5v-2h6V5h2v6h6v2z"/></svg>
        Create Notification
    </a>
</div>

<c:if test="${not empty successMessage}">
    <div class="alert alert-success">${fn:escapeXml(successMessage)}</div>
</c:if>

<div class="card">
    <div class="card-body p-0">
        <c:choose>
            <c:when test="${notificationPage.totalElements == 0}">
                <div class="empty-state"><p>No notifications sent yet.</p></div>
            </c:when>
            <c:otherwise>
                <table class="data-table">
                    <thead>
                        <tr>
                            <th>#</th>
                            <th>Title</th>
                            <th>Type</th>
                            <th>Recipient</th>
                            <th>Message</th>
                            <th>Sent At</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach items="${notificationPage.content}" var="n">
                        <tr>
                            <td>${n.id}</td>
                            <td><strong>${fn:escapeXml(n.title)}</strong></td>
                            <td><span class="badge badge-gray">${fn:escapeXml(n.type)}</span></td>
                            <td class="text-sm">${fn:escapeXml(n.account.email)}</td>
                            <td class="text-sm">${fn:escapeXml(fn:substring(n.message, 0, 80))}${fn:length(n.message) > 80 ? '…' : ''}</td>
                            <td class="text-muted text-sm text-nowrap">${n.createdAt != null ? n.createdAt.format(adminDateTimeFormatter) : '—'}</td>
                        </tr>
                        </c:forEach>
                    </tbody>
                </table>
                <div class="pagination-bar">
                    <c:if test="${notificationPage.hasPrevious()}">
                        <a href="?page=${notificationPage.number - 1}" class="btn btn-sm btn-outline">← Prev</a>
                    </c:if>
                    <span class="pagination-info">Page ${notificationPage.number + 1} of ${notificationPage.totalPages}</span>
                    <c:if test="${notificationPage.hasNext()}">
                        <a href="?page=${notificationPage.number + 1}" class="btn btn-sm btn-outline">Next →</a>
                    </c:if>
                </div>
            </c:otherwise>
        </c:choose>
    </div>
</div>

<%@ include file="../../layout/footer.jsp" %>
