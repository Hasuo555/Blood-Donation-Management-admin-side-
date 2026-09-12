<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8"/><meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>500 — Server Error</title>
    <link rel="preconnect" href="https://fonts.googleapis.com"/>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600&display=swap" rel="stylesheet"/>
    <link rel="stylesheet" href="<c:url value='/static/css/admin.css'/>"/>
</head>
<body class="error-body">
<div class="error-page">
    <div class="error-code">500</div>
    <h1>Server Error</h1>
    <p class="text-muted">An unexpected error occurred. Please try again later.</p>
    <a href="<c:url value='/admin/dashboard'/>" class="btn btn-primary mt-3">Back to Dashboard</a>
</div>
</body>
</html>
