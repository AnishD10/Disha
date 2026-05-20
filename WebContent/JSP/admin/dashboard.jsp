<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.disha.model.User" %>
<%
    User currentUser = (User) session.getAttribute("loggedInUser");
    if (currentUser == null) {
        response.sendRedirect(request.getContextPath() + "/jsp/auth/login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Admin Dashboard — DISHA</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/CSS/disha-main.css">
</head>
<body>
<nav class="navbar">
    <a href="#" class="nav-brand">DISHA</a>
    <div class="nav-user">
        <span>Welcome, <%= currentUser.getFullName() %></span>
        <span class="role-chip">ADMIN</span>
        <a href="<%= request.getContextPath() %>/jsp/auth/login.jsp" class="btn btn-sm btn-secondary">Log Out</a>
    </div>
</nav>
<div class="page-wrapper">
    <div class="page-header">
        <h1>⚙️ Admin Dashboard</h1>
        <p> yo kam baki xa</p>
    </div>
    <div style="background:#161B22; border:1px dashed #30363D; border-radius:10px; padding:32px; text-align:center; color:#8B949E;">
        <p style="font-size:1.1rem;">      </p>
        <p>This dashboard will contain: manage users, labour market data, career profiles, college moderation.</p>
    </div>
</div>
</body>
</html>
