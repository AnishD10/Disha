<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    /* If already logged in, redirect */
    Object user = session.getAttribute("loggedInUser");
    if (user != null) {
        response.sendRedirect(request.getContextPath() + "/pages/student/dashboard.jsp");
        return;
    }

    /* Repopulate form values after validation error */
    String formName    = request.getAttribute("formName")    != null ? (String) request.getAttribute("formName")    : "";
    String formEmail   = request.getAttribute("formEmail")   != null ? (String) request.getAttribute("formEmail")   : "";
    String formPhone   = request.getAttribute("formPhone")   != null ? (String) request.getAttribute("formPhone")   : "";
    String formAddress = request.getAttribute("formAddress") != null ? (String) request.getAttribute("formAddress") : "";
    String formRole    = request.getAttribute("formRole")    != null ? (String) request.getAttribute("formRole")    : "";
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Create Account — DISHA Nepal</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/CSS/disha-main.css">
    <style>
        .auth-panel { padding: 36px 48px; }

        .role-selector {
            display:               grid;
            grid-template-columns: repeat(2, 1fr);
            gap:                   10px;
            margin-bottom:         18px;
        }

        .role-option {
            position: relative;
        }

        .role-option input[type="radio"] {
            position: absolute;
            opacity:  0;
            width:    0;
            height:   0;
        }

        .role-option label {
            display:        flex;
            flex-direction: column;
            align-items:    center;
            gap:            6px;
            padding:        14px 10px;
            background:     var(--color-surface-2);
            border:         2px solid var(--color-border);
            border-radius:  var(--radius-md);
            cursor:         pointer;
            transition:     border-color 0.15s, background 0.15s;
            font-size:      0.85rem;
            font-weight:    500;
            color:          var(--color-text-muted);
            text-align:     center;
            text-transform: none;
            letter-spacing: normal;
        }

        .role-option label .role-icon { font-size: 1.5rem; }

        .role-option input[type="radio"]:checked + label {
            border-color: var(--color-primary);
            background:   rgba(244,162,45,0.08);
            color:        var(--color-text);
        }

        .role-option label:hover {
            border-color: rgba(244,162,45,0.4);
        }

        .password-wrapper { position: relative; }
        .password-wrapper input { padding-right: 44px; }
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
        }
        .toggle-password:hover { color: var(--color-primary); }

        .strength-bar {
            height:        3px;
            border-radius: 2px;
            background:    var(--color-border);
            margin-top:    6px;
            overflow:      hidden;
        }

        .strength-bar-fill {
            height:     100%;
            width:      0%;
            border-radius: 2px;
            transition: width 0.3s, background 0.3s;
        }

        .strength-label {
            font-size:  0.73rem;
            color:      var(--color-text-dim);
            margin-top: 3px;
        }

        .section-title {
            font-size:     0.78rem;
            text-transform: uppercase;
            letter-spacing: 0.08em;
            color:         var(--color-text-dim);
            margin-bottom: 12px;
            padding-bottom: 8px;
            border-bottom:  1px solid var(--color-border-soft);
        }
    </style>
</head>
<body>

<div class="auth-wrapper">

    <!-- ── Left Hero ───────────────────────────────────────────────── -->
    <div class="auth-hero">
        <div class="logo">DISHA</div>
        <p class="tagline">Nepal Career Intelligence Portal</p>

        <ul class="feature-list">
            <li><span class="icon">🎓</span>Find the right degree for your goals and budget</li>
            <li><span class="icon">🗺️</span>Explore careers with real Nepal market salary data</li>
            <li><span class="icon">📋</span>Take aptitude assessments to discover your strengths</li>
            <li><span class="icon">🔔</span>Parents and counselors get their own dashboards</li>
        </ul>
    </div>

    <!-- ── Right Register Panel ─────────────────────────────────────── -->
    <div class="auth-panel">
        <div class="auth-card" style="max-width: 460px;">

            <h2>Create your account</h2>
            <p class="subtitle">Join DISHA and start planning your future.</p>

            <!-- Server-side error -->
            <% if (request.getAttribute("errorMessage") != null) { %>
            <div class="alert alert-error">
                <span>⚠</span> <%= request.getAttribute("errorMessage") %>
            </div>
            <% } %>

            <form method="POST" action="<%= request.getContextPath() %>/auth/register" novalidate id="registerForm">

                <!-- Role Selection -->
                <p class="section-title">I am a…</p>
                <div class="role-selector">
                    <div class="role-option">
                        <input type="radio" id="roleStudent" name="role" value="STUDENT"
                            <%= "STUDENT".equals(formRole) || formRole.isEmpty() ? "checked" : "" %>>
                        <label for="roleStudent">
                            <span class="role-icon">🎓</span>
                            Student
                        </label>
                    </div>
                    <div class="role-option">
                        <input type="radio" id="roleParent" name="role" value="PARENT"
                            <%= "PARENT".equals(formRole) ? "checked" : "" %>>
                        <label for="roleParent">
                            <span class="role-icon">👨‍👩‍👧</span>
                            Parent
                        </label>
                    </div>
                    <div class="role-option">
                        <input type="radio" id="roleCounselor" name="role" value="COUNSELOR"
                            <%= "COUNSELOR".equals(formRole) ? "checked" : "" %>>
                        <label for="roleCounselor">
                            <span class="role-icon">🧑‍💼</span>
                            Counselor
                        </label>
                    </div>
                    <div class="role-option">
                        <input type="radio" id="roleAdmin" name="role" value="ADMIN"
                            <%= "ADMIN".equals(formRole) ? "checked" : "" %>>
                        <label for="roleAdmin">
                            <span class="role-icon">⚙️</span>
                            Admin
                        </label>
                    </div>
                </div>

                <!-- Personal Details -->
                <p class="section-title">Personal Details</p>

                <div class="form-group">
                    <label for="fullName">Full Name *</label>
                    <input type="text" id="fullName" name="fullName"
                           value="<%= formName %>"
                           placeholder="e.g. Joyal Karki"
                           autocomplete="name" required>
                </div>

                <div class="form-group">
                    <label for="email">Email Address *</label>
                    <input type="email" id="email" name="email"
                           value="<%= formEmail %>"
                           placeholder="your@email.com"
                           autocomplete="email" required>
                </div>

                <div class="form-row">
                    <div class="form-group">
                        <label for="phone">Phone Number</label>
                        <input type="tel" id="phone" name="phone"
                               value="<%= formPhone %>"
                               placeholder="+977 98XXXXXXXX"
                               autocomplete="tel">
                    </div>
                    <div class="form-group">
                        <label for="address">District / City</label>
                        <input type="text" id="address" name="address"
                               value="<%= formAddress %>"
                               placeholder="e.g. Kathmandu">
                    </div>
                </div>

                <!-- Security -->
                <p class="section-title" style="margin-top: 4px;">Security</p>

                <div class="form-group">
                    <label for="password">Password *</label>
                    <div class="password-wrapper">
                        <input type="password" id="password" name="password"
                               placeholder="Minimum 8 characters"
                               autocomplete="new-password" required
                               oninput="checkStrength(this.value)">
                        <button type="button" class="toggle-password" onclick="togglePassword('password', this)">👁</button>
                    </div>
                    <div class="strength-bar">
                        <div class="strength-bar-fill" id="strengthFill"></div>
                    </div>
                    <div class="strength-label" id="strengthLabel"></div>
                </div>

                <div class="form-group">
                    <label for="confirmPassword">Confirm Password *</label>
                    <div class="password-wrapper">
                        <input type="password" id="confirmPassword" name="confirmPassword"
                               placeholder="Repeat your password"
                               autocomplete="new-password" required>
                        <button type="button" class="toggle-password" onclick="togglePassword('confirmPassword', this)">👁</button>
                    </div>
                </div>

                <button type="submit" class="btn btn-primary" onclick="return validateForm()">
                    Create Account →
                </button>

            </form>

            <div class="auth-footer">
                Already have an account?
                <a href="<%= request.getContextPath() %>/pages/auth/login.jsp">Sign in</a>
            </div>

        </div>
    </div>

</div>

<script>
    function togglePassword(inputId, btn) {
        const input = document.getElementById(inputId);
        input.type  = (input.type === 'password') ? 'text' : 'password';
        btn.textContent = (input.type === 'text') ? '🙈' : '👁';
    }

    function checkStrength(password) {
        const fill  = document.getElementById('strengthFill');
        const label = document.getElementById('strengthLabel');
        let score   = 0;

        if (password.length >= 8)              score++;
        if (/[A-Z]/.test(password))            score++;
        if (/[0-9]/.test(password))            score++;
        if (/[^A-Za-z0-9]/.test(password))     score++;

        const levels = [
            { pct: '0%',   color: 'transparent', text: '' },
            { pct: '25%',  color: '#F85149',     text: 'Weak' },
            { pct: '50%',  color: '#D29922',      text: 'Fair' },
            { pct: '75%',  color: '#58A6FF',      text: 'Good' },
            { pct: '100%', color: '#3FB950',      text: 'Strong' },
        ];

        fill.style.width      = levels[score].pct;
        fill.style.background = levels[score].color;
        label.textContent     = levels[score].text;
        label.style.color     = levels[score].color;
    }

    function validateForm() {
        const pw  = document.getElementById('password').value;
        const cpw = document.getElementById('confirmPassword').value;
        if (pw !== cpw) {
            alert('Passwords do not match. Please check and try again.');
            return false;
        }
        if (pw.length < 8) {
            alert('Password must be at least 8 characters long.');
            return false;
        }
        return true;
    }
</script>

</body>
</html>
