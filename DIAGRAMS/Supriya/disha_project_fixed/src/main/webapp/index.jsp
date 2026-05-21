<%-- index.jsp — root landing page, redirects to dashboard or login --%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    // If user is already logged in, go straight to dashboard
    if (session != null && session.getAttribute("username") != null) {
        response.sendRedirect(request.getContextPath() + "/PersonalDashboardServlet");
    } else {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
    }
%>
