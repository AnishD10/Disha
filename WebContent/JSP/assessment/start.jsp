<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
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
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Aptitude Test - DISHA</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/disha-main.css">
</head>
<body>
<div class="dashboard-layout">
    <jsp:include page="../includes/sidebar.jsp" />
    <div class="main-content">
        <jsp:include page="../includes/dashboard-header.jsp" />
        <main class="dashboard-body">
            <div class="page-header" style="margin-bottom:2rem;">
                <h1 style="color:var(--color-primary);">Aptitude Test</h1>
                <p style="color:var(--color-text-muted);">Answer 30 questions across aptitude, personality, and interests.</p>
            </div>
            <% if (request.getAttribute("errorMessage") != null) { %>
                <div class="alert alert-error"><%= request.getAttribute("errorMessage") %></div>
            <% } %>
            <div class="grid-cards">
                <div class="card stat-card"><span class="stat-card-title">Questions</span><span class="stat-card-value">30</span></div>
                <div class="card stat-card"><span class="stat-card-title">Time</span><span class="stat-card-value">10-15 min</span></div>
                <div class="card stat-card"><span class="stat-card-title">Retakes</span><span class="stat-card-value">Allowed</span></div>
            </div>
            <div class="card" style="max-width:760px;">
                <h3 style="margin-bottom:1rem;">Before you begin</h3>
                <p style="color:var(--color-text-muted); margin-bottom:1rem;">The aptitude section has correct answers. Personality and interest sections have no wrong answers, so choose what best describes you.</p>
                <form method="post" action="<%= request.getContextPath() %>/assessment/start">
                    <button type="submit" class="btn btn-primary" style="width:auto;">Start Test</button>
                    <a href="<%= request.getContextPath() %>/assessment/history" class="btn btn-secondary" style="width:auto;">View History</a>
                </form>
            </div>
        </main>
    </div>
</div>
</body>
</html>
