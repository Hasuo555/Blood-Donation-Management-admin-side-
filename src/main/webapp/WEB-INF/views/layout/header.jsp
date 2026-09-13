<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.time.format.DateTimeFormatter,java.util.Locale" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<% request.setAttribute("adminDateTimeFormatter", DateTimeFormatter.ofPattern("dd MMM uuuu, hh:mm a", Locale.ENGLISH)); %>
<% request.setAttribute("adminDateFormatter", DateTimeFormatter.ofPattern("dd MMM uuuu", Locale.ENGLISH)); %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>AMyanHlu Admin — ${pageTitle != null ? pageTitle : 'Dashboard'}</title>
    <meta name="description" content="AMyanHlu Blood Donation Platform Admin Panel" />
    <link rel="preconnect" href="https://fonts.googleapis.com" />
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin />
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet" />
    <link rel="stylesheet" href="<c:url value='/static/css/admin.css' />" />
</head>
<body>
<div class="admin-wrapper">
    <%@ include file="sidebar.jsp" %>
    <div class="main-content">
        <%@ include file="topbar.jsp" %>
        <div class="page-content">
