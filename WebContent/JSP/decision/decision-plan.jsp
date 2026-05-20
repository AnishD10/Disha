<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.disha.model.DecisionPlan, com.disha.model.User, java.util.List" %>
<%
    User currentUser = (User) session.getAttribute("loggedInUser");
    if (currentUser == null) {
        response.sendRedirect(request.getContextPath() + "/JSP/auth/login.jsp");
        return;
    }

    List<DecisionPlan> results   = (List<DecisionPlan>) request.getAttribute("results");
    List<String> faculties       = (List<String>) request.getAttribute("faculties");
    List<String> locations       = (List<String>) request.getAttribute("locations");
    List<String> careerPaths     = (List<String>) request.getAttribute("careerPaths");
    Integer resultCount          = (Integer) request.getAttribute("resultCount");
    String errorMessage          = (String) request.getAttribute("errorMessage");

    Object fBudget    = request.getAttribute("filterMaxBudget");
    Object fLocation  = request.getAttribute("filterLocation");
    Object fPercent   = request.getAttribute("filterPercent");
    Object fCareer    = request.getAttribute("filterCareer");
    Object fFaculty   = request.getAttribute("filterFaculty");
    Object fScholar   = request.getAttribute("filterScholarship");

    boolean hasSearched = results != null;
    int safeResultCount = resultCount != null ? resultCount : 0;
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Decision Planning - DISHA Nepal</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/disha-main.css">
</head>
<body>
<div class="dashboard-layout">
    <jsp:include page="../includes/sidebar.jsp" />
    <div class="main-content">
        <jsp:include page="../includes/dashboard-header.jsp" />
        <main class="dashboard-body">
            <section class="feature-hero">
                <div>
                    <span class="feature-eyebrow">Decision Planning</span>
                    <h1>Programme Finder</h1>
                    <p class="feature-subtitle">Compare degrees and colleges by budget, location, academic score, faculty, and career interest.</p>
                </div>
                <div class="feature-actions">
                    <a href="<%= request.getContextPath() %>/career?action=search" class="btn btn-secondary">Explore Careers</a>
                    <a href="<%= request.getContextPath() %>/assessment/start" class="btn btn-primary">Aptitude Test</a>
                </div>
            </section>

            <% if (errorMessage != null) { %>
                <div class="alert alert-error"><span>Warning</span> <%= errorMessage %></div>
            <% } %>

            <div class="two-column-layout">
                <aside class="panel">
                    <h2>Filters</h2>
                    <form method="POST" action="<%= request.getContextPath() %>/decision/plan" class="section-stack">
                        <div>
                            <label for="maxBudget">Max Annual Fee (NPR)</label>
                            <input type="number" id="maxBudget" name="maxBudget" min="0" step="5000"
                                   placeholder="e.g. 150000"
                                   value="<%= fBudget != null && !fBudget.equals(0.0) ? fBudget : "" %>">
                        </div>

                        <div>
                            <label for="location">Location / District</label>
                            <select id="location" name="location">
                                <option value="">Any Location</option>
                                <% if (locations != null) {
                                    for (String loc : locations) {
                                        boolean selected = loc.equals(fLocation);
                                %>
                                <option value="<%= loc %>" <%= selected ? "selected" : "" %>><%= loc %></option>
                                <% }} %>
                            </select>
                        </div>

                        <div>
                            <label for="studentPercent">Academic Score (%)</label>
                            <input type="number" id="studentPercent" name="studentPercent"
                                   min="0" max="100" step="0.5"
                                   placeholder="e.g. 72.5"
                                   value="<%= fPercent != null && !fPercent.equals(0.0) ? fPercent : "" %>">
                        </div>

                        <div>
                            <label for="faculty">Faculty / Stream</label>
                            <select id="faculty" name="faculty">
                                <option value="">Any Faculty</option>
                                <% if (faculties != null) {
                                    for (String fac : faculties) {
                                        boolean selected = fac.equals(fFaculty);
                                %>
                                <option value="<%= fac %>" <%= selected ? "selected" : "" %>><%= fac %></option>
                                <% }} %>
                            </select>
                        </div>

                        <div>
                            <label for="careerPath">Career Interest</label>
                            <select id="careerPath" name="careerPath">
                                <option value="">Any Career</option>
                                <% if (careerPaths != null) {
                                    for (String cp : careerPaths) {
                                        boolean selected = cp.equals(fCareer);
                                %>
                                <option value="<%= cp %>" <%= selected ? "selected" : "" %>><%= cp %></option>
                                <% }} %>
                            </select>
                        </div>

                        <label style="display:flex; gap:.6rem; align-items:center; margin:0;">
                            <input type="checkbox" id="scholarshipOnly" name="scholarshipOnly"
                                   <%= Boolean.TRUE.equals(fScholar) ? "checked" : "" %> style="width:auto;">
                            <span>Scholarship available only</span>
                        </label>

                        <button type="submit" class="btn btn-primary" style="width:100%;">Find Programmes</button>
                        <% if (hasSearched) { %>
                            <a href="<%= request.getContextPath() %>/decision/plan" class="btn btn-secondary" style="width:100%;">Clear Filters</a>
                        <% } %>
                    </form>
                </aside>

                <section>
                    <% if (!hasSearched) { %>
                        <div class="empty-state">
                            <h2>Set filters to find matching programmes</h2>
                            <p class="muted-copy">Leave fields blank to search across all available values.</p>
                        </div>
                    <% } else { %>
                        <div class="applied-filters">
                            <% if (fBudget != null && !fBudget.equals(0.0)) { %>
                                <span class="filter-chip">Budget <= NPR <%= fBudget %></span>
                            <% } %>
                            <% if (fLocation != null && !fLocation.toString().isEmpty()) { %>
                                <span class="filter-chip"><%= fLocation %></span>
                            <% } %>
                            <% if (fPercent != null && !fPercent.equals(0.0)) { %>
                                <span class="filter-chip">Score >= <%= fPercent %>%</span>
                            <% } %>
                            <% if (fFaculty != null && !fFaculty.toString().isEmpty()) { %>
                                <span class="filter-chip"><%= fFaculty %></span>
                            <% } %>
                            <% if (fCareer != null && !fCareer.toString().isEmpty()) { %>
                                <span class="filter-chip"><%= fCareer %></span>
                            <% } %>
                            <% if (Boolean.TRUE.equals(fScholar)) { %>
                                <span class="filter-chip">Scholarship</span>
                            <% } %>
                        </div>

                        <div class="feature-hero" style="margin-bottom:1rem;">
                            <div>
                                <h2 style="margin:0;">Matching Programmes</h2>
                                <p class="muted-copy"><%= safeResultCount %> found</p>
                            </div>
                        </div>

                        <% if (results.isEmpty()) { %>
                            <div class="empty-state">
                                <h2>No programmes match your filters</h2>
                                <p class="muted-copy">Try increasing your budget, relaxing the location filter, or lowering the academic score threshold.</p>
                            </div>
                        <% } else { %>
                            <div class="planner-results">
                                <% for (DecisionPlan dp : results) { %>
                                    <article class="programme-card">
                                        <div class="programme-card-header">
                                            <div>
                                                <h3 class="programme-title"><%= dp.getCollegeName() %></h3>
                                                <div class="programme-subtitle">
                                                    <%= dp.getDegreeName() %> - <%= dp.getFaculty() %>
                                                    (<%= dp.getDurationYears() %> yrs, <%= dp.getAffiliation() %>)
                                                </div>
                                            </div>
                                            <% if (dp.isScholarshipAvailable()) { %>
                                                <span class="badge badge-success">Scholarship</span>
                                            <% } %>
                                        </div>

                                        <div class="metric-strip">
                                            <div class="metric-box">
                                                <span class="metric-label">Annual Fee</span>
                                                <span class="metric-value">NPR <%= String.format("%,.0f", dp.getAnnualFeeNPR()) %></span>
                                            </div>
                                            <div class="metric-box">
                                                <span class="metric-label">Min. Score</span>
                                                <span class="metric-value"><%= dp.getMinimumPercentage() %>%</span>
                                            </div>
                                            <div class="metric-box">
                                                <span class="metric-label">Location</span>
                                                <span class="metric-value"><%= dp.getLocation() %></span>
                                            </div>
                                        </div>

                                        <% if (dp.getCareerPath() != null && !dp.getCareerPath().isEmpty()) { %>
                                            <div class="pill-row">
                                                <% for (String tag : dp.getCareerPath().split(",")) { %>
                                                    <span class="pill"><%= tag.trim() %></span>
                                                <% } %>
                                            </div>
                                        <% } %>

                                        <% if (dp.getContactInfo() != null && !dp.getContactInfo().isEmpty()) { %>
                                            <p class="muted-copy"><strong>Contact:</strong> <%= dp.getContactInfo() %></p>
                                        <% } %>
                                    </article>
                                <% } %>
                            </div>
                        <% } %>
                    <% } %>
                </section>
            </div>
        </main>
    </div>
</div>
</body>
</html>
