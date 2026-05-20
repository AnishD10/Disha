<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.disha.model.User, com.disha.model.Career, com.disha.model.LabourMarketData, java.util.List" %>
<%
    User currentUser = (User) session.getAttribute("loggedInUser");
    if (currentUser == null || !"ADMIN".equals(currentUser.getRole().name())) {
        response.sendRedirect(request.getContextPath() + "/JSP/auth/login.jsp");
        return;
    }
    if (request.getAttribute("records") == null) {
        response.sendRedirect(request.getContextPath() + "/admin/labour-market");
        return;
    }

    List<LabourMarketData> records = (List<LabourMarketData>) request.getAttribute("records");
    List<Career> careers = (List<Career>) request.getAttribute("careers");
    LabourMarketData editRecord = (LabourMarketData) request.getAttribute("editRecord");
    boolean editing = editRecord != null;
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Labour Market â€” DISHA Admin</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/disha-main.css">
    <style>
        .labour-form-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(220px, 1fr));
            gap: 1rem;
        }
    </style>
</head>
<body>
<div class="dashboard-layout">
    <jsp:include page="../includes/sidebar.jsp" />
    <div class="main-content">
        <jsp:include page="../includes/dashboard-header.jsp" />
        <div class="dashboard-body">
            <div style="display:flex;justify-content:space-between;gap:1rem;align-items:center;margin-bottom:1.5rem;">
                <div>
                    <h1 class="page-title">Nepal Labour Market</h1>
                    <p style="color:var(--color-text-muted);margin-top:0.35rem;">Manage career demand, salary, risk, job openings, and growth data.</p>
                </div>
            </div>

            <div class="card" style="margin-bottom:2rem;">
                <h3 style="margin-bottom:1rem;"><%= editing ? "Edit Labour Market Record" : "Add Labour Market Record" %></h3>
                <form method="POST" action="<%= request.getContextPath() %>/admin/labour-market">
                    <input type="hidden" name="action" value="<%= editing ? "edit" : "add" %>">
                    <% if (editing) { %>
                        <input type="hidden" name="marketDataId" value="<%= editRecord.getMarketDataId() %>">
                    <% } %>

                    <div class="labour-form-grid">
                        <div class="form-group">
                            <label>Career</label>
                            <select name="careerId" required>
                                <% for (Career career : careers) { %>
                                    <option value="<%= career.getCareerId() %>" <%= editing && editRecord.getCareerId() == career.getCareerId() ? "selected" : "" %>>
                                        <%= career.getCareerName() %>
                                    </option>
                                <% } %>
                            </select>
                        </div>
                        <div class="form-group">
                            <label>Year</label>
                            <input type="number" name="dataYear" min="2000" max="2100" required value="<%= editing ? editRecord.getDataYear() : 2026 %>">
                        </div>
                        <div class="form-group">
                            <label>Job Openings</label>
                            <input type="number" name="jobOpenings" min="0" required value="<%= editing ? editRecord.getJobOpenings() : 0 %>">
                        </div>
                        <div class="form-group">
                            <label>Average Salary</label>
                            <input type="number" name="averageSalary" min="0" step="0.01" required value="<%= editing && editRecord.getAverageSalary() != null ? editRecord.getAverageSalary() : 0 %>">
                        </div>
                        <div class="form-group">
                            <label>Currency</label>
                            <input type="text" name="salaryCurrency" maxlength="10" value="<%= editing ? editRecord.getSalaryCurrency() : "NPR" %>">
                        </div>
                        <div class="form-group">
                            <label>Demand Level</label>
                            <select name="marketDemand">
                                <option value="LOW" <%= editing && "LOW".equals(editRecord.getMarketDemand()) ? "selected" : "" %>>Low</option>
                                <option value="MEDIUM" <%= !editing || "MEDIUM".equals(editRecord.getMarketDemand()) ? "selected" : "" %>>Medium</option>
                                <option value="HIGH" <%= editing && "HIGH".equals(editRecord.getMarketDemand()) ? "selected" : "" %>>High</option>
                            </select>
                        </div>
                        <div class="form-group">
                            <label>Risk Index</label>
                            <input type="number" name="riskIndex" min="0" max="10" value="<%= editing ? editRecord.getRiskIndex() : 0 %>">
                        </div>
                        <div class="form-group">
                            <label>Growth Rate (%)</label>
                            <input type="number" name="growthRate" step="0.01" value="<%= editing && editRecord.getGrowthRate() != null ? editRecord.getGrowthRate() : 0 %>">
                        </div>
                    </div>

                    <div style="display:flex;gap:1rem;margin-top:1rem;">
                        <button type="submit" class="btn btn-primary"><%= editing ? "Save Changes" : "Add Record" %></button>
                        <% if (editing) { %>
                            <a href="<%= request.getContextPath() %>/admin/labour-market" class="btn btn-secondary">Cancel</a>
                        <% } %>
                    </div>
                </form>
            </div>

            <div class="table-container">
                <table class="table">
                    <thead>
                    <tr>
                        <th>Career</th>
                        <th>Year</th>
                        <th>Openings</th>
                        <th>Salary</th>
                        <th>Demand</th>
                        <th>Risk</th>
                        <th>Growth</th>
                        <th>Actions</th>
                    </tr>
                    </thead>
                    <tbody>
                    <% if (records.isEmpty()) { %>
                        <tr><td colspan="8" style="text-align:center;color:var(--color-text-muted);">No labour market records found.</td></tr>
                    <% } else {
                        for (LabourMarketData record : records) { %>
                            <tr>
                                <td><strong><%= record.getCareerName() %></strong></td>
                                <td><%= record.getDataYear() %></td>
                                <td><%= record.getJobOpenings() %></td>
                                <td><%= record.getSalaryCurrency() %> <%= record.getAverageSalary() %></td>
                                <td><span class="badge"><%= record.getMarketDemand() %></span></td>
                                <td><%= record.getRiskIndex() %>/10</td>
                                <td><%= record.getGrowthRate() %>%</td>
                                <td>
                                    <a href="<%= request.getContextPath() %>/admin/labour-market?action=edit&id=<%= record.getMarketDataId() %>" class="btn btn-secondary" style="padding:0.4rem 0.8rem;font-size:0.85rem;">Edit</a>
                                    <a href="<%= request.getContextPath() %>/admin/labour-market?action=delete&id=<%= record.getMarketDataId() %>" class="btn btn-secondary" style="padding:0.4rem 0.8rem;font-size:0.85rem;color:var(--color-danger);" onclick="return confirm('Delete this labour market record?')">Delete</a>
                                </td>
                            </tr>
                    <%  }
                    } %>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</div>
</body>
</html>
