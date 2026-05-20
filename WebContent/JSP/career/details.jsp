<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.disha.career.model.Career" %>
<%@ page import="com.disha.career.model.Career.CareerSkill" %>
<%@ page import="com.disha.career.model.Career.CareerRoadmap" %>
<%@ page import="com.disha.career.model.Career.CareerCourse" %>
<%
    Career career = (Career) request.getAttribute("career");
    String contextPath = request.getContextPath();
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Career Details - DISHA</title>
    <link rel="stylesheet" href="<%= contextPath %>/css/disha-main.css">
</head>
<body>
<div class="dashboard-layout">
    <jsp:include page="../includes/sidebar.jsp" />
    <div class="main-content">
        <jsp:include page="../includes/dashboard-header.jsp" />
        <main class="dashboard-body">
            <% if (career == null) { %>
                <section class="empty-state">
                    <h1>Career not found</h1>
                    <p class="muted-copy" style="margin-bottom:1rem;">The requested career could not be loaded.</p>
                    <a href="<%= contextPath %>/career" class="btn btn-primary">Back to Recommendations</a>
                </section>
            <% } else { %>
                <section class="feature-hero">
                    <div>
                        <span class="feature-eyebrow">Career Details</span>
                        <h1><%= career.getCareerName() %></h1>
                        <p class="feature-subtitle"><%= career.getOverview() %></p>
                    </div>
                    <div class="feature-actions">
                        <a href="<%= contextPath %>/career" class="btn btn-secondary">Recommendations</a>
                        <a href="<%= contextPath %>/career?action=search" class="btn btn-secondary">Search Careers</a>
                    </div>
                </section>

                <section class="panel" style="margin-bottom:1rem;">
                    <h2>Career Snapshot</h2>
                    <p class="muted-copy"><%= career.getDescription() %></p>
                    <div class="metric-strip" style="margin-top:1rem;">
                        <div class="metric-box">
                            <span class="metric-label">Industry</span>
                            <span class="metric-value"><%= career.getIndustry() %></span>
                        </div>
                        <div class="metric-box">
                            <span class="metric-label">Demand</span>
                            <span class="metric-value"><%= career.getDemandLevel() %></span>
                        </div>
                        <div class="metric-box">
                            <span class="metric-label">Automation Risk</span>
                            <span class="metric-value"><%= career.getAutomationRisk() %></span>
                        </div>
                        <div class="metric-box">
                            <span class="metric-label">Remote</span>
                            <span class="metric-value"><%= career.getRemoteOpportunity() %></span>
                        </div>
                    </div>
                </section>

                <div class="section-stack">
                    <section class="panel">
                        <h2>Salary Range</h2>
                        <div class="salary-range">
                            <div class="metric-box">
                                <span class="metric-label">Entry</span>
                                <span class="metric-value">NPR <%= career.getSalaryEntry() %></span>
                            </div>
                            <div class="metric-box">
                                <span class="metric-label">Mid</span>
                                <span class="metric-value">NPR <%= career.getSalaryMid() %></span>
                            </div>
                            <div class="metric-box">
                                <span class="metric-label">Senior</span>
                                <span class="metric-value">NPR <%= career.getSalarySenior() %></span>
                            </div>
                        </div>
                    </section>

                    <section class="panel">
                        <h2>Responsibilities</h2>
                        <p class="muted-copy"><%= career.getResponsibilities() %></p>
                    </section>

                    <section class="panel">
                        <h2>Future Scope</h2>
                        <p class="muted-copy"><%= career.getFutureScope() %></p>
                    </section>

                    <section class="panel">
                        <h2>Skills</h2>
                        <ul class="detail-list">
                            <% for (CareerSkill skill : career.getSkills()) { %>
                                <li><%= skill.getSkillName() %> - <%= skill.getSkillType() %> / <%= skill.getSkillLevel() %></li>
                            <% } %>
                        </ul>
                    </section>

                    <section class="panel">
                        <h2>Roadmap</h2>
                        <ul class="detail-list">
                            <% for (CareerRoadmap roadmap : career.getRoadmaps()) { %>
                                <li><strong><%= roadmap.getStageName() %></strong>: <%= roadmap.getDescription() %> (<%= roadmap.getEstimatedDuration() %>)</li>
                            <% } %>
                        </ul>
                    </section>

                    <section class="panel">
                        <h2>Courses</h2>
                        <ul class="detail-list">
                            <% for (CareerCourse course : career.getCourses()) { %>
                                <li><%= course.getCourseName() %> - <%= course.getPlatform() %>, <%= course.getDifficulty() %>, <%= course.getDuration() %>, <%= course.getFreePaid() %></li>
                            <% } %>
                        </ul>
                    </section>

                    <section class="panel">
                        <h2>Certifications</h2>
                        <p class="muted-copy"><%= career.getSuggestedCertifications() %></p>
                    </section>
                </div>
            <% } %>
        </main>
    </div>
</div>
</body>
</html>
