<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
            <c:set var="pageTitle" value="Donors — Detail" scope="request" />
            <%@ include file="../../layout/header.jsp" %>

                <div class="page-header">
                    <div>
                        <h1 class="page-title">${fn:escapeXml(donor.name)}</h1>
                        <p class="page-subtitle">Donor Profile</p>
                    </div>
                    <a href="<c:url value='/admin/donors/${donor.id}/edit'/>" class="btn btn-primary">Edit / Update
                        Donor</a>
                    <a href="<c:url value='/admin/donors'/>" class="btn btn-secondary">← Back to Donors</a>
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
                                <dt>Email</dt>
                                <dd>${fn:escapeXml(donor.account.email)}</dd>
                                <dt>Phone</dt>
                                <dd>${fn:escapeXml(donor.account.phone)}</dd>
                                <dt>Account Status</dt>
                                <dd><span
                                        class="badge badge-status badge-status--${fn:toLowerCase(donor.account.status.toString())}">${donor.account.status}</span>
                                </dd>
                                <dt>Role</dt>
                                <dd>${donor.account.role}</dd>
                                <dt>Last Login</dt>
                                <dd>${donor.account.lastLoginAt != null ? donor.account.lastLoginAt : '—'}</dd>
                                <dt>Registered</dt>
                                <dd>${donor.account.createdAt != null ? donor.account.createdAt.toLocalDate() : '—'}
                                </dd>
                            </dl>
                        </div>
                    </div>

                    <div class="card">
                        <div class="card-header">Donor Profile</div>
                        <div class="card-body">
                            <dl class="detail-list">
                                <dt>Full Name</dt>
                                <dd>${fn:escapeXml(donor.name)}</dd>
                                <dt>Date of Birth</dt>
                                <dd>${donor.dateOfBirth != null ? donor.dateOfBirth : '—'}</dd>
                                <dt>Gender</dt>
                                <dd>${donor.gender != null ? donor.gender : '—'}</dd>
                                <dt>Blood Type</dt>
                                <dd>
                                    <c:choose>
                                        <c:when test="${donor.bloodType != null}">
                                            <span class="badge badge-blood">${donor.bloodType.displayName}</span>
                                            <c:if test="${donor.bloodTypeVerified}">
                                                <span class="badge badge-success ml-1">Verified</span>
                                            </c:if>
                                        </c:when>
                                        <c:otherwise><span class="text-muted">Not set</span></c:otherwise>
                                    </c:choose>
                                </dd>
                                <dt>Address</dt>
                                <dd>
                                    <c:choose>
                                        <c:when test="${donor.address != null}">
                                            ${fn:escapeXml(donor.address.detailAddress)},
                                            ${fn:escapeXml(donor.address.township)},
                                            ${fn:escapeXml(donor.address.division)}
                                        </c:when>
                                        <c:otherwise><span class="text-muted">—</span></c:otherwise>
                                    </c:choose>
                                </dd>
                            </dl>
                        </div>
                    </div>
                </div>



                <div class="card mt-4">
                    <div class="card-header">NFC Card Management</div>
                    <div class="card-body">

                        <c:choose>
                            <c:when test="${empty nfcCards}">
                                <div class="empty-state">
                                    <p>No NFC cards are linked to this donor.</p>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <table class="data-table">
                                    <thead>
                                        <tr>
                                            <th>Card Identifier</th>
                                            <th>Issued By</th>
                                            <th>Issue Date</th>
                                            <th>Expiry Date</th>
                                            <th>Card Status</th>
                                            <th>Update Status</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <c:forEach items="${nfcCards}" var="card">
                                            <tr>
                                                <td><strong>${fn:escapeXml(card.cardUid)}</strong></td>
                                                <td>
                                                    <c:choose>
                                                        <c:when test="${card.issuedByHospital != null}">
                                                            ${fn:escapeXml(card.issuedByHospital.name)}
                                                        </c:when>
                                                        <c:otherwise>—</c:otherwise>
                                                    </c:choose>
                                                </td>
                                                <td class="text-muted text-sm">
                                                    ${card.issuedAt != null ? card.issuedAt.toLocalDate() : '—'}
                                                </td>
                                                <td class="text-muted text-sm">
                                                    ${card.validUntil != null ? card.validUntil : '—'}
                                                </td>
                                                <td>
                                                    <span
                                                        class="badge badge-status badge-status--${fn:toLowerCase(card.status.toString())}">${card.status}</span>
                                                </td>
                                                <td>
                                                    <form method="post"
                                                        action="<c:url value='/admin/donors/${donor.id}/nfc-cards/${card.id}/status'/>"
                                                        class="nfc-status-form">
                                                        <input type="hidden" name="${_csrf.parameterName}"
                                                            value="${_csrf.token}" />
                                                        <select name="status" class="form-control form-control-sm">
                                                            <c:forEach items="${nfcStatuses}" var="st">
                                                                <option value="${st}" ${card.status==st ? 'selected'
                                                                    : '' }>${st}</option>
                                                            </c:forEach>
                                                        </select>
                                                        <button type="submit"
                                                            class="btn btn-sm btn-primary">Update</button>
                                                    </form>
                                                </td>
                                            </tr>
                                        </c:forEach>
                                    </tbody>
                                </table>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>

                <%@ include file="../../layout/footer.jsp" %>