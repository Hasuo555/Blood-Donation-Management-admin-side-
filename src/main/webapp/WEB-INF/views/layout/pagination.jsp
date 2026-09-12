<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <%@ taglib prefix="fn" uri="jakarta.tags.functions" %>

            <%-- Resolve active Spring Data Page object --%>
                <c:set var="p"
                    value="${not empty currentPage ? currentPage : (not empty donorPage ? donorPage : (not empty staffPage ? staffPage : page))}" />

                <c:if test="${not empty p and p.totalPages > 1}">
                    <div class="pagination-container"
                        style="display: flex; justify-content: space-between; align-items: center; padding: 1rem 1.5rem; border-top: 1px solid #e5e7eb;">
                        <div class="pagination-info text-muted text-sm">
                            Showing page <strong>${p.number + 1}</strong> of <strong>${p.totalPages}</strong>
                            (${p.totalElements} total entries)
                        </div>

                        <ul class="pagination-links"
                            style="display: flex; gap: 0.5rem; list-style: none; margin: 0; padding: 0;">
                            <%-- Previous Button --%>
                                <c:choose>
                                    <c:when test="${p.hasPrevious()}">
                                        <li>
                                            <a href="?keyword=${fn:escapeXml(keyword)}&page=${p.number - 1}"
                                                class="btn btn-sm btn-outline">← Previous</a>
                                        </li>
                                    </c:when>
                                    <c:otherwise>
                                        <li>
                                            <span class="btn btn-sm btn-outline disabled"
                                                style="opacity: 0.5; cursor: not-allowed;">← Previous</span>
                                        </li>
                                    </c:otherwise>
                                </c:choose>

                                <%-- Page Number Indicator --%>
                                    <li
                                        style="display: flex; align-items: center; padding: 0 0.5rem; font-size: 0.875rem; color: #6b7280;">
                                        Page ${p.number + 1} / ${p.totalPages}
                                    </li>

                                    <%-- Next Button --%>
                                        <c:choose>
                                            <c:when test="${p.hasNext()}">
                                                <li>
                                                    <a href="?keyword=${fn:escapeXml(keyword)}&page=${p.number + 1}"
                                                        class="btn btn-sm btn-outline">Next →</a>
                                                </li>
                                            </c:when>
                                            <c:otherwise>
                                                <li>
                                                    <span class="btn btn-sm btn-outline disabled"
                                                        style="opacity: 0.5; cursor: not-allowed;">Next →</span>
                                                </li>
                                            </c:otherwise>
                                        </c:choose>
                        </ul>
                    </div>
                </c:if>