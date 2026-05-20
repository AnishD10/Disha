<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.disha.model.User" %>
<%
    User u = (User) session.getAttribute("loggedInUser");
    if (u == null) { response.sendRedirect(request.getContextPath() + "/pages/auth/login.jsp"); return; }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Admin Dashboard - DISHA</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/disha-main.css">
</head>
<body>
<nav class="navbar">
    <a href="<%= request.getContextPath() %>/" class="nav-brand">DISHA</a>
    <div class="nav-user">
        <span>Welcome, <%= u.getFullName() %></span>
        <span class="role-chip"><%= u.getRole().name() %></span>
        <a href="<%= request.getContextPath() %>/auth/logout" class="btn btn-sm btn-secondary">Log Out</a>
    </div>
</nav>
<div class="page-wrapper">
    <div class="page-header">
        <h1>Admin Dashboard</h1>
        <p>Monitor portal readiness, user roles, and the decision-planning data used by DISHA.</p>
    </div>

    <section class="dashboard-hero">
        <div>
            <span class="dashboard-kicker">Logged in as <%= u.getRole().name() %></span>
            <h2>Portal Administration</h2>
            <p>Keep DISHA organized by checking access roles, data quality, and feature readiness across the portal.</p>
        </div>
        <span class="status-pill">Admin Console</span>
    </section>

    <section class="dashboard-grid">
        <article class="dashboard-card">
            <div class="dashboard-card-icon">USR</div>
            <h3>User Access</h3>
            <p>Review student, parent, counselor, and admin roles so each user reaches the correct dashboard.</p>
        </article>
        <article class="dashboard-card">
            <div class="dashboard-card-icon">DB</div>
            <h3>Decision Data</h3>
            <p>Maintain reliable college, programme, fee, eligibility, and scholarship information.</p>
        </article>
        <article class="dashboard-card">
            <div class="dashboard-card-icon">SEC</div>
            <h3>Session Security</h3>
            <p>Confirm protected pages require login and role-based routing remains enforced.</p>
        </article>
    </section>

    <section class="dashboard-panel">
        <div class="dashboard-panel-header">
            <h2>Administration Checklist</h2>
            <span class="status-pill">Operational</span>
        </div>
        <div class="task-list">
            <div class="task-item">
                <span class="task-marker">1</span>
                <div>
                    <h3>Validate role dashboards</h3>
                    <p>Test login redirection for students, parents, counselors, and admins after user changes.</p>
                </div>
            </div>
            <div class="task-item">
                <span class="task-marker">2</span>
                <div>
                    <h3>Review programme records</h3>
                    <p>Check that fees, minimum percentages, locations, and affiliations are current.</p>
                </div>
            </div>
            <div class="task-item">
                <span class="task-marker">3</span>
                <div>
                    <h3>Watch error pages and access rules</h3>
                    <p>Confirm unauthorized users are redirected cleanly and error pages remain available.</p>
                </div>
            </div>
        </div>
    </section>
</div>
</body>
</html>
