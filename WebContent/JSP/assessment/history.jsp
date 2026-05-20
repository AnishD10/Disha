<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, com.disha.model.assessment.AssessmentAttempt" %>
<%
    List<AssessmentAttempt> attempts = (List<AssessmentAttempt>) request.getAttribute("attempts");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Assessment History - DISHA</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/disha-main.css">
</head>
<body>
<div class="dashboard-layout">
    <jsp:include page="../includes/sidebar.jsp" />
    <div class="main-content">
        <jsp:include page="../includes/dashboard-header.jsp" />
        <main class="dashboard-body">
            <div class="page-header" style="margin-bottom:2rem;">
                <h1 style="color:var(--color-primary);">Assessment History</h1>
                <a href="<%= request.getContextPath() %>/assessment/start" class="btn btn-primary" style="width:auto;">Take New Test</a>
            </div>
            <div class="card">
                <table class="table">
                    <thead><tr><th>Date</th><th>Cluster</th><th>Aptitude</th><th>Personality</th><th>Interest</th><th></th></tr></thead>
                    <tbody>
                    <% if (attempts != null && !attempts.isEmpty()) {
                        for (AssessmentAttempt attempt : attempts) { %>
                        <tr>
                            <td><%= attempt.getAttemptDate() %></td>
                            <td><%= attempt.getPersonalityCluster() %></td>
                            <td><%= attempt.getAptitudeScore() %>/10</td>
                            <td><%= attempt.getPersonalityScore() %>/50</td>
                            <td><%= attempt.getInterestScore() %>/50</td>
                            <td><a href="<%= request.getContextPath() %>/assessment/result?attemptId=<%= attempt.getAttemptId() %>">View</a></td>
                        </tr>
                    <%  }
                    } else { %>
                        <tr><td colspan="6" style="text-align:center; color:var(--color-text-muted);">No completed assessments yet.</td></tr>
                    <% } %>
                    </tbody>
                </table>
            </div>
        </main>
    </div>
</div>
</body>
</html>
