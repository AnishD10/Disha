<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    // Redirect root URL to the public landing page
    response.sendRedirect(request.getContextPath() + "/JSP/home.jsp");
%>
