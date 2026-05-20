<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String contextPath = request.getContextPath();
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Career Assessment - DISHA</title>
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
                    <h1>Career Fit Scores</h1>
                    <p class="feature-subtitle">Enter your current aptitude profile to generate career recommendations.</p>
                </div>
                <div class="feature-actions">
                    <a href="<%= contextPath %>/career?action=search" class="btn btn-secondary">Search Careers</a>
                    <a href="<%= contextPath %>/career?action=saved" class="btn btn-secondary">Saved Careers</a>
                </div>
            </section>

            <nav class="feature-tabs">
                <a href="<%= contextPath %>/career" class="feature-tab">Recommendations</a>
                <a href="<%= contextPath %>/career?action=search" class="feature-tab">Search</a>
                <a href="<%= contextPath %>/career?action=saved" class="feature-tab">Saved</a>
                <span class="feature-tab active">Scores</span>
            </nav>

            <section class="panel">
                <h2>Score Profile</h2>
                <p class="muted-copy" style="margin-bottom:1rem;">Use values from 0 to 100 for each area.</p>
                <form method="post" action="<%= contextPath %>/career">
                    <input type="hidden" name="action" value="saveScores">
                    <div class="score-grid">
                        <div class="score-field">
                            <label for="analyticalScore">Analytical</label>
                            <input id="analyticalScore" name="analyticalScore" type="number" min="0" max="100" required>
                        </div>
                        <div class="score-field">
                            <label for="creativityScore">Creativity</label>
                            <input id="creativityScore" name="creativityScore" type="number" min="0" max="100" required>
                        </div>
                        <div class="score-field">
                            <label for="leadershipScore">Leadership</label>
                            <input id="leadershipScore" name="leadershipScore" type="number" min="0" max="100" required>
                        </div>
                        <div class="score-field">
                            <label for="technicalScore">Technical</label>
                            <input id="technicalScore" name="technicalScore" type="number" min="0" max="100" required>
                        </div>
                        <div class="score-field">
                            <label for="communicationScore">Communication</label>
                            <input id="communicationScore" name="communicationScore" type="number" min="0" max="100" required>
                        </div>
                        <div class="score-field">
                            <label for="entrepreneurialScore">Entrepreneurial</label>
                            <input id="entrepreneurialScore" name="entrepreneurialScore" type="number" min="0" max="100" required>
                        </div>
                        <div class="score-field">
                            <label for="researchScore">Research</label>
                            <input id="researchScore" name="researchScore" type="number" min="0" max="100" required>
                        </div>
                    </div>
                    <div class="inline-actions" style="margin-top:1.25rem;">
                        <button type="submit" class="btn btn-primary">Save Scores</button>
                        <a href="<%= contextPath %>/assessment/start" class="btn btn-secondary">Take Aptitude Test</a>
                    </div>
                </form>
            </section>
        </main>
    </div>
</div>
</body>
</html>
