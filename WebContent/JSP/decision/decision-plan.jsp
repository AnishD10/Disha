<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.disha.model.DecisionPlan, com.disha.model.User, java.util.List" %>
<%
    /* Frontend guard for this integration UI. Backend ownership can move to the decision-planning branch. */
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

    // Re-populate applied filters
    Object fBudget    = request.getAttribute("filterMaxBudget");
    Object fLocation  = request.getAttribute("filterLocation");
    Object fPercent   = request.getAttribute("filterPercent");
    Object fCareer    = request.getAttribute("filterCareer");
    Object fFaculty   = request.getAttribute("filterFaculty");
    Object fScholar   = request.getAttribute("filterScholarship");

    boolean hasSearched = results != null;
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Decision Planning â€” DISHA Nepal</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/disha-main.css">
    <style>
        .fee-highlight { color: var(--color-primary); }

        .no-results-tip {
            margin-top: 12px;
            font-size:  0.83rem;
            color:      var(--color-text-dim);
        }

        .applied-filters {
            display:        flex;
            flex-wrap:      wrap;
            gap:            8px;
            margin-bottom:  16px;
        }

        .filter-chip {
            background:    rgba(244,162,45,0.08);
            border:        1px solid rgba(244,162,45,0.25);
            color:         var(--color-primary);
            border-radius: var(--radius-full);
            padding:       3px 12px;
            font-size:     0.78rem;
            font-family:   var(--font-mono);
        }

        .contact-info {
            font-size:  0.8rem;
            color:      var(--color-text-muted);
            margin-top: 6px;
        }
    </style>
</head>
<body>

<!-- â”€â”€ Navbar â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€ -->
<nav class="navbar">
    <a href="<%= request.getContextPath() %>/JSP/student/dashboard.jsp" class="nav-brand">DISHA</a>
    <div class="nav-user">
        <span>Welcome, <%= currentUser.getFullName() %></span>
        <span class="role-chip"><%= currentUser.getRole().name() %></span>
        <a href="<%= request.getContextPath() %>/auth/logout" class="btn btn-sm btn-secondary">Log Out</a>
    </div>
</nav>

<!-- â”€â”€ Page Content â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€ -->
<div class="page-wrapper">

    <div class="page-header">
        <h1>ðŸ§­ Decision Planning</h1>
        <p>Filter degrees and colleges by your budget, location, academic score, and career goals.</p>
    </div>

    <!-- Error message -->
    <% if (errorMessage != null) { %>
    <div class="alert alert-error" style="margin-bottom: 20px;">
        <span>âš </span> <%= errorMessage %>
    </div>
    <% } %>

    <div class="decision-grid">

        <!-- â”€â”€ Filter Panel â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€ -->
        <aside class="filter-panel">
            <h3>ðŸ” Filter Options</h3>

            <form method="POST" action="<%= request.getContextPath() %>/decision/plan">

                <!-- Budget -->
                <div class="filter-section">
                    <label for="maxBudget">Max Annual Fee (NPR)</label>
                    <input type="number" id="maxBudget" name="maxBudget" min="0" step="5000"
                           placeholder="e.g. 150000"
                           value="<%= fBudget != null && !fBudget.equals(0.0) ? fBudget : "" %>">
                </div>

                <!-- Location -->
                <div class="filter-section">
                    <label for="location">Location / District</label>
                    <select id="location" name="location">
                        <option value="">â€” Any Location â€”</option>
                        <% if (locations != null) {
                            for (String loc : locations) {
                                boolean selected = loc.equals(fLocation);
                        %>
                        <option value="<%= loc %>" <%= selected ? "selected" : "" %>><%= loc %></option>
                        <% }} %>
                    </select>
                </div>

                <!-- Academic Score -->
                <div class="filter-section">
                    <label for="studentPercent">My Academic Score (%)</label>
                    <input type="number" id="studentPercent" name="studentPercent"
                           min="0" max="100" step="0.5"
                           placeholder="e.g. 72.5"
                           value="<%= fPercent != null && !fPercent.equals(0.0) ? fPercent : "" %>">
                </div>

                <!-- Faculty -->
                <div class="filter-section">
                    <label for="faculty">Faculty / Stream</label>
                    <select id="faculty" name="faculty">
                        <option value="">â€” Any Faculty â€”</option>
                        <% if (faculties != null) {
                            for (String fac : faculties) {
                                boolean selected = fac.equals(fFaculty);
                        %>
                        <option value="<%= fac %>" <%= selected ? "selected" : "" %>><%= fac %></option>
                        <% }} %>
                    </select>
                </div>

                <!-- Career Path -->
                <div class="filter-section">
                    <label for="careerPath">Career Interest</label>
                    <select id="careerPath" name="careerPath">
                        <option value="">â€” Any Career â€”</option>
                        <% if (careerPaths != null) {
                            for (String cp : careerPaths) {
                                boolean selected = cp.equals(fCareer);
                        %>
                        <option value="<%= cp %>" <%= selected ? "selected" : "" %>><%= cp %></option>
                        <% }} %>
                    </select>
                </div>

                <!-- Scholarship -->
                <div class="checkbox-group">
                    <input type="checkbox" id="scholarshipOnly" name="scholarshipOnly"
                        <%= Boolean.TRUE.equals(fScholar) ? "checked" : "" %>>
                    <label for="scholarshipOnly">Scholarship Available Only</label>
                </div>

                <button type="submit" class="btn btn-primary" style="width:100%; margin-top: 8px;">
                    Find Programmes â†’
                </button>

                <% if (hasSearched) { %>
                <a href="<%= request.getContextPath() %>/decision/plan"
                   class="btn btn-secondary" style="width:100%; margin-top: 10px; text-align:center;">
                    Clear Filters
                </a>
                <% } %>

            </form>
        </aside>

        <!-- â”€â”€ Results Panel â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€ -->
        <main class="results-panel">

            <% if (!hasSearched) { %>
            <!-- Prompt state â€” no search yet -->
            <div class="empty-state">
                <div class="empty-icon">ðŸ—ºï¸</div>
                <h3>Set your filters and find the right programme</h3>
                <p class="no-results-tip">
                    Leave any filter blank to search across all values.<br>
                    Results are sorted by lowest annual fee.
                </p>
            </div>

            <% } else { %>

            <!-- Applied filter chips -->
            <div class="applied-filters">
                <% if (fBudget != null && !fBudget.equals(0.0)) { %>
                <span class="filter-chip">Budget â‰¤ NPR <%= fBudget %></span>
                <% } %>
                <% if (fLocation != null && !fLocation.toString().isEmpty()) { %>
                <span class="filter-chip">ðŸ“ <%= fLocation %></span>
                <% } %>
                <% if (fPercent != null && !fPercent.equals(0.0)) { %>
                <span class="filter-chip">Score â‰¥ <%= fPercent %>%</span>
                <% } %>
                <% if (fFaculty != null && !fFaculty.toString().isEmpty()) { %>
                <span class="filter-chip"><%= fFaculty %></span>
                <% } %>
                <% if (fCareer != null && !fCareer.toString().isEmpty()) { %>
                <span class="filter-chip">ðŸŽ¯ <%= fCareer %></span>
                <% } %>
                <% if (Boolean.TRUE.equals(fScholar)) { %>
                <span class="filter-chip">ðŸ… Scholarship</span>
                <% } %>
            </div>

            <div class="results-header">
                <h3>Matching Programmes</h3>
                <span class="count-badge"><%= resultCount %> found</span>
            </div>

            <% if (results.isEmpty()) { %>
            <div class="empty-state">
                <div class="empty-icon">ðŸ”</div>
                <h3>No programmes match your current filters</h3>
                <p class="no-results-tip">
                    Try increasing your budget, relaxing the location filter,
                    or lowering the academic score threshold.
                </p>
            </div>

            <% } else {
                for (DecisionPlan dp : results) { %>

            <div class="result-card">
                <div class="result-card-header">
                    <div>
                        <div class="college-name"><%= dp.getCollegeName() %></div>
                        <div class="degree-name">
                            <%= dp.getDegreeName() %> â€” <%= dp.getFaculty() %>
                            (<%= dp.getDurationYears() %> yrs, <%= dp.getAffiliation() %>)
                        </div>
                    </div>
                    <% if (dp.isScholarshipAvailable()) { %>
                    <span class="scholarship-badge">ðŸ… Scholarship</span>
                    <% } %>
                </div>

                <div class="result-card-meta">
                    <div class="meta-item">
                        <div class="meta-label">Annual Fee</div>
                        <div class="meta-value fee-highlight">
                            NPR <%= String.format("%,.0f", dp.getAnnualFeeNPR()) %>
                        </div>
                    </div>
                    <div class="meta-item">
                        <div class="meta-label">Min. Score</div>
                        <div class="meta-value"><%= dp.getMinimumPercentage() %>%</div>
                    </div>
                    <div class="meta-item">
                        <div class="meta-label">Location</div>
                        <div class="meta-value" style="font-family: var(--font-body); font-size: 0.85rem;">
                            ðŸ“ <%= dp.getLocation() %>
                        </div>
                    </div>
                </div>

                <div class="result-card-tags">
                    <% if (dp.getCareerPath() != null && !dp.getCareerPath().isEmpty()) {
                        for (String tag : dp.getCareerPath().split(",")) { %>
                    <span class="tag">ðŸŽ¯ <%= tag.trim() %></span>
                    <%     }
                    } %>
                </div>

                <% if (dp.getContactInfo() != null && !dp.getContactInfo().isEmpty()) { %>
                <div class="contact-info">ðŸ“ž <%= dp.getContactInfo() %></div>
                <% } %>
            </div>

            <%   }
            } %>
            <% } %>

        </main>

    </div><!-- /.decision-grid -->
</div><!-- /.page-wrapper -->

</body>
</html>
