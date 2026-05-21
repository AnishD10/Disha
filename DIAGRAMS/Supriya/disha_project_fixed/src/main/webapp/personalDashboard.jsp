 <%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.disha.disha.UserProfile" %>
<%@ page import="com.disha.disha.TestHistory" %>
<%@ page import="java.util.List" %>
<%
    /* ── Auth guard (belt-and-suspenders; servlet already redirects) ── */
    String username = (String) session.getAttribute("username");
    if (username == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }

    UserProfile user            = (UserProfile)        session.getAttribute("userProfile");
    List<TestHistory> histList  = (List<TestHistory>)  request.getAttribute("testHistoryList");
    String successMsg           = (String)             request.getAttribute("successMessage");
    String errorMsg             = (String)             request.getAttribute("errorMessage");

    /* Build comma-separated score list for the JS chart — NO trailing comma */
    StringBuilder scoreJson = new StringBuilder("[");
    if (histList != null) {
        int limit = Math.min(histList.size(), 5);
        int start = histList.size() - limit;   // last 5 entries (list is ASC)
        for (int k = start; k < histList.size(); k++) {
            if (k > start) scoreJson.append(",");
            scoreJson.append(histList.get(k).getScore());
        }
    }
    scoreJson.append("]");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>DISHA - Personal Dashboard</title>
    <style>
        * { box-sizing: border-box; margin: 0; padding: 0; }
        body { font-family: Arial, sans-serif; background: #f0f4f8; color: #333; }
        nav { background: #1a237e; color: #fff; padding: 14px 32px; display: flex; justify-content: space-between; align-items: center; }
        nav .brand { font-size: 1.5rem; font-weight: 700; }
        nav a { color: #fff; text-decoration: none; margin-left: 24px; font-size: 0.95rem; }
        nav a:hover { text-decoration: underline; }
        .hero { background: #283593; color: #fff; padding: 36px 40px; }
        .hero h1 { font-size: 1.8rem; margin-bottom: 6px; }
        .hero p  { font-size: 1rem; opacity: 0.85; }
        .alert { margin: 20px 40px 0; padding: 12px 18px; border-radius: 6px; font-weight: 600; }
        .alert-success { background: #e8f5e9; color: #2e7d32; border-left: 4px solid #43a047; }
        .alert-error   { background: #ffebee; color: #c62828; border-left: 4px solid #e53935; }
        .dashboard-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 24px; padding: 28px 40px; }
        .card { background: #fff; border-radius: 12px; padding: 24px; box-shadow: 0 2px 10px rgba(0,0,0,0.08); }
        .card h2 { font-size: 1.1rem; color: #1a237e; margin-bottom: 16px; border-bottom: 2px solid #e8eaf6; padding-bottom: 10px; }
        .profile-row { display: flex; justify-content: space-between; font-size: 0.95rem; margin-bottom: 10px; }
        .profile-row span:first-child { color: #777; }
        .profile-row span:last-child  { font-weight: 600; }
        .btn { display: inline-block; margin-top: 0; padding: 9px 20px; background: #3949ab; color: #fff; border: none; border-radius: 6px; cursor: pointer; font-size: 0.9rem; text-decoration: none; }
        .btn:hover { background: #283593; }
        .btn-outline { background: transparent; border: 2px solid #3949ab; color: #3949ab; margin-top: 16px; }
        .btn-outline:hover { background: #3949ab; color: #fff; }
        .skill-item { margin-bottom: 14px; }
        .skill-label { display: flex; justify-content: space-between; font-size: 0.9rem; margin-bottom: 5px; }
        .progress-bar  { background: #e0e0e0; border-radius: 50px; height: 10px; overflow: hidden; }
        .progress-fill { height: 100%; border-radius: 50px; background: #3949ab; }
        .roadmap-step { display: flex; align-items: flex-start; gap: 14px; margin-bottom: 16px; }
        .step-badge { min-width: 32px; height: 32px; border-radius: 50%; display: flex; align-items: center; justify-content: center; font-weight: 700; font-size: 0.85rem; color: #fff; }
        .step-done    { background: #43a047; }
        .step-current { background: #3949ab; }
        .step-pending { background: #bdbdbd; }
        .step-info h4 { font-size: 0.95rem; margin-bottom: 3px; }
        .step-info p  { font-size: 0.82rem; color: #777; }
        table { width: 100%; border-collapse: collapse; font-size: 0.88rem; }
        th { background: #e8eaf6; color: #1a237e; padding: 10px 12px; text-align: left; }
        td { padding: 9px 12px; border-bottom: 1px solid #f0f0f0; }
        tr:hover td { background: #f5f5f5; }
        .badge        { padding: 3px 10px; border-radius: 20px; font-size: 0.78rem; font-weight: 600; }
        .badge-green  { background: #e8f5e9; color: #2e7d32; }
        .badge-blue   { background: #e3f2fd; color: #1565c0; }
        .badge-orange { background: #fff3e0; color: #e65100; }
        .compare-chart { display: flex; align-items: flex-end; gap: 18px; height: 140px; border-bottom: 2px solid #e0e0e0; margin-bottom: 10px; padding-bottom: 4px; }
        .bar-wrap  { display: flex; flex-direction: column; align-items: center; gap: 6px; flex: 1; }
        .bar       { width: 100%; border-radius: 6px 6px 0 0; background: #3949ab; min-height: 4px; }
        .bar-label { font-size: 0.78rem; color: #555; text-align: center; }
        .retest-item { display: flex; justify-content: space-between; align-items: center; padding: 12px 14px; background: #f5f5f5; border-radius: 8px; margin-bottom: 12px; }
        footer { text-align: center; padding: 22px; color: #888; font-size: 0.82rem; }
    </style>
</head>
<body>

<%-- ── Navigation ── --%>
<nav>
    <div class="brand">DISHA</div>
    <div>
        <a href="<%= request.getContextPath() %>/home.jsp">Home</a>
        <a href="<%= request.getContextPath() %>/assessment.jsp">Assessment</a>
        <a href="<%= request.getContextPath() %>/PersonalDashboardServlet">Dashboard</a>
        <a href="<%= request.getContextPath() %>/LogoutServlet">Logout</a>
    </div>
</nav>

<%-- ── Hero banner ── --%>
<div class="hero">
    <h1>Welcome, <%= (user != null) ? user.getFullName() : username %>!</h1>
    <p>Track your skill progress, view test history, and plan your learning roadmap.</p>
</div>

<%-- ── Flash messages ── --%>
<% if (successMsg != null) { %>
    <div class="alert alert-success"><%= successMsg %></div>
<% } %>
<% if (errorMsg != null) { %>
    <div class="alert alert-error"><%= errorMsg %></div>
<% } %>

<div class="dashboard-grid">

    <%-- ── 1. My Profile ── --%>
    <div class="card">
        <h2>My Profile</h2>
        <div class="profile-row"><span>Full Name</span>      <span><%= (user != null && user.getFullName()       != null) ? user.getFullName()       : "N/A" %></span></div>
        <div class="profile-row"><span>Email</span>          <span><%= (user != null && user.getEmail()          != null) ? user.getEmail()          : "N/A" %></span></div>
        <div class="profile-row"><span>Phone</span>          <span><%= (user != null && user.getPhone()          != null) ? user.getPhone()          : "N/A" %></span></div>
        <div class="profile-row"><span>Education Level</span><span><%= (user != null && user.getEducationLevel() != null) ? user.getEducationLevel() : "N/A" %></span></div>
        <div class="profile-row"><span>Preferred Career</span><span><%= (user != null && user.getPreferredCareer() != null) ? user.getPreferredCareer() : "N/A" %></span></div>
        <div class="profile-row"><span>Member Since</span>   <span><%= (user != null && user.getMemberSince()    != null) ? user.getMemberSince()    : "N/A" %></span></div>
        <a href="<%= request.getContextPath() %>/EditProfileServlet" class="btn btn-outline">Edit Profile</a>
    </div>

    <%-- ── 2. Skill Progress (static display — will be dynamic once Assessment feature is done) ── --%>
    <div class="card">
        <h2>Skill Progress</h2>
        <div class="skill-item">
            <div class="skill-label"><span>Communication</span><span>75%</span></div>
            <div class="progress-bar"><div class="progress-fill" style="width:75%"></div></div>
        </div>
        <div class="skill-item">
            <div class="skill-label"><span>Problem Solving</span><span>60%</span></div>
            <div class="progress-bar"><div class="progress-fill" style="width:60%"></div></div>
        </div>
        <div class="skill-item">
            <div class="skill-label"><span>Teamwork</span><span>85%</span></div>
            <div class="progress-bar"><div class="progress-fill" style="width:85%"></div></div>
        </div>
        <div class="skill-item">
            <div class="skill-label"><span>Technical Skills</span><span>50%</span></div>
            <div class="progress-bar"><div class="progress-fill" style="width:50%"></div></div>
        </div>
        <div class="skill-item">
            <div class="skill-label"><span>Leadership</span><span>40%</span></div>
            <div class="progress-bar"><div class="progress-fill" style="width:40%"></div></div>
        </div>
    </div>

    <%-- ── 3. Test History ── --%>
    <div class="card" style="grid-column: span 2;">
        <h2>Test History</h2>
        <% if (histList != null && !histList.isEmpty()) { %>
        <table>
            <thead>
                <tr>
                    <th>#</th>
                    <th>Assessment Name</th>
                    <th>Date Taken</th>
                    <th>Score</th>
                    <th>Result</th>
                    <th>Action</th>
                </tr>
            </thead>
            <tbody>
            <%
                int rowNum = 1;
                for (TestHistory th : histList) {
            %>
                <tr>
                    <td><%= rowNum++ %></td>
                    <td><%= th.getAssessmentName() %></td>
                    <td><%= th.getDateTaken() %></td>
                    <td><%= th.getScore() %>%</td>
                    <td><span class="badge <%= th.getBadgeClass() %>"><%= th.getResultLabel() %></span></td>
                    <td>
                        <form action="<%= request.getContextPath() %>/RetestServlet" method="post" style="display:inline">
                            <input type="hidden" name="assessmentId" value="<%= th.getAssessmentId() %>">
                            <button type="submit" class="btn" style="padding:5px 12px;font-size:0.8rem;margin-top:0;">Re-Test</button>
                        </form>
                    </td>
                </tr>
            <% } %>
            </tbody>
        </table>
        <% } else { %>
            <p style="color:#888;margin-top:12px;">
                No test history found.
                <a href="<%= request.getContextPath() %>/assessment.jsp" class="btn" style="margin-left:10px;">Take Assessment</a>
            </p>
        <% } %>
    </div>

    <%-- ── 4. Compare Results Chart ── --%>
    <div class="card">
        <h2>Compare Results Over Time</h2>
        <div class="compare-chart" id="compareChart"></div>
        <p style="font-size:0.8rem;color:#888;text-align:center;margin-top:8px;">Score trend across your last 5 assessments</p>
    </div>

    <%-- ── 5. Skill Roadmap ── --%>
    <div class="card">
        <h2>Skill Roadmap</h2>
        <div class="roadmap-step">
            <div class="step-badge step-done">&#10003;</div>
            <div class="step-info"><h4>Self-Assessment Completed</h4><p>Initial skills baseline established.</p></div>
        </div>
        <div class="roadmap-step">
            <div class="step-badge step-done">&#10003;</div>
            <div class="step-info"><h4>Career Interest Mapping</h4><p>Preferred career path identified.</p></div>
        </div>
        <div class="roadmap-step">
            <div class="step-badge step-current">3</div>
            <div class="step-info"><h4>Skill Gap Analysis</h4><p>Identify gaps between current and target skills. <strong>(Current)</strong></p></div>
        </div>
        <div class="roadmap-step">
            <div class="step-badge step-pending">4</div>
            <div class="step-info"><h4>Learning Plan Creation</h4><p>Personalised courses and resources.</p></div>
        </div>
        <div class="roadmap-step">
            <div class="step-badge step-pending">5</div>
            <div class="step-info"><h4>Career Decision Planning</h4><p>Final guidance and counsellor review.</p></div>
        </div>
    </div>

    <%-- ── 6. Available Re-Tests ── --%>
    <div class="card" style="grid-column: span 2;">
        <h2>Available Re-Tests</h2>
        <div class="retest-item">
            <span>Aptitude Assessment</span>
            <form action="<%= request.getContextPath() %>/RetestServlet" method="post">
                <input type="hidden" name="assessmentId" value="1">
                <button type="submit" class="btn">Start Re-Test</button>
            </form>
        </div>
        <div class="retest-item">
            <span>Personality Assessment</span>
            <form action="<%= request.getContextPath() %>/RetestServlet" method="post">
                <input type="hidden" name="assessmentId" value="2">
                <button type="submit" class="btn">Start Re-Test</button>
            </form>
        </div>
        <div class="retest-item">
            <span>Skill Competency Test</span>
            <form action="<%= request.getContextPath() %>/RetestServlet" method="post">
                <input type="hidden" name="assessmentId" value="3">
                <button type="submit" class="btn">Start Re-Test</button>
            </form>
        </div>
    </div>

</div><%-- end dashboard-grid --%>

<footer>&copy; 2025 DISHA - Career Guidance System. All rights reserved.</footer>

<%-- ── Compare Chart Script ── --%>
<script>
(function () {
    "use strict";

    /* Scores array built safely in Java — no trailing comma */
    var scores = <%= scoreJson %>;

    var chart = document.getElementById("compareChart");
    if (!chart) return;

    if (scores.length === 0) {
        chart.innerHTML = "<p style='color:#aaa;align-self:center;width:100%;text-align:center'>No results yet.</p>";
        return;
    }

    /* Scale bars: max bar height = 120px mapped to max score in the set */
    var MAX_HEIGHT = 120;
    var maxScore   = Math.max.apply(null, scores);
    if (maxScore === 0) maxScore = 100;

    scores.forEach(function (score, idx) {
        var barHeight = Math.round((score / maxScore) * MAX_HEIGHT);
        if (barHeight < 4) barHeight = 4;

        var wrap = document.createElement("div");
        wrap.className = "bar-wrap";
        wrap.innerHTML =
            "<span style='font-size:0.82rem;color:#3949ab;font-weight:600'>" + score + "%</span>" +
            "<div class='bar' style='height:" + barHeight + "px'></div>" +
            "<span class='bar-label'>Test " + (idx + 1) + "</span>";
        chart.appendChild(wrap);
    });
}());
</script>

</body>
</html>
