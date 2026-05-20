<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.disha.model.User, com.disha.model.Career, java.util.List" %>
<%
    User cu = (User) session.getAttribute("loggedInUser");
    if (cu == null || !"ADMIN".equals(cu.getRole().name())) { response.sendRedirect(request.getContextPath() + "/JSP/auth/login.jsp"); return; }
    List<Career> careers = (List<Career>) request.getAttribute("careers");
    String searchQuery = (String) request.getAttribute("searchQuery");
    String msg = request.getParameter("msg");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Careers - DISHA Admin</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/disha-main.css">
</head>
<body>
<div class="dashboard-layout">
    <jsp:include page="../includes/sidebar.jsp" />
    <div class="main-content">
        <jsp:include page="../includes/dashboard-header.jsp" />
        <div class="dashboard-body">
            <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 1.5rem; flex-wrap: wrap; gap: 1rem;">
                <h1 class="page-title" style="margin:0; color: var(--color-primary);">Manage Careers</h1>
                <a href="<%= request.getContextPath() %>/admin/careers?action=add" class="btn btn-primary">+ Add Career</a>
            </div>

            <% if ("deleted".equals(msg)) { %><div class="alert alert-success">Career deleted successfully.</div><% } %>
            <% if ("delete_blocked".equals(msg)) { %><div class="alert alert-error">Career could not be deleted because it is linked to normalized records such as skills, roadmaps, matches, degrees, or labour market data.</div><% } %>
            <% if ("added".equals(msg)) { %><div class="alert alert-success">Career added successfully.</div><% } %>
            <% if ("updated".equals(msg)) { %><div class="alert alert-success">Career updated successfully.</div><% } %>

            <!-- Search -->
            <div class="card" style="margin-bottom: 1.5rem;">
                <form method="GET" action="<%= request.getContextPath() %>/admin/careers" style="display: flex; gap: 1rem; align-items: flex-end;">
                    <input type="hidden" name="action" value="list">
                    <div class="form-group" style="flex:1; margin-bottom:0;">
                        <label>Search Careers</label>
                        <input type="text" name="search" placeholder="Search by career name..." value="<%= searchQuery != null ? searchQuery : "" %>">
                    </div>
                    <button type="submit" class="btn btn-primary" style="height: fit-content;"> Search</button>
                </form>
            </div>

            <!-- Careers Table -->
            <div class="table-container">
                <table class="table">
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Career Name</th>
                            <th>Industry</th>
                            <th>Mid Salary (NPR)</th>
                            <th>Demand</th>
                            <th>Growth Rate</th>
                            <th>Automation Risk</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                    <% if (careers != null) for (Career c : careers) { %>
                        <tr>
                            <td><%= c.getCareerId() %></td>
                            <td>
                                <strong><%= c.getCareerName() %></strong>
                                <br><small style="color:var(--color-text-muted);"><%= c.getOverview() != null ? c.getOverview() : "" %></small>
                            </td>
                            <td><%= c.getIndustry() != null ? c.getIndustry() : "N/A" %></td>
                            <td><%= c.getSalaryMid() != null ? String.format("%,.0f", c.getSalaryMid()) : "N/A" %></td>
                            <td>
                                <span class="badge badge-<%= "HIGH".equals(c.getDemandLevel()) ? "success" : "MEDIUM".equals(c.getDemandLevel()) ? "warning" : "danger" %>">
                                    <%= c.getDemandLevel() %>
                                </span>
                            </td>
                            <td><%= c.getGrowthRate() != null ? c.getGrowthRate() + "%" : "N/A" %></td>
                            <td><%= c.getAutomationRisk() != null ? c.getAutomationRisk() : "N/A" %></td>
                            <td style="display:flex; gap:0.5rem;">
                                <a href="<%= request.getContextPath() %>/admin/careers?action=edit&id=<%= c.getCareerId() %>" class="btn btn-secondary" style="padding:0.4rem 0.8rem; font-size:0.85rem;">Edit</a>
                                <a href="<%= request.getContextPath() %>/admin/careers?action=delete&id=<%= c.getCareerId() %>" class="btn btn-secondary" style="padding:0.4rem 0.8rem; font-size:0.85rem; color:var(--color-danger);" onclick="return confirm('Delete this career?')">Delete</a>
                            </td>
                        </tr>
                    <% } %>
                    <% if (careers == null || careers.isEmpty()) { %><tr><td colspan="7" style="text-align:center; padding:2rem; color:var(--color-text-muted);">No careers found.</td></tr><% } %>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</div>
</body>
</html>
