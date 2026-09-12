<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
            <c:set var="pageTitle" value="Audit Logs" scope="request" />
            <%@ include file="../../layout/header.jsp" %>

                <div class="page-header">
                    <h1 class="page-title">Audit Logs</h1>
                    <p class="page-subtitle">Immutable record of administrative actions</p>
                </div>

                <div class="card mb-4">
                    <div class="card-body">
                        <form id="audit-filter-form" method="get" action="<c:url value='/admin/audit-logs'/>"
                            class="filter-form">
                            <%-- Row 1: Entity Type + Action --%>
                                <div class="form-row form-row--2">
                                    <div class="form-group">
                                        <label class="form-label" for="filter-entityType">Entity Type</label>
                                        <select id="filter-entityType" name="entityType" class="form-control">
                                            <option value="">All</option>
                                            <option value="DONOR" ${entityType=='DONOR' ? 'selected' : '' }>Donor
                                            </option>
                                            <option value="STAFF" ${entityType=='STAFF' ? 'selected' : '' }>Staff
                                            </option>
                                            <option value="HOSPITAL" ${entityType=='HOSPITAL' ? 'selected' : '' }>
                                                Hospital</option>
                                            <option value="ARTICLE" ${entityType=='ARTICLE' ? 'selected' : '' }>Article
                                            </option>
                                            <option value="BLOOD_REQUEST" ${entityType=='BLOOD_REQUEST' ? 'selected'
                                                : '' }>Blood Request</option>
                                            <option value="ACCOUNT" ${entityType=='ACCOUNT' ? 'selected' : '' }>Account
                                            </option>
                                            <option value="ADMIN" ${entityType=='ADMIN' ? 'selected' : '' }>Admin
                                            </option>
                                        </select>
                                    </div>
                                    <div class="form-group">
                                        <label class="form-label" for="filter-action">Action / Event</label>
                                        <select id="filter-action" name="action" class="form-control">
                                            <option value="">All</option>
                                            <option value="CREATE" ${action=='CREATE' ? 'selected' : '' }>Create
                                            </option>
                                            <option value="UPDATE" ${action=='UPDATE' ? 'selected' : '' }>Update
                                            </option>
                                            <option value="DELETE" ${action=='DELETE' ? 'selected' : '' }>Delete
                                            </option>
                                            <option value="LOGIN" ${action=='LOGIN' ? 'selected' : '' }>Login</option>
                                            <option value="STATUS_CHANGE" ${action=='STATUS_CHANGE' ? 'selected' : '' }>
                                                Status Change</option>
                                            <option value="PUBLISH" ${action=='PUBLISH' ? 'selected' : '' }>Publish
                                            </option>
                                            <option value="ARCHIVE" ${action=='ARCHIVE' ? 'selected' : '' }>Archive
                                            </option>
                                            <option value="PASSWORD_CHANGE" ${action=='PASSWORD_CHANGE' ? 'selected'
                                                : '' }>Password Change</option>
                                        </select>
                                    </div>
                                </div>
                                <%-- Row 2: Date Range --%>
                                    <div class="form-row form-row--2">
                                        <div class="form-group">
                                            <label class="form-label" for="filter-startDate">From</label>
                                            <input id="filter-startDate" type="datetime-local" name="startDate"
                                                class="form-control" value="${fn:escapeXml(startDate)}" />
                                        </div>
                                        <div class="form-group">
                                            <label class="form-label" for="filter-endDate">To</label>
                                            <input id="filter-endDate" type="datetime-local" name="endDate"
                                                class="form-control" value="${fn:escapeXml(endDate)}" />
                                        </div>
                                    </div>
                                    <%-- Row 3: Performer --%>
                                        <div class="form-row form-row--1">
                                            <div class="form-group">
                                                <label class="form-label" for="filter-performer">User / Admin
                                                    Email</label>
                                                <input id="filter-performer" type="text" name="performer"
                                                    class="form-control" placeholder="e.g. admin@amyanhlu.org"
                                                    value="${fn:escapeXml(performer)}" />
                                            </div>
                                        </div>
                                        <div class="form-actions">
                                            <button type="submit" class="btn btn-primary">Filter</button>
                                            <a href="<c:url value='/admin/audit-logs'/>" class="btn btn-secondary">Reset
                                                Filters</a>
                                        </div>
                        </form>
                    </div>
                </div>

                <div class="card">
                    <div class="card-body p-0">
                        <c:choose>
                            <c:when test="${logPage.totalElements == 0}">
                                <div class="empty-state">
                                    <p>No audit log entries found.</p>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <table class="data-table data-table--compact">
                                    <thead>
                                        <tr>
                                            <th>#</th>
                                            <th>Timestamp</th>
                                            <th>Account</th>
                                            <th>Action</th>
                                            <th>Entity Type</th>
                                            <th>Entity ID</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach items="${logPage.content}" var="log">
                                            <tr>
                                                <td>${log.id}</td>
                                                <td class="text-sm text-muted text-nowrap">${log.createdAtYangon}</td>
                                                <td class="text-sm">${log.account != null ?
                                                    fn:escapeXml(log.account.email) : '—'}</td>
                                                <td><span class="badge badge-action">${fn:escapeXml(log.action)}</span>
                                                </td>
                                                <td class="text-sm">${fn:escapeXml(log.entityType)}</td>
                                                <td>${log.entityId}</td>
                                            </tr>
                                        </c:forEach>
                                    </tbody>
                                </table>
                                <%-- Pagination — carry all active filter params so filters survive page navigation --%>
                                    <div class="pagination-bar">
                                        <c:if test="${logPage.hasPrevious()}">
                                            <a href="?page=${logPage.number - 1}&entityType=<c:out value='${entityType}'/>&action=<c:out value='${action}'/>&startDate=<c:out value='${startDate}'/>&endDate=<c:out value='${endDate}'/>&performer=<c:out value='${performer}'/>"
                                                class="btn btn-sm btn-outline">← Prev</a>
                                        </c:if>
                                        <span class="pagination-info">Page ${logPage.number + 1} of
                                            ${logPage.totalPages}</span>
                                        <c:if test="${logPage.hasNext()}">
                                            <a href="?page=${logPage.number + 1}&entityType=<c:out value='${entityType}'/>&action=<c:out value='${action}'/>&startDate=<c:out value='${startDate}'/>&endDate=<c:out value='${endDate}'/>&performer=<c:out value='${performer}'/>"
                                                class="btn btn-sm btn-outline">Next →</a>
                                        </c:if>
                                    </div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>

                <%@ include file="../../layout/footer.jsp" %>
