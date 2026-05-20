<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.disha.career.model.Career" %>
<%
    List<Career> careers = (List<Career>) request.getAttribute("careers");
    String keyword = (String) request.getAttribute("keyword");
    String contextPath = request.getContextPath();
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Career Search - DISHA</title>
    <link rel="stylesheet" href="<%= contextPath %>/CSS/disha-main.css">
    <style>
        .career-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
            gap: 18px;
            margin-top: 24px;
        }
        .career-card, .filter-panel {
            border: 1px solid #30363D;
            border-radius: 8px;
            padding: 18px;
            background: #161B22;
        }
        .filter-row {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(180px, 1fr));
            gap: 12px;
            align-items: end;
        }
        .muted {
            color: #8B949E;
            line-height: 1.5;
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
        <h1>Career Search</h1>
        <p>Search and filter available careers.</p>
    </div>

    <section class="filter-panel">
        <form method="get" action="<%= contextPath %>/career" class="filter-row">
            <input type="hidden" name="action" value="search">
            <div>
                <label for="keyword">Keyword</label>
                <input id="keyword" name="keyword" value="<%= keyword == null ? "" : keyword %>" placeholder="software, data, design">
            </div>
            <button type="submit" class="btn btn-primary">Search</button>
        </form>
        <form method="get" action="<%= contextPath %>/career" class="filter-row" style="margin-top:16px;">
            <input type="hidden" name="action" value="filter">
            <div>
                <label for="industry">Industry</label>
                <input id="industry" name="industry" placeholder="Information Technology">
            </div>
            <div>
                <label for="demandLevel">Demand</label>
                <select id="demandLevel" name="demandLevel">
                    <option value="">Any</option>
                    <option value="HIGH">High</option>
                    <option value="MEDIUM">Medium</option>
                    <option value="LOW">Low</option>
                </select>
            </div>
            <div>
                <label for="remoteOpportunity">Remote</label>
                <select id="remoteOpportunity" name="remoteOpportunity">
                    <option value="">Any</option>
                    <option value="HIGH">High</option>
                    <option value="MEDIUM">Medium</option>
                    <option value="LOW">Low</option>
                </select>
            </div>
            <div>
                <label for="sortBy">Sort</label>
                <select id="sortBy" name="sortBy">
                    <option value="">Name</option>
                    <option value="salary">Salary</option>
                    <option value="demand">Demand</option>
                    <option value="growth">Growth</option>
                </select>
            </div>
            <button type="submit" class="btn btn-primary">Filter</button>
        </form>
    </section>

    <% if (careers == null || careers.isEmpty()) { %>
        <div class="career-card" style="margin-top:18px;">
            <h2>No careers found</h2>
            <p class="muted">Try a different keyword or remove filters.</p>
        </div>
    <% } else { %>
        <div class="career-grid">
            <% for (Career career : careers) { %>
                <article class="career-card">
                    <h2><%= career.getCareerName() %></h2>
                    <p class="muted"><%= career.getOverview() %></p>
                    <p class="muted">Industry: <%= career.getIndustry() %><br>Demand: <%= career.getDemandLevel() %></p>
                    <a href="<%= contextPath %>/career?action=details&careerId=<%= career.getCareerId() %>" class="btn btn-secondary">View Details</a>
                </article>
            <% } %>
        </div>
    <% } %>
</div>
</body>
</html>

