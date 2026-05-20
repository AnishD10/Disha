<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.disha.career.model.CareerMatch" %>
<%
    List<CareerMatch> recommendedCareers = (List<CareerMatch>) request.getAttribute("recommendedCareers");
    String contextPath = request.getContextPath();
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Career Recommendations - DISHA</title>
    <link rel="stylesheet" href="<%= contextPath %>/css/disha-main.css">
</head>
<body>
<div class="dashboard-layout">
    <jsp:include page="../includes/sidebar.jsp" />
    <div class="main-content">
        <jsp:include page="../includes/dashboard-header.jsp" />
        <main class="dashboard-body">
            <section class="feature-hero">
                <div>
                    <span class="feature-eyebrow">Career Discovery</span>
                    <h1>Career Recommendations</h1>
                    <p class="feature-subtitle">Your strongest matches ranked by aptitude fit, market demand, and career profile.</p>
                </div>
                <div class="feature-actions">
                    <form method="post" action="<%= contextPath %>/career">
                        <input type="hidden" name="action" value="retake">
                        <button type="submit" class="btn btn-secondary">Retake Scores</button>
                    </form>
                    <a href="<%= contextPath %>/career?action=saved" class="btn btn-primary">Saved Careers</a>
                </div>
            </section>

            <nav class="feature-tabs">
                <span class="feature-tab active">Recommendations</span>
                <a href="<%= contextPath %>/career?action=search" class="feature-tab">Search</a>
                <a href="<%= contextPath %>/career?action=saved" class="feature-tab">Saved</a>
            </nav>

            <% if (recommendedCareers == null || recommendedCareers.isEmpty()) { %>
                <section class="empty-state">
                    <h2>No recommendations found</h2>
                    <p class="muted-copy" style="margin:0 auto 1rem; max-width:560px;">Complete the career score form to generate a ranked set of career matches.</p>
                    <form method="post" action="<%= contextPath %>/career" class="inline-actions" style="justify-content:center;">
                        <input type="hidden" name="action" value="retake">
                        <button type="submit" class="btn btn-primary">Enter Scores</button>
                        <a href="<%= contextPath %>/assessment/start" class="btn btn-secondary">Take Aptitude Test</a>
                    </form>
                </section>
            <% } else { %>
                <div class="career-grid">
                    <% for (CareerMatch match : recommendedCareers) { %>
                        <article class="career-card">
                            <div class="career-card-header">
                                <div>
                                    <h2><%= match.getCareer().getCareerName() %></h2>
                                    <p class="muted-copy"><%= match.getExplanation() %></p>
                                </div>
                                <div class="match-score"><%= match.getCompatibilityPercentage() %>%<span>Match</span></div>
                            </div>

                            <div class="pill-row">
                                <span class="pill"><%= match.getMatchStrength() %></span>
                                <span class="pill"><%= match.getDemandBadge() %></span>
                                <span class="pill"><%= match.getAutomationRiskBadge() %></span>
                                <span class="pill"><%= match.getRemoteOpportunityBadge() %></span>
                                <span class="pill"><%= match.getGrowthTrendBadge() %></span>
                            </div>

                            <p class="muted-copy"><%= match.getCareer().getOverview() %></p>

                            <div class="metric-strip">
                                <div class="metric-box">
                                    <span class="metric-label">Entry</span>
                                    <span class="metric-value">NPR <%= match.getCareer().getSalaryEntry() %></span>
                                </div>
                                <div class="metric-box">
                                    <span class="metric-label">Mid</span>
                                    <span class="metric-value">NPR <%= match.getCareer().getSalaryMid() %></span>
                                </div>
                                <div class="metric-box">
                                    <span class="metric-label">Senior</span>
                                    <span class="metric-value">NPR <%= match.getCareer().getSalarySenior() %></span>
                                </div>
                            </div>

                            <form method="post" action="<%= contextPath %>/career" class="inline-actions">
                                <input type="hidden" name="action" value="bookmark">
                                <input type="hidden" name="careerId" value="<%= match.getCareer().getCareerId() %>">
                                <button type="submit" class="btn btn-primary">Save Career</button>
                                <a href="<%= contextPath %>/career?action=details&careerId=<%= match.getCareer().getCareerId() %>" class="btn btn-secondary">View Details</a>
                            </form>
                        </article>
                    <% } %>
                </div>
            <% } %>
        </main>
    </div>
</div>
</body>
</html>
