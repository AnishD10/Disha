<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.disha.model.User" %>
<%@ page import="com.disha.model.ParentDashboardData" %>
<%@ page import="com.disha.model.ParentDashboardData.CareerMatch" %>
<%@ page import="com.disha.model.ParentDashboardData.DegreeOption" %>
<%@ page import="java.util.List" %>
<%
    User currentUser = (User) session.getAttribute("loggedInUser");
    if (currentUser == null) {
        response.sendRedirect(request.getContextPath() + "/JSP/auth/login.jsp");
        return;
    }
    
    ParentDashboardData dashboardData = (ParentDashboardData) request.getAttribute("dashboardData");
    Integer selectedBudget = (Integer) request.getAttribute("selectedBudget");
    String errorMessage = (String) request.getAttribute("errorMessage");

    if (dashboardData == null) {
        response.sendRedirect(request.getContextPath() + "/parent-dashboard");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Parent Dashboard — DISHA</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/CSS/disha-main.css">
    <style>
        /* Extra styles for fine-tuning premium look */
        tr:hover td {
            background: rgba(255, 255, 255, 0.02);
        }
    </style>
</head>
<body>
<nav class="navbar">
    <a href="#" class="nav-brand">DISHA</a>
    <div class="nav-user">
        <span>Welcome, <%= currentUser.getFullName() %></span>
        <span class="role-chip">PARENT</span>
        <a href="<%= request.getContextPath() %>/JSP/auth/login.jsp" class="btn btn-sm btn-secondary">Log Out</a>
    </div>
</nav>

<div class="page-wrapper">
    <div class="page-header">
        <h1>👨‍👩‍👧 Parent Dashboard</h1>
        <p>Career guidance information and academic analysis for your child</p>
    </div>

    <% if (errorMessage != null) { %>
        <div class="alert alert-error">
            <p><%= errorMessage %></p>
        </div>
    <% } %>

    <!-- Child Profile Card -->
    <div class="result-card" style="margin-bottom: 24px;">
        <h3 style="color: var(--color-primary); margin: 0 0 8px 0; display: flex; align-items: center; gap: 8px;">
            <span>👤</span> Child Profile: <%= dashboardData.getChildName() %>
        </h3>
        <p style="color: var(--color-text-muted); font-size: 0.95rem; margin: 0;">
            Here you can view the career planning details and academic progression of your child.
        </p>
    </div>

    <!-- Aptitude assessment results -->
    <div class="result-card" style="margin-bottom: 24px;">
        <div class="result-card-header" style="border-bottom: 1px solid var(--color-border); padding-bottom: 12px; margin-bottom: 16px;">
            <h2 style="margin: 0; font-size: 1.4rem;">🧠 Aptitude Assessment Analysis</h2>
        </div>
        
        <% if (dashboardData.getAptitudeSummary() == null || dashboardData.getAptitudeSummary().contains("not completed")) { %>
            <div class="alert alert-error" style="margin: 0;">
                <p>Your child has not completed the aptitude assessment yet.</p>
            </div>
        <% } else { %>
            <div style="display: grid; grid-template-columns: 1fr; gap: 16px;">
                <div style="background: var(--color-surface-2); border: 1px solid var(--color-border); border-radius: 12px; padding: 18px;">
                    <span class="meta-label">Overall Summary</span>
                    <p style="margin: 8px 0 0 0; line-height: 1.6; color: var(--color-text);"><%= dashboardData.getAptitudeSummary() %></p>
                </div>
                <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 16px;">
                    <div style="background: rgba(34, 197, 94, 0.08); border: 1px solid rgba(34, 197, 94, 0.2); border-radius: 12px; padding: 18px;">
                        <span class="meta-label" style="color: #22c55e;">Key Strengths</span>
                        <p style="margin: 8px 0 0 0; line-height: 1.5; color: var(--color-text);"><%= dashboardData.getStrengthClusters() %></p>
                    </div>
                    <div style="background: rgba(239, 68, 68, 0.08); border: 1px solid rgba(239, 68, 68, 0.2); border-radius: 12px; padding: 18px;">
                        <span class="meta-label" style="color: #ef4444;">Areas to Develop</span>
                        <p style="margin: 8px 0 0 0; line-height: 1.5; color: var(--color-text);"><%= dashboardData.getWeaknessClusters() %></p>
                    </div>
                </div>
            </div>
        <% } %>
    </div>

    <!-- Career Path Matches -->
    <div class="result-card" style="margin-bottom: 24px;">
        <div class="result-card-header" style="border-bottom: 1px solid var(--color-border); padding-bottom: 12px; margin-bottom: 16px;">
            <h2 style="margin: 0; font-size: 1.4rem;">💼 Recommended Career Paths</h2>
        </div>
        
        <% List<CareerMatch> careers = dashboardData.getMatchedCareers();
           if (careers == null || careers.isEmpty()) { %>
            <div class="empty-state">
                <div class="empty-icon">📂</div>
                <p>No career recommendations found yet. Your child needs to take the assessment first.</p>
            </div>
        <% } else { %>
            <div style="display: grid; gap: 16px;">
                <% for (CareerMatch career : careers) { %>
                    <div style="background: var(--color-surface-2); border: 1px solid var(--color-border); border-radius: 12px; padding: 18px;">
                        <div style="display: flex; justify-content: space-between; align-items: center; flex-wrap: wrap; gap: 12px;">
                            <h3 style="color: var(--color-primary); margin: 0;"><%= career.getCareerName() %></h3>
                            <div style="display: flex; gap: 8px;">
                                <span class="count-badge">Demand: <%= career.getDemandLevel() %></span>
                                <span class="tag" style="border-color: rgba(239, 68, 68, 0.3); color: #ef4444;">Risk: <%= career.getRiskIndex() %></span>
                            </div>
                        </div>
                        <p style="margin: 12px 0; font-size: 0.95rem; color: var(--color-text-muted); line-height: 1.5;"><%= career.getPlainDescription() %></p>
                        <div style="display: flex; justify-content: space-between; align-items: center; border-top: 1px solid rgba(255,255,255,0.05); padding-top: 8px; font-size: 0.85rem;">
                            <span style="color: var(--color-text-dim);">Est. Starting Salary:</span>
                            <strong style="color: #22c55e;"><%= career.getSalaryRange() %></strong>
                        </div>
                    </div>
                <% } %>
            </div>
        <% } %>
    </div>

    <!-- College Degrees Budget Filter -->
    <div class="result-card">
        <div class="result-card-header" style="border-bottom: 1px solid var(--color-border); padding-bottom: 12px; margin-bottom: 16px;">
            <h2 style="margin: 0; font-size: 1.4rem;">🎓 Affordable Degree & College Options</h2>
        </div>
        
        <form method="POST" action="<%= request.getContextPath() %>/parent-dashboard" style="background: var(--color-surface-2); padding: 18px; border-radius: 12px; border: 1px solid var(--color-border); margin-bottom: 20px; display: flex; gap: 16px; align-items: flex-end; flex-wrap: wrap;">
            <div style="flex: 1; min-width: 200px;">
                <label for="budget" style="margin-bottom: 8px; font-size: 0.88rem;">Annual Fee Budget (NPR)</label>
                <input type="number" id="budget" name="budget" value="<%= selectedBudget != null ? selectedBudget : 200000 %>" min="10000" max="2000000" step="10000" style="padding: 10px; border-radius: 8px; width: 100%;">
            </div>
            <div>
                <button type="submit" class="btn btn-primary" style="padding: 11px 24px; border-radius: 8px;">Filter Degrees</button>
            </div>
        </form>
        
        <% List<DegreeOption> degrees = dashboardData.getDegreeOptions();
           if (degrees == null || degrees.isEmpty()) { %>
            <div class="empty-state">
                <div class="empty-icon">🏫</div>
                <p>No degree programs found within NPR <%= selectedBudget %> / year. Try expanding your budget.</p>
            </div>
        <% } else { %>
            <div style="overflow-x: auto;">
                <table style="width: 100%; border-collapse: collapse; margin-top: 8px; min-width: 600px;">
                    <thead>
                        <tr style="border-bottom: 2px solid var(--color-border);">
                            <th style="padding: 12px; text-align: left; color: var(--color-text-muted); font-size: 0.85rem; font-weight: 700; text-transform: uppercase;">Degree Program</th>
                            <th style="padding: 12px; text-align: left; color: var(--color-text-muted); font-size: 0.85rem; font-weight: 700; text-transform: uppercase;">College / University</th>
                            <th style="padding: 12px; text-align: left; color: var(--color-text-muted); font-size: 0.85rem; font-weight: 700; text-transform: uppercase;">Location</th>
                            <th style="padding: 12px; text-align: left; color: var(--color-text-muted); font-size: 0.85rem; font-weight: 700; text-transform: uppercase;">Duration</th>
                            <th style="padding: 12px; text-align: right; color: var(--color-text-muted); font-size: 0.85rem; font-weight: 700; text-transform: uppercase;">Annual Fee</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% for (DegreeOption degree : degrees) { %>
                            <tr style="border-bottom: 1px solid rgba(255,255,255,0.05); transition: background 0.2s;">
                                <td style="padding: 14px 12px; font-weight: 700; color: var(--color-text);"><%= degree.getDegreeName() %></td>
                                <td style="padding: 14px 12px; color: var(--color-text-muted);"><%= degree.getCollegeName() %></td>
                                <td style="padding: 14px 12px; color: var(--color-text-dim); font-size: 0.9rem;"><%= degree.getLocation() %></td>
                                <td style="padding: 14px 12px; color: var(--color-text-muted);"><%= degree.getDuration() %></td>
                                <td style="padding: 14px 12px; text-align: right; font-weight: 700; color: var(--color-primary);"><%= degree.getAnnualFeeNPR() %></td>
                            </tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
        <% } %>
    </div>
</div>
</body>
</html>
