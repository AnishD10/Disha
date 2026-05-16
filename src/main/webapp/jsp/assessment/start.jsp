<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Start Assessment - DISHA Career Portal</title>
    <meta name="description"
          content="Begin your career assessment with DISHA. Discover your strengths and ideal career paths in Nepal.">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/main.css?v=5">
    <style>
        body {
            background: var(--bg);
            min-height: 100vh;
            overflow-x: hidden;
        }

        /* --- PAGE LAYOUT ------------------------ */
        .page-content {
            max-width: 100%;
            margin: 0 auto;
            padding: 0 40px;
        }

        /* --- HERO -------------------------------- */
        .hero {
            display: grid;
            grid-template-columns: 1fr 460px;
            align-items: center;
            gap: 56px;
            padding: 40px 0 60px;
        }

        @media (max-width: 1024px) {
            .hero {
                grid-template-columns: 1fr;
                padding: 20px 0 40px;
            }

            .page-content {
                padding: 0 20px;
            }
        }

        /* Tag pill */
        .hero-tag {
            display: inline-flex;
            align-items: center;
            gap: 7px;
            background: var(--primary-50);
            border: 1px solid var(--primary-100);
            color: var(--primary);
            padding: 6px 14px;
            border-radius: var(--radius-full);
            font-size: 12px;
            font-weight: 600;
            margin-bottom: 22px;
            letter-spacing: -0.01em;
        }

        .hero-tag-dot {
            width: 6px;
            height: 6px;
            border-radius: 50%;
            background: var(--primary);
            animation: pulse 2s infinite;
        }

        @keyframes pulse {
            0%, 100% {
                opacity: 1;
                transform: scale(1);
            }
            50% {
                opacity: 0.5;
                transform: scale(0.8);
            }
        }

        .hero-title {
            font-size: 50px;
            font-weight: 800;
            font-family: 'Plus Jakarta Sans', sans-serif;
            line-height: 1.14;
            letter-spacing: -0.04em;
            margin-bottom: 20px;
            color: var(--text-primary);
        }

        .hero-title .accent {
            background: var(--primary-gradient);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
        }

        .hero-subtitle {
            font-size: 16px;
            color: var(--text-secondary);
            line-height: 1.75;
            margin-bottom: 32px;
            max-width: 420px;
        }

        .hero-meta {
            display: flex;
            align-items: center;
            gap: 18px;
            flex-wrap: wrap;
        }

        .hero-meta-item {
            display: flex;
            align-items: center;
            gap: 6px;
            font-size: 13px;
            font-weight: 500;
            color: var(--text-muted);
        }

        /* Hero Visual */
        .hero-visual {
            position: relative;
        }

        .hero-visual-card {
            background: var(--surface);
            border: 1px solid var(--border);
            border-radius: var(--radius-2xl);
            overflow: hidden;
            box-shadow: var(--shadow-xl);
            position: relative;
        }

        .hero-visual-card img {
            width: 100%;
            height: 340px;
            object-fit: cover;
            object-position: center;
            display: block;
        }

        /* Floating stat chip */
        .hero-chip {
            position: absolute;
            z-index: 10;
            background: var(--surface);
            border: 1px solid var(--border);
            border-radius: var(--radius-md);
            padding: 10px 14px;
            box-shadow: var(--shadow-lg);
            display: flex;
            align-items: center;
            gap: 8px;
            font-size: 13px;
            font-weight: 600;
        }

        .hero-chip.chip-1 {
            bottom: -18px;
            left: -20px;
            color: var(--text-primary);
        }

        .hero-chip.chip-2 {
            top: -18px;
            right: -16px;
            color: var(--text-primary);
        }

        .chip-icon {
            width: 32px;
            height: 32px;
            border-radius: 8px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 15px;
        }

        .chip-icon.blue {
            background: var(--primary-100);
        }

        .chip-icon.green {
            background: var(--success-bg);
        }

        .chip-label {
            font-size: 10px;
            font-weight: 500;
            color: var(--text-muted);
            margin-top: 2px;
        }

        /* --- DIVIDER ---------------------------- */
        .section-divider {
            height: 1px;
            background: var(--border);
            margin: 0;
        }

        /* --- STAT CARDS ------------------------- */
        .stats-row {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 18px;
            padding: 40px 0;
        }

        @media (max-width: 1024px) {
            .stats-row {
                grid-template-columns: 1fr;
            }
        }

        .stat-card {
            background: var(--surface);
            border: 1px solid var(--border);
            border-radius: var(--radius-lg);
            padding: 24px;
            display: flex;
            align-items: center;
            gap: 16px;
            box-shadow: var(--shadow-xs);
            transition: var(--transition);
            cursor: default;
        }

        .stat-card:hover {
            transform: translateY(-3px);
            box-shadow: var(--shadow-lg);
            border-color: var(--primary-200);
        }

        .stat-icon-wrap {
            width: 52px;
            height: 52px;
            border-radius: var(--radius-md);
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 22px;
            flex-shrink: 0;
        }

        .stat-icon-wrap.blue {
            background: var(--primary-100);
        }

        .stat-icon-wrap.cyan {
            background: #ECFEFF;
        }

        .stat-icon-wrap.green {
            background: var(--success-bg);
        }

        .stat-number {
            font-size: 30px;
            font-weight: 800;
            font-family: 'Plus Jakarta Sans', sans-serif;
            color: var(--text-primary);
            line-height: 1;
            margin-bottom: 4px;
            letter-spacing: -0.03em;
        }

        .stat-label {
            font-size: 14px;
            font-weight: 600;
            color: var(--text-secondary);
            margin-bottom: 2px;
        }

        .stat-sub {
            font-size: 12px;
            color: var(--text-muted);
        }

        /* --- SECTION CARDS ---------------------- */
        .sections-block {
            padding: 0 0 40px;
        }

        .block-eyebrow {
            font-size: 11px;
            font-weight: 700;
            color: var(--text-muted);
            text-transform: uppercase;
            letter-spacing: 1px;
            margin-bottom: 14px;
        }

        .sections-grid {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 14px;
        }

        @media (max-width: 1024px) {
            .sections-grid {
                grid-template-columns: 1fr;
            }
        }

        .section-card {
            background: var(--surface);
            border: 1px solid var(--border);
            border-radius: var(--radius-lg);
            padding: 22px;
            transition: var(--transition);
            box-shadow: var(--shadow-xs);
            position: relative;
            overflow: hidden;
        }

        .section-card::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            height: 3px;
            border-radius: var(--radius-lg) var(--radius-lg) 0 0;
        }

        .section-card.blue::before {
            background: var(--primary-gradient);
        }

        .section-card.teal::before {
            background: linear-gradient(135deg, #0EA5E9, #06B6D4);
        }

        .section-card.green::before {
            background: linear-gradient(135deg, #22C55E, #16A34A);
        }

        .section-card:hover {
            transform: translateY(-3px);
            box-shadow: var(--shadow-lg);
            border-color: var(--border-strong);
        }

        .section-card-icon {
            width: 44px;
            height: 44px;
            border-radius: var(--radius-sm);
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 20px;
            margin-bottom: 14px;
        }

        .section-card.blue .section-card-icon {
            background: var(--primary-100);
        }

        .section-card.teal .section-card-icon {
            background: #ECFEFF;
        }

        .section-card.green .section-card-icon {
            background: var(--success-bg);
        }

        .section-card-letter {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            width: 22px;
            height: 22px;
            border-radius: 6px;
            font-size: 11px;
            font-weight: 800;
            margin-bottom: 6px;
        }

        .section-card.blue .section-card-letter {
            background: var(--primary-100);
            color: var(--primary-dark);
        }

        .section-card.teal .section-card-letter {
            background: #ECFEFF;
            color: var(--info);
        }

        .section-card.green .section-card-letter {
            background: var(--success-bg);
            color: #15803D;
        }

        .section-card-name {
            font-size: 15px;
            font-weight: 700;
            color: var(--text-primary);
            margin-bottom: 6px;
            letter-spacing: -0.01em;
        }

        .section-card-desc {
            font-size: 13px;
            color: var(--text-muted);
            line-height: 1.6;
        }

        /* --- NOTICE + CTA ----------------------- */
        .cta-block {
            display: grid;
            grid-template-columns: 1fr auto;
            gap: 20px;
            align-items: center;
            padding: 0 0 56px;
        }

        @media (max-width: 1024px) {
            .cta-block {
                grid-template-columns: 1fr;
            }
        }

        .notice-card {
            background: var(--bg-blue);
            border: 1px solid var(--primary-100);
            border-radius: var(--radius-lg);
            padding: 18px 22px;
            display: flex;
            align-items: flex-start;
            gap: 14px;
        }

        .notice-icon {
            font-size: 20px;
            flex-shrink: 0;
            margin-top: 1px;
        }

        .notice-title {
            font-size: 14px;
            font-weight: 600;
            color: var(--text-primary);
            margin-bottom: 4px;
        }

        .notice-desc {
            font-size: 13px;
            color: var(--text-secondary);
            line-height: 1.6;
        }

        /* CTA Button */
        .btn-cta {
            display: flex;
            align-items: center;
            gap: 10px;
            padding: 16px 36px;
            font-size: 16px;
            font-weight: 700;
            font-family: 'Plus Jakarta Sans', sans-serif;
            border: none;
            border-radius: var(--radius-lg);
            background: var(--accent-gradient);
            color: #fff;
            cursor: pointer;
            white-space: nowrap;
            transition: var(--transition);
            text-decoration: none;
            box-shadow: var(--accent-glow);
            letter-spacing: -0.02em;
        }

        .btn-cta:hover {
            transform: translateY(-2px);
            box-shadow: 0 16px 40px rgba(249, 115, 22, 0.42);
        }

        .btn-cta:active {
            transform: translateY(0);
        }

        .btn-cta-arrow {
            font-size: 18px;
            transition: transform 0.2s ease;
        }

        .btn-cta:hover .btn-cta-arrow {
            transform: translateX(4px);
        }

        /* --- ERROR -------------------------------- */
        .error-box {
            background: var(--danger-bg);
            border: 1px solid var(--danger-border);
            color: #B91C1C;
            padding: 12px 16px;
            border-radius: var(--radius-md);
            font-size: 13px;
            font-weight: 500;
            margin-bottom: 20px;
            display: flex;
            align-items: center;
            gap: 8px;
        }

        /* --- TRUST FOOTER ------------------------- */
        .trust-row {
            display: flex;
            justify-content: center;
            align-items: center;
            gap: 40px;
            padding: 20px 0 56px;
            border-top: 1px solid var(--border);
        }

        .trust-item {
            display: flex;
            align-items: center;
            gap: 7px;
            font-size: 12px;
            color: var(--text-muted);
            font-weight: 500;
        }

        /* --- RESPONSIVE --------------------------- */
        @media (max-width: 980px) {
            .hero {
                grid-template-columns: 1fr;
                padding: 48px 0 36px;
                gap: 36px;
            }

            .hero-title {
                font-size: 38px;
            }

            .hero-visual-card img {
                height: 240px;
            }

            .hero-subtitle {
                max-width: 100%;
            }

            .stats-row, .sections-grid {
                grid-template-columns: 1fr;
            }

            .cta-block {
                grid-template-columns: 1fr;
            }

            .btn-cta {
                width: 100%;
                justify-content: center;
            }

            .trust-row {
                flex-direction: column;
                gap: 14px;
            }

            .top-nav {
                padding: 0 var(--space-5);
            }

            .page-content {
                padding: 0 var(--space-5);
            }

            .hero-chip {
                display: none;
            }
        }
    </style>
</head>
<body>
<div class="sidebar-overlay" id="sidebarOverlay"></div>

<!-- Sidebar -->
<aside class="sidebar">
    <a href="${pageContext.request.contextPath}/" class="brand">
        <div class="brand-icon">
            <img src="${pageContext.request.contextPath}/images/logo.svg?v=1.1" alt="DISHA Logo">
        </div>
        <div class="brand-text">DISHA</div>
    </a>
    <nav>
        <a href="${pageContext.request.contextPath}/" class="nav-item">
            <span style="font-size:18px">⌂</span> Dashboard
        </a>
        <a href="#" class="nav-item active">
            <span style="font-size:18px">📝</span> Assessment
        </a>
        <a href="${pageContext.request.contextPath}/assessment/history" class="nav-item">
            <span style="font-size:18px">🕒</span> History
        </a>
        <a href="${pageContext.request.contextPath}/profile" class="nav-item">
            <span style="font-size:18px">👤</span> Profile
        </a>
        <a href="${pageContext.request.contextPath}/resources" class="nav-item">
            <span style="font-size:18px">📚</span> Resources
        </a>
        <a href="${pageContext.request.contextPath}/support" class="nav-item">
            <span style="font-size:18px">🎧</span> Counselor Support
        </a>
    </nav>
</aside>

<!-- Main Wrapper -->
<div class="main-wrapper">

    <!-- Topnav -->
    <header class="topnav">
        <button class="mobile-menu-btn" id="mobileMenuBtn">☰</button>
        <a href="${pageContext.request.contextPath}/assessment/history" class="btn btn-outline"
           style="padding: 8px 16px;">
            📊 My Results
        </a>
        <button class="icon-btn">🔔</button>
        <div class="avatar">S</div>
    </header>

    <div class="page-content">

        <!-- Hero Section -->
        <section class="hero animate-fade-in">
            <div class="hero-left">
                <div class="hero-tag">
                    <span class="hero-tag-dot"></span>
                    Career Assessment for Nepal 🇳🇵
                </div>
                <h1 class="hero-title">
                    Discover the Right<br>
                    <span class="accent">Career Path</span><br>
                    for You
                </h1>
                <p class="hero-subtitle">
                    This assessment identifies your unique strengths, personality type,
                    and the careers in Nepal best suited for you. Honest answers
                    lead to the most accurate results.
                </p>
                <div class="hero-meta">
                    <div class="hero-meta-item">⏱️ Takes 10-15 minutes</div>
                    <div class="hero-meta-item">📋 30 questions</div>
                    <div class="hero-meta-item">🔄 Unlimited retakes</div>
                </div>
            </div>

            <div class="hero-visual">
                <!-- Floating chips -->
                <div class="hero-chip chip-2">
                    <div class="chip-icon green">🎯</div>
                    <div>
                        <div>Career Match</div>
                        <div class="chip-label">Personalized</div>
                    </div>
                </div>
                <div class="hero-visual-card">
                    <img src="${pageContext.request.contextPath}/images/hero.png" alt="Career Paths Illustration">
                </div>
                <div class="hero-chip chip-1">
                    <div class="chip-icon blue">📊</div>
                    <div>
                        <div>Skill Report</div>
                        <div class="chip-label">Detailed Analysis</div>
                    </div>
                </div>
            </div>
        </section>

        <div class="section-divider"></div>

        <!-- Stat Cards -->
        <div class="stats-row animate-fade-in delay-1">
            <div class="stat-card">
                <div class="stat-icon-wrap blue">📄</div>
                <div>
                    <div class="stat-number">30</div>
                    <div class="stat-label">Questions</div>
                    <div class="stat-sub">Across 3 sections</div>
                </div>
            </div>
            <div class="stat-card">
                <div class="stat-icon-wrap cyan">⏰</div>
                <div>
                    <div class="stat-number">10-15</div>
                    <div class="stat-label">Minutes</div>
                    <div class="stat-sub">Estimated completion time</div>
                </div>
            </div>
            <div class="stat-card">
                <div class="stat-icon-wrap green">🔄</div>
                <div>
                    <div class="stat-label"
                         style="margin-bottom: 4px; font-size: 16px; font-weight: 700; color: var(--text-primary);">
                        Unlimited
                    </div>
                    <div class="stat-label">Retakes Allowed</div>
                    <div class="stat-sub">Each attempt saved separately</div>
                </div>
            </div>
        </div>

        <!-- Assessment Sections -->
        <div class="sections-block animate-fade-in delay-2">
            <div class="block-eyebrow">What you'll be assessed on</div>
            <div class="sections-grid">
                <div class="section-card blue">
                    <div class="section-card-icon">🧠</div>
                    <div class="section-card-letter">A</div>
                    <div class="section-card-name">Aptitude (MCQ)</div>
                    <div class="section-card-desc">Measures your cognitive abilities, logical reasoning, and
                        problem-solving skills.
                    </div>
                </div>
                <div class="section-card teal">
                    <div class="section-card-icon">🌟</div>
                    <div class="section-card-letter">B</div>
                    <div class="section-card-name">Personality</div>
                    <div class="section-card-desc">Understands your behavioral patterns, preferences, and personality
                        traits.
                    </div>
                </div>
                <div class="section-card green">
                    <div class="section-card-icon">🎯</div>
                    <div class="section-card-letter">C</div>
                    <div class="section-card-name">Interest</div>
                    <div class="section-card-desc">Identifies your areas of passion and career inclinations for the
                        future.
                    </div>
                </div>
            </div>
        </div>

        <!-- Error Message -->
        <c:if test="${not empty errorMessage}">
            <div class="error-box">⚠️ ${errorMessage}</div>
        </c:if>

        <!-- CTA Block -->
        <div class="cta-block animate-fade-in delay-2">
            <div class="notice-card">
                <div class="notice-icon">🛡️</div>
                <div>
                    <div class="notice-title">Answer every question honestly</div>
                    <div class="notice-desc">Sections B and C have no right or wrong answers. Your results are saved
                        privately to your profile only.
                    </div>
                </div>
            </div>
            <form method="post" action="${pageContext.request.contextPath}/assessment/start">
                <button type="submit" class="btn-cta" id="btnStartAssessment">
                    🚀 Start Assessment
                    <span class="btn-cta-arrow">→</span>
                </button>
            </form>
        </div>

        <!-- Trust Footer -->
        <div class="trust-row">
            <div class="trust-item">🏔️ Trusted by students across Nepal</div>
            <div class="trust-item">👤 Designed with career experts</div>
            <div class="trust-item">🔒 100% Private &amp; Secure</div>
        </div>

    </div>
</div>
<script>
    document.addEventListener('DOMContentLoaded', function () {
        const mobileMenuBtn = document.getElementById('mobileMenuBtn');
        const sidebar = document.querySelector('.sidebar');
        const overlay = document.getElementById('sidebarOverlay');

        if (mobileMenuBtn && sidebar && overlay) {
            function toggleMenu() {
                sidebar.classList.toggle('open');
                overlay.classList.toggle('show');
            }

            mobileMenuBtn.addEventListener('click', toggleMenu);
            overlay.addEventListener('click', toggleMenu);
        }
    });
</script>
</body>
</html>
