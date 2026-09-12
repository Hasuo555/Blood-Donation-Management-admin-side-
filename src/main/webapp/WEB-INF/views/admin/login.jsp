<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="jakarta.tags.core" %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8" />
            <meta name="viewport" content="width=device-width, initial-scale=1.0" />
            <title>AMyanHlu Admin — Login</title>
            <meta name="description" content="AMyanHlu Blood Donation Admin Login" />
            <link rel="preconnect" href="https://fonts.googleapis.com" />
            <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin />
            <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap"
                rel="stylesheet" />
            <link rel="stylesheet" href="<c:url value='/static/css/admin.css'/>" />
        </head>

        <body class="login-body">
            <div class="login-container">
                <div class="login-card">
                    <div class="login-brand">
                        <div class="login-brand-icon">
                            <svg width="40" height="40" viewBox="0 0 24 24" fill="none">
                                <path d="M12 2C8 2 4 6 4 10c0 5.5 7 12 8 12s8-6.5 8-12c0-4-4-8-8-8z" fill="#e53e3e" />
                                <path d="M12 7v6M9 10h6" stroke="#fff" stroke-width="1.5" stroke-linecap="round" />
                            </svg>
                        </div>
                        <h1 class="login-brand-name">AMyanHlu</h1>
                        <p class="login-brand-sub">Admin Portal</p>
                    </div>

                    <c:if test="${param.error != null}">
                        <div class="alert alert-error">
                            <c:choose>
                                <c:when test="${param.error == 'unauthorized'}">
                                    You must be signed in as an administrator to access that page.
                                </c:when>
                                <c:otherwise>
                                    Invalid email or password. Please try again.
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </c:if>
                    <c:if test="${param.logout != null}">
                        <div class="alert alert-success">
                            You have been logged out successfully.
                        </div>
                    </c:if>

                    <form action="<c:url value='/admin/login'/>" method="post" class="login-form" novalidate>
                        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}" />

                        <div class="form-group">
                            <label for="email" class="form-label">Email Address</label>
                            <input type="email" id="email" name="email" class="form-control" autocomplete="email"
                                required autofocus />
                        </div>

                        <div class="form-group">
                            <label for="password" class="form-label">Password</label>
                            <div class="input-password-wrapper">
                                <input type="password" id="password" name="password" class="form-control"
                                    placeholder="••••••••" autocomplete="current-password" required />
                                <button type="button" class="toggle-password" onclick="togglePassword()"
                                    aria-label="Toggle password visibility">
                                    <svg width="18" height="18" viewBox="0 0 24 24">
                                        <path
                                            d="M12 4.5C7 4.5 2.7 7.6 1 12c1.7 4.4 6 7.5 11 7.5s9.3-3.1 11-7.5C21.3 7.6 17 4.5 12 4.5zm0 12.5c-2.8 0-5-2.2-5-5s2.2-5 5-5 5 2.2 5 5-2.2 5-5 5zm0-8c-1.7 0-3 1.3-3 3s1.3 3 3 3 3-1.3 3-3-1.3-3-3-3z" />
                                    </svg>
                                </button>
                            </div>
                        </div>

                        <button type="submit" class="btn btn-primary btn-block" id="login-btn">
                            Sign In
                        </button>
                    </form>
                </div>
            </div>
            <script>
                function togglePassword() {
                    const pwd = document.getElementById('password');
                    pwd.type = pwd.type === 'password' ? 'text' : 'password';
                }
            </script>
        </body>

        </html>