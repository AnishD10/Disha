<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Your Results - DISHA Career Portal</title>
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/main.css?v=7">
    <style>
        :root {
            --primary: #2563EB;
            --primary-light: #38BDF8;
            --accent-orange: #F97316;
            --success-green: #22C55E;
            --bg: #F8FAFC;
            --surface: #FFFFFF;
            --text-dark: #0F172A;
            --text-muted: #64748B;
            --border: #E2E8F0;
            --sidebar-w: 240px;
        }

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: 'Inter', sans-serif;
        }

        body {
            background-color: var(--bg);
            color: var(--text-dark);
            display: flex;
        }

        /* Sidebar */
        .sidebar {
            width: var(--sidebar-w);
            background: var(--surface);
            border-right: 1px solid var(--border);
            height: 100vh;
            position: fixed;
            left: 0;
            top: 0;
            padding: 24px 16px;
            display: flex;
            flex-direction: column;
            gap: 8px;
            overflow-y: auto;
        }

        .brand {
            display: flex;
            align-items: center;
            gap: 12px;
            margin-bottom: 32px;
            padding: 0 8px;
            text-decoration: none;
        }

        .brand-icon {
            width: 32px;
            height: 32px;
            background: var(--primary);
            color: white;
            border-radius: 8px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: bold;
        }

        .brand-text {
            font-size: 18px;
            font-weight: 700;
            color: var(--text-dark);
        }

        .nav-item {
            display: flex;
            align-items: center;
            gap: 12px;
            padding: 12px 16px;
            border-radius: 12px;
            color: var(--text-muted);
            text-decoration: none;
            font-size: 14px;
            font-weight: 500;
            transition: all 0.2s;
        }

        .nav-item:hover {
            background: #F1F5F9;
            color: var(--text-dark);
        }

        .nav-item.active {
            background: #EFF6FF;
            color: var(--primary);
            font-weight: 600;
        }

        .sidebar-counselor {
            margin-top: auto;
            padding: 20px 16px;
            background: #F8FAFC;
            border-radius: 16px;
            text-align: center;
            border: 1px solid var(--border);
            margin-bottom: 16px;
        }

        .sidebar-counselor img {
            width: 80px;
            height: 80px;
            border-radius: 50%;
            margin: 0 auto 12px;
            background: #E0E7FF;
            object-fit: cover;
        }

        .sidebar-counselor .btn-pill {
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 6px;
            width: 100%;
            padding: 8px 12px;
            font-size: 12px;
            font-weight: 600;
            background: white;
            border: 1px solid var(--border);
            border-radius: 20px;
            color: var(--text-dark);
            text-decoration: none;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.02);
        }

        /* Main Layout */
        .main-wrapper {
            margin-left: var(--sidebar-w);
            flex: 1;
            display: flex;
            flex-direction: column;
            min-height: 100vh;
        }

        /* Topnav */
        .topnav {
            height: 72px;
            background: var(--surface);
            border-bottom: 1px solid var(--border);
            display: flex;
            align-items: center;
            justify-content: flex-end;
            padding: 0 40px;
            gap: 16px;
            position: sticky;
            top: 0;
            z-index: 10;
        }

        .btn {
            padding: 10px 20px;
            border-radius: 8px;
            font-size: 14px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.2s;
            border: none;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            justify-content: center;
        }

        .btn-outline {
            background: var(--surface);
            border: 1px solid var(--border);
            color: var(--text-dark);
        }

        .btn-outline:hover {
            background: #F1F5F9;
        }

        .btn-primary {
            background: var(--primary);
            color: white;
        }

        .btn-primary:hover {
            background: #1D4ED8;
        }

        .avatar {
            width: 36px;
            height: 36px;
            border-radius: 50%;
            background: #2563EB;
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: 600;
            color: #fff;
        }

        .icon-btn {
            width: 36px;
            height: 36px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            background: white;
            border: 1px solid var(--border);
            cursor: pointer;
            color: var(--text-muted);
        }

        /* Content Area */
        .content {
            padding: 32px 40px;
            max-width: 1100px;
            margin: 0 auto;
            width: 100%;
        }

        /* Section Title */
        .section-title {
            font-size: 18px;
            font-weight: 700;
            margin-bottom: 20px;
            color: var(--text-dark);
            display: flex;
            align-items: center;
            justify-content: space-between;
        }

        .view-all {
            font-size: 14px;
            font-weight: 500;
            color: var(--primary);
            text-decoration: none;
            display: flex;
            align-items: center;
            gap: 4px;
        }

        /* Career Grid */
        .careers-container {
            display: flex;
            align-items: center;
            gap: 16px;
            margin-bottom: 32px;
        }

        .carousel-btn {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            background: white;
            border: 1px solid var(--border);
            display: flex;
            align-items: center;
            justify-content: center;
            color: var(--text-muted);
            cursor: pointer;
            flex-shrink: 0;
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.02);
            font-size: 18px;
        }

        .careers-grid {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 24px;
            flex: 1;
        }

        .career-card {
            background: var(--surface);
            border-radius: 16px;
            padding: 24px;
            box-shadow: 0 4px 10px -2px rgba(0, 0, 0, 0.03);
            border: 1px solid var(--border);
            position: relative;
            display: flex;
            flex-direction: column;
        }

        .c-header-icons {
            display: flex;
            justify-content: space-between;
            margin-bottom: 16px;
        }

        .rank-badge {
            width: 28px;
            height: 28px;
            border-radius: 50%;
            color: white;
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: 700;
            font-size: 14px;
        }

        .rank-1 {
            background: var(--primary);
        }

        .rank-2 {
            background: var(--accent-orange);
        }

        .rank-3 {
            background: var(--success-green);
        }

        .bookmark-btn {
            width: 28px;
            height: 28px;
            color: var(--text-muted);
            display: flex;
            align-items: center;
            justify-content: center;
            border: 1px solid var(--border);
            border-radius: 6px;
            background: white;
            cursor: pointer;
        }

        .career-icon-wrap {
            width: 64px;
            height: 64px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 32px;
            margin: 0 auto 16px;
        }

        .career-icon-wrap.rank-1 {
            background: #EFF6FF;
        }

        .career-icon-wrap.rank-2 {
            background: #FFF7ED;
        }

        .career-icon-wrap.rank-3 {
            background: #F0FDF4;
        }

        .career-title {
            font-size: 18px;
            font-weight: 700;
            text-align: center;
            margin-bottom: 4px;
            color: var(--text-dark);
        }

        .career-industry {
            font-size: 13px;
            color: var(--text-muted);
            text-align: center;
            margin-bottom: 12px;
        }

        .career-match {
            background: #DCFCE7;
            color: #15803D;
            font-size: 12px;
            font-weight: 600;
            padding: 4px 12px;
            border-radius: 12px;
            display: block;
            margin: 0 auto 16px;
            width: max-content;
        }

        .career-desc {
            font-size: 13px;
            color: var(--text-muted);
            text-align: center;
            line-height: 1.5;
            margin-bottom: 20px;
            min-height: 60px;
        }

        .career-tags {
            display: flex;
            justify-content: space-between;
            border-top: 1px solid var(--border);
            padding-top: 16px;
            margin-bottom: 20px;
        }

        .c-tag {
            display: flex;
            flex-direction: column;
            gap: 4px;
        }

        .c-tag-label {
            font-size: 11px;
            color: var(--text-muted);
            text-transform: uppercase;
            font-weight: 600;
        }

        .c-tag-val {
            font-size: 13px;
            font-weight: 600;
            color: var(--text-dark);
            display: flex;
            align-items: center;
            gap: 4px;
        }

        .c-tag-val.high {
            color: var(--success-green);
        }

        .c-tag-val.medium {
            color: var(--accent-orange);
        }

        .btn-career {
            width: 100%;
            text-align: center;
            border-radius: 8px;
            padding: 10px;
            font-size: 13px;
            font-weight: 600;
            cursor: pointer;
            margin-top: auto;
            text-decoration: none;
            display: block;
        }

        .btn-career.rank-1 {
            background: #EFF6FF;
            color: #1D4ED8;
            border: none;
        }

        .btn-career.rank-2 {
            background: #FFF7ED;
            color: #C2410C;
            border: none;
        }

        .btn-career.rank-3 {
            background: #F0FDF4;
            color: #15803D;
            border: none;
        }

        .carousel-dots {
            display: flex;
            justify-content: center;
            gap: 6px;
            margin-bottom: 48px;
        }

        .dot {
            width: 8px;
            height: 8px;
            border-radius: 50%;
            background: #CBD5E1;
        }

        .dot.active {
            background: var(--primary);
            width: 16px;
            border-radius: 4px;
        }

        /* Two Column Layout for Analysis & Chart */
        .analysis-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 24px;
            margin-bottom: 48px;
        }

        .panel {
            background: var(--surface);
            border-radius: 16px;
            padding: 24px;
            box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.03);
            border: 1px solid var(--border);
            display: flex;
            flex-direction: column;
        }

        .panel-title {
            font-size: 16px;
            font-weight: 700;
            margin-bottom: 24px;
            color: var(--text-dark);
            display: flex;
            align-items: center;
            gap: 8px;
        }

        /* Skills List */
        .skill-item {
            display: flex;
            align-items: center;
            gap: 16px;
            margin-bottom: 24px;
        }

        .skill-item:last-child {
            margin-bottom: 0;
        }

        .skill-icon {
            width: 32px;
            height: 32px;
            border-radius: 8px;
            background: #F1F5F9;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 16px;
            flex-shrink: 0;
        }

        .skill-name {
            width: 120px;
            font-size: 13px;
            font-weight: 600;
            color: var(--text-dark);
        }

        .skill-bar-wrap {
            flex: 1;
            display: flex;
            align-items: center;
            gap: 12px;
        }

        .s-bar-bg {
            flex: 1;
            height: 6px;
            background: #F1F5F9;
            border-radius: 4px;
            overflow: hidden;
        }

        .s-bar-fg {
            height: 100%;
            border-radius: 4px;
        }

        .s-val {
            font-size: 12px;
            font-weight: 600;
            width: 32px;
            color: var(--text-muted);
            text-align: right;
        }

        .s-badge {
            width: 80px;
            text-align: center;
            padding: 4px 0;
            border-radius: 4px;
            font-size: 11px;
            font-weight: 600;
        }

        .s-tip {
            font-size: 11px;
            color: var(--text-muted);
            width: 140px;
            line-height: 1.4;
        }

        .status-needs-work .s-bar-fg {
            background: #EF4444;
        }

        .status-needs-work .s-badge {
            background: #FEF2F2;
            color: #DC2626;
        }

        .status-average .s-bar-fg {
            background: #F59E0B;
        }

        .status-average .s-badge {
            background: #FFFBEB;
            color: #D97706;
        }

        .status-strong .s-bar-fg {
            background: #22C55E;
        }

        .status-strong .s-badge {
            background: #F0FDF4;
            color: #16A34A;
        }

        .insight-box {
            margin-top: auto;
            padding: 16px;
            background: #EFF6FF;
            border-radius: 8px;
            display: flex;
            align-items: center;
            gap: 12px;
            font-size: 12px;
            font-weight: 600;
            color: #1E3A8A;
            line-height: 1.4;
        }

        .insight-icon {
            font-size: 16px;
        }

        /* Radar Chart container */
        .chart-container {
            position: relative;
            flex: 1;
            width: 100%;
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 280px;
            padding: 10px;
            margin-bottom: 24px;
        }

        /* Next Steps */
        .next-steps-grid {
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            gap: 16px;
            margin-bottom: 40px;
        }

        .step-card {
            background: var(--surface);
            border: 1px solid var(--border);
            border-radius: 12px;
            padding: 20px;
            transition: all 0.2s;
            text-decoration: none;
            color: inherit;
            display: flex;
            flex-direction: column;
            height: 100%;
        }

        .step-card:hover {
            border-color: var(--primary);
            transform: translateY(-2px);
            box-shadow: 0 10px 15px -3px rgba(0, 0, 0, 0.05);
        }

        .step-icon {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 20px;
            margin-bottom: 16px;
        }

        .step-icon.blue {
            background: #EFF6FF;
            color: var(--primary);
        }

        .step-icon.orange {
            background: #FFF7ED;
            color: var(--accent-orange);
        }

        .step-icon.green {
            background: #F0FDF4;
            color: var(--success-green);
        }

        .step-icon.purple {
            background: #F5F3FF;
            color: #8B5CF6;
        }

        .step-title {
            font-size: 14px;
            font-weight: 700;
            margin-bottom: 6px;
            color: var(--text-dark);
        }

        .step-desc {
            font-size: 12px;
            color: var(--text-muted);
            line-height: 1.5;
            margin-bottom: 16px;
            flex: 1;
        }

        .step-link {
            font-size: 12px;
            font-weight: 600;
            color: var(--primary);
            display: flex;
            align-items: center;
            gap: 4px;
        }

        /* Responsive Layout */
        @media (max-width: 1024px) {
            .sidebar-counselor {
                display: none;
            }

            .main-wrapper {
                margin-left: 0;
                width: 100%;
            }

            .topnav {
                padding: 0 20px;
                justify-content: flex-start;
            }

            .topnav > :first-child:not(.mobile-menu-btn) {
                margin-left: auto;
            }

            .careers-grid {
                grid-template-columns: 1fr;
            }

            .analysis-grid {
                grid-template-columns: 1fr;
            }

            .next-steps-grid {
                grid-template-columns: 1fr 1fr;
            }

            .content {
                padding: 20px;
            }

            .mobile-menu-btn {
                display: flex;
                align-items: center;
                justify-content: center;
                background: transparent;
                border: none;
                font-size: 24px;
                padding: 8px;
                margin-right: 12px;
                cursor: pointer;
                color: var(--text-dark);
            }
        }

        /* Responsive Overrides */
        @media (max-width: 1024px) {
            .careers-grid {
                grid-template-columns: repeat(2, 1fr);
            }
            .analysis-grid {
                grid-template-columns: 1fr;
            }
            .next-steps-grid {
                grid-template-columns: repeat(2, 1fr);
            }
        }

        @media (max-width: 768px) {
            body {
                flex-direction: column;
            }
            .sidebar {
                display: none; /* Collapsed by default on mobile */
            }
            .main-content {
                margin-left: 0;
                padding: 24px 16px;
            }
            .careers-grid {
                grid-template-columns: 1fr;
            }
            .next-steps-grid {
                grid-template-columns: 1fr;
            }
            .skill-item {
                flex-direction: column;
                align-items: flex-start;
                gap: 8px;
            }
            .skill-name {
                width: 100%;
            }
            .skill-bar-wrap {
                width: 100%;
            }
            .s-tip {
                display: none;
            }
        }

        @media (max-width: 480px) {
            .result-header {
                padding: 32px 16px;
            }
            .score-circle {
                width: 80px;
                height: 80px;
                font-size: 20px;
            }
            .career-card {
                padding: 16px;
            }
        }
    </style>
</head>
<body>
<div class="sidebar-overlay" id="sidebarOverlay"></div>

<!-- Sidebar -->
<aside class="sidebar">
    <a href="${pageContext.request.contextPath}/" class="brand">
        <div class="brand-icon">D</div>
        <div class="brand-text">DISHA</div>
    </a>
    <nav>
        <a href="${pageContext.request.contextPath}/" class="nav-item">
            <span style="font-size:18px">⌂</span> Dashboard
        </a>
        <a href="${pageContext.request.contextPath}/assessment/start" class="nav-item">
            <span style="font-size:18px">📝</span> Assessment
        </a>
        <a href="#" class="nav-item active">
            <span style="font-size:18px">📊</span> Results
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

    <div class="sidebar-counselor">
        <img src="${pageContext.request.contextPath}/images/counselor-avatar.png"
             onerror="this.src='https://ui-avatars.com/api/?name=Counselor&background=E0E7FF&color=2563EB&rounded=true'"
             alt="Counselor">
        <a href="#" class="btn-pill">💬 Talk to a Counselor</a>
    </div>
</aside>

<!-- Main Wrapper -->
<div class="main-wrapper">

    <!-- Topnav -->
    <header class="topnav">
        <button class="mobile-menu-btn" id="mobileMenuBtn">☰</button>
        <div class="avatar">S</div>
    </header>

    <!-- Content -->
    <main class="content">
        <c:if test="${not empty errorMessage}">
            <div style="background:#FEF2F2; color:#DC2626; padding:16px; border-radius:8px; border:1px solid #FECACA; margin-bottom:24px; font-weight:500;">
                    ${errorMessage}
            </div>
        </c:if>

        <c:if test="${not empty report}">

            <!-- Careers -->
            <div class="section-title">
                <span>⭐ Top Career Recommendations in Nepal</span>
                <a href="#" class="view-all">View All Careers →</a>
            </div>

            <div class="careers-container">
                <button class="carousel-btn">❮</button>
                <div class="careers-grid">
                    <c:forEach var="career" items="${report.topCareers}" varStatus="cs">
                        <div class="career-card">
                            <div class="c-header-icons">
                                <div class="rank-badge rank-${cs.index + 1}">${cs.index + 1}</div>
                                <div class="bookmark-btn">🔖</div>
                            </div>
                            <div class="career-icon-wrap rank-${cs.index + 1}">
                                <c:choose>
                                    <c:when test="${cs.index == 0}">💻</c:when>
                                    <c:when test="${cs.index == 1}">🏗️</c:when>
                                    <c:when test="${cs.index == 2}">🎨</c:when>
                                    <c:otherwise>📊</c:otherwise>
                                </c:choose>
                            </div>
                            <h3 class="career-title">${career.careerName}</h3>
                            <div class="career-industry">
                                <c:choose>
                                    <c:when test="${cs.index == 0}">Technology & IT</c:when>
                                    <c:when test="${cs.index == 1}">Engineering</c:when>
                                    <c:when test="${cs.index == 2}">Design & Creative</c:when>
                                    <c:otherwise>Industry</c:otherwise>
                                </c:choose>
                            </div>

                            <c:set var="matchPct" value="75%"/>
                            <c:if test="${cs.index == 0}"><c:set var="matchPct" value="92%"/></c:if>
                            <c:if test="${cs.index == 1}"><c:set var="matchPct" value="86%"/></c:if>
                            <c:if test="${cs.index == 2}"><c:set var="matchPct" value="78%"/></c:if>
                            <div class="career-match">${matchPct} Match</div>

                            <p class="career-desc">${career.careerDescription}</p>

                            <div class="career-tags">
                                <div class="c-tag">
                                    <span class="c-tag-label">Growth</span>
                                    <span class="c-tag-val ${cs.index == 2 ? 'medium' : 'high'}">${cs.index == 2 ? 'Medium ↗' : 'High ↗'}</span>
                                </div>
                                <div class="c-tag">
                                    <span class="c-tag-label">Avg. Salary</span>
                                    <span class="c-tag-val">NPR ${cs.index == 0 ? '1,20,000+' : (cs.index == 1 ? '90,000+' : '70,000+')}</span>
                                </div>
                            </div>

                            <a href="#" class="btn-career rank-${cs.index + 1}">View Career Roadmap</a>
                        </div>
                    </c:forEach>
                </div>
                <button class="carousel-btn">❯</button>
            </div>
            <div class="carousel-dots">
                <div class="dot active"></div>
                <div class="dot"></div>
                <div class="dot"></div>
            </div>

            <!-- Analysis Grid -->
            <div class="analysis-grid">
                <!-- Skills -->
                <div class="panel">
                    <div class="panel-title">📊 Skill Analysis</div>

                    <c:forEach var="skill" items="${report.skills}">
                        <c:set var="statusClass" value=""/>
                        <c:set var="pct" value=""/>
                        <c:set var="badgeText" value=""/>

                        <c:choose>
                            <c:when test="${skill.skillLevel == 'STRONG'}">
                                <c:set var="statusClass" value="status-strong"/>
                                <c:set var="pct" value="80%"/>
                                <c:set var="badgeText" value="Strong"/>
                                <c:if test="${fn:containsIgnoreCase(skill.skillName, 'creat')}"><c:set var="pct"
                                                                                                       value="80%"/></c:if>
                            </c:when>
                            <c:when test="${skill.skillLevel == 'AVERAGE'}">
                                <c:set var="statusClass" value="status-average"/>
                                <c:set var="pct" value="65%"/>
                                <c:set var="badgeText" value="Average"/>
                                <c:if test="${fn:containsIgnoreCase(skill.skillName, 'ethic')}"><c:set var="pct"
                                                                                                       value="70%"/></c:if>
                            </c:when>
                            <c:otherwise>
                                <c:set var="statusClass" value="status-needs-work"/>
                                <c:set var="pct" value="40%"/>
                                <c:set var="badgeText" value="Needs Work"/>
                            </c:otherwise>
                        </c:choose>
                        <c:if test="${fn:containsIgnoreCase(skill.skillName, 'team')}">
                            <c:set var="statusClass" value="status-strong"/>
                            <c:set var="pct" value="75%"/>
                            <c:set var="badgeText" value="Good"/>
                        </c:if>

                        <div class="skill-item ${statusClass}">
                            <div class="skill-icon">
                                <c:choose>
                                    <c:when test="${fn:containsIgnoreCase(skill.skillName, 'logic')}">🧠</c:when>
                                    <c:when test="${fn:containsIgnoreCase(skill.skillName, 'comm')}">💬</c:when>
                                    <c:when test="${fn:containsIgnoreCase(skill.skillName, 'ethic')}">💼</c:when>
                                    <c:when test="${fn:containsIgnoreCase(skill.skillName, 'creat')}">💡</c:when>
                                    <c:when test="${fn:containsIgnoreCase(skill.skillName, 'team')}">👥</c:when>
                                    <c:otherwise>🎯</c:otherwise>
                                </c:choose>
                            </div>
                            <div class="skill-name">
                                <c:choose>
                                    <c:when test="${fn:containsIgnoreCase(skill.skillName, 'logic')}">Logical Thinking</c:when>
                                    <c:when test="${fn:containsIgnoreCase(skill.skillName, 'comm')}">Communication</c:when>
                                    <c:when test="${fn:containsIgnoreCase(skill.skillName, 'ethic')}">Work Ethic</c:when>
                                    <c:when test="${fn:containsIgnoreCase(skill.skillName, 'creat')}">Creativity</c:when>
                                    <c:when test="${fn:containsIgnoreCase(skill.skillName, 'team')}">Teamwork</c:when>
                                    <c:otherwise>${skill.skillName}</c:otherwise>
                                </c:choose>
                            </div>
                            <div class="skill-bar-wrap">
                                <div class="s-bar-bg">
                                    <div class="s-bar-fg" style="width: ${pct}"></div>
                                </div>
                                <div class="s-val">${pct}</div>
                            </div>
                            <div class="s-badge">${badgeText}</div>
                            <div class="s-tip">
                                <c:choose>
                                    <c:when test="${fn:containsIgnoreCase(skill.skillName, 'logic')}">Practice more analytical and reasoning questions</c:when>
                                    <c:when test="${fn:containsIgnoreCase(skill.skillName, 'comm')}">Work on public speaking and group discussions</c:when>
                                    <c:when test="${fn:containsIgnoreCase(skill.skillName, 'ethic')}">Keep improving consistency</c:when>
                                    <c:when test="${fn:containsIgnoreCase(skill.skillName, 'creat')}">Excellent imaginative and innovative thinking</c:when>
                                    <c:when test="${fn:containsIgnoreCase(skill.skillName, 'team')}">Good collaboration and cooperation</c:when>
                                    <c:otherwise>Focus on consistent practice to improve further.</c:otherwise>
                                </c:choose>
                            </div>
                        </div>
                    </c:forEach>

                    <div class="insight-box">
                        <span class="insight-icon">⚡</span> Focus on improving Logical Thinking to unlock even better
                        career opportunities.
                    </div>
                </div>

                <!-- Radar Chart -->
                <div class="panel">
                    <div class="panel-title">Your Strength Profile</div>
                    <div class="chart-container">
                        <canvas id="strengthChart"></canvas>
                    </div>
                    <div class="insight-box">
                        <span class="insight-icon">✨</span> You balance practical ability with analytical thinking quite
                        well!
                    </div>
                </div>
            </div>

            <!-- Next Steps -->
            <div class="section-title" style="margin-bottom: 16px;">What You Can Do Next</div>
            <div class="next-steps-grid">
                <a href="#" class="step-card">
                    <div class="step-icon blue">🧭</div>
                    <div class="step-title">Explore Careers</div>
                    <div class="step-desc">Discover more careers that match your profile.</div>
                    <div class="step-link">Explore Now →</div>
                </a>
                <a href="#" class="step-card">
                    <div class="step-icon orange">🧑‍🏫</div>
                    <div class="step-title">Talk to Counselor</div>
                    <div class="step-desc">Get personalized guidance from our experts.</div>
                    <div class="step-link">Book a Session →</div>
                </a>
                <a href="#" class="step-card">
                    <div class="step-icon green">📄</div>
                    <div class="step-title">Download Report</div>
                    <div class="step-desc">Save your detailed report for future reference.</div>
                    <div class="step-link">Download PDF →</div>
                </a>
                <a href="${pageContext.request.contextPath}/assessment/start" class="step-card">
                    <div class="step-icon purple">🔄</div>
                    <div class="step-title">Retake Assessment</div>
                    <div class="step-desc">Improve your skills and try again later.</div>
                    <div class="step-link">Retake Now →</div>
                </a>
            </div>

        </c:if>
    </main>
</div>

<!-- Chart.js Initialization -->
<c:if test="${not empty report}">
    <script>
        document.addEventListener('DOMContentLoaded', function () {
            var ctx = document.getElementById('strengthChart');
            if (ctx) {
                new Chart(ctx, {
                    type: 'radar',
                    data: {
                        labels: ['Analytical', 'Practical', 'Social', 'Creative', 'Conventional'],
                        datasets: [{
                            label: 'Strength',
                            data: [70, 85, 60, 65, 45],
                            backgroundColor: 'rgba(37, 99, 235, 0.2)',
                            borderColor: 'rgba(37, 99, 235, 1)',
                            pointBackgroundColor: 'rgba(37, 99, 235, 1)',
                            pointBorderColor: '#fff',
                            pointBorderWidth: 2,
                            pointRadius: 4,
                            pointHoverRadius: 6,
                            borderWidth: 2
                        }]
                    },
                    options: {
                        responsive: true,
                        maintainAspectRatio: false,
                        layout: {padding: 20},
                        scales: {
                            r: {
                                angleLines: {color: 'rgba(0, 0, 0, 0.05)'},
                                grid: {color: 'rgba(0, 0, 0, 0.05)'},
                                pointLabels: {
                                    font: {family: 'Inter', size: 11, weight: '600'},
                                    color: '#64748B',
                                    callback: function (value, index, values) {
                                        var data = this.chart.data.datasets[0].data;
                                        return value + '\n' + data[index] + '%';
                                    }
                                },
                                ticks: {display: false, min: 0, max: 100}
                            }
                        },
                        plugins: {
                            legend: {display: false},
                            tooltip: {
                                callbacks: {
                                    label: function (context) {
                                        return context.raw + '%';
                                    }
                                }
                            }
                        }
                    }
                });
            }
        });
    </script>
</c:if>

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
