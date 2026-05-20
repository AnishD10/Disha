<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    /* If already logged in, redirect to appropriate dashboard */
    Object user = session.getAttribute("loggedInUser");
    if (user != null) {
        response.sendRedirect(request.getContextPath() + "/JSP/student/dashboard.jsp");
        return;
    }

    /* Consume flash message from registration redirect */
    String flashMsg  = (String) session.getAttribute("flashMessage");
    String flashType = (String) session.getAttribute("flashType");
    if (flashMsg != null) {
        session.removeAttribute("flashMessage");
        session.removeAttribute("flashType");
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login — DISHA Nepal</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/CSS/disha-main.css">
    <style>
        .password-wrapper {
            position: relative;
        }
        .password-wrapper input {
            padding-right: 44px;
        }
        .toggle-password {
            position:   absolute;
            right:      12px;
            top:        50%;
            transform:  translateY(-50%);
            background: none;
            border:     none;
            cursor:     pointer;
            color:      var(--color-text-muted);
            font-size:  1rem;
            padding:    0;
            line-height: 1;
        }
        .toggle-password:hover { color: var(--color-primary); }
    </style>
</head>
<body>

<div class="auth-wrapper">

    <!-- ── Left Hero Panel ─────────────────────────────────────────── -->
    <div class="auth-hero">
        <div class="logo">DISHA</div>
        <p class="tagline">Nepal Career Intelligence Portal</p>

        <ul class="feature-list">
            <li>
                <span class="icon">🎯</span>
                Psychometric assessments mapped to Nepal's job market
            </li>
            <li>
                <span class="icon">🏫</span>
                Browse colleges filtered by budget, location & score
            </li>
            <li>
                <span class="icon">📊</span>
                Real salary & demand data for Nepali career paths
            </li>
            <li>
                <span class="icon">👨‍👩‍👧</span>
                Family-facing dashboard for informed decisions
            </li>
            <li>
                <span class="icon">🧭</span>
                Counselor tools to guide students at scale
            </li>
        </ul>
    </div>

    <!-- ── Right Login Panel ───────────────────────────────────────── -->
    <div class="auth-panel">
        <div class="auth-card">

            <h2>Welcome back</h2>
            <p class="subtitle">Log in to your DISHA account to continue.</p>

            <!-- Flash message (from registration redirect) -->
            <% if (flashMsg != null) { %>
            <div class="alert alert-<%= flashType %>">
                <span>✓</span> <%= flashMsg %>
            </div>
            <% } %>

            <!-- Error message from servlet -->
            <% if (request.getAttribute("errorMessage") != null) { %>
            <div class="alert alert-error">
                <span>⚠</span> <%= request.getAttribute("errorMessage") %>
            </div>
            <% } %>

            <!-- Login Form -->
            <form method="POST" action="<%= request.getContextPath() %>/auth/login" novalidate>

                <div class="form-group">
                    <label for="email">Email Address</label>
                    <input
                            type="email"
                            id="email"
                            name="email"
                            value="<%= request.getAttribute("formEmail") != null ? request.getAttribute("formEmail") : "" %>"
                            placeholder="your@email.com"
                            autocomplete="email"
                            required>
                </div>

                <div class="form-group">
                    <label for="password">Password</label>
                    <div class="password-wrapper">
                        <input
                                type="password"
                                id="password"
                                name="password"
                                placeholder="Enter your password"
                                autocomplete="current-password"
                                required>
                        <button type="button" class="toggle-password" onclick="togglePassword('password', this)" title="Show/hide password">
                            👁
                        </button>
                    </div>
                </div>

                <button type="submit" class="btn btn-primary">
                    Sign In →
                </button>

            </form>

            <div class="divider">or</div>

            <div class="auth-footer">
                Don't have an account?
                <a href="<%= request.getContextPath() %>/JSP/auth/register.jsp">Create one free</a>
            </div>

        </div>
    </div>

</div>

<script>
    function togglePassword(inputId, btn) {
        const input = document.getElementById(inputId);
        if (input.type === 'password') {
            input.type = 'text';
            btn.textContent = '🙈';
        } else {
            input.type = 'password';
            btn.textContent = '👁';
        }
    }
</script>

</body>
</html>
