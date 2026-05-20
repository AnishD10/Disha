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
    <title>Counselor Dashboard - DISHA</title>
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
        <h1>Counselor Dashboard</h1>
        <p>Guide students through programme selection with budget, eligibility, and career fit in view.</p>
    </div>

    <section class="dashboard-hero">
        <div>
            <span class="dashboard-kicker">Logged in as <%= u.getRole().name() %></span>
            <h2>Counseling Workspace</h2>
            <p>Use this page as a structured guide for student conversations, shortlist review, and next-step planning.</p>
        </div>
        <span class="status-pill">Counselor Tools</span>
    </section>

    <section class="dashboard-grid">
        <article class="dashboard-card">
            <div class="dashboard-card-icon">FIT</div>
            <h3>Profile Fit</h3>
            <p>Help students connect academic scores, interests, and family constraints with suitable programmes.</p>
        </article>
        <article class="dashboard-card">
            <div class="dashboard-card-icon">MAP</div>
            <h3>College Mapping</h3>
            <p>Compare colleges by district, affiliation, annual fees, and scholarship availability.</p>
        </article>
        <article class="dashboard-card">
            <div class="dashboard-card-icon">PLAN</div>
            <h3>Action Plan</h3>
            <p>Turn search results into a practical shortlist, application timeline, and document checklist.</p>
        </article>
    </section>

    <section class="dashboard-panel">
        <div class="dashboard-panel-header">
            <h2>Session Flow</h2>
            <span class="status-pill">Active</span>
        </div>
        <div class="task-list">
            <div class="task-item">
                <span class="task-marker">1</span>
                <div>
                    <h3>Collect student constraints</h3>
                    <p>Record budget range, preferred locations, academic score, and intended career direction.</p>
                </div>
            </div>
            <div class="task-item">
                <span class="task-marker">2</span>
                <div>
                    <h3>Explain tradeoffs clearly</h3>
                    <p>Show how fee, location, scholarship, and eligibility choices affect the final shortlist.</p>
                </div>
            </div>
            <div class="task-item">
                <span class="task-marker">3</span>
                <div>
                    <h3>Prepare follow-up work</h3>
                    <p>Give the student a focused set of colleges to verify, contact, and discuss with family.</p>
                </div>
            </div>
        </div>
    </section>
</div>
</body>
</html>
