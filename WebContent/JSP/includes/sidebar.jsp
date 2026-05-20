<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    String userRole = (String) session.getAttribute("userRole");
    String uri = request.getRequestURI();
    if (userRole == null) {
        if (uri.contains("/student/")) userRole = "STUDENT";
        else if (uri.contains("/parent/")) userRole = "PARENT";
        else if (uri.contains("/counselor/")) userRole = "COUNSELOR";
        else if (uri.contains("/admin/")) userRole = "ADMIN";
        else userRole = "STUDENT";
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
                    <span style="font-size: 1.2rem;">DB</span> <span>Dashboard</span>
                </a>
            </li>
            <li class="nav-item">
                <a href="<%= request.getContextPath() %>/decision/plan" class="nav-link <%= uri.contains("/decision/") ? "active":""%>">
                    <span style="font-size: 1.2rem;">DP</span> <span>Decision Planning</span>
                </a>
            </li>
            <li class="nav-item">
                <a href="<%= request.getContextPath() %>/assessment/start" class="nav-link <%= uri.contains("/assessment/start") ? "active":""%>">
                    <span style="font-size: 1.2rem;">AT</span> <span>Aptitude Test</span>
                </a>
            </li>
            <li class="nav-item">
                <a href="<%= request.getContextPath() %>/assessment/history" class="nav-link <%= uri.contains("/assessment/history") ? "active":""%>">
                    <span style="font-size: 1.2rem;">AH</span> <span>Assessment History</span>
                </a>
            </li>
            <li class="nav-item">
                <a href="<%= request.getContextPath() %>/career" class="nav-link <%= uri.contains("/career") ? "active":""%>">
                    <span style="font-size: 1.2rem;">CD</span> <span>Career Discovery</span>
                </a>
            </li>

        <% } else if ("PARENT".equalsIgnoreCase(userRole)) { %>
            <li class="nav-item">
                <a href="<%= request.getContextPath() %>/parent/dashboard" class="nav-link <%= uri.contains("/parent/") ? "active":""%>">
                    <span style="font-size: 1.2rem;">DB</span> <span>Dashboard</span>
                </a>
            </li>

        <% } else if ("COUNSELOR".equalsIgnoreCase(userRole)) { %>
            <li class="nav-item">
                <a href="<%= request.getContextPath() %>/counselor/dashboard" class="nav-link <%= uri.contains("/counselor/") ? "active":""%>">
                    <span style="font-size: 1.2rem;">DB</span> <span>Dashboard</span>
                </a>
            </li>

        <% } else if ("ADMIN".equalsIgnoreCase(userRole)) { %>
            <li class="nav-item">
                <a href="<%= request.getContextPath() %>/admin/dashboard" class="nav-link <%= uri.contains("dashboard") ? "active":""%>">
                    <span style="font-size: 1.2rem;">DB</span> <span>Dashboard</span>
                </a>
            </li>
            <li class="nav-item">
                <a href="<%= request.getContextPath() %>/admin/users" class="nav-link <%= uri.contains("user") ? "active":""%>">
                    <span style="font-size: 1.2rem;">US</span> <span>Manage Users</span>
                </a>
            </li>
            <li class="nav-item">
                <a href="<%= request.getContextPath() %>/admin/careers" class="nav-link <%= uri.contains("career") ? "active":""%>">
                    <span style="font-size: 1.2rem;">CA</span> <span>Manage Careers</span>
                </a>
            </li>
            <li class="nav-item">
                <a href="<%= request.getContextPath() %>/admin/colleges" class="nav-link <%= uri.contains("college") ? "active":""%>">
                    <span style="font-size: 1.2rem;">CO</span> <span>Colleges</span>
                </a>
            </li>
            <li class="nav-item">
                <a href="<%= request.getContextPath() %>/admin/labour-market" class="nav-link <%= uri.contains("labour-market") ? "active":""%>">
                    <span style="font-size: 1.2rem;">LM</span> <span>Labour Market</span>
                </a>
            </li>
            <li class="nav-item">
                <a href="<%= request.getContextPath() %>/admin/reports" class="nav-link <%= uri.contains("report") ? "active":""%>">
                    <span style="font-size: 1.2rem;">RP</span> <span>Reports</span>
                </a>
            </li>
        <% } %>
        <li class="nav-item">
            <a href="<%= request.getContextPath() %>/profile" class="nav-link <%= uri.contains("/profile") ? "active":""%>">
                <span style="font-size: 1.2rem;">PR</span> <span>Profile</span>
            </a>
        </li>
    </ul>

    <div class="sidebar-footer">
        <a href="<%= request.getContextPath() %>/auth/logout" class="nav-link">
            <span style="font-size: 1.2rem;">LO</span> <span style="color: var(--color-danger); font-weight: bold;">Logout</span>
        </a>
    </div>
</aside>
