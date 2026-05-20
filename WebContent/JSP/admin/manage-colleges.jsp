<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.disha.model.User, com.disha.model.College, java.util.List" %>
<%
    User cu = (User) session.getAttribute("loggedInUser");
    if (cu == null || !"ADMIN".equals(cu.getRole().name())) { response.sendRedirect(request.getContextPath() + "/JSP/auth/login.jsp"); return; }
    List<College> colleges = (List<College>) request.getAttribute("colleges");
    String msg = request.getParameter("msg");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Colleges — DISHA Admin</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/CSS/disha-main.css">
</head>
<body>
<div class="dashboard-layout">
    <jsp:include page="../includes/sidebar.jsp" />
    <div class="main-content">
        <jsp:include page="../includes/dashboard-header.jsp" />
        <div class="dashboard-body">
            <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 1.5rem; flex-wrap: wrap; gap: 1rem;">
                <h1 class="page-title" style="margin:0; color: var(--color-primary);">Manage Colleges</h1>
                <a href="<%= request.getContextPath() %>/admin/colleges?action=add" class="btn btn-primary">+ Add College</a>
            </div>

            <% if ("deleted".equals(msg)) { %><div class="alert alert-success">College deleted successfully.</div><% } %>
            <% if ("added".equals(msg)) { %><div class="alert alert-success">College added successfully.</div><% } %>
            <% if ("updated".equals(msg)) { %><div class="alert alert-success">College updated successfully.</div><% } %>

            <div class="table-container">
                <table class="table">
                    <thead>
                        <tr><th>ID</th><th>College Name</th><th>Location</th><th>City</th><th>Type</th><th>Verified</th><th>Actions</th></tr>
                    </thead>
                    <tbody>
                    <% if (colleges != null) for (College c : colleges) { %>
                        <tr>
                            <td><%= c.getCollegeId() %></td>
                            <td>
                                <strong><%= c.getCollegeName() %></strong>
                                <% if (c.getWebsiteUrl() != null && !c.getWebsiteUrl().isEmpty()) { %>
                                <br><a href="<%= c.getWebsiteUrl() %>" target="_blank" style="font-size:0.8rem;">🌐 Website</a>
                                <% } %>
                            </td>
                            <td><%= c.getCollegeLocation() != null ? c.getCollegeLocation() : "-" %></td>
                            <td><%= c.getCollegeCity() != null ? c.getCollegeCity() : "-" %></td>
                            <td><span class="badge badge-<%= c.isPublic() ? "success" : "warning" %>"><%= c.isPublic() ? "Public" : "Private" %></span></td>
                            <td><span class="badge badge-<%= c.isVerified() ? "success" : "danger" %>"><%= c.isVerified() ? "Yes" : "No" %></span></td>
                            <td style="display:flex; gap:0.5rem;">
                                <a href="<%= request.getContextPath() %>/admin/colleges?action=edit&id=<%= c.getCollegeId() %>" class="btn btn-secondary" style="padding:0.4rem 0.8rem; font-size:0.85rem;">Edit</a>
                                <a href="<%= request.getContextPath() %>/admin/colleges?action=delete&id=<%= c.getCollegeId() %>" class="btn btn-secondary" style="padding:0.4rem 0.8rem; font-size:0.85rem; color:var(--color-danger);" onclick="return confirm('Delete this college?')">Delete</a>
                            </td>
                        </tr>
                    <% } %>
                    <% if (colleges == null || colleges.isEmpty()) { %><tr><td colspan="7" style="text-align:center; padding:2rem; color:var(--color-text-muted);">No colleges found.</td></tr><% } %>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</div>
</body>
</html>
