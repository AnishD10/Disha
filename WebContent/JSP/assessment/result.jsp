<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.disha.model.assessment.AssessmentReport, com.disha.model.assessment.AttemptSkill, com.disha.model.assessment.NepalCareer" %>
<%
    AssessmentReport report = (AssessmentReport) request.getAttribute("report");
    if (report == null || report.getAttempt() == null) {
        response.sendRedirect(request.getContextPath() + "/assessment/history");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Assessment Result - DISHA</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/disha-main.css">
</head>
<body>
<div class="dashboard-layout">
    <jsp:include page="../includes/sidebar.jsp" />
    <div class="main-content">
        <jsp:include page="../includes/dashboard-header.jsp" />
        <main class="dashboard-body">
            <div class="page-header" style="margin-bottom:2rem;">
                <h1 style="color:var(--color-primary);">Assessment Result</h1>
                <p style="color:var(--color-text-muted);">Your dominant cluster is <strong><%= report.getAttempt().getPersonalityCluster() %></strong>.</p>
            </div>
            <div class="grid-cards">
                <div class="card stat-card"><span class="stat-card-title">Aptitude</span><span class="stat-card-value"><%= report.getAttempt().getAptitudeScore() %>/10</span></div>
                <div class="card stat-card"><span class="stat-card-title">Personality</span><span class="stat-card-value"><%= report.getAttempt().getPersonalityScore() %>/50</span></div>
                <div class="card stat-card"><span class="stat-card-title">Interest</span><span class="stat-card-value"><%= report.getAttempt().getInterestScore() %>/50</span></div>
            </div>
            <div class="card" style="margin-bottom:2rem;">
                <h3 style="margin-bottom:1rem;">Skill Profile</h3>
                <% for (AttemptSkill skill : report.getSkills()) { %>
                    <p><strong><%= skill.getSkillName() %>:</strong> <%= skill.getSkillScore() %> - <%= skill.getSkillLevel() %></p>
                <% } %>
            </div>
            <div class="card">
                <h3 style="margin-bottom:1rem;">Recommended Careers</h3>
                <% for (NepalCareer career : report.getTopCareers()) { %>
                    <div style="padding:1rem 0; border-bottom:1px solid var(--color-border-soft);">
                        <h4><%= career.getCareerName() %></h4>
                        <p style="color:var(--color-text-muted);"><%= career.getCareerDescription() %></p>
                        <p style="font-size:.9rem;"><%= career.getNepalRelevanceNote() %></p>
                    </div>
                <% } %>
                <div style="margin-top:1rem;">
                    <a href="<%= request.getContextPath() %>/assessment/history" class="btn btn-secondary" style="width:auto;">View History</a>
                    <a href="<%= request.getContextPath() %>/career" class="btn btn-primary" style="width:auto;">Explore Careers</a>
                </div>
            </div>
        </main>
    </div>
</div>
</body>
</html>
