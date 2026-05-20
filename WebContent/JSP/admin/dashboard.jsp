<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.disha.model.User, java.util.List" %>
<%
    User currentUser = (User) session.getAttribute("loggedInUser");
    if (currentUser == null || !"ADMIN".equals(currentUser.getRole().name())) {
        response.sendRedirect(request.getContextPath() + "/JSP/auth/login.jsp");
        return;
    }
    // If accessed directly (not via servlet), redirect to servlet
    if (request.getAttribute("totalUsers") == null) {
        response.sendRedirect(request.getContextPath() + "/admin/dashboard");
        return;
    }

    int totalStudents  = (Integer) request.getAttribute("totalStudents");
    int totalParents   = (Integer) request.getAttribute("totalParents");
    int totalCounselors= (Integer) request.getAttribute("totalCounselors");
    int totalCareers   = (Integer) request.getAttribute("totalCareers");
    int totalColleges  = (Integer) request.getAttribute("totalColleges");
    int totalUsers     = (Integer) request.getAttribute("totalUsers");
    List<User> recentUsers = (List<User>) request.getAttribute("recentUsers");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard â€” DISHA</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/disha-main.css">
</head>
<body>
<div class="dashboard-layout">
    <jsp:include page="../includes/sidebar.jsp" />
    <div class="main-content">
        <jsp:include page="../includes/dashboard-header.jsp" />
        <div class="dashboard-body">
            <h1 class="page-title" style="color: var(--color-primary);">Admin Dashboard</h1>
            <p style="color: var(--color-text-muted); margin-bottom: 2rem;">Welcome back, <%= currentUser.getFullName() %>. Here is an overview of the platform.</p>

            <!-- Statistics Cards -->
            <div class="grid-cards">
                <div class="card stat-card">
                    <span class="stat-card-title">ðŸ‘¥ Total Users</span>
                    <span class="stat-card-value"><%= totalUsers %></span>
                </div>
                <div class="card stat-card">
                    <span class="stat-card-title">ðŸŽ“ Students</span>
                    <span class="stat-card-value"><%= totalStudents %></span>
                </div>
                <div class="card stat-card">
                    <span class="stat-card-title">ðŸ‘¨â€ðŸ‘©â€ðŸ‘§ Parents</span>
                    <span class="stat-card-value"><%= totalParents %></span>
                </div>
                <div class="card stat-card">
                    <span class="stat-card-title">ðŸ§‘â€ðŸ’¼ Counselors</span>
                    <span class="stat-card-value"><%= totalCounselors %></span>
                </div>
                <div class="card stat-card">
                    <span class="stat-card-title">ðŸ’¼ Careers</span>
                    <span class="stat-card-value"><%= totalCareers %></span>
                </div>
                <div class="card stat-card">
                    <span class="stat-card-title">ðŸ« Colleges</span>
                    <span class="stat-card-value"><%= totalColleges %></span>
                </div>
            </div>

            <!-- Quick Actions -->
            <div class="card" style="margin-bottom: 2rem;">
                <h3 style="margin-bottom: 1rem;">Quick Actions</h3>
                <div style="display: flex; gap: 1rem; flex-wrap: wrap;">
                    <a href="<%= request.getContextPath() %>/admin/users?action=add" class="btn btn-primary">+ Add User</a>
                    <a href="<%= request.getContextPath() %>/admin/careers?action=add" class="btn btn-secondary">+ Add Career</a>
                    <a href="<%= request.getContextPath() %>/admin/colleges?action=add" class="btn btn-secondary">+ Add College</a>
                </div>
            </div>

            <!-- Recent Activity Table -->
            <div class="card">
                <h3 style="margin-bottom: 1rem;">Recent Registrations</h3>
                <div class="table-container" style="border: none; box-shadow: none;">
                    <table class="table">
                        <thead>
                            <tr><th>Name</th><th>Email</th><th>Role</th><th>Joined</th><th>Status</th></tr>
                        </thead>
                        <tbody>
                        <% if (recentUsers != null) for (User u : recentUsers) { %>
                            <tr>
                                <td><%= u.getFullName() %></td>
                                <td><%= u.getEmail() %></td>
                                <td><span class="badge badge-<%= "ADMIN".equals(u.getRole().name()) ? "danger" : "success" %>"><%= u.getRole().name() %></span></td>
                                <td><%= u.getCreatedAt() != null ? u.getCreatedAt().toString().substring(0, 10) : "N/A" %></td>
                                <td><span class="badge badge-<%= u.isActive() ? "success" : "warning" %>"><%= u.isActive() ? "Active" : "Inactive" %></span></td>
                            </tr>
                        <% } %>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
</div>
</body>
</html>
