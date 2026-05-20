<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="model.Career" %>
<%
    List<Career> savedCareers = (List<Career>) request.getAttribute("savedCareers");
    String contextPath = request.getContextPath();
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Saved Careers - DISHA</title>
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
        .muted {
            color: #8B949E;
            line-height: 1.5;
        }
        .actions {
            display: flex;
            flex-wrap: wrap;
            gap: 10px;
            margin-top: 16px;
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
    <div class="page-header">
        <h1>Saved Careers</h1>
        <p>Careers saved for later review.</p>
    </div>

    <% if (savedCareers == null || savedCareers.isEmpty()) { %>
        <div class="career-card">
            <h2>No saved careers</h2>
            <p class="muted">Save careers from your recommendation list to review them here.</p>
            <a href="<%= contextPath %>/career" class="btn btn-primary">View Recommendations</a>
        </div>
    <% } else { %>
        <form method="get" action="<%= contextPath %>/career">
            <input type="hidden" name="action" value="compare">
            <div class="career-grid">
                <% for (Career career : savedCareers) { %>
                    <article class="career-card">
                        <label class="checkbox-group">
                            <input type="checkbox" name="careerId" value="<%= career.getCareerId() %>">
                            Compare
                        </label>
                        <h2><%= career.getCareerName() %></h2>
                        <p class="muted"><%= career.getOverview() %></p>
                        <div class="actions">
                            <a href="<%= contextPath %>/career?action=details&careerId=<%= career.getCareerId() %>" class="btn btn-secondary">Details</a>
                            <button type="submit" form="remove-<%= career.getCareerId() %>" class="btn btn-secondary">Remove</button>
                        </div>
                    </article>
                <% } %>
            </div>
            <button type="submit" class="btn btn-primary" style="margin-top:18px;">Compare Selected</button>
        </form>
        <% for (Career career : savedCareers) { %>
            <form id="remove-<%= career.getCareerId() %>" method="post" action="<%= contextPath %>/career">
                <input type="hidden" name="action" value="removeBookmark">
                <input type="hidden" name="careerId" value="<%= career.getCareerId() %>">
            </form>
        <% } %>
    <% } %>
</div>
</body>
</html>
