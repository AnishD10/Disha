<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.disha.model.User" %>
<% User cu = (User)session.getAttribute("loggedInUser"); if(cu==null||!"ADMIN".equals(cu.getRole().name())){response.sendRedirect(request.getContextPath()+"/JSP/auth/login.jsp");return;} %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Add Career — DISHA Admin</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/CSS/disha-main.css">
</head>
<body>
<div class="dashboard-layout">
    <jsp:include page="../includes/sidebar.jsp" />
    <div class="main-content">
        <jsp:include page="../includes/dashboard-header.jsp" />
        <div class="dashboard-body">
            <h1 class="page-title" style="color:var(--color-primary);">Add New Career</h1>
            <div class="card" style="max-width:650px;">
                <form method="POST" action="<%= request.getContextPath() %>/admin/careers">
                    <input type="hidden" name="action" value="add">
                    <div class="form-group">
                        <label>Career Name *</label>
                        <input type="text" name="careerName" required placeholder="e.g. Software Engineer">
                    </div>
                    <div class="form-group">
                        <label>Description</label>
                        <textarea name="careerDescription" rows="3" style="width:100%;padding:0.75rem;border:1px solid var(--color-border);border-radius:var(--radius-md);font-family:var(--font-family);resize:vertical;" placeholder="Brief description of the career path..."></textarea>
                    </div>
                    <div class="form-row">
                        <div class="form-group">
                            <label>Aptitude Cluster</label>
                            <select name="requiredAptitudeCluster">
                                <option value="Analytical">Analytical</option>
                                <option value="Technical">Technical</option>
                                <option value="Creative">Creative</option>
                                <option value="Scientific">Scientific</option>
                                <option value="Interpersonal">Interpersonal</option>
                                <option value="Numerical">Numerical</option>
                            </select>
                        </div>
                        <div class="form-group">
                            <label>Market Demand</label>
                            <select name="marketDemand">
                                <option value="HIGH">High</option>
                                <option value="MEDIUM">Medium</option>
                                <option value="LOW">Low</option>
                            </select>
                        </div>
                    </div>
                    <div class="form-row">
                        <div class="form-group">
                            <label>Average Salary (NPR/month)</label>
                            <input type="number" name="averageSalary" placeholder="e.g. 80000" step="1000">
                        </div>
                        <div class="form-group">
                            <label>Risk Index (1-10)</label>
                            <input type="number" name="riskIndex" min="1" max="10" value="5">
                        </div>
                    </div>
                    <div class="form-group">
                        <label>Growth Rate (%)</label>
                        <input type="number" name="jobMarketGrowthRate" step="0.01" placeholder="e.g. 12.5">
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
