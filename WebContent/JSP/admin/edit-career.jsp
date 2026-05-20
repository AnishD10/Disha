<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.disha.model.User, com.disha.model.Career" %>
<%
    User cu = (User)session.getAttribute("loggedInUser");
    if(cu==null||!"ADMIN".equals(cu.getRole().name())){response.sendRedirect(request.getContextPath()+"/JSP/auth/login.jsp");return;}
    Career c = (Career) request.getAttribute("editCareer");
    if(c==null){response.sendRedirect(request.getContextPath()+"/admin/careers");return;}
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Edit Career — DISHA Admin</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/CSS/disha-main.css">
</head>
<body>
<div class="dashboard-layout">
    <jsp:include page="../includes/sidebar.jsp" />
    <div class="main-content">
        <jsp:include page="../includes/dashboard-header.jsp" />
        <div class="dashboard-body">
            <h1 class="page-title" style="color:var(--color-primary);">Edit Career: <%= c.getCareerName() %></h1>
            <div class="card" style="max-width:650px;">
                <form method="POST" action="<%= request.getContextPath() %>/admin/careers">
                    <input type="hidden" name="action" value="edit">
                    <input type="hidden" name="careerId" value="<%= c.getCareerId() %>">
                    <div class="form-group">
                        <label>Career Name *</label>
                        <input type="text" name="careerName" required value="<%= c.getCareerName() %>">
                    </div>
                    <div class="form-group">
                        <label>Description</label>
                        <textarea name="careerDescription" rows="3" style="width:100%;padding:0.75rem;border:1px solid var(--color-border);border-radius:var(--radius-md);font-family:var(--font-family);resize:vertical;"><%= c.getCareerDescription() != null ? c.getCareerDescription() : "" %></textarea>
                    </div>
                    <div class="form-row">
                        <div class="form-group">
                            <label>Aptitude Cluster</label>
                            <select name="requiredAptitudeCluster">
                                <option value="Analytical" <%= "Analytical".equals(c.getRequiredAptitudeCluster())?"selected":"" %>>Analytical</option>
                                <option value="Technical" <%= "Technical".equals(c.getRequiredAptitudeCluster())?"selected":"" %>>Technical</option>
                                <option value="Creative" <%= "Creative".equals(c.getRequiredAptitudeCluster())?"selected":"" %>>Creative</option>
                                <option value="Scientific" <%= "Scientific".equals(c.getRequiredAptitudeCluster())?"selected":"" %>>Scientific</option>
                                <option value="Interpersonal" <%= "Interpersonal".equals(c.getRequiredAptitudeCluster())?"selected":"" %>>Interpersonal</option>
                                <option value="Numerical" <%= "Numerical".equals(c.getRequiredAptitudeCluster())?"selected":"" %>>Numerical</option>
                            </select>
                        </div>
                        <div class="form-group">
                            <label>Market Demand</label>
                            <select name="marketDemand">
                                <option value="HIGH" <%= "HIGH".equals(c.getMarketDemand())?"selected":"" %>>High</option>
                                <option value="MEDIUM" <%= "MEDIUM".equals(c.getMarketDemand())?"selected":"" %>>Medium</option>
                                <option value="LOW" <%= "LOW".equals(c.getMarketDemand())?"selected":"" %>>Low</option>
                            </select>
                        </div>
                    </div>
                    <div class="form-row">
                        <div class="form-group">
                            <label>Average Salary (NPR)</label>
                            <input type="number" name="averageSalary" step="1000" value="<%= c.getAverageSalary() != null ? c.getAverageSalary().intValue() : "" %>">
                        </div>
                        <div class="form-group">
                            <label>Risk Index (1-10)</label>
                            <input type="number" name="riskIndex" min="1" max="10" value="<%= c.getRiskIndex() %>">
                        </div>
                    </div>
                    <div class="form-group">
                        <label>Growth Rate (%)</label>
                        <input type="number" name="jobMarketGrowthRate" step="0.01" value="<%= c.getJobMarketGrowthRate() != null ? c.getJobMarketGrowthRate() : "" %>">
                    </div>
                    <div style="display:flex;gap:1rem;">
                        <button type="submit" class="btn btn-primary">Save Changes</button>
                        <a href="<%= request.getContextPath() %>/admin/careers" class="btn btn-secondary">Cancel</a>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>
</body>
</html>
