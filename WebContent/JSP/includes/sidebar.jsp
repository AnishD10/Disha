<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    String userRole = (String) session.getAttribute("userRole");
    // Fallback based on URI if we are browsing without proper login (for frontend design demo purpose)
    String uri = request.getRequestURI();
    if (userRole == null) {
        if (uri.contains("/student/")) userRole = "STUDENT";
        else if (uri.contains("/parent/")) userRole = "PARENT";
        else if (uri.contains("/consultant/") || uri.contains("/counselor/")) userRole = "COUNSELOR";
        else if (uri.contains("/admin/")) userRole = "ADMIN";
        else userRole = "STUDENT"; // default
    }
%>
<aside class="sidebar">
    <div class="sidebar-logo">
        <h2 style="margin: 0;">DISHA</h2>
    </div>
    <ul class="sidebar-nav">
        <% if ("STUDENT".equalsIgnoreCase(userRole)) { %>
            <li class="nav-item">
                <a href="<%= request.getContextPath() %>/JSP/student/dashboard.jsp" class="nav-link <%= uri.endsWith("dashboard.jsp") ? "active":""%>">
                    <span style="font-size: 1.2rem;">📊</span> <span>Dashboard</span>
                </a>
            </li>
            <li class="nav-item">
                <a href="<%= request.getContextPath() %>/JSP/student/assessment.jsp" class="nav-link <%= uri.endsWith("assessment.jsp") ? "active":""%>">
                    <span style="font-size: 1.2rem;">📝</span> <span>Assessment</span>
                </a>
            </li>
            <li class="nav-item">
                <a href="<%= request.getContextPath() %>/JSP/student/career-matches.jsp" class="nav-link <%= uri.endsWith("career-matches.jsp") || uri.endsWith("results.jsp") || uri.endsWith("career-detail.jsp") ? "active":""%>">
                    <span style="font-size: 1.2rem;">🎯</span> <span>Career Matches</span>
                </a>
            </li>
            <li class="nav-item">
                <a href="<%= request.getContextPath() %>/JSP/student/progress-tracker.jsp" class="nav-link <%= uri.endsWith("progress-tracker.jsp") ? "active":""%>">
                    <span style="font-size: 1.2rem;">📈</span> <span>Progress</span>
                </a>
            </li>
            <li class="nav-item">
                <a href="<%= request.getContextPath() %>/JSP/student/profile.jsp" class="nav-link <%= uri.endsWith("profile.jsp") ? "active":""%>">
                    <span style="font-size: 1.2rem;">👤</span> <span>Profile</span>
                </a>
            </li>

        <% } else if ("PARENT".equalsIgnoreCase(userRole)) { %>
            <li class="nav-item">
                <a href="<%= request.getContextPath() %>/JSP/parent/dashboard.jsp" class="nav-link <%= uri.endsWith("dashboard.jsp") ? "active":""%>">
                    <span style="font-size: 1.2rem;">📊</span> <span>Dashboard</span>
                </a>
            </li>
            <li class="nav-item">
                <a href="<%= request.getContextPath() %>/JSP/parent/child-report.jsp" class="nav-link <%= uri.endsWith("child-report.jsp") ? "active":""%>">
                    <span style="font-size: 1.2rem;">📄</span> <span>Child Report</span>
                </a>
            </li>
            <li class="nav-item">
                <a href="<%= request.getContextPath() %>/JSP/parent/career-suggestions.jsp" class="nav-link <%= uri.endsWith("career-suggestions.jsp") ? "active":""%>">
                    <span style="font-size: 1.2rem;">💡</span> <span>Suggestions</span>
                </a>
            </li>
            <li class="nav-item">
                <a href="<%= request.getContextPath() %>/JSP/parent/budget-degree.jsp" class="nav-link <%= uri.endsWith("budget-degree.jsp") ? "active":""%>">
                    <span style="font-size: 1.2rem;">💰</span> <span>Budgeting</span>
                </a>
            </li>

        <% } else if ("COUNSELOR".equalsIgnoreCase(userRole) || "CONSULTANT".equalsIgnoreCase(userRole)) { %>
            <li class="nav-item">
                <a href="<%= request.getContextPath() %>/JSP/consultant/dashboard.jsp" class="nav-link <%= uri.endsWith("dashboard.jsp") ? "active":""%>">
                    <span style="font-size: 1.2rem;">📊</span> <span>Dashboard</span>
                </a>
            </li>
            <li class="nav-item">
                <a href="<%= request.getContextPath() %>/JSP/consultant/student-list.jsp" class="nav-link <%= uri.endsWith("student-list.jsp") || uri.endsWith("student-report.jsp") ? "active":""%>">
                    <span style="font-size: 1.2rem;">👥</span> <span>Students</span>
                </a>
            </li>
            <li class="nav-item">
                <a href="<%= request.getContextPath() %>/JSP/consultant/analytics.jsp" class="nav-link <%= uri.endsWith("analytics.jsp") ? "active":""%>">
                    <span style="font-size: 1.2rem;">📈</span> <span>Analytics</span>
                </a>
            </li>

        <% } else if ("ADMIN".equalsIgnoreCase(userRole)) { %>
            <li class="nav-item">
                <a href="<%= request.getContextPath() %>/admin/dashboard" class="nav-link <%= uri.contains("dashboard") ? "active":""%>">
                    <span style="font-size: 1.2rem;">📊</span> <span>Dashboard</span>
                </a>
            </li>
            <li class="nav-item">
                <a href="<%= request.getContextPath() %>/admin/users" class="nav-link <%= uri.contains("user") ? "active":""%>">
                    <span style="font-size: 1.2rem;">👥</span> <span>Manage Users</span>
                </a>
            </li>
            <li class="nav-item">
                <a href="<%= request.getContextPath() %>/admin/careers" class="nav-link <%= uri.contains("career") ? "active":""%>">
                    <span style="font-size: 1.2rem;">💼</span> <span>Manage Careers</span>
                </a>
            </li>
            <li class="nav-item">
                <a href="<%= request.getContextPath() %>/admin/colleges" class="nav-link <%= uri.contains("college") ? "active":""%>">
                    <span style="font-size: 1.2rem;">🏫</span> <span>Colleges</span>
                </a>
            </li>
            <li class="nav-item">
                <a href="<%= request.getContextPath() %>/JSP/admin/reports.jsp" class="nav-link <%= uri.contains("report") ? "active":""%>">
                    <span style="font-size: 1.2rem;">📝</span> <span>Reports</span>
                </a>
            </li>
        <% } %>
    </ul>
    
    <div class="sidebar-footer">
        <a href="<%= request.getContextPath() %>/auth/logout" class="nav-link">
            <span style="font-size: 1.2rem;">🚪</span> <span style="color: var(--color-danger); font-weight: bold;">Logout</span>
        </a>
    </div>
</aside>
