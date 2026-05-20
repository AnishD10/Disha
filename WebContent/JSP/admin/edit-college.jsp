<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.disha.model.User, com.disha.model.College" %>
<%
    User cu = (User)session.getAttribute("loggedInUser");
    if(cu==null||!"ADMIN".equals(cu.getRole().name())){response.sendRedirect(request.getContextPath()+"/JSP/auth/login.jsp");return;}
    College c = (College) request.getAttribute("editCollege");
    if(c==null){response.sendRedirect(request.getContextPath()+"/admin/colleges");return;}
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Edit College - DISHA Admin</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/disha-main.css">
</head>
<body>
<div class="dashboard-layout">
    <jsp:include page="../includes/sidebar.jsp" />
    <div class="main-content">
        <jsp:include page="../includes/dashboard-header.jsp" />
        <div class="dashboard-body">
            <h1 class="page-title" style="color:var(--color-primary);">Edit College: <%= c.getCollegeName() %></h1>
            <div class="card" style="max-width:650px;">
                <form method="POST" action="<%= request.getContextPath() %>/admin/colleges">
                    <input type="hidden" name="action" value="edit">
                    <input type="hidden" name="collegeId" value="<%= c.getCollegeId() %>">
                    <div class="form-group">
                        <label>College Name *</label>
                        <input type="text" name="collegeName" required value="<%= c.getCollegeName() %>">
                    </div>
                    <div class="form-row">
                        <div class="form-group">
                            <label>Location</label>
                            <input type="text" name="collegeLocation" value="<%= c.getCollegeLocation() != null ? c.getCollegeLocation() : "" %>">
                        </div>
                        <div class="form-group">
                            <label>City</label>
                            <input type="text" name="collegeCity" value="<%= c.getCollegeCity() != null ? c.getCollegeCity() : "" %>">
                        </div>
                    </div>
                    <div class="form-group">
                        <label>Description</label>
                        <textarea name="collegeDescription" rows="3" style="width:100%;padding:0.75rem;border:1px solid var(--color-border);border-radius:var(--radius-md);font-family:var(--font-family);resize:vertical;"><%= c.getCollegeDescription() != null ? c.getCollegeDescription() : "" %></textarea>
                    </div>
                    <div class="form-group">
                        <label>Website URL</label>
                        <input type="url" name="websiteUrl" value="<%= c.getWebsiteUrl() != null ? c.getWebsiteUrl() : "" %>">
                    </div>
                    <div class="form-row">
                        <div class="form-group">
                            <label>Contact Email</label>
                            <input type="email" name="contactEmail" value="<%= c.getContactEmail() != null ? c.getContactEmail() : "" %>">
                        </div>
                        <div class="form-group">
                            <label>Contact Phone</label>
                            <input type="tel" name="contactPhone" value="<%= c.getContactPhone() != null ? c.getContactPhone() : "" %>">
                        </div>
                    </div>
                    <div style="display:flex; gap:2rem; margin-bottom:1.25rem;">
                        <div style="display:flex;align-items:center;gap:0.5rem;">
                            <input type="checkbox" name="isPublic" style="width:auto;" <%= c.isPublic()?"checked":"" %>>
                            <label style="margin:0;">Public Institution</label>
                        </div>
                        <div style="display:flex;align-items:center;gap:0.5rem;">
                            <input type="checkbox" name="isVerified" style="width:auto;" <%= c.isVerified()?"checked":"" %>>
                            <label style="margin:0;">Verified</label>
                        </div>
                    </div>
                    <div style="display:flex;gap:1rem;">
                        <button type="submit" class="btn btn-primary">Save Changes</button>
                        <a href="<%= request.getContextPath() %>/admin/colleges" class="btn btn-secondary">Cancel</a>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>
</body>
</html>
