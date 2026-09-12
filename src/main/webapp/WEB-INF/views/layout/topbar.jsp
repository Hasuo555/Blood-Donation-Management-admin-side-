<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<header class="topbar">
    <button class="sidebar-toggle" id="sidebarToggle" aria-label="Toggle sidebar">
        <svg width="22" height="22" viewBox="0 0 24 24"><path d="M3 18h18v-2H3v2zm0-5h18v-2H3v2zm0-7v2h18V6H3z"/></svg>
    </button>
    <div class="topbar-title">${pageTitle != null ? pageTitle : 'Dashboard'}</div>
    <div class="topbar-right">
        <sec:authorize access="isAuthenticated()">
            <div class="topbar-admin">
                <svg width="18" height="18" viewBox="0 0 24 24" style="opacity:.6"><path d="M12 12c2.7 0 5-2.3 5-5s-2.3-5-5-5-5 2.3-5 5 2.3 5 5 5zm0 2c-3.3 0-10 1.7-10 5v2h20v-2c0-3.3-6.7-5-10-5z"/></svg>
                <sec:authentication property="principal.adminName" />
            </div>
        </sec:authorize>
    </div>
</header>
