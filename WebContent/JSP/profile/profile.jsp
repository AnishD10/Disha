<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.disha.model.User, com.disha.util.RoleConstants" %>
<%
    User profileUser = (User) request.getAttribute("profileUser");
    if (profileUser == null) {
        profileUser = (User) session.getAttribute("loggedInUser");
    }
    if (profileUser == null) {
        response.sendRedirect(request.getContextPath() + "/JSP/auth/login.jsp");
        return;
    }

    String fullName = profileUser.getFullName();
    String email = profileUser.getEmail() != null && !profileUser.getEmail().isBlank() ? profileUser.getEmail() : "Not provided";
    String phone = profileUser.getPhone() != null && !profileUser.getPhone().isBlank() ? profileUser.getPhone() : "Not provided";
    String address = profileUser.getAddress() != null && !profileUser.getAddress().isBlank() ? profileUser.getAddress() : "Not provided";
    String username = profileUser.getUsername() != null && !profileUser.getUsername().isBlank() ? profileUser.getUsername() : "Not set";
    String role = profileUser.getRole().name();
    String status = profileUser.isActive() ? "Active" : "Inactive";
    String joined = profileUser.getCreatedAt() != null ? profileUser.getCreatedAt().toString().substring(0, 10) : "Not available";
    String updated = profileUser.getUpdatedAt() != null ? profileUser.getUpdatedAt().toString().substring(0, 10) : "Not available";
    String initial = fullName != null && !fullName.isBlank() ? fullName.substring(0, 1).toUpperCase() : "U";
    String dashboardPath = RoleConstants.getDashboardPath(role);
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Profile - DISHA</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/disha-main.css">
</head>
<body>
<div class="dashboard-layout">
    <jsp:include page="../includes/sidebar.jsp" />
    <div class="main-content">
        <jsp:include page="../includes/dashboard-header.jsp" />
        <main class="dashboard-body">
            <section class="profile-hero">
                <div class="profile-avatar-xl"><%= initial %></div>
                <div>
                    <span class="feature-eyebrow">Profile</span>
                    <h1><%= fullName %></h1>
                    <p class="feature-subtitle"><%= email %></p>
                    <div class="profile-meta">
                        <span class="badge badge-success"><%= role %></span>
                        <span class="pill"><%= status %></span>
                    </div>
                </div>
                <div class="feature-actions">
                    <a href="<%= request.getContextPath() + dashboardPath %>" class="btn btn-secondary">Dashboard</a>
                    <a href="<%= request.getContextPath() %>/auth/logout" class="btn btn-primary">Log Out</a>
                </div>
            </section>

            <div class="profile-grid">
                <section class="profile-card">
                    <h2>Account Details</h2>
                    <div class="detail-row">
                        <div class="detail-label">Full Name</div>
                        <div class="detail-value"><%= fullName %></div>
                    </div>
                    <div class="detail-row">
                        <div class="detail-label">Email</div>
                        <div class="detail-value"><%= email %></div>
                    </div>
                    <div class="detail-row">
                        <div class="detail-label">Username</div>
                        <div class="detail-value"><%= username %></div>
                    </div>
                    <div class="detail-row">
                        <div class="detail-label">Phone</div>
                        <div class="detail-value"><%= phone %></div>
                    </div>
                    <div class="detail-row">
                        <div class="detail-label">Address</div>
                        <div class="detail-value"><%= address %></div>
                    </div>
                </section>

                <section class="profile-card">
                    <h2>Access</h2>
                    <div class="metric-strip">
                        <div class="metric-box">
                            <span class="metric-label">Role</span>
                            <span class="metric-value"><%= role %></span>
                        </div>
                        <div class="metric-box">
                            <span class="metric-label">Status</span>
                            <span class="metric-value"><%= status %></span>
                        </div>
                    </div>
                    <div class="detail-row">
                        <div class="detail-label">Joined</div>
                        <div class="detail-value"><%= joined %></div>
                    </div>
                    <div class="detail-row">
                        <div class="detail-label">Updated</div>
                        <div class="detail-value"><%= updated %></div>
                    </div>
                    <div class="inline-actions" style="margin-top:1rem;">
                        <% if ("STUDENT".equals(role)) { %>
                            <a href="<%= request.getContextPath() %>/assessment/start" class="btn btn-secondary">Aptitude Test</a>
                            <a href="<%= request.getContextPath() %>/career" class="btn btn-secondary">Career Discovery</a>
                        <% } else if ("PARENT".equals(role)) { %>
                            <a href="<%= request.getContextPath() %>/parent/dashboard" class="btn btn-secondary">Parent Dashboard</a>
                        <% } else if ("COUNSELOR".equals(role)) { %>
                            <a href="<%= request.getContextPath() %>/counselor/dashboard" class="btn btn-secondary">Counselor Dashboard</a>
                        <% } else if ("ADMIN".equals(role)) { %>
                            <a href="<%= request.getContextPath() %>/admin/users" class="btn btn-secondary">Manage Users</a>
                        <% } %>
                    </div>
                </section>
            </div>
        </main>
    </div>
</div>
</body>
</html>
