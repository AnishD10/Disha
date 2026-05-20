<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="model.Career" %>
<%@ page import="model.Career.CareerSkill" %>
<%@ page import="model.Career.CareerRoadmap" %>
<%@ page import="model.Career.CareerCourse" %>
<%
    Career career = (Career) request.getAttribute("career");
    String contextPath = request.getContextPath();
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Career Details - DISHA</title>
    <link rel="stylesheet" href="<%= contextPath %>/CSS/disha-main.css">
    <style>
        .career-card, .section-panel {
            border: 1px solid #30363D;
            border-radius: 8px;
            padding: 18px;
            background: #161B22;
            margin-bottom: 18px;
        }
        .career-meta {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(180px, 1fr));
            gap: 12px;
            margin-top: 16px;
        }
        .meta-box {
            border: 1px solid #30363D;
            border-radius: 8px;
            padding: 12px;
        }
        .muted {
            color: #8B949E;
            line-height: 1.5;
        }
        .item-list {
            display: grid;
            gap: 10px;
            padding-left: 18px;
        }
    </style>
</head>
<body>
<nav class="navbar">
    <a href="<%= contextPath %>/career" class="nav-brand">DISHA</a>
    <div class="nav-user">
        <a href="<%= contextPath %>/career" class="btn btn-sm btn-secondary">Recommendations</a>
        <span class="role-chip">STUDENT</span>
    </div>
</nav>

<div class="page-wrapper">
    <% if (career == null) { %>
        <div class="career-card">
            <h1>Career not found</h1>
            <p class="muted">The requested career could not be loaded.</p>
            <a href="<%= contextPath %>/career" class="btn btn-primary">Back to Recommendations</a>
        </div>
    <% } else { %>
        <div class="page-header">
            <h1><%= career.getCareerName() %></h1>
            <p><%= career.getOverview() %></p>
        </div>

        <section class="career-card">
            <h2>Career Snapshot</h2>
            <p class="muted"><%= career.getDescription() %></p>
            <div class="career-meta">
                <div class="meta-box">
                    <div class="meta-label">Industry</div>
                    <div class="meta-value"><%= career.getIndustry() %></div>
                </div>
                <div class="meta-box">
                    <div class="meta-label">Demand</div>
                    <div class="meta-value"><%= career.getDemandLevel() %></div>
                </div>
                <div class="meta-box">
                    <div class="meta-label">Automation Risk</div>
                    <div class="meta-value"><%= career.getAutomationRisk() %></div>
                </div>
                <div class="meta-box">
                    <div class="meta-label">Remote Opportunity</div>
                    <div class="meta-value"><%= career.getRemoteOpportunity() %></div>
                </div>
            </div>
        </section>

        <section class="section-panel">
            <h2>Salary Range</h2>
            <p class="muted">
                Entry: NPR <%= career.getSalaryEntry() %><br>
                Mid: NPR <%= career.getSalaryMid() %><br>
                Senior: NPR <%= career.getSalarySenior() %>
            </p>
        </section>

        <section class="section-panel">
            <h2>Responsibilities</h2>
            <p class="muted"><%= career.getResponsibilities() %></p>
        </section>

        <section class="section-panel">
            <h2>Future Scope</h2>
            <p class="muted"><%= career.getFutureScope() %></p>
        </section>

        <section class="section-panel">
            <h2>Skills</h2>
            <ul class="item-list">
                <% for (CareerSkill skill : career.getSkills()) { %>
                    <li><%= skill.getSkillName() %> - <%= skill.getSkillType() %> / <%= skill.getSkillLevel() %></li>
                <% } %>
            </ul>
        </section>

        <section class="section-panel">
            <h2>Roadmap</h2>
            <ul class="item-list">
                <% for (CareerRoadmap roadmap : career.getRoadmaps()) { %>
                    <li><strong><%= roadmap.getStageName() %></strong>: <%= roadmap.getDescription() %> (<%= roadmap.getEstimatedDuration() %>)</li>
                <% } %>
            </ul>
        </section>

        <section class="section-panel">
            <h2>Courses</h2>
            <ul class="item-list">
                <% for (CareerCourse course : career.getCourses()) { %>
                    <li><%= course.getCourseName() %> - <%= course.getPlatform() %>, <%= course.getDifficulty() %>, <%= course.getDuration() %>, <%= course.getFreePaid() %></li>
                <% } %>
            </ul>
        </section>

        <section class="section-panel">
            <h2>Certifications</h2>
            <p class="muted"><%= career.getSuggestedCertifications() %></p>
        </section>
    <% } %>
</div>
</body>
</html>
