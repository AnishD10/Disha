<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.disha.model.User" %>
<% User cu = (User)session.getAttribute("loggedInUser"); if(cu==null||!"ADMIN".equals(cu.getRole().name())){response.sendRedirect(request.getContextPath()+"/JSP/auth/login.jsp");return;} %>
<!DOCTYPE html><html lang="en"><head><meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0"><title>Add User â€” DISHA</title><link rel="stylesheet" href="<%= request.getContextPath() %>/css/disha-main.css"></head><body>
<div class="dashboard-layout"><jsp:include page="../includes/sidebar.jsp" /><div class="main-content"><jsp:include page="../includes/dashboard-header.jsp" />
<div class="dashboard-body">
    <h1 class="page-title" style="color:var(--color-primary);">Add New User</h1>
    <% if(request.getAttribute("errorMessage")!=null){ %><div class="alert alert-error"><%= request.getAttribute("errorMessage") %></div><% } %>
    <div class="card" style="max-width:600px;">
        <form method="POST" action="<%= request.getContextPath() %>/admin/users">
            <input type="hidden" name="action" value="add">
            <div class="form-row"><div class="form-group"><label>First Name *</label><input type="text" name="firstName" required></div><div class="form-group"><label>Last Name</label><input type="text" name="lastName"></div></div>
            <div class="form-group"><label>Email *</label><input type="email" name="email" required></div>
            <div class="form-group"><label>Phone</label><input type="tel" name="phone"></div>
            <div class="form-group"><label>Role *</label><select name="role" required><option value="STUDENT">Student</option><option value="PARENT">Parent</option><option value="COUNSELOR">Counselor</option><option value="ADMIN">Admin</option></select></div>
            <div class="form-group"><label>Password *</label><input type="password" name="password" required minlength="8"></div>
            <div style="display:flex;gap:1rem;"><button type="submit" class="btn btn-primary">Create User</button><a href="<%= request.getContextPath() %>/admin/users" class="btn btn-secondary">Cancel</a></div>
        </form>
    </div>
</div></div></div></body></html>
