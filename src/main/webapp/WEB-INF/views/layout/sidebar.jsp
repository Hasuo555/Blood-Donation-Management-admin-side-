<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>

<nav class="sidebar" id="sidebar">
    <div class="sidebar-brand">
        <div class="sidebar-brand-icon">
            <svg width="28" height="28" viewBox="0 0 24 24" fill="none">
                <path d="M12 2C8 2 4 6 4 10c0 5.5 7 12 8 12s8-6.5 8-12c0-4-4-8-8-8z" fill="#e53e3e"/>
                <path d="M12 7v6M9 10h6" stroke="#fff" stroke-width="1.5" stroke-linecap="round"/>
            </svg>
        </div>
        <span class="sidebar-brand-text">AMyanHlu</span>
    </div>

    <ul class="sidebar-nav">
        <li class="sidebar-nav-item">
            <a href="<c:url value='/admin/dashboard' />"
               class="sidebar-nav-link ${activeMenu == 'dashboard' ? 'active' : ''}">
                <svg class="nav-icon" viewBox="0 0 24 24"><path d="M3 13h8V3H3v10zm0 8h8v-6H3v6zm10 0h8V11h-8v10zm0-18v6h8V3h-8z"/></svg>
                <span>Dashboard</span>
            </a>
        </li>

        <li class="sidebar-nav-section">DONORS</li>
        <li class="sidebar-nav-item">
            <a href="<c:url value='/admin/donors' />"
               class="sidebar-nav-link ${activeMenu == 'donors' ? 'active' : ''}">
                <svg class="nav-icon" viewBox="0 0 24 24"><path d="M12 12c2.7 0 5-2.3 5-5s-2.3-5-5-5-5 2.3-5 5 2.3 5 5 5zm0 2c-3.3 0-10 1.7-10 5v2h20v-2c0-3.3-6.7-5-10-5z"/></svg>
                <span>Manage Donors</span>
            </a>
        </li>
        <li class="sidebar-nav-item">
            <a href="<c:url value='/admin/donors/create' />"
               class="sidebar-nav-link ${activeMenu == 'donors-create' ? 'active' : ''}">
                <svg class="nav-icon" viewBox="0 0 24 24"><path d="M19 13h-6v6h-2v-6H5v-2h6V5h2v6h6v2z"/></svg>
                <span>Create Donor</span>
            </a>
        </li>

        <li class="sidebar-nav-section">STAFF</li>
        <li class="sidebar-nav-item">
            <a href="<c:url value='/admin/staff' />"
               class="sidebar-nav-link ${activeMenu == 'staff' ? 'active' : ''}">
                <svg class="nav-icon" viewBox="0 0 24 24"><path d="M16 11c1.7 0 3-1.3 3-3s-1.3-3-3-3-3 1.3-3 3 1.3 3 3 3zm-8 0c1.7 0 3-1.3 3-3S9.7 5 8 5 5 6.3 5 8s1.3 3 3 3zm0 2c-2.3 0-7 1.2-7 3.5V19h14v-2.5C15 14.2 10.3 13 8 13zm8 0c-.3 0-.6 0-1 .1 1.2.8 2 2 2 3.4V19h6v-2.5c0-2.3-4.7-3.5-7-3.5z"/></svg>
                <span>Manage Staff</span>
            </a>
        </li>
        <li class="sidebar-nav-item">
            <a href="<c:url value='/admin/staff/create' />"
               class="sidebar-nav-link ${activeMenu == 'staff-create' ? 'active' : ''}">
                <svg class="nav-icon" viewBox="0 0 24 24"><path d="M19 13h-6v6h-2v-6H5v-2h6V5h2v6h6v2z"/></svg>
                <span>Create Staff</span>
            </a>
        </li>

        <li class="sidebar-nav-section">HOSPITALS</li>
        <li class="sidebar-nav-item">
            <a href="<c:url value='/admin/hospitals' />"
               class="sidebar-nav-link ${activeMenu == 'hospitals' ? 'active' : ''}">
                <svg class="nav-icon" viewBox="0 0 24 24"><path d="M19 3H5a2 2 0 0 0-2 2v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2V5a2 2 0 0 0-2-2zm-7 14v-4H8v-2h4V7h2v4h4v2h-4v4h-2z"/></svg>
                <span>Manage Hospitals</span>
            </a>
        </li>
        <li class="sidebar-nav-item">
            <a href="<c:url value='/admin/hospitals/create' />"
               class="sidebar-nav-link ${activeMenu == 'hospitals-create' ? 'active' : ''}">
                <svg class="nav-icon" viewBox="0 0 24 24"><path d="M19 13h-6v6h-2v-6H5v-2h6V5h2v6h6v2z"/></svg>
                <span>Create Hospital</span>
            </a>
        </li>

        <li class="sidebar-nav-section">ARTICLES</li>
        <li class="sidebar-nav-item">
            <a href="<c:url value='/admin/articles' />"
               class="sidebar-nav-link ${activeMenu == 'articles' ? 'active' : ''}">
                <svg class="nav-icon" viewBox="0 0 24 24"><path d="M19 3H5c-1.1 0-2 .9-2 2v14c0 1.1.9 2 2 2h14c1.1 0 2-.9 2-2V5c0-1.1-.9-2-2-2zm-5 14H7v-2h7v2zm3-4H7v-2h10v2zm0-4H7V7h10v2z"/></svg>
                <span>Manage Articles</span>
            </a>
        </li>
        <li class="sidebar-nav-item">
            <a href="<c:url value='/admin/articles/create' />"
               class="sidebar-nav-link ${activeMenu == 'articles-create' ? 'active' : ''}">
                <svg class="nav-icon" viewBox="0 0 24 24"><path d="M19 13h-6v6h-2v-6H5v-2h6V5h2v6h6v2z"/></svg>
                <span>Create Article</span>
            </a>
        </li>

        <li class="sidebar-nav-section">OPERATIONS</li>
        <li class="sidebar-nav-item">
            <a href="<c:url value='/admin/emergency-blood' />"
               class="sidebar-nav-link ${activeMenu == 'emergency-blood' ? 'active' : ''}">
                <svg class="nav-icon" viewBox="0 0 24 24"><path d="M12 2C8 2 4 6 4 10c0 5.5 7 12 8 12s8-6.5 8-12c0-4-4-8-8-8z" fill="none" stroke="currentColor" stroke-width="2"/><path d="M12 7v6M9 10h6" stroke="currentColor" stroke-width="1.5" stroke-linecap="round"/></svg>
                <span>Emergency Blood</span>
            </a>
        </li>
        <li class="sidebar-nav-item">
            <a href="<c:url value='/admin/notifications' />"
               class="sidebar-nav-link ${activeMenu == 'notifications' ? 'active' : ''}">
                <svg class="nav-icon" viewBox="0 0 24 24"><path d="M12 22c1.1 0 2-.9 2-2h-4c0 1.1.9 2 2 2zm6-6v-5c0-3.1-1.6-5.6-4.5-6.3V4c0-.8-.7-1.5-1.5-1.5S10.5 3.2 10.5 4v.7C7.6 5.4 6 7.9 6 11v5l-2 2v1h16v-1l-2-2z"/></svg>
                <span>Notifications</span>
            </a>
        </li>
        <li class="sidebar-nav-item">
            <a href="<c:url value='/admin/audit-logs' />"
               class="sidebar-nav-link ${activeMenu == 'audit-logs' ? 'active' : ''}">
                <svg class="nav-icon" viewBox="0 0 24 24"><path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8l-6-6zm4 18H6V4h7v5h5v11zm-5-5H8v-2h5v2zm3-4H8V9h8v2z"/></svg>
                <span>Audit Logs</span>
            </a>
        </li>
    </ul>

    <div class="sidebar-footer">
        <a href="<c:url value='/admin/profile' />"
           class="sidebar-nav-link ${activeMenu == 'profile' ? 'active' : ''}">
            <svg class="nav-icon" viewBox="0 0 24 24"><path d="M12 12c2.7 0 5-2.3 5-5s-2.3-5-5-5-5 2.3-5 5 2.3 5 5 5zm0 2c-3.3 0-10 1.7-10 5v2h20v-2c0-3.3-6.7-5-10-5z"/></svg>
            <span>Profile</span>
        </a>
        <form action="<c:url value='/admin/logout' />" method="post" style="display:inline;">
            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />
            <button type="submit" class="sidebar-logout-btn">
                <svg class="nav-icon" viewBox="0 0 24 24"><path d="M17 7l-1.41 1.41L18.17 11H8v2h10.17l-2.58 2.58L17 17l5-5-5-5zM4 5h8V3H4c-1.1 0-2 .9-2 2v14c0 1.1.9 2 2 2h8v-2H4V5z"/></svg>
                <span>Logout</span>
            </button>
        </form>
    </div>
</nav>
