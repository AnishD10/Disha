<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Sign In - DISHA Career Portal</title>
    <meta name="description"
          content="Sign in to DISHA - Nepal's premier science-backed career assessment platform for students.">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/main.css?v=5">
    <style>
        body {
            display: flex;
            align-items: center;
            justify-content: center;
            min-height: 100vh;
            background: var(--bg);
            background-image: radial-gradient(ellipse 80% 60% at 20% 110%, rgba(37, 99, 235, 0.08) 0%, transparent 60%),
            radial-gradient(ellipse 60% 50% at 85% -10%, rgba(56, 189, 248, 0.07) 0%, transparent 55%);
            padding: 24px;
        }

        /* -- Wrapper -- */
        .login-wrapper {
            display: grid;
            grid-template-columns: 1fr 1fr;
            width: 960px;
            max-width: 100%;
            min-height: 580px;
            border-radius: var(--radius-2xl);
            overflow: hidden;
            box-shadow: var(--shadow-xl), 0 0 0 1px rgba(255, 255, 255, 0.6);
            background: var(--surface);
        }

        /* -- Left Brand Panel -- */
        .login-brand {
            position: relative;
            background: linear-gradient(145deg, #1E3A8A 0%, #1D4ED8 40%, #2563EB 70%, #3B82F6 100%);
            display: flex;
            flex-direction: column;
            align-items: flex-start;
            justify-content: flex-end;
            padding: 52px 48px;
            overflow: hidden;
        }

        /* Background blobs */
        .login-brand::before {
            content: '';
            position: absolute;
            top: -80px;
            right: -80px;
            width: 340px;
            height: 340px;
            border-radius: 50%;
            background: rgba(255, 255, 255, 0.06);
        }

        .login-brand::after {
            content: '';
            position: absolute;
            bottom: -60px;
            left: -40px;
            width: 260px;
            height: 260px;
            border-radius: 50%;
            background: rgba(255, 255, 255, 0.04);
        }

        /* Grid pattern overlay */
        .brand-grid {
            position: absolute;
            inset: 0;
            background-image: linear-gradient(rgba(255, 255, 255, 0.04) 1px, transparent 1px),
            linear-gradient(90deg, rgba(255, 255, 255, 0.04) 1px, transparent 1px);
            background-size: 48px 48px;
        }

        .brand-content {
            position: relative;
            z-index: 2;
        }

        /* Floating cards decoration */
        .brand-cards {
            position: absolute;
            top: 52px;
            right: -10px;
            z-index: 2;
            display: flex;
            flex-direction: column;
            gap: 12px;
        }

        /*Glass morphisim mini-card */
        .mini-card {
            background: rgba(255, 255, 255, 0.12);
            border: 1px solid rgba(255, 255, 255, 0.18);
            backdrop-filter: blur(8px);
            border-radius: var(--radius-md);
            padding: 12px 16px;
            display: flex;
            align-items: center;
            gap: 10px;
            width: 176px;
            box-shadow: 0 4px 16px rgba(0, 0, 0, 0.15);
        }

        .mini-card-icon {
            width: 32px;
            height: 32px;
            border-radius: 8px;
            background: rgba(255, 255, 255, 0.18);
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 15px;
            flex-shrink: 0;
        }

        .mini-card-text {
            font-size: 11px;
            font-weight: 600;
            color: rgba(255, 255, 255, 0.9);
            line-height: 1.35;
        }

        .mini-card-sub {
            font-size: 10px;
            color: rgba(255, 255, 255, 0.55);
            margin-top: 1px;
        }

        /* Logo */
        .brand-logo-wrap {
            display: flex;
            align-items: center;
            gap: 12px;
            margin-bottom: 32px;
        }

        .brand-logo-wrap img {
            width: 44px;
            height: 44px;
            object-fit: contain;
            filter: brightness(0) invert(1);
        }

        .brand-logo-name {
            font-size: 26px;
            font-weight: 800;
            font-family: 'Plus Jakarta Sans', sans-serif;
            color: #fff;
            letter-spacing: 3px;
        }

        /* Main heading */
        .brand-heading {
            font-size: 32px;
            font-weight: 800;
            font-family: 'Plus Jakarta Sans', sans-serif;
            color: #fff;
            line-height: 1.2;
            letter-spacing: -0.03em;
            margin-bottom: 14px;
        }

        .brand-heading .highlight {
            color: #93C5FD;
        }

        .brand-sub {
            font-size: 14px;
            color: rgba(255, 255, 255, 0.65);
            line-height: 1.7;
            margin-bottom: 32px;
            max-width: 280px;
        }

        /* Trust bullets */
        .trust-list {
            display: flex;
            flex-direction: column;
            gap: 10px;
        }

        .trust-item {
            display: flex;
            align-items: center;
            gap: 10px;
            font-size: 13px;
            color: rgba(255, 255, 255, 0.78);
            font-weight: 500;
        }

        .trust-icon {
            width: 28px;
            height: 28px;
            border-radius: 7px;
            background: rgba(255, 255, 255, 0.12);
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 13px;
            flex-shrink: 0;
        }

        /* Nepali text */
        .brand-nepali {
            margin-top: 28px;
            font-size: 13px;
            color: rgba(255, 255, 255, 0.45);
            letter-spacing: 0.5px;
            border-top: 1px solid rgba(255, 255, 255, 0.1);
            padding-top: 20px;
        }

        /* -- Right Form Panel -- */
        .login-form-panel {
            padding: 64px 52px;
            display: flex;
            flex-direction: column;
            justify-content: center;
            background: var(--surface);
        }

        .form-eyebrow {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            font-size: 11px;
            font-weight: 700;
            color: var(--primary);
            letter-spacing: 1.5px;
            text-transform: uppercase;
            margin-bottom: 10px;
        }

        .form-title {
            font-size: 28px;
            font-weight: 800;
            font-family: 'Plus Jakarta Sans', sans-serif;
            color: var(--text-primary);
            letter-spacing: -0.03em;
            margin-bottom: 6px;
            line-height: 1.2;
        }

        .form-subtitle {
            font-size: 14px;
            color: var(--text-muted);
            margin-bottom: 36px;
            line-height: 1.6;
        }

        /* Input with icon wrapper */
        .input-wrapper {
            position: relative;
        }

        .input-icon {
            position: absolute;
            left: 14px;
            top: 50%;
            transform: translateY(-50%);
            color: var(--text-muted);
            font-size: 15px;
            pointer-events: none;
            transition: var(--transition);
        }

        .input-wrapper .form-control {
            padding-left: 42px;
        }

        /* Focus-within colour transition */
        .input-wrapper .form-control:focus ~ .input-icon,
        .input-wrapper:focus-within .input-icon {
            color: var(--primary);
        }

        .form-label {
            font-size: 13px;
            font-weight: 600;
            color: var(--text-secondary);
            margin-bottom: 7px;
            display: block;
            letter-spacing: -0.01em;
        }

        /* Login submit button */
        .btn-login {
            width: 100%;
            padding: 13px;
            font-size: 15px;
            font-weight: 700;
            border-radius: var(--radius-md);
            margin-top: 4px;
            letter-spacing: -0.01em;
        }

        /* Error message */
        .error-message {
            display: flex;
            align-items: flex-start;
            gap: 10px;
            background: var(--danger-bg);
            border: 1px solid var(--danger-border);
            color: #B91C1C;
            padding: 12px 16px;
            border-radius: var(--radius-md);
            font-size: 13px;
            font-weight: 500;
            margin-bottom: 24px;
            line-height: 1.5;
        }

        /* Footer */
        .form-footer {
            text-align: center;
            margin-top: 20px;
            font-size: 13px;
            color: var(--text-muted);
        }

        /* Dev credentials */
        .dev-creds {
            margin-top: 28px;
            padding: 16px 18px;
            background: var(--bg-alt);
            border: 1px solid var(--border);
            border-radius: var(--radius-md);
            position: relative;
        }

        .dev-creds-label {
            position: absolute;
            top: -9px;
            left: 14px;
            font-size: 10px;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 1px;
            color: var(--text-muted);
            background: var(--bg-alt);
            padding: 0 6px;
        }

        .cred-row {
            display: flex;
            align-items: center;
            gap: 8px;
            margin-bottom: 6px;
            font-size: 12px;
            color: var(--text-secondary);
        }

        .cred-row:last-child {
            margin-bottom: 0;
        }

        .cred-tag {
            font-size: 10px;
            font-weight: 700;
            background: var(--primary-100);
            color: var(--primary);
            padding: 2px 7px;
            border-radius: var(--radius-xs);
            text-transform: uppercase;
            letter-spacing: 0.5px;
            flex-shrink: 0;
        }

        .cred-code {
            font-family: 'Courier New', monospace;
            font-size: 11px;
            background: var(--surface);
            border: 1px solid var(--border);
            padding: 2px 7px;
            border-radius: var(--radius-xs);
            color: var(--text-primary);
        }

        /* Responsive */
        @media (max-width: 768px) {
            .login-wrapper {
                grid-template-columns: 1fr;
            }

            .login-brand {
                display: none;
            }

            .login-form-panel {
                padding: 40px 28px;
            }
        }
    </style>
</head>
<body>

<div class="login-wrapper animate-fade-in">

    <!-- Left Brand Panel -->
    <div class="login-brand">
        <div class="brand-grid"></div>

        <!-- Floating Decorative Cards -->
        <div class="brand-cards">
            <div class="mini-card">
                <div class="mini-card-icon">🧠</div>
                <div>
                    <div class="mini-card-text">Aptitude Score</div>
                    <div class="mini-card-sub">Cognitive Analysis</div>
                </div>
            </div>
            <div class="mini-card">
                <div class="mini-card-icon">🎯</div>
                <div>
                    <div class="mini-card-text">Career Match</div>
                    <div class="mini-card-sub">Personalized Results</div>
                </div>
            </div>
            <div class="mini-card">
                <div class="mini-card-icon">📊</div>
                <div>
                    <div class="mini-card-text">Skill Analysis</div>
                    <div class="mini-card-sub">Detailed Report</div>
                </div>
            </div>
        </div>

        <div class="brand-content">
            <div class="brand-logo-wrap">
                <img src="${pageContext.request.contextPath}/images/logo.svg" alt="DISHA Logo">
                <div class="brand-logo-name">DISHA</div>
            </div>
            <h2 class="brand-heading">
                Find Your<br><span class="highlight">Perfect Career</span><br>Path
            </h2>
            <p class="brand-sub">
                Science-backed assessment tailored for students across Nepal. Discover your strengths and unlock your
                future.
            </p>
            <div class="trust-list">
                <div class="trust-item">
                    <div class="trust-icon">✅</div>
                    Science-backed career assessment
                </div>
                <div class="trust-item">
                    <div class="trust-icon">🇳🇵</div>
                    Tailored for Nepal's job market
                </div>
                <div class="trust-item">
                    <div class="trust-icon">🔒</div>
                    100% private & secure data
                </div>
            </div>
            <div class="brand-nepali">सही बाटो, उज्वल भविष्य</div>
        </div>
    </div>

    <!-- Right Form Panel -->
    <div class="login-form-panel">
        <div class="form-eyebrow">Welcome back</div>
        <h1 class="form-title">Sign in to DISHA</h1>
        <p class="form-subtitle">Access your career assessment dashboard and results.</p>

        <c:if test="${not empty errorMessage}">
            <div class="error-message">
                <span>⚠️</span>
                <span>${errorMessage}</span>
            </div>
        </c:if>

        <form action="${pageContext.request.contextPath}/login" method="post" id="loginForm">
            <div class="form-group">
                <label class="form-label" for="email">Email address</label>
                <div class="input-wrapper">
                    <span class="input-icon">✉️</span>
                    <input
                            type="email"
                            id="email"
                            name="email"
                            class="form-control"
                            required
                            placeholder="name@example.com"
                            autocomplete="email"
                    >
                </div>
            </div>

            <div class="form-group">
                <label class="form-label" for="password">Password</label>
                <div class="input-wrapper">
                    <span class="input-icon">🔑</span>
                    <input
                            type="password"
                            id="password"
                            name="password"
                            class="form-control"
                            required
                            placeholder="Enter your password"
                            autocomplete="current-password"
                    >
                </div>
            </div>

            <button type="submit" class="btn-accent btn-login" id="btnSignIn">
                Sign In &nbsp;→
            </button>
        </form>

        <p class="form-footer">Don't have an account? Contact your counselor.</p>


    </div>

</div>

</body>
</html>
