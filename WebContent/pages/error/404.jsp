<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isErrorPage="true" %>
<!DOCTYPE html><html><head><meta charset="UTF-8"><title>404 — DISHA</title>
<link rel="stylesheet" href="<%= request.getContextPath() %>/css/disha-main.css"></head>
<body><div style="min-height:100vh;display:flex;align-items:center;justify-content:center;flex-direction:column;gap:16px;text-align:center;padding:32px;">
    <div style="font-size:4rem;">🗺️</div>
    <h1 style="color:#F4A22D;">404 — Page Not Found</h1>
    <p style="color:#8B949E;max-width:400px;">This page doesn't exist or hasn't been built yet.</p>
    <a href="<%= request.getContextPath() %>/pages/auth/login.jsp" class="btn btn-primary" style="width:auto;display:inline-flex;">← Go to Login</a>
</div></body></html>
