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
    <title>Student Dashboard - DISHA</title>
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
        <h1>Student Dashboard</h1>
        <p>Plan your next academic step with programme filters, scholarship signals, and saved guidance.</p>
    </div>

    <section class="dashboard-hero">
        <div>
            <span class="dashboard-kicker">Logged in as <%= u.getRole().name() %></span>
            <h2>Welcome back, <%= u.getFullName() %></h2>
            <p>Use DISHA to compare colleges in Nepal by annual fee, location, faculty, score requirement, career interest, and scholarship availability.</p>
        </div>
        <a href="<%= request.getContextPath() %>/decision/plan" class="btn btn-primary dashboard-primary-action">Start Decision Planning</a>
    </section>

    <section class="dashboard-grid">
        <article class="dashboard-card">
            <div class="dashboard-card-icon">01</div>
            <h3>Search Programmes</h3>
            <p>Filter available degrees by budget, district, academic percentage, faculty, and career path.</p>
        </article>
        <article class="dashboard-card">
            <div class="dashboard-card-icon">02</div>
            <h3>Compare Costs</h3>
            <p>Review annual fees side by side so you can shortlist realistic options before applying.</p>
        </article>
        <article class="dashboard-card">
            <div class="dashboard-card-icon">03</div>
            <h3>Find Scholarships</h3>
            <p>Prioritize programmes that show scholarship availability and match your academic profile.</p>
        </article>
    </section>

    <section class="dashboard-panel">
        <div class="dashboard-panel-header">
            <h2>Your Next Steps</h2>
            <span class="status-pill">Ready</span>
        </div>
        <div class="task-list">
            <div class="task-item">
                <span class="task-marker">1</span>
                <div>
                    <h3>Enter your budget and score</h3>
                    <p>Start with your maximum annual fee and current academic percentage.</p>
                </div>
            </div>
            <div class="task-item">
                <span class="task-marker">2</span>
                <div>
                    <h3>Choose a career interest</h3>
                    <p>Select a goal such as IT, management, health, engineering, or education.</p>
                </div>
            </div>
            <div class="task-item">
                <span class="task-marker">3</span>
                <div>
                    <h3>Shortlist matching colleges</h3>
                    <p>Use the results to discuss affordable and realistic choices with your family or counselor.</p>
                </div>
            </div>
        </div>
    </section>
</div>
</body>
</html>
