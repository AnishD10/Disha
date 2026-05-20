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
    <title>Parent Dashboard - DISHA</title>
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
        <h1>Parent Dashboard</h1>
        <p>Support your child with practical planning around budget, location, eligibility, and scholarships.</p>
    </div>

    <section class="dashboard-hero">
        <div>
            <span class="dashboard-kicker">Logged in as <%= u.getRole().name() %></span>
            <h2>Welcome, <%= u.getFullName() %></h2>
            <p>This area helps parents review the key factors that shape an affordable and realistic study plan.</p>
        </div>
        <span class="status-pill">Family Guidance</span>
    </section>

    <section class="dashboard-grid">
        <article class="dashboard-card">
            <div class="dashboard-card-icon">Rs</div>
            <h3>Budget Planning</h3>
            <p>Estimate annual fees, travel costs, materials, and emergency expenses before finalizing a college choice.</p>
        </article>
        <article class="dashboard-card">
            <div class="dashboard-card-icon">%</div>
            <h3>Eligibility Check</h3>
            <p>Compare your child's academic percentage with programme minimum requirements.</p>
        </article>
        <article class="dashboard-card">
            <div class="dashboard-card-icon">SCH</div>
            <h3>Scholarship Focus</h3>
            <p>Give priority to colleges that offer scholarship options for qualified students.</p>
        </article>
    </section>

    <section class="dashboard-panel">
        <div class="dashboard-panel-header">
            <h2>Discussion Checklist</h2>
            <span class="status-pill">Recommended</span>
        </div>
        <div class="task-list">
            <div class="task-item">
                <span class="task-marker">1</span>
                <div>
                    <h3>Confirm the yearly budget</h3>
                    <p>Set a realistic ceiling for tuition and living expenses before comparing colleges.</p>
                </div>
            </div>
            <div class="task-item">
                <span class="task-marker">2</span>
                <div>
                    <h3>Review location preferences</h3>
                    <p>Discuss whether studying near home or in another district is practical for the family.</p>
                </div>
            </div>
            <div class="task-item">
                <span class="task-marker">3</span>
                <div>
                    <h3>Talk through career goals</h3>
                    <p>Use the student's interests to shortlist programmes that lead toward clear career paths.</p>
                </div>
            </div>
        </div>
    </section>
</div>
</body>
</html>
