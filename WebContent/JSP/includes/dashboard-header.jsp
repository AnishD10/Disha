<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    String roleName = "User";
    String uRole = (String) session.getAttribute("userRole");
    if (uRole != null) {
        if ("STUDENT".equalsIgnoreCase(uRole)) roleName = "Student";
        else if ("PARENT".equalsIgnoreCase(uRole)) roleName = "Parent";
        else if ("COUNSELOR".equalsIgnoreCase(uRole)) roleName = "Counselor";
        else if ("ADMIN".equalsIgnoreCase(uRole)) roleName = "Admin";
    }
    
    // Attempt fallback from URI if session is null for frontend testing
    if (uRole == null) {
        String uri = request.getRequestURI();
        if (uri.contains("/student/")) roleName = "Student";
        else if (uri.contains("/parent/")) roleName = "Parent";
        else if (uri.contains("/counselor/")) roleName = "Counselor";
        else if (uri.contains("/admin/")) roleName = "Admin";
    }
    
    // User initial
    String fName = (String) session.getAttribute("userName");
    String initial = "U";
    if (fName != null && !fName.trim().isEmpty()) {
        initial = fName.trim().substring(0, 1).toUpperCase();
    } else {
        initial = roleName.substring(0, 1).toUpperCase();
    }
%>
<header class="dashboard-header">
    <div class="header-search">
        <% if (!"Admin".equalsIgnoreCase(roleName)) { %>
            <input type="text" placeholder="Search careers, colleges, paths...">
        <% } else { %>
            <input type="text" placeholder="Search users, records...">
        <% } %>
    </div>
    
    <div class="header-user">
        <span class="user-role-badge"><%= roleName %></span>
        <a href="<%= request.getContextPath() %>/profile" class="avatar avatar-link" title="View profile"><%= initial %></a>
    </div>
</header>
