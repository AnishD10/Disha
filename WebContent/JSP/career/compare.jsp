<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.disha.career.model.Career" %>
<%
    List<Career> careers = (List<Career>) request.getAttribute("careersToCompare");
    String contextPath = request.getContextPath();
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Compare Careers - DISHA</title>
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
                    <h1>Compare Careers</h1>
                    <p class="feature-subtitle">Review key differences between selected career paths.</p>
                </div>
                <div class="feature-actions">
                    <a href="<%= contextPath %>/career?action=saved" class="btn btn-primary">Saved Careers</a>
                    <a href="<%= contextPath %>/career?action=search" class="btn btn-secondary">Search Careers</a>
                </div>
            </section>

            <% if (careers == null || careers.size() < 2) { %>
                <section class="empty-state">
                    <h2>Select at least two careers</h2>
                    <p class="muted-copy" style="margin-bottom:1rem;">Use the saved careers page to choose two to four careers for comparison.</p>
                    <a href="<%= contextPath %>/career?action=saved" class="btn btn-primary">Go to Saved Careers</a>
                </section>
            <% } else { %>
                <div class="compare-wrap">
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
                                <td class="muted-copy"><%= career.getOverview() %></td>
                            <% } %>
                        </tr>
                    </table>
                </div>
            <% } %>
        </main>
    </div>
</div>
</body>
</html>
