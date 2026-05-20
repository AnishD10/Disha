<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.disha.model.User, dao.UserDAO, dao.CareerDAO, dao.CollegeDAO" %>
<%
    User cu = (User) session.getAttribute("loggedInUser");
    if (cu == null || !"ADMIN".equals(cu.getRole().name())) { response.sendRedirect(request.getContextPath() + "/JSP/auth/login.jsp"); return; }
    
    // Fetch statistics directly for reports page
    UserDAO userDAO = new UserDAO();
    CareerDAO careerDAO = new CareerDAO();
    CollegeDAO collegeDAO = new CollegeDAO();
    
    int totalStudents = userDAO.countByRole("STUDENT");
    int totalParents = userDAO.countByRole("PARENT");
    int totalCounselors = userDAO.countByRole("COUNSELOR");
    int totalAdmins = userDAO.countByRole("ADMIN");
    int totalUsers = userDAO.countAll();
    int totalCareers = careerDAO.countAll();
    int totalColleges = collegeDAO.countAll();
    
    // Compute percentages for CSS bar charts
    int maxVal = Math.max(1, Math.max(totalStudents, Math.max(totalParents, Math.max(totalCounselors, totalAdmins))));
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Reports — DISHA Admin</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/CSS/disha-main.css">
    <style>
        .chart-container { margin-bottom: 2rem; }
        .bar-chart { display: flex; flex-direction: column; gap: 1rem; }
        .bar-row { display: flex; align-items: center; gap: 1rem; }
        .bar-label { min-width: 120px; font-weight: 600; font-size: 0.9rem; color: var(--color-text-muted); }
        .bar-track { flex: 1; background: var(--color-accent); border-radius: var(--radius-full); height: 32px; overflow: hidden; position: relative; }
        .bar-fill { height: 100%; border-radius: var(--radius-full); display: flex; align-items: center; padding-left: 1rem; color: white; font-weight: 700; font-size: 0.85rem; transition: width 0.8s ease; }
        .bar-fill-red { background: linear-gradient(135deg, #C62828, #ef5350); }
        .bar-fill-blue { background: linear-gradient(135deg, #1565c0, #42a5f5); }
        .bar-fill-green { background: linear-gradient(135deg, #2e7d32, #66bb6a); }
        .bar-fill-orange { background: linear-gradient(135deg, #ef6c00, #ffa726); }
        .bar-fill-purple { background: linear-gradient(135deg, #6a1b9a, #ab47bc); }
        .stat-mini { text-align: center; padding: 1.5rem; }
        .stat-mini-value { font-size: 2.5rem; font-weight: 800; color: var(--color-primary); }
        .stat-mini-label { color: var(--color-text-muted); font-size: 0.9rem; margin-top: 0.25rem; }
        .report-grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(300px, 1fr)); gap: 1.5rem; margin-bottom: 2rem; }
    </style>
</head>
<body>
<div class="dashboard-layout">
    <jsp:include page="../includes/sidebar.jsp" />
    <div class="main-content">
        <jsp:include page="../includes/dashboard-header.jsp" />
        <div class="dashboard-body">
            <h1 class="page-title" style="color: var(--color-primary);">📊 Platform Reports</h1>
            <p style="color: var(--color-text-muted); margin-bottom: 2rem;">Comprehensive overview of the Disha Nepal Career Intelligence Platform statistics and analytics.</p>

            <!-- Summary Cards -->
            <div class="grid-cards" style="margin-bottom: 2rem;">
                <div class="card stat-mini">
                    <div class="stat-mini-value"><%= totalUsers %></div>
                    <div class="stat-mini-label">Total Users</div>
                </div>
                <div class="card stat-mini">
                    <div class="stat-mini-value"><%= totalCareers %></div>
                    <div class="stat-mini-label">Career Paths</div>
                </div>
                <div class="card stat-mini">
                    <div class="stat-mini-value"><%= totalColleges %></div>
                    <div class="stat-mini-label">Colleges Listed</div>
                </div>
            </div>

            <div class="report-grid">
                <!-- User Distribution Chart -->
                <div class="card chart-container">
                    <h3 style="margin-bottom: 1.5rem;">👥 User Distribution by Role</h3>
                    <div class="bar-chart">
                        <div class="bar-row">
                            <span class="bar-label">Students</span>
                            <div class="bar-track"><div class="bar-fill bar-fill-red" style="width: <%= (totalStudents * 100) / maxVal %>%;"><%= totalStudents %></div></div>
                        </div>
                        <div class="bar-row">
                            <span class="bar-label">Parents</span>
                            <div class="bar-track"><div class="bar-fill bar-fill-blue" style="width: <%= (totalParents * 100) / maxVal %>%;"><%= totalParents %></div></div>
                        </div>
                        <div class="bar-row">
                            <span class="bar-label">Counselors</span>
                            <div class="bar-track"><div class="bar-fill bar-fill-green" style="width: <%= (totalCounselors * 100) / maxVal %>%;"><%= totalCounselors %></div></div>
                        </div>
                        <div class="bar-row">
                            <span class="bar-label">Admins</span>
                            <div class="bar-track"><div class="bar-fill bar-fill-orange" style="width: <%= (totalAdmins * 100) / maxVal %>%;"><%= totalAdmins %></div></div>
                        </div>
                    </div>
                </div>

                <!-- Platform Overview -->
                <div class="card chart-container">
                    <h3 style="margin-bottom: 1.5rem;">📈 Platform Overview</h3>
                    <div class="bar-chart">
                        <div class="bar-row">
                            <span class="bar-label">Users</span>
                            <div class="bar-track"><div class="bar-fill bar-fill-red" style="width: 100%;"><%= totalUsers %></div></div>
                        </div>
                        <div class="bar-row">
                            <span class="bar-label">Careers</span>
                            <div class="bar-track"><div class="bar-fill bar-fill-purple" style="width: <%= totalUsers > 0 ? (totalCareers * 100) / totalUsers : 0 %>%;"><%= totalCareers %></div></div>
                        </div>
                        <div class="bar-row">
                            <span class="bar-label">Colleges</span>
                            <div class="bar-track"><div class="bar-fill bar-fill-green" style="width: <%= totalUsers > 0 ? (totalColleges * 100) / totalUsers : 0 %>%;"><%= totalColleges %></div></div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Summary Table -->
            <div class="card">
                <h3 style="margin-bottom: 1rem;">📋 Summary Report</h3>
                <div class="table-container" style="border: none; box-shadow: none;">
                    <table class="table">
                        <thead>
                            <tr><th>Metric</th><th>Count</th><th>Percentage of Total Users</th></tr>
                        </thead>
                        <tbody>
                            <tr><td>Students</td><td><strong><%= totalStudents %></strong></td><td><%= totalUsers > 0 ? String.format("%.1f", (totalStudents * 100.0) / totalUsers) : "0" %>%</td></tr>
                            <tr><td>Parents</td><td><strong><%= totalParents %></strong></td><td><%= totalUsers > 0 ? String.format("%.1f", (totalParents * 100.0) / totalUsers) : "0" %>%</td></tr>
                            <tr><td>Counselors</td><td><strong><%= totalCounselors %></strong></td><td><%= totalUsers > 0 ? String.format("%.1f", (totalCounselors * 100.0) / totalUsers) : "0" %>%</td></tr>
                            <tr><td>Admins</td><td><strong><%= totalAdmins %></strong></td><td><%= totalUsers > 0 ? String.format("%.1f", (totalAdmins * 100.0) / totalUsers) : "0" %>%</td></tr>
                            <tr style="background: var(--color-accent);"><td><strong>Total</strong></td><td><strong><%= totalUsers %></strong></td><td><strong>100%</strong></td></tr>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
</div>
</body>
</html>
