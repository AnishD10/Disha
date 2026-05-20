<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.disha.model.User" %>
<%
    User currentUser = (User) session.getAttribute("loggedInUser");
    if (currentUser == null) {
        response.sendRedirect(request.getContextPath() + "/JSP/auth/login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Counselor Dashboard â€” DISHA</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/disha-main.css">
</head>
<body>
<nav class="navbar">
    <a href="#" class="nav-brand">DISHA</a>
    <div class="nav-user">
        <span>Welcome, <%= currentUser.getFullName() %></span>
        <span class="role-chip">COUNSELOR</span>
        <a href="<%= request.getContextPath() %>/auth/logout" class="btn btn-sm btn-secondary">Log Out</a>
    </div>
</nav>
<div class="page-wrapper">
    <div class="page-header">
        <h1>ðŸ§‘â€ðŸ’¼ Counselor Dashboard</h1>
        <p> yo kam baki xa </p>
    </div>
    <div style="background:#161B22; border:1px dashed #30363D; border-radius:10px; padding:32px; text-align:center; color:#8B949E;">
        <p style="font-size:1.1rem;">yo kam baki xa</p>
        <p>This dashboard will contain: bulk student management, aggregate reports, flagging at-risk students.</p>
    </div>
</div>
<jsp:include page="../includes/login-toast.jsp" />
</body>
</html>
