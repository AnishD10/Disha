<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.disha.model.User" %>
<%@ page import="com.disha.util.RoleConstants" %>
<%
    // ── Redirect already-logged-in users ──────────────────────────────────────
    User existingUser = (User) session.getAttribute("loggedInUser");
    if (existingUser != null) {
        response.sendRedirect(request.getContextPath()
                + RoleConstants.getDashboardPath(existingUser.getRole().name()));
        return;
    }

    // ── Repopulate form values after server-side validation error ─────────────
    String errorMsg    = (String) request.getAttribute("errorMessage");
    String formName    = request.getAttribute("formName")    != null ? (String) request.getAttribute("formName")    : "";
    String formEmail   = request.getAttribute("formEmail")   != null ? (String) request.getAttribute("formEmail")   : "";
    String formPhone   = request.getAttribute("formPhone")   != null ? (String) request.getAttribute("formPhone")   : "";
    String formAddress = request.getAttribute("formAddress") != null ? (String) request.getAttribute("formAddress") : "";
    String formRole    = request.getAttribute("formRole")    != null ? (String) request.getAttribute("formRole")    : "STUDENT";
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Create Account — DISHA Nepal</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/disha-main.css">
    <style>
        .role-grid {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 10px;
            margin-bottom: 20px;
        }
        .role-option input[type="radio"] {
            position: absolute; opacity: 0; width: 0; height: 0;
        }
        .role-option { position: relative; }
        .role-option label {
            display: flex; flex-direction: column; align-items: center;
            gap: 6px; padding: 14px 10px;
            background: var(--color-surface-2);
            border: 2px solid var(--color-border);
            border-radius: var(--radius-md); cursor: pointer;
            font-size: 0.85rem; font-weight: 500;
            color: var(--color-text-muted); text-align: center;
            transition: border-color 0.15s, background 0.15s;
            text-transform: none; letter-spacing: normal;
        }
        .role-option label .icon { font-size: 1.5rem; }
        .role-option input:checked + label {
            border-color: var(--color-primary);
            background: rgba(244,162,45,0.08);
            color: var(--color-text);
        }
        .role-option label:hover { border-color: rgba(244,162,45,0.4); }

        .password-wrapper { position: relative; }
        .password-wrapper input { padding-right: 44px; }
        .toggle-pw {
            position: absolute; right: 12px; top: 50%;
            transform: translateY(-50%);
            background: none; border: none; cursor: pointer;
            color: var(--color-text-muted); font-size: 1rem; padding: 0;
        }
        .toggle-pw:hover { color: var(--color-primary); }

        .strength-bar {
            height: 3px; border-radius: 2px;
            background: var(--color-border); margin-top: 6px; overflow: hidden;
        }
        .strength-fill {
            height: 100%; width: 0%; border-radius: 2px;
            transition: width 0.3s, background 0.3s;
        }
        .strength-text { font-size: 0.72rem; color: var(--color-text-dim); margin-top: 3px; }
        .section-label {
            font-size: 0.75rem; text-transform: uppercase; letter-spacing: 0.08em;
            color: var(--color-text-dim); margin-bottom: 12px; margin-top: 4px;
            padding-bottom: 8px; border-bottom: 1px solid var(--color-border-soft);
        }
    </style>
</head>
<body>

<div class="auth-wrapper">

    <!-- ── Left Hero ─────────────────────────────────────────────────────── -->
    <div class="auth-hero">
        <div class="logo">DISHA</div>
        <p class="tagline">Nepal Career Intelligence Portal</p>
        <ul class="feature-list">
            <li><span class="icon">🎓</span> Find the right degree for your goals and budget</li>
            <li><span class="icon">🗺️</span> Explore careers with real Nepal salary data</li>
            <li><span class="icon">📋</span> Aptitude assessments to discover your strengths</li>
            <li><span class="icon">🔔</span> Dashboards for students, parents &amp; counselors</li>
        </ul>
    </div>

    <!-- ── Right Register Panel ──────────────────────────────────────────── -->
    <div class="auth-panel">
        <div class="auth-card" style="max-width:460px;">

            <h2>Create your account</h2>
            <p class="subtitle">Join DISHA and start planning your future.</p>

            <%-- Error message from servlet validation --%>
            <% if (errorMsg != null && !errorMsg.isEmpty()) { %>
            <div class="alert alert-error">
                <span>⚠</span> <%= errorMsg %>
            </div>
            <% } %>

            <form id="registerForm"
                  method="POST"
                  action="<%= request.getContextPath() %>/auth/register"
                  novalidate>

                <%-- Role Selection --%>
                <p class="section-label">I am a…</p>
                <div class="role-grid">
                    <div class="role-option">
                        <input type="radio" id="rStudent" name="role" value="STUDENT"
                            <%= "STUDENT".equals(formRole) ? "checked" : "" %> required>
                        <label for="rStudent"><span class="icon">🎓</span>Student</label>
                    </div>
                    <div class="role-option">
                        <input type="radio" id="rParent" name="role" value="PARENT"
                            <%= "PARENT".equals(formRole) ? "checked" : "" %>>
                        <label for="rParent"><span class="icon">👨‍👩‍👧</span>Parent</label>
                    </div>
                    <div class="role-option">
                        <input type="radio" id="rCounselor" name="role" value="COUNSELOR"
                            <%= "COUNSELOR".equals(formRole) ? "checked" : "" %>>
                        <label for="rCounselor"><span class="icon">🧑‍💼</span>Counselor</label>
                    </div>
                    <div class="role-option">
                        <input type="radio" id="rAdmin" name="role" value="ADMIN"
                            <%= "ADMIN".equals(formRole) ? "checked" : "" %>>
                        <label for="rAdmin"><span class="icon">⚙️</span>Admin</label>
                    </div>
                </div>

                <%-- Personal Details --%>
                <p class="section-label">Personal Details</p>

                <div class="form-group">
                    <label for="fullName">Full Name <span style="color:var(--color-error)">*</span></label>
                    <input type="text" id="fullName" name="fullName"
                           value="<%= formName %>"
                           placeholder="e.g. Joyal Karki"
                           autocomplete="name" required>
                </div>

                <div class="form-group">
                    <label for="email">Email Address <span style="color:var(--color-error)">*</span></label>
                    <input type="email" id="email" name="email"
                           value="<%= formEmail %>"
                           placeholder="your@email.com"
                           autocomplete="email" required>
                </div>

                <div class="form-row">
                    <div class="form-group">
                        <label for="phone">Phone</label>
                        <input type="tel" id="phone" name="phone"
                               value="<%= formPhone %>"
                               placeholder="98XXXXXXXX">
                    </div>
                    <div class="form-group">
                        <label for="address">District / City</label>
                        <input type="text" id="address" name="address"
                               value="<%= formAddress %>"
                               placeholder="e.g. Kathmandu">
                    </div>
                </div>

                <%-- Security --%>
                <p class="section-label">Security</p>

                <div class="form-group">
                    <label for="password">Password <span style="color:var(--color-error)">*</span></label>
                    <div class="password-wrapper">
                        <input type="password" id="password" name="password"
                               placeholder="Min 8 chars, 1 letter, 1 number"
                               autocomplete="new-password" required
                               oninput="checkStrength(this.value)">
                        <button type="button" class="toggle-pw"
                                onclick="togglePw('password',this)">👁</button>
                    </div>
                    <div class="strength-bar">
                        <div class="strength-fill" id="strengthFill"></div>
                    </div>
                    <div class="strength-text" id="strengthText"></div>
                </div>

                <div class="form-group">
                    <label for="confirmPassword">Confirm Password <span style="color:var(--color-error)">*</span></label>
                    <div class="password-wrapper">
                        <input type="password" id="confirmPassword" name="confirmPassword"
                               placeholder="Repeat your password"
                               autocomplete="new-password" required>
                        <button type="button" class="toggle-pw"
                                onclick="togglePw('confirmPassword',this)">👁</button>
                    </div>
                </div>

                <button type="submit" class="btn btn-primary" id="registerBtn">
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
    function togglePw(id, btn) {
        var input = document.getElementById(id);
        input.type = (input.type === 'password') ? 'text' : 'password';
        btn.textContent = (input.type === 'text') ? '🙈' : '👁';
    }

    function checkStrength(pw) {
        var fill = document.getElementById('strengthFill');
        var text = document.getElementById('strengthText');
        var score = 0;
        if (pw.length >= 8)              score++;
        if (/[A-Z]/.test(pw))            score++;
        if (/[0-9]/.test(pw))            score++;
        if (/[^A-Za-z0-9]/.test(pw))     score++;
        var levels = [
            {pct:'0%',   color:'transparent', label:''},
            {pct:'25%',  color:'#F85149',     label:'Weak'},
            {pct:'50%',  color:'#D29922',     label:'Fair'},
            {pct:'75%',  color:'#58A6FF',     label:'Good'},
            {pct:'100%', color:'#3FB950',     label:'Strong'},
        ];
        fill.style.width      = levels[score].pct;
        fill.style.background = levels[score].color;
        text.textContent      = levels[score].label;
        text.style.color      = levels[score].color;
    }

    document.getElementById('registerForm').addEventListener('submit', function(e) {
        var fullName = document.getElementById('fullName').value.trim();
        var email    = document.getElementById('email').value.trim();
        var pw       = document.getElementById('password').value;
        var cpw      = document.getElementById('confirmPassword').value;
        var role     = document.querySelector('input[name="role"]:checked');
        var emailReg = /^[\w.+\-]+@[a-zA-Z0-9.\-]+\.[a-zA-Z]{2,}$/;

        if (!fullName) {
            e.preventDefault(); alert('Please enter your full name.'); return;
        }
        if (!email || !emailReg.test(email)) {
            e.preventDefault(); alert('Please enter a valid email address.'); return;
        }
        if (!role) {
            e.preventDefault(); alert('Please select your role.'); return;
        }
        if (pw.length < 8) {
            e.preventDefault(); alert('Password must be at least 8 characters.'); return;
        }
        if (!/[A-Za-z]/.test(pw) || !/[0-9]/.test(pw)) {
            e.preventDefault(); alert('Password must have at least 1 letter and 1 number.'); return;
        }
        if (pw !== cpw) {
            e.preventDefault(); alert('Passwords do not match.'); return;
        }

        document.getElementById('registerBtn').textContent = 'Creating account…';
        document.getElementById('registerBtn').disabled = true;
    });
</script>

</body>
</html>
