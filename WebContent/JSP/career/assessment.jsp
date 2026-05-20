<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String contextPath = request.getContextPath();
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Career Assessment - DISHA</title>
    <link rel="stylesheet" href="<%= contextPath %>/CSS/disha-main.css">
    <style>
        .assessment-panel {
            border: 1px solid #30363D;
            border-radius: 8px;
            padding: 18px;
            background: #161B22;
        }
        .score-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(220px, 1fr));
            gap: 16px;
        }
    </style>
</head>
<body>
<nav class="navbar">
    <a href="<%= contextPath %>/career" class="nav-brand">DISHA</a>
    <div class="nav-user">
        <span class="role-chip">STUDENT</span>
    </div>
</nav>

<div class="page-wrapper">
    <div class="page-header">
        <h1>Career Assessment</h1>
        <p>Enter aptitude scores from 0 to 100.</p>
    </div>

    <section class="assessment-panel">
        <form method="post" action="<%= contextPath %>/career">
            <input type="hidden" name="action" value="saveScores">
            <div class="score-grid">
                <div>
                    <label for="analyticalScore">Analytical</label>
                    <input id="analyticalScore" name="analyticalScore" type="number" min="0" max="100" required>
                </div>
                <div>
                    <label for="creativityScore">Creativity</label>
                    <input id="creativityScore" name="creativityScore" type="number" min="0" max="100" required>
                </div>
                <div>
                    <label for="leadershipScore">Leadership</label>
                    <input id="leadershipScore" name="leadershipScore" type="number" min="0" max="100" required>
                </div>
                <div>
                    <label for="technicalScore">Technical</label>
                    <input id="technicalScore" name="technicalScore" type="number" min="0" max="100" required>
                </div>
                <div>
                    <label for="communicationScore">Communication</label>
                    <input id="communicationScore" name="communicationScore" type="number" min="0" max="100" required>
                </div>
                <div>
                    <label for="entrepreneurialScore">Entrepreneurial</label>
                    <input id="entrepreneurialScore" name="entrepreneurialScore" type="number" min="0" max="100" required>
                </div>
                <div>
                    <label for="researchScore">Research</label>
                    <input id="researchScore" name="researchScore" type="number" min="0" max="100" required>
                </div>
            </div>
            <button type="submit" class="btn btn-primary" style="margin-top:18px;">Save Scores</button>
        </form>
    </section>
</div>
</body>
</html>

