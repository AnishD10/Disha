<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.disha.model.User" %>
<%
    // This is a temporary script to mock a successful login
    // because the backend /auth/login servlet does not exist yet!
    
    // Create a mock user
    User mockUser = new User();
    mockUser.setFullName("Test User");
    // Depending on what we want to test, we can set the role
    String roleStr = request.getParameter("role");
    if (roleStr == null || roleStr.isEmpty()) roleStr = "STUDENT";
    
    // Set to session just like how auth servlet would do
    session.setAttribute("loggedInUser", mockUser);
    session.setAttribute("userRole", roleStr);
    
    // Redirect based on role
    if ("PARENT".equalsIgnoreCase(roleStr)) {
        response.sendRedirect(request.getContextPath() + "/JSP/parent/dashboard.jsp");
    } else if ("COUNSELOR".equalsIgnoreCase(roleStr) || "CONSULTANT".equalsIgnoreCase(roleStr)) {
        response.sendRedirect(request.getContextPath() + "/JSP/consultant/dashboard.jsp");
    } else if ("ADMIN".equalsIgnoreCase(roleStr)) {
        response.sendRedirect(request.getContextPath() + "/JSP/admin/dashboard.jsp");
    } else {
        response.sendRedirect(request.getContextPath() + "/JSP/student/dashboard.jsp");
    }
%>
