<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="model.CareerMatch" %>
<%
    List<CareerMatch> recommendedCareers = (List<CareerMatch>) request.getAttribute("recommendedCareers");
    String contextPath = request.getContextPath();
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Career Recommendations - DISHA</title>
    <link rel="stylesheet" href="<%= contextPath %>/CSS/disha-main.css">
    <style>
        .career-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
            gap: 18px;
            margin-top: 24px;
        }

        .career-card {
            border: 1px solid #30363D;
            border-radius: 8px;
            padding: 18px;
            background: #161B22;
        }

        .career-score {
            font-size: 2rem;
            font-weight: 700;
            color: #F4A22D;
            margin: 8px 0;
        }

        .career-badges {
            display: flex;
            flex-wrap: wrap;
            gap: 8px;
            margin: 12px 0;
        }

        .badge {
            border: 1px solid #30363D;
            border-radius: 999px;
            padding: 4px 10px;
            font-size: 0.75rem;
            color: #C9D1D9;
        }

        .career-card p {
            color: #8B949E;
            line-height: 1.5;
        }
    </style>
</head>
<body>
<nav class="navbar">
    <a href="<%= contextPath %>/jsp/student/dashboard.jsp" class="nav-brand">DISHA</a>
    <div class="nav-user">
        <span class="role-chip">STUDENT</span>
    </div>
</nav>

<div class="page-wrapper">
    <div class="page-header">
        <h1>Career Recommendations</h1>
        <p>Your top career matches based on aptitude compatibility.</p>
    </div>

    <% if (recommendedCareers == null || recommendedCareers.isEmpty()) { %>
        <div class="career-card">
            <h3>No recommendations found</h3>
            <p>Please complete or retake your career aptitude assessment.</p>
            <form method="post" action="<%= contextPath %>/career">
                <input type="hidden" name="action" value="retake">
                <button type="submit" class="btn btn-primary">Retake Assessment</button>
            </form>
        </div>
    <% } else { %>
        <div class="career-grid">
            <% for (CareerMatch match : recommendedCareers) { %>
                <article class="career-card">
                    <h2><%= match.getCareer().getCareerName() %></h2>
                    <div class="career-score"><%= match.getCompatibilityPercentage() %>%</div>
                    <strong><%= match.getMatchStrength() %></strong>

                    <div class="career-badges">
                        <span class="badge"><%= match.getDemandBadge() %></span>
                        <span class="badge"><%= match.getAutomationRiskBadge() %></span>
                        <span class="badge"><%= match.getRemoteOpportunityBadge() %></span>
                        <span class="badge"><%= match.getGrowthTrendBadge() %></span>
                    </div>

                    <p><%= match.getExplanation() %></p>
                    <p><%= match.getCareer().getOverview() %></p>

                    <p>
                        Entry: NPR <%= match.getCareer().getSalaryEntry() %><br>
                        Mid: NPR <%= match.getCareer().getSalaryMid() %><br>
                        Senior: NPR <%= match.getCareer().getSalarySenior() %>
                    </p>

                    <form method="post" action="<%= contextPath %>/career">
                        <input type="hidden" name="action" value="bookmark">
                        <input type="hidden" name="careerId" value="<%= match.getCareer().getCareerId() %>">
                        <button type="submit" class="btn btn-primary">Save Career</button>
                    </form>
                </article>
            <% } %>
        </div>
    <% } %>
</div>
</body>
</html>
