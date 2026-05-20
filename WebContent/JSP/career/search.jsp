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
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Career Search - DISHA</title>
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
                    <h1>Search Careers</h1>
                    <p class="feature-subtitle">Explore career paths by keyword, demand, salary potential, and remote opportunity.</p>
                </div>
                <div class="feature-actions">
                    <a href="<%= contextPath %>/career" class="btn btn-secondary">Recommendations</a>
                    <a href="<%= contextPath %>/career?action=saved" class="btn btn-primary">Saved Careers</a>
                </div>
            </section>

            <nav class="feature-tabs">
                <a href="<%= contextPath %>/career" class="feature-tab">Recommendations</a>
                <span class="feature-tab active">Search</span>
                <a href="<%= contextPath %>/career?action=saved" class="feature-tab">Saved</a>
            </nav>

            <section class="panel" style="margin-bottom:1.5rem;">
                <h2>Find a Career</h2>
                <form method="get" action="<%= contextPath %>/career" class="filter-grid" style="margin-bottom:1rem;">
                    <input type="hidden" name="action" value="search">
                    <div>
                        <label for="keyword">Keyword</label>
                        <input id="keyword" name="keyword" value="<%= keyword == null ? "" : keyword %>" placeholder="software, data, design">
                    </div>
                    <div style="align-self:end;">
                        <button type="submit" class="btn btn-primary" style="width:100%;">Search</button>
                    </div>
                </form>

                <form method="get" action="<%= contextPath %>/career" class="filter-grid">
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
                    <div style="align-self:end;">
                        <button type="submit" class="btn btn-primary" style="width:100%;">Apply Filters</button>
                    </div>
                </form>
            </section>

            <% if (careers == null || careers.isEmpty()) { %>
                <section class="empty-state">
                    <h2>No careers found</h2>
                    <p class="muted-copy">Try a different keyword or remove filters.</p>
                </section>
            <% } else { %>
                <div class="career-grid">
                    <% for (Career career : careers) { %>
                        <article class="career-card">
                            <div>
                                <h2><%= career.getCareerName() %></h2>
                                <p class="muted-copy"><%= career.getOverview() %></p>
                            </div>
                            <div class="pill-row">
                                <span class="pill"><%= career.getIndustry() %></span>
                                <span class="pill">Demand: <%= career.getDemandLevel() %></span>
                            </div>
                            <div class="inline-actions">
                                <a href="<%= contextPath %>/career?action=details&careerId=<%= career.getCareerId() %>" class="btn btn-secondary">View Details</a>
                            </div>
                        </article>
                    <% } %>
                </div>
            <% } %>
        </main>
    </div>
</div>
</body>
</html>
