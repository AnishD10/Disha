<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.disha.model.User, java.util.List" %>
<%
    User currentUser = (User) session.getAttribute("loggedInUser");
    if (currentUser == null || !"ADMIN".equals(currentUser.getRole().name())) { response.sendRedirect(request.getContextPath() + "/JSP/auth/login.jsp"); return; }
    List<User> users = (List<User>) request.getAttribute("users");
    String searchQuery = (String) request.getAttribute("searchQuery");
    String roleFilter = (String) request.getAttribute("roleFilter");
    String msg = request.getParameter("msg");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Users - DISHA Admin</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/disha-main.css">
</head>
<body>
<div class="dashboard-layout">
    <jsp:include page="../includes/sidebar.jsp" />
    <div class="main-content">
        <jsp:include page="../includes/dashboard-header.jsp" />
        <div class="dashboard-body">
            <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 1.5rem; flex-wrap: wrap; gap: 1rem;">
                <h1 class="page-title" style="margin:0; color: var(--color-primary);">Manage Users</h1>
                <a href="<%= request.getContextPath() %>/admin/users?action=add" class="btn btn-primary">+ Add User</a>
            </div>

            <% if ("deleted".equals(msg)) { %><div class="alert alert-success">User deleted successfully.</div><% } %>
            <% if ("added".equals(msg)) { %><div class="alert alert-success">User added successfully.</div><% } %>
            <% if ("updated".equals(msg)) { %><div class="alert alert-success">User updated successfully.</div><% } %>

            <!-- Search & Filter -->
            <div class="card" style="margin-bottom: 1.5rem;">
                <form method="GET" action="<%= request.getContextPath() %>/admin/users" style="display: flex; gap: 1rem; flex-wrap: wrap; align-items: flex-end;">
                    <input type="hidden" name="action" value="list">
                    <div class="form-group" style="flex:2; margin-bottom:0;">
                        <label>Search</label>
                        <input type="text" name="search" placeholder="Search by name or email..." value="<%= searchQuery != null ? searchQuery : "" %>">
                    </div>
                    <div class="form-group" style="flex:1; margin-bottom:0;">
                        <label>Filter by Role</label>
                        <select name="role">
                            <option value="">All Roles</option>
                            <option value="STUDENT" <%= "STUDENT".equals(roleFilter) ? "selected" : "" %>>Student</option>
                            <option value="PARENT" <%= "PARENT".equals(roleFilter) ? "selected" : "" %>>Parent</option>
                            <option value="COUNSELOR" <%= "COUNSELOR".equals(roleFilter) ? "selected" : "" %>>Counselor</option>
                            <option value="ADMIN" <%= "ADMIN".equals(roleFilter) ? "selected" : "" %>>Admin</option>
                        </select>
                    </div>
                    <button type="submit" class="btn btn-primary" style="height: fit-content;"> Search</button>
                </form>
            </div>

            <!-- Users Table -->
            <div class="table-container">
                <table class="table">
                    <thead><tr><th>ID</th><th>Name</th><th>Email</th><th>Role</th><th>Phone</th><th>Status</th><th>Actions</th></tr></thead>
                    <tbody>
                    <% if (users != null) for (User u : users) { %>
                        <tr>
                            <td><%= u.getUserId() %></td>
                            <td><%= u.getFullName() %></td>
                            <td><%= u.getEmail() %></td>
                            <td><span class="badge badge-<%= "ADMIN".equals(u.getRole().name())?"danger":"success" %>"><%= u.getRole() %></span></td>
                            <td><%= u.getPhone() != null ? u.getPhone() : "-" %></td>
                            <td><span class="badge badge-<%= u.isActive()?"success":"warning" %>"><%= u.isActive()?"Active":"Inactive" %></span></td>
                            <td style="display:flex; gap:0.5rem;">
                                <a href="<%= request.getContextPath() %>/admin/users?action=edit&id=<%= u.getUserId() %>" class="btn btn-secondary" style="padding:0.4rem 0.8rem; font-size:0.85rem;">Edit</a>
                                <a href="<%= request.getContextPath() %>/admin/users?action=delete&id=<%= u.getUserId() %>" class="btn btn-secondary" style="padding:0.4rem 0.8rem; font-size:0.85rem; color:var(--color-danger);" onclick="return confirm('Are you sure you want to delete this user?')">Delete</a>
                            </td>
                        </tr>
                    <% } %>
                    <% if (users == null || users.isEmpty()) { %><tr><td colspan="7" style="text-align:center; padding:2rem; color:var(--color-text-muted);">No users found.</td></tr><% } %>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</div>
</body>
</html>
