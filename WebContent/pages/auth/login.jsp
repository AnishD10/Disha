<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.disha.model.User" %>
<%@ page import="com.disha.util.RoleConstants" %>
<%
    // ── Session check: redirect already-logged-in users to their dashboard ────
    User existingUser = (User) session.getAttribute("loggedInUser");
    if (existingUser != null) {
        response.sendRedirect(request.getContextPath()
                + RoleConstants.getDashboardPath(existingUser.getRole().name()));
        return;
    }

    // ── Read flash message (from register redirect or logout) ─────────────────
    String flashMsg  = (String) session.getAttribute("flashMessage");
    String flashType = (String) session.getAttribute("flashType");
    if (flashMsg != null) {
        session.removeAttribute("flashMessage");
        session.removeAttribute("flashType");
    }

    // ── Read error and repopulated email from servlet forward ─────────────────
    String errorMsg = (String) request.getAttribute("errorMessage");
    String formEmail = request.getAttribute("formEmail") != null
            ? (String) request.getAttribute("formEmail") : "";
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login — DISHA Nepal</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/disha-main.css">
    <style>
        .password-wrapper { position: relative; }
        .password-wrapper input { padding-right: 44px; }
        .toggle-pw {
            position: absolute; right: 12px; top: 50%;
            transform: translateY(-50%);
            background: none; border: none; cursor: pointer;
            color: var(--color-text-muted); font-size: 1rem; padding: 0;
        }
        .toggle-pw:hover { color: var(--color-primary); }
        .input-error { border-color: var(--color-error) !important; }
    </style>
</head>
<body>

<div class="auth-wrapper">

    <!-- ── Left Hero ─────────────────────────────────────────────────────── -->
    <div class="auth-hero">
        <div class="logo">DISHA</div>
        <p class="tagline">Nepal Career Intelligence Portal</p>
        <ul class="feature-list">
            <li><span class="icon">🎯</span> Psychometric assessments mapped to Nepal's job market</li>
            <li><span class="icon">🏫</span> Browse colleges filtered by budget, location &amp; score</li>
            <li><span class="icon">📊</span> Real salary &amp; demand data for Nepali careers</li>
            <li><span class="icon">👨‍👩‍👧</span> Parent-facing dashboard for family decisions</li>
            <li><span class="icon">🧭</span> Counselor tools to guide students at scale</li>
        </ul>
    </div>

    <!-- ── Right Login Panel ─────────────────────────────────────────────── -->
    <div class="auth-panel">
        <div class="auth-card">

            <h2>Welcome back</h2>
            <p class="subtitle">Log in to your DISHA account to continue.</p>

            <%-- Flash message (success from register, info from logout) --%>
            <% if (flashMsg != null && !flashMsg.isEmpty()) { %>
            <div class="alert alert-<%= flashType != null ? flashType : "info" %>">
                <span><%= "success".equals(flashType) ? "✓" : "ℹ" %></span>
                <%= flashMsg %>
            </div>
            <% } %>

            <%-- Error message from failed login attempt --%>
            <% if (errorMsg != null && !errorMsg.isEmpty()) { %>
            <div class="alert alert-error">
                <span>⚠</span> <%= errorMsg %>
            </div>
            <% } %>

            <%-- Login form — POST to /auth/login servlet --%>
            <form id="loginForm"
                  method="POST"
                  action="<%= request.getContextPath() %>/auth/login"
                  novalidate>

                <div class="form-group">
                    <label for="email">Email Address</label>
                    <input type="email"
                           id="email"
                           name="email"
                           value="<%= formEmail %>"
                           placeholder="your@email.com"
                           autocomplete="email"
                           class="<%= (errorMsg != null) ? "input-error" : "" %>"
                           required>
                </div>

                <div class="form-group">
                    <label for="password">Password</label>
                    <div class="password-wrapper">
                        <input type="password"
                               id="password"
                               name="password"
                               placeholder="Enter your password"
                               autocomplete="current-password"
                               class="<%= (errorMsg != null) ? "input-error" : "" %>"
                               required>
                        <button type="button" class="toggle-pw"
                                onclick="togglePw('password', this)"
                                title="Show/hide password">👁</button>
                    </div>
                </div>

                <button type="submit" class="btn btn-primary" id="loginBtn">
                    Sign In →
                </button>

            </form>

            <div class="divider">or</div>

            <div class="auth-footer">
                Don't have an account?
                <a href="<%= request.getContextPath() %>/pages/auth/register.jsp">
                    Create one free
                </a>
            </div>

        </div>
    </div>
</div>

<script>
    // Show/hide password toggle
    function togglePw(inputId, btn) {
        var input = document.getElementById(inputId);
        if (input.type === 'password') {
            input.type = 'text';
            btn.textContent = '🙈';
        } else {
            input.type = 'password';
            btn.textContent = '👁';
        }
    }

    // Client-side validation before submit
    document.getElementById('loginForm').addEventListener('submit', function(e) {
        var email    = document.getElementById('email').value.trim();
        var password = document.getElementById('password').value;
        var emailReg = /^[\w.+\-]+@[a-zA-Z0-9.\-]+\.[a-zA-Z]{2,}$/;

        if (!email || !password) {
            e.preventDefault();
            alert('Please enter both email and password.');
            return;
        }
        if (!emailReg.test(email)) {
            e.preventDefault();
            alert('Please enter a valid email address.');
            return;
        }

        // Show loading state
        document.getElementById('loginBtn').textContent = 'Signing in…';
        document.getElementById('loginBtn').disabled = true;
    });
</script>

</body>
</html>
