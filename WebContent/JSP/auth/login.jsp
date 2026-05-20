<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String contextPath = request.getContextPath();
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Career Discovery Login - DISHA</title>
    <link rel="stylesheet" href="<%= contextPath %>/CSS/disha-main.css">
</head>
<body>
<div class="auth-wrapper">
    <div class="auth-card">
        <h1>Career Discovery</h1>
        <p class="subtitle">
            Authentication is owned by the integrated DISHA application. For this feature branch,
            use the local student test session.
        </p>
        <a href="<%= contextPath %>/jsp/auth/dev-student-login.jsp" class="btn btn-primary">
            Continue as Test Student
        </a>
    </div>
</div>
</body>
</html>
