<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.disha.model.User" %>
<% User cu = (User)session.getAttribute("loggedInUser"); if(cu==null||!"ADMIN".equals(cu.getRole().name())){response.sendRedirect(request.getContextPath()+"/JSP/auth/login.jsp");return;} %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Add Career - DISHA Admin</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/disha-main.css">
</head>
<body>
<div class="dashboard-layout">
    <jsp:include page="../includes/sidebar.jsp" />
    <div class="main-content">
        <jsp:include page="../includes/dashboard-header.jsp" />
        <div class="dashboard-body">
            <h1 class="page-title" style="color:var(--color-primary);">Add New Career</h1>
            <div class="card" style="max-width:900px;">
                <form method="POST" action="<%= request.getContextPath() %>/admin/careers">
                    <input type="hidden" name="action" value="add">

                    <div class="form-row">
                        <div class="form-group">
                            <label>Career Name *</label>
                            <input type="text" name="careerName" required placeholder="e.g. Software Engineer">
                        </div>
                        <div class="form-group">
                            <label>Industry *</label>
                            <input type="text" name="industry" required placeholder="e.g. Technology">
                        </div>
                    </div>

                    <div class="form-group">
                        <label>Overview *</label>
                        <textarea name="overview" rows="3" required style="width:100%;padding:0.75rem;border:1px solid var(--color-border);border-radius:var(--radius-md);font-family:var(--font-family);resize:vertical;"></textarea>
                    </div>

                    <div class="form-group">
                        <label>Description *</label>
                        <textarea name="description" rows="3" required style="width:100%;padding:0.75rem;border:1px solid var(--color-border);border-radius:var(--radius-md);font-family:var(--font-family);resize:vertical;"></textarea>
                    </div>

                    <div class="form-row">
                        <div class="form-group">
                            <label>Responsibilities *</label>
                            <textarea name="responsibilities" rows="4" required style="width:100%;padding:0.75rem;border:1px solid var(--color-border);border-radius:var(--radius-md);font-family:var(--font-family);resize:vertical;"></textarea>
                        </div>
                        <div class="form-group">
                            <label>Future Scope *</label>
                            <textarea name="futureScope" rows="4" required style="width:100%;padding:0.75rem;border:1px solid var(--color-border);border-radius:var(--radius-md);font-family:var(--font-family);resize:vertical;"></textarea>
                        </div>
                    </div>

                    <div class="form-row">
                        <div class="form-group">
                            <label>Entry Salary (NPR)</label>
                            <input type="number" name="salaryEntry" min="0" step="1000" value="0">
                        </div>
                        <div class="form-group">
                            <label>Mid Salary (NPR)</label>
                            <input type="number" name="salaryMid" min="0" step="1000" value="0">
                        </div>
                        <div class="form-group">
                            <label>Senior Salary (NPR)</label>
                            <input type="number" name="salarySenior" min="0" step="1000" value="0">
                        </div>
                    </div>

                    <div class="form-row">
                        <div class="form-group">
                            <label>Demand Level</label>
                            <select name="demandLevel"><option value="HIGH">High</option><option value="MEDIUM" selected>Medium</option><option value="LOW">Low</option></select>
                        </div>
                        <div class="form-group">
                            <label>Automation Risk</label>
                            <select name="automationRisk"><option value="LOW">Low</option><option value="MEDIUM" selected>Medium</option><option value="HIGH">High</option></select>
                        </div>
                        <div class="form-group">
                            <label>Remote Opportunity</label>
                            <select name="remoteOpportunity"><option value="LOW">Low</option><option value="MEDIUM" selected>Medium</option><option value="HIGH">High</option></select>
                        </div>
                    </div>

                    <div class="form-row">
                        <div class="form-group">
                            <label>Growth Rate (%)</label>
                            <input type="number" name="growthRate" step="0.01" value="0">
                        </div>
                        <div class="form-group">
                            <label>Suggested Certifications</label>
                            <input type="text" name="suggestedCertifications" placeholder="e.g. Java, AWS, Google Analytics">
                        </div>
                    </div>

                    <div style="display:flex;gap:1rem;">
                        <button type="submit" class="btn btn-primary">Add Career</button>
                        <a href="<%= request.getContextPath() %>/admin/careers" class="btn btn-secondary">Cancel</a>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>
</body>
</html>
