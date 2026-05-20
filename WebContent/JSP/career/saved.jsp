<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.disha.career.model.Career" %>
<%
    List<Career> savedCareers = (List<Career>) request.getAttribute("savedCareers");
    String contextPath = request.getContextPath();
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Saved Careers - DISHA</title>
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
                    <h1>Saved Careers</h1>
                    <p class="feature-subtitle">Review, compare, and remove careers from your shortlist.</p>
                </div>
                <div class="feature-actions">
                    <a href="<%= contextPath %>/career" class="btn btn-secondary">Recommendations</a>
                    <a href="<%= contextPath %>/career?action=search" class="btn btn-secondary">Search Careers</a>
                </div>
            </section>

            <nav class="feature-tabs">
                <a href="<%= contextPath %>/career" class="feature-tab">Recommendations</a>
                <a href="<%= contextPath %>/career?action=search" class="feature-tab">Search</a>
                <span class="feature-tab active">Saved</span>
            </nav>

            <% if (savedCareers == null || savedCareers.isEmpty()) { %>
                <section class="empty-state">
                    <h2>No saved careers</h2>
                    <p class="muted-copy" style="margin-bottom:1rem;">Save careers from your recommendation list to review them here.</p>
                    <a href="<%= contextPath %>/career" class="btn btn-primary">View Recommendations</a>
                </section>
            <% } else { %>
                <form method="get" action="<%= contextPath %>/career">
                    <input type="hidden" name="action" value="compare">
                    <div class="career-grid">
                        <% for (Career career : savedCareers) { %>
                            <article class="career-card">
                                <label class="checkbox-group" style="display:flex; gap:.55rem; align-items:center;">
                                    <input type="checkbox" name="careerId" value="<%= career.getCareerId() %>" style="width:auto;">
                                    Compare
                                </label>
                                <div>
                                    <h2><%= career.getCareerName() %></h2>
                                    <p class="muted-copy"><%= career.getOverview() %></p>
                                </div>
                                <div class="pill-row">
                                    <span class="pill"><%= career.getIndustry() %></span>
                                    <span class="pill">Demand: <%= career.getDemandLevel() %></span>
                                </div>
                                <div class="inline-actions">
                                    <a href="<%= contextPath %>/career?action=details&careerId=<%= career.getCareerId() %>" class="btn btn-secondary">Details</a>
                                    <button type="submit" form="remove-<%= career.getCareerId() %>" class="btn btn-secondary">Remove</button>
                                </div>
                            </article>
                        <% } %>
                    </div>
                    <button type="submit" class="btn btn-primary" style="margin-top:1.25rem;">Compare Selected</button>
                </form>
                <% for (Career career : savedCareers) { %>
                    <form id="remove-<%= career.getCareerId() %>" method="post" action="<%= contextPath %>/career">
                        <input type="hidden" name="action" value="removeBookmark">
                        <input type="hidden" name="careerId" value="<%= career.getCareerId() %>">
                    </form>
                <% } %>
            <% } %>
        </main>
    </div>
</div>
</body>
</html>
