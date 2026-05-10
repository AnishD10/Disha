<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isErrorPage="true" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>404 Not Found — DISHA</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/CSS/disha-main.css">
</head>
<body>
<div style="min-height:100vh; display:flex; align-items:center; justify-content:center; flex-direction:column; gap:16px; text-align:center; padding:32px;">
    <div style="font-size:4rem;">🗺️</div>
    <h1 style="font-size:2rem; color:#F4A22D;">404 — Page Not Found</h1>
    <p style="color:#8B949E; max-width:400px;">The page you're looking for doesn't exist yet. It may be a feature still under construction by a team member.</p>
    <a href="<%= request.getContextPath() %>/JSP/auth/login.jsp" class="btn btn-primary" style="width:auto; display:inline-flex; margin-top:8px;">
        ← Go to Login
    </a>
</div>
</body>
</html>
