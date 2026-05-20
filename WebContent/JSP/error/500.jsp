<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isErrorPage="true" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>500 Server Error — DISHA</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/CSS/disha-main.css">
</head>
<body>
<div style="min-height:100vh; display:flex; align-items:center; justify-content:center; flex-direction:column; gap:16px; text-align:center; padding:32px;">
    <div style="font-size:4rem;">⚠️</div>
    <h1 style="font-size:2rem; color:#F85149;">500 — Server Error</h1>
    <p style="color:#8B949E; max-width:440px;">Something went wrong on the server. This is usually a database connection issue or a bug in a Servlet. Check the Tomcat logs for details.</p>
    <% if (exception != null) { %>
    <pre style="background:#161B22; border:1px solid #30363D; padding:16px; border-radius:8px; font-size:0.78rem; color:#F85149; max-width:600px; text-align:left; overflow:auto;">
<%= exception.getMessage() %>
    </pre>
    <% } %>
    <a href="<%= request.getContextPath() %>/jsp/auth/login.jsp" class="btn btn-secondary" style="width:auto; display:inline-flex; margin-top:8px;">
        ← Back to Login
    </a>
</div>
</body>
</html>
