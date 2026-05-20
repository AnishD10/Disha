<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.disha.model.User" %>
<%@ page import="com.disha.model.assessment.AssessmentAttempt" %>
<%@ page import="com.disha.model.assessment.AttemptSkill" %>
<%@ page import="com.disha.model.parent.ParentDashboardData" %>
<%@ page import="com.disha.model.parent.ParentDashboardData.CareerRecommendation" %>
<%@ page import="com.disha.model.parent.ParentDashboardData.DegreeOption" %>
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

    private String valueOrPending(String value) {
        return value == null || value.trim().isEmpty() ? "Pending" : value;
    }
%>
<%
    User currentUser = (User) session.getAttribute("loggedInUser");
    if (currentUser == null) {
        response.sendRedirect(request.getContextPath() + "/JSP/auth/login.jsp");
        return;
    }

    ParentDashboardData dashboardData = (ParentDashboardData) request.getAttribute("dashboardData");
    String errorMessage = (String) request.getAttribute("errorMessage");
    if (dashboardData == null && errorMessage == null) {
        response.sendRedirect(request.getContextPath() + "/parent/dashboard");
        return;
    }

    int selectedBudget = dashboardData != null ? dashboardData.getSelectedBudget() : 200000;
    User child = dashboardData != null ? dashboardData.getChild() : null;
    AssessmentAttempt attempt = dashboardData != null ? dashboardData.getLatestAttempt() : null;
    List<AttemptSkill> skills = dashboardData != null ? dashboardData.getSkills() : null;
    List<CareerRecommendation> careers = dashboardData != null ? dashboardData.getCareerRecommendations() : null;
    List<DegreeOption> degrees = dashboardData != null ? dashboardData.getDegreeOptions() : null;
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Parent Dashboard - DISHA</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/disha-main.css">
</head>
<body>
<div class="dashboard-layout">
    <jsp:include page="../includes/sidebar.jsp" />

    <div class="main-content">
        <jsp:include page="../includes/dashboard-header.jsp" />

        <div class="dashboard-body">
            <div class="page-header mb-3">
                <h1 class="page-title">Parent Dashboard</h1>
                <p style="color: var(--color-text-muted); max-width: 780px;">
                    A family-friendly view of assessment evidence, career direction, Nepal market data,
                    and degree options within your budget.
                </p>
            </div>

            <% if (errorMessage != null) { %>
                <div class="alert alert-error"><%= h(errorMessage) %></div>
            <% } %>

            <% if (child == null) { %>
                <div class="card">
                    <h2 style="margin-bottom: 0.75rem;">No linked student yet</h2>
                    <p style="color: var(--color-text-muted);">
                        Your parent account is active, but it is not linked to a student account in
                        <code>parent_student_links</code>. Link a student to unlock aptitude results,
                        career advice, and family budget planning.
                    </p>
                </div>
            <% } else { %>
                <div class="grid-cards">
                    <div class="card stat-card">
                        <span class="stat-card-title">Student</span>
                        <span class="stat-card-value" style="font-size: 1.5rem;"><%= h(child.getFullName()) %></span>
                        <span style="color: var(--color-text-muted);"><%= h(child.getEmail()) %></span>
                    </div>
                    <div class="card stat-card">
                        <span class="stat-card-title">Assessment</span>
                        <span class="stat-card-value" style="font-size: 1.5rem;">
                            <%= attempt == null ? "Pending" : "Completed" %>
                        </span>
                        <span class="<%= attempt == null ? "badge badge-warning" : "badge badge-success" %>" style="width: fit-content;">
                            <%= attempt == null ? "Needs test" : "Evidence available" %>
                        </span>
                    </div>
                    <div class="card stat-card">
                        <span class="stat-card-title">Budget Filter</span>
                        <span class="stat-card-value" style="font-size: 1.5rem;">NPR <%= selectedBudget %></span>
                        <span style="color: var(--color-text-muted);">Annual fee ceiling</span>
                    </div>
                </div>

                <div class="card mb-3">
                    <h2 style="margin-bottom: 1rem;">Aptitude Summary</h2>
                    <% if (attempt == null) { %>
                        <p style="color: var(--color-text-muted);">
                            Your child has not completed the aptitude assessment yet. Once completed,
                            this section will show cognitive, personality, interest, and skill evidence.
                        </p>
                    <% } else { %>
                        <div class="grid-cards" style="margin-bottom: 1rem;">
                            <div>
                                <span class="stat-card-title">Aptitude Score</span>
                                <div class="stat-card-value"><%= attempt.getAptitudeScore() %></div>
                            </div>
                            <div>
                                <span class="stat-card-title">Personality Score</span>
                                <div class="stat-card-value"><%= attempt.getPersonalityScore() %></div>
                            </div>
                            <div>
                                <span class="stat-card-title">Interest Score</span>
                                <div class="stat-card-value"><%= attempt.getInterestScore() %></div>
                            </div>
                            <div>
                                <span class="stat-card-title">Dominant Cluster</span>
                                <div class="stat-card-value" style="font-size: 1.5rem;">
                                    <%= h(valueOrPending(attempt.getPersonalityCluster())) %>
                                </div>
                            </div>
                        </div>

                        <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(260px, 1fr)); gap: 1rem;">
                            <div class="card" style="box-shadow: none;">
                                <h3 style="margin-bottom: 0.75rem;">Strength Clusters</h3>
                                <% boolean hasStrength = false;
                                   if (skills != null) {
                                       for (AttemptSkill skill : skills) {
                                           if ("STRONG".equalsIgnoreCase(skill.getSkillLevel())) {
                                               hasStrength = true; %>
                                               <p><strong><%= h(skill.getSkillName()) %></strong> - <%= skill.getSkillScore() %></p>
                                <%         }
                                       }
                                   }
                                   if (!hasStrength) { %>
                                    <p style="color: var(--color-text-muted);">No strong skill clusters saved yet.</p>
                                <% } %>
                            </div>
                            <div class="card" style="box-shadow: none;">
                                <h3 style="margin-bottom: 0.75rem;">Areas To Develop</h3>
                                <% boolean hasWeakness = false;
                                   if (skills != null) {
                                       for (AttemptSkill skill : skills) {
                                           if ("WEAK".equalsIgnoreCase(skill.getSkillLevel())) {
                                               hasWeakness = true; %>
                                               <p><strong><%= h(skill.getSkillName()) %></strong> - <%= skill.getSkillScore() %></p>
                                <%         }
                                       }
                                   }
                                   if (!hasWeakness) { %>
                                    <p style="color: var(--color-text-muted);">No weak skill clusters saved yet.</p>
                                <% } %>
                            </div>
                        </div>
                    <% } %>
                </div>

                <div class="card mb-3">
                    <h2 style="margin-bottom: 1rem;">Plain Language Career Advice</h2>
                    <% if (careers == null || careers.isEmpty()) { %>
                        <p style="color: var(--color-text-muted);">
                            Career matches will appear after assessment recommendations are generated.
                        </p>
                    <% } else { %>
                        <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(280px, 1fr)); gap: 1rem;">
                            <% for (CareerRecommendation career : careers) { %>
                                <div class="card" style="box-shadow: none;">
                                    <h3 style="margin-bottom: 0.5rem;"><%= h(career.getCareerName()) %></h3>
                                    <p style="color: var(--color-text-muted); margin-bottom: 0.75rem;">
                                        <%= h(valueOrPending(career.getDescription())) %>
                                    </p>
                                    <p><strong>Salary:</strong> <%= h(career.getSalaryLabel()) %></p>
                                    <p><strong>Demand:</strong> <%= h(career.getDemandLevel()) %></p>
                                    <p><strong>Risk index:</strong> <%= h(career.getRiskIndex()) %></p>
                                    <% if (career.getNepalRelevanceNote() != null) { %>
                                        <p style="margin-top: 0.75rem; color: var(--color-text-muted);">
                                            <%= h(career.getNepalRelevanceNote()) %>
                                        </p>
                                    <% } %>
                                </div>
                            <% } %>
                        </div>
                    <% } %>
                </div>
            <% } %>

            <div class="card">
                <div style="display: flex; align-items: flex-end; justify-content: space-between; gap: 1rem; flex-wrap: wrap;">
                    <div>
                        <h2 style="margin-bottom: 0.5rem;">Budget To Degree Match</h2>
                        <p style="color: var(--color-text-muted);">
                            Filter college programmes by annual fee to support evidence-based family decisions.
                        </p>
                    </div>
                    <form method="post" action="<%= request.getContextPath() %>/parent/dashboard" style="display: flex; gap: 0.75rem; align-items: end;">
                        <div>
                            <label for="budget">Annual budget (NPR)</label>
                            <input id="budget" name="budget" type="number" min="10000" max="5000000" step="10000"
                                   value="<%= selectedBudget %>" style="min-width: 190px;">
                        </div>
                        <button class="btn btn-primary" type="submit">Filter</button>
                    </form>
                </div>

                <% if (degrees == null || degrees.isEmpty()) { %>
                    <p style="color: var(--color-text-muted); margin-top: 1.5rem;">
                        No active degree options were found within this budget.
                    </p>
                <% } else { %>
                    <div class="table-container mt-3">
                        <table class="table">
                            <thead>
                            <tr>
                                <th>Degree</th>
                                <th>College</th>
                                <th>Location</th>
                                <th>Minimum %</th>
                                <th>Duration</th>
                                <th>Annual Fee</th>
                                <th>Scholarship</th>
                            </tr>
                            </thead>
                            <tbody>
                            <% for (DegreeOption degree : degrees) { %>
                                <tr>
                                    <td><%= h(degree.getDegreeName()) %></td>
                                    <td><%= h(degree.getCollegeName()) %></td>
                                    <td><%= h(degree.getLocation()) %></td>
                                    <td><%= degree.getMinimumPercentage() == null ? "Pending" : h(degree.getMinimumPercentage()) %></td>
                                    <td><%= h(degree.getDuration()) %></td>
                                    <td><strong><%= h(degree.getFeeLabel()) %></strong></td>
                                    <td><%= degree.isScholarshipAvailable() ? "Available" : "Not listed" %></td>
                                </tr>
                            <% } %>
                            </tbody>
                        </table>
                    </div>
                <% } %>
            </div>
        </div>
    </div>
</div>

<jsp:include page="../includes/login-toast.jsp" />
</body>
</html>
