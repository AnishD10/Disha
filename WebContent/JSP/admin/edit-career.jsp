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
    <title>Edit Career - DISHA Admin</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/disha-main.css">
</head>
<body>
<div class="dashboard-layout">
    <jsp:include page="../includes/sidebar.jsp" />
    <div class="main-content">
        <jsp:include page="../includes/dashboard-header.jsp" />
        <div class="dashboard-body">
            <h1 class="page-title" style="color:var(--color-primary);">Edit Career: <%= c.getCareerName() %></h1>
            <div class="card" style="max-width:900px;">
                <form method="POST" action="<%= request.getContextPath() %>/admin/careers">
                    <input type="hidden" name="action" value="edit">
                    <input type="hidden" name="careerId" value="<%= c.getCareerId() %>">

                    <div class="form-row">
                        <div class="form-group">
                            <label>Career Name *</label>
                            <input type="text" name="careerName" required value="<%= c.getCareerName() %>">
                        </div>
                        <div class="form-group">
                            <label>Industry *</label>
                            <input type="text" name="industry" required value="<%= c.getIndustry() != null ? c.getIndustry() : "" %>">
                        </div>
                    </div>

                    <div class="form-group">
                        <label>Overview *</label>
                        <textarea name="overview" rows="3" required style="width:100%;padding:0.75rem;border:1px solid var(--color-border);border-radius:var(--radius-md);font-family:var(--font-family);resize:vertical;"><%= c.getOverview() != null ? c.getOverview() : "" %></textarea>
                    </div>

                    <div class="form-group">
                        <label>Description *</label>
                        <textarea name="description" rows="3" required style="width:100%;padding:0.75rem;border:1px solid var(--color-border);border-radius:var(--radius-md);font-family:var(--font-family);resize:vertical;"><%= c.getDescription() != null ? c.getDescription() : "" %></textarea>
                    </div>

                    <div class="form-row">
                        <div class="form-group">
                            <label>Responsibilities *</label>
                            <textarea name="responsibilities" rows="4" required style="width:100%;padding:0.75rem;border:1px solid var(--color-border);border-radius:var(--radius-md);font-family:var(--font-family);resize:vertical;"><%= c.getResponsibilities() != null ? c.getResponsibilities() : "" %></textarea>
                        </div>
                        <div class="form-group">
                            <label>Future Scope *</label>
                            <textarea name="futureScope" rows="4" required style="width:100%;padding:0.75rem;border:1px solid var(--color-border);border-radius:var(--radius-md);font-family:var(--font-family);resize:vertical;"><%= c.getFutureScope() != null ? c.getFutureScope() : "" %></textarea>
                        </div>
                    </div>

                    <div class="form-row">
                        <div class="form-group">
                            <label>Entry Salary (NPR)</label>
                            <input type="number" name="salaryEntry" min="0" step="1000" value="<%= c.getSalaryEntry() != null ? c.getSalaryEntry() : 0 %>">
                        </div>
                        <div class="form-group">
                            <label>Mid Salary (NPR)</label>
                            <input type="number" name="salaryMid" min="0" step="1000" value="<%= c.getSalaryMid() != null ? c.getSalaryMid() : 0 %>">
                        </div>
                        <div class="form-group">
                            <label>Senior Salary (NPR)</label>
                            <input type="number" name="salarySenior" min="0" step="1000" value="<%= c.getSalarySenior() != null ? c.getSalarySenior() : 0 %>">
                        </div>
                    </div>

                    <div class="form-row">
                        <div class="form-group">
                            <label>Demand Level</label>
                            <select name="demandLevel"><option value="HIGH" <%= "HIGH".equals(c.getDemandLevel())?"selected":"" %>>High</option><option value="MEDIUM" <%= "MEDIUM".equals(c.getDemandLevel())?"selected":"" %>>Medium</option><option value="LOW" <%= "LOW".equals(c.getDemandLevel())?"selected":"" %>>Low</option></select>
                        </div>
                        <div class="form-group">
                            <label>Automation Risk</label>
                            <select name="automationRisk"><option value="LOW" <%= "LOW".equals(c.getAutomationRisk())?"selected":"" %>>Low</option><option value="MEDIUM" <%= "MEDIUM".equals(c.getAutomationRisk())?"selected":"" %>>Medium</option><option value="HIGH" <%= "HIGH".equals(c.getAutomationRisk())?"selected":"" %>>High</option></select>
                        </div>
                        <div class="form-group">
                            <label>Remote Opportunity</label>
                            <select name="remoteOpportunity"><option value="LOW" <%= "LOW".equals(c.getRemoteOpportunity())?"selected":"" %>>Low</option><option value="MEDIUM" <%= "MEDIUM".equals(c.getRemoteOpportunity())?"selected":"" %>>Medium</option><option value="HIGH" <%= "HIGH".equals(c.getRemoteOpportunity())?"selected":"" %>>High</option></select>
                        </div>
                    </div>

                    <div class="form-row">
                        <div class="form-group">
                            <label>Growth Rate (%)</label>
                            <input type="number" name="growthRate" step="0.01" value="<%= c.getGrowthRate() != null ? c.getGrowthRate() : 0 %>">
                        </div>
                        <div class="form-group">
                            <label>Suggested Certifications</label>
                            <input type="text" name="suggestedCertifications" value="<%= c.getSuggestedCertifications() != null ? c.getSuggestedCertifications() : "" %>">
                        </div>
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
