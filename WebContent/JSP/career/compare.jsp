<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="model.Career" %>
<%
    List<Career> careers = (List<Career>) request.getAttribute("careersToCompare");
    String contextPath = request.getContextPath();
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Compare Careers - DISHA</title>
    <link rel="stylesheet" href="<%= contextPath %>/CSS/disha-main.css">
    <style>
        .compare-table {
            width: 100%;
            border-collapse: collapse;
            border: 1px solid #30363D;
            background: #161B22;
        }
        .compare-table th, .compare-table td {
            border: 1px solid #30363D;
            padding: 12px;
            text-align: left;
            vertical-align: top;
        }
        .compare-table th {
            color: #F4A22D;
            width: 180px;
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
    </style>
</head>
<body>
<nav class="navbar">
    <a href="<%= contextPath %>/career" class="nav-brand">DISHA</a>
    <div class="nav-user">
        <a href="<%= contextPath %>/career?action=saved" class="btn btn-sm btn-secondary">Saved Careers</a>
        <span class="role-chip">STUDENT</span>
    </div>
</nav>

<div class="page-wrapper">
    <div class="page-header">
        <h1>Compare Careers</h1>
        <p>Review key differences between selected careers.</p>
    </div>

    <% if (careers == null || careers.size() < 2) { %>
        <div class="career-card">
            <h2>Select at least two careers</h2>
            <p class="muted">Use the saved careers page to choose two to four careers for comparison.</p>
            <a href="<%= contextPath %>/career?action=saved" class="btn btn-primary">Go to Saved Careers</a>
        </div>
    <% } else { %>
        <table class="compare-table">
            <tr>
                <th>Career</th>
                <% for (Career career : careers) { %>
                    <td><strong><%= career.getCareerName() %></strong></td>
                <% } %>
            </tr>
            <tr>
                <th>Industry</th>
                <% for (Career career : careers) { %>
                    <td><%= career.getIndustry() %></td>
                <% } %>
            </tr>
            <tr>
                <th>Demand</th>
                <% for (Career career : careers) { %>
                    <td><%= career.getDemandLevel() %></td>
                <% } %>
            </tr>
            <tr>
                <th>Remote</th>
                <% for (Career career : careers) { %>
                    <td><%= career.getRemoteOpportunity() %></td>
                <% } %>
            </tr>
            <tr>
                <th>Growth</th>
                <% for (Career career : careers) { %>
                    <td><%= career.getGrowthRate() %>%</td>
                <% } %>
            </tr>
            <tr>
                <th>Salary</th>
                <% for (Career career : careers) { %>
                    <td>NPR <%= career.getSalaryEntry() %> - NPR <%= career.getSalarySenior() %></td>
                <% } %>
            </tr>
            <tr>
                <th>Summary</th>
                <% for (Career career : careers) { %>
                    <td class="muted"><%= career.getOverview() %></td>
                <% } %>
            </tr>
        </table>
    <% } %>
</div>
</body>
</html>
