<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    /* If already logged in, go straight to dashboard */
    if (session.getAttribute("username") != null) {
        response.sendRedirect(request.getContextPath() + "/PersonalDashboardServlet");
        return;
    }

    String error = request.getParameter("error");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>DISHA - Login</title>
    <style>
        * { box-sizing: border-box; margin: 0; padding: 0; }
        body { font-family: Arial, sans-serif; background: #f0f4f8; display: flex; align-items: center; justify-content: center; min-height: 100vh; }
        .login-box { background: #fff; border-radius: 12px; padding: 40px 36px; box-shadow: 0 4px 20px rgba(0,0,0,0.10); width: 100%; max-width: 400px; }
        .brand { text-align: center; font-size: 2rem; font-weight: 700; color: #1a237e; margin-bottom: 6px; }
        .subtitle { text-align: center; color: #777; font-size: 0.9rem; margin-bottom: 28px; }
        label { display: block; font-size: 0.88rem; color: #555; margin-bottom: 5px; margin-top: 16px; }
        input[type=text], input[type=password] {
            width: 100%; padding: 10px 14px; border: 1px solid #ddd;
            border-radius: 6px; font-size: 0.95rem; outline: none;
        }
        input:focus { border-color: #3949ab; }
        .btn { width: 100%; margin-top: 24px; padding: 12px; background: #3949ab; color: #fff; border: none; border-radius: 6px; font-size: 1rem; cursor: pointer; }
        .btn:hover { background: #283593; }
        .error { background: #ffebee; color: #c62828; border-left: 4px solid #e53935; padding: 10px 14px; border-radius: 6px; font-size: 0.88rem; margin-bottom: 16px; }
        .note { margin-top: 18px; text-align: center; font-size: 0.8rem; color: #aaa; }
    </style>
</head>
<body>
<div class="login-box">
    <div class="brand">DISHA</div>
    <div class="subtitle">Nepal Career Intelligence Portal</div>

    <% if ("1".equals(error)) { %>
        <div class="error">Invalid username or password. Please try again.</div>
    <% } %>

    <form action="<%= request.getContextPath() %>/LoginServlet" method="post">
        <label for="username">Username</label>
        <input type="text" id="username" name="username" placeholder="Enter your username" required autofocus>

        <label for="password">Password</label>
        <input type="password" id="password" name="password" placeholder="Enter your password" required>

        <button type="submit" class="btn">Login</button>
    </form>
    <div class="note">Test account: username <strong>supriya</strong> / password <strong>test123</strong></div>
</div>
</body>
</html>
