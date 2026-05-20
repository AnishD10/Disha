<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.disha.model.User" %>
<%@ page import="com.disha.model.counselor.CounselorDashboardData" %>
<%@ page import="com.disha.model.counselor.CounselorDashboardData.StudentSummary" %>
<%@ page import="com.disha.model.counselor.CounselorDashboardData.ClusterStat" %>
<%@ page import="com.disha.model.counselor.CounselorDashboardData.CareerInterestStat" %>
<%@ page import="java.util.List" %>
<%!
    private String h(Object value) {
        if (value == null) return "";
        return String.valueOf(value)
                .replace("&", "&amp;")
                .replace("<", "&lt;")
                .replace(">", "&gt;")
                .replace("\"", "&quot;");
    }

    private String show(Object value, String fallback) {
        return value == null || String.valueOf(value).trim().isEmpty() ? fallback : String.valueOf(value);
    }
%>
<%
    User currentUser = (User) session.getAttribute("loggedInUser");
    if (currentUser == null) {
        response.sendRedirect(request.getContextPath() + "/JSP/auth/login.jsp");
        return;
    }

    CounselorDashboardData dashboardData = (CounselorDashboardData) request.getAttribute("dashboardData");
    String errorMessage = (String) request.getAttribute("errorMessage");
    if (dashboardData == null && errorMessage == null) {
        response.sendRedirect(request.getContextPath() + "/counselor/dashboard");
        return;
    }

    String search = (String) request.getAttribute("search");
    if (search == null) search = "";
    boolean flaggedOnly = Boolean.TRUE.equals(request.getAttribute("flaggedOnly"));
    List<StudentSummary> students = dashboardData != null ? dashboardData.getStudents() : null;
    List<ClusterStat> clusterStats = dashboardData != null ? dashboardData.getClusterStats() : null;
    List<CareerInterestStat> careerStats = dashboardData != null ? dashboardData.getCareerInterestStats() : null;

    String addError = request.getParameter("addError");
    String flagError = request.getParameter("flagError");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Counselor Dashboard - DISHA</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/disha-main.css">
    <style>
        @media (max-width: 900px) {
            .counselor-dashboard-grid {
                grid-template-columns: 1fr !important;
            }
        }
    </style>
</head>
<body>
<div class="dashboard-layout">
    <jsp:include page="../includes/sidebar.jsp" />

    <div class="main-content">
        <jsp:include page="../includes/dashboard-header.jsp" />

        <div class="dashboard-body">
            <div class="page-header mb-3">
                <h1 class="page-title">Counselor Dashboard</h1>
                <p style="color: var(--color-text-muted); max-width: 780px;">
                    Monitor student assessments, identify urgent guidance needs, compare interest patterns,
                    and export counseling reports.
                </p>
            </div>

            <% if (errorMessage != null) { %>
                <div class="alert alert-error"><%= h(errorMessage) %></div>
            <% } %>
            <% if ("true".equals(request.getParameter("addSuccess"))) { %>
                <div class="alert alert-success">Student account created successfully.</div>
            <% } else if (addError != null) { %>
                <div class="alert alert-error">
                    <% if ("duplicate".equals(addError)) { %>
                        A student with that email already exists.
                    <% } else if ("password".equals(addError)) { %>
                        Password must be at least 8 characters and include letters and numbers.
                    <% } else if ("empty".equals(addError)) { %>
                        Please fill in all student fields.
                    <% } else { %>
                        Student account could not be created.
                    <% } %>
                </div>
            <% } %>
            <% if ("true".equals(request.getParameter("flagSuccess"))) { %>
                <div class="alert alert-success">Student guidance status updated.</div>
            <% } else if (flagError != null) { %>
                <div class="alert alert-error">Student guidance status could not be updated.</div>
            <% } %>

            <% if (dashboardData != null) { %>
                <div class="grid-cards">
                    <div class="card stat-card">
                        <span class="stat-card-title">Total Students</span>
                        <span class="stat-card-value"><%= dashboardData.getTotalStudents() %></span>
                    </div>
                    <div class="card stat-card">
                        <span class="stat-card-title">Completed Assessments</span>
                        <span class="stat-card-value"><%= dashboardData.getCompletedAssessments() %></span>
                    </div>
                    <div class="card stat-card">
                        <span class="stat-card-title">Needs Immediate Support</span>
                        <span class="stat-card-value"><%= dashboardData.getFlaggedStudents() %></span>
                    </div>
                    <div class="card stat-card">
                        <span class="stat-card-title">Average Aptitude</span>
                        <span class="stat-card-value"><%= String.format("%.1f", dashboardData.getAverageAptitudeScore()) %></span>
                        <span style="color: var(--color-text-muted);">Top cluster: <%= h(show(dashboardData.getTopCluster(), "N/A")) %></span>
                    </div>
                </div>

                <div class="counselor-dashboard-grid" style="display: grid; grid-template-columns: 2fr 1fr; gap: 1.5rem; align-items: start;">
                    <div class="card">
                        <div style="display: flex; justify-content: space-between; align-items: flex-end; gap: 1rem; flex-wrap: wrap; margin-bottom: 1rem;">
                            <div>
                                <h2 style="margin-bottom: 0.35rem;">My Students</h2>
                                <p style="color: var(--color-text-muted);">Search, filter, flag, and export student reports.</p>
                            </div>
                            <a class="btn btn-secondary" href="<%= request.getContextPath() %>/counselor/export">Export CSV</a>
                        </div>

                        <form method="get" action="<%= request.getContextPath() %>/counselor/dashboard"
                              style="display: flex; gap: 0.75rem; align-items: end; flex-wrap: wrap; margin-bottom: 1rem;">
                            <div style="min-width: 260px; flex: 1;">
                                <label for="search">Search students</label>
                                <input id="search" name="search" value="<%= h(search) %>" placeholder="Name or email">
                            </div>
                            <label style="display: flex; align-items: center; gap: 0.5rem; margin-bottom: 0.8rem;">
                                <input type="checkbox" name="flaggedOnly" value="true" <%= flaggedOnly ? "checked" : "" %>
                                       style="width: auto;">
                                At-risk only
                            </label>
                            <button class="btn btn-primary" type="submit">Apply</button>
                        </form>

                        <div class="table-container">
                            <table class="table">
                                <thead>
                                <tr>
                                    <th>Student</th>
                                    <th>Latest Assessment</th>
                                    <th>Cluster</th>
                                    <th>Status</th>
                                    <th>Guidance Action</th>
                                </tr>
                                </thead>
                                <tbody>
                                <% if (students == null || students.isEmpty()) { %>
                                    <tr>
                                        <td colspan="5" style="color: var(--color-text-muted);">
                                            No students found for this filter.
                                        </td>
                                    </tr>
                                <% } else {
                                    for (StudentSummary student : students) { %>
                                        <tr>
                                            <td>
                                                <strong><%= h(student.getFullName()) %></strong><br>
                                                <span style="color: var(--color-text-muted); font-size: 0.9rem;">
                                                    <%= h(student.getEmail()) %>
                                                </span>
                                            </td>
                                            <td>
                                                <% if (student.hasCompletedAssessment()) { %>
                                                    <span class="badge badge-success">Completed</span>
                                                    <div style="margin-top: 0.35rem;">Aptitude: <%= student.getAptitudeScore() %></div>
                                                <% } else { %>
                                                    <span class="badge badge-warning">Pending</span>
                                                <% } %>
                                            </td>
                                            <td><%= h(show(student.getPersonalityCluster(), "N/A")) %></td>
                                            <td>
                                                <% if (student.isAtRisk()) { %>
                                                    <span class="badge badge-danger">At risk</span>
                                                <% } else { %>
                                                    <span class="badge badge-success">Active</span>
                                                <% } %>
                                                <% if (student.getCounselorNote() != null && !student.getCounselorNote().trim().isEmpty()) { %>
                                                    <div style="margin-top: 0.4rem; color: var(--color-text-muted); font-size: 0.85rem;">
                                                        <%= h(student.getCounselorNote()) %>
                                                    </div>
                                                <% } %>
                                            </td>
                                            <td>
                                                <form method="post" action="<%= request.getContextPath() %>/counselor/flag-student"
                                                      style="display: grid; gap: 0.5rem; min-width: 220px;">
                                                    <input type="hidden" name="studentId" value="<%= student.getUserId() %>">
                                                    <input type="hidden" name="atRisk" value="<%= student.isAtRisk() ? "false" : "true" %>">
                                                    <textarea name="note" rows="2" placeholder="Counselor note"><%= h(student.getCounselorNote()) %></textarea>
                                                    <button class="btn <%= student.isAtRisk() ? "btn-secondary" : "btn-primary" %>" type="submit">
                                                        <%= student.isAtRisk() ? "Clear Flag" : "Flag For Support" %>
                                                    </button>
                                                </form>
                                            </td>
                                        </tr>
                                <%  }
                                   } %>
                                </tbody>
                            </table>
                        </div>
                    </div>

                    <div style="display: flex; flex-direction: column; gap: 1.5rem;">
                        <div class="card">
                            <h2 style="margin-bottom: 1rem;">Add Student</h2>
                            <form method="post" action="<%= request.getContextPath() %>/counselor/add-student">
                                <div class="form-group">
                                    <label for="fullName">Full name</label>
                                    <input id="fullName" name="fullName" required>
                                </div>
                                <div class="form-group">
                                    <label for="email">Email</label>
                                    <input id="email" name="email" type="email" required>
                                </div>
                                <div class="form-group">
                                    <label for="password">Temporary password</label>
                                    <input id="password" name="password" type="password" required>
                                </div>
                                <button class="btn btn-primary" type="submit" style="width: 100%;">Create Student</button>
                            </form>
                        </div>

                        <div class="card">
                            <h2 style="margin-bottom: 1rem;">Assessment Patterns</h2>
                            <% if (clusterStats == null || clusterStats.isEmpty()) { %>
                                <p style="color: var(--color-text-muted);">No completed assessment clusters yet.</p>
                            <% } else {
                                for (ClusterStat stat : clusterStats) { %>
                                    <div style="display: flex; justify-content: space-between; border-bottom: 1px solid var(--color-border-soft); padding: 0.6rem 0;">
                                        <span><%= h(stat.getClusterName()) %></span>
                                        <strong><%= stat.getTotal() %></strong>
                                    </div>
                            <%  }
                               } %>
                        </div>

                        <div class="card">
                            <h2 style="margin-bottom: 1rem;">Career Interest Pattern</h2>
                            <% if (careerStats == null || careerStats.isEmpty()) { %>
                                <p style="color: var(--color-text-muted);">Career recommendation patterns will appear after students complete tests.</p>
                            <% } else {
                                for (CareerInterestStat stat : careerStats) { %>
                                    <div style="display: flex; justify-content: space-between; border-bottom: 1px solid var(--color-border-soft); padding: 0.6rem 0;">
                                        <span><%= h(stat.getCareerName()) %></span>
                                        <strong><%= stat.getTotal() %></strong>
                                    </div>
                            <%  }
                               } %>
                        </div>
                    </div>
                </div>
            <% } %>
        </div>
    </div>
</div>

<jsp:include page="../includes/login-toast.jsp" />
</body>
</html>
