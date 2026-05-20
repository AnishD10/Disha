<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.disha.model.User" %>
<% User cu=(User)session.getAttribute("loggedInUser"); if(cu==null||!"ADMIN".equals(cu.getRole().name())){response.sendRedirect(request.getContextPath()+"/JSP/auth/login.jsp");return;}
User editUser=(User)request.getAttribute("editUser"); if(editUser==null){response.sendRedirect(request.getContextPath()+"/admin/users");return;} %>
<!DOCTYPE html><html lang="en"><head><meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0"><title>Edit User - DISHA</title><link rel="stylesheet" href="<%= request.getContextPath() %>/css/disha-main.css"></head><body>
<div class="dashboard-layout"><jsp:include page="../includes/sidebar.jsp" /><div class="main-content"><jsp:include page="../includes/dashboard-header.jsp" />
<div class="dashboard-body">
    <h1 class="page-title" style="color:var(--color-primary);">Edit User #<%= editUser.getUserId() %></h1>
    <div class="card" style="max-width:600px;">
        <form method="POST" action="<%= request.getContextPath() %>/admin/users">
            <input type="hidden" name="action" value="edit">
            <input type="hidden" name="userId" value="<%= editUser.getUserId() %>">
            <div class="form-row"><div class="form-group"><label>First Name</label><input type="text" name="firstName" value="<%= editUser.getFirstName()!=null?editUser.getFirstName():"" %>"></div><div class="form-group"><label>Last Name</label><input type="text" name="lastName" value="<%= editUser.getLastName()!=null?editUser.getLastName():"" %>"></div></div>
            <div class="form-group"><label>Email</label><input type="email" name="email" value="<%= editUser.getEmail() %>"></div>
            <div class="form-group"><label>Phone</label><input type="tel" name="phone" value="<%= editUser.getPhone()!=null?editUser.getPhone():"" %>"></div>
            <div class="form-group"><label>Role</label><select name="role"><option value="STUDENT" <%= "STUDENT".equals(editUser.getRole().name())?"selected":"" %>>Student</option><option value="PARENT" <%= "PARENT".equals(editUser.getRole().name())?"selected":"" %>>Parent</option><option value="COUNSELOR" <%= "COUNSELOR".equals(editUser.getRole().name())?"selected":"" %>>Counselor</option><option value="ADMIN" <%= "ADMIN".equals(editUser.getRole().name())?"selected":"" %>>Admin</option></select></div>
            <div class="form-group" style="display:flex;align-items:center;gap:0.5rem;"><input type="checkbox" name="isActive" style="width:auto;" <%= editUser.isActive()?"checked":"" %>><label style="margin:0;">Active</label></div>
            <div style="display:flex;gap:1rem;"><button type="submit" class="btn btn-primary">Save Changes</button><a href="<%= request.getContextPath() %>/admin/users" class="btn btn-secondary">Cancel</a></div>
        </form>
    </div>
</div></div></div></body></html>
