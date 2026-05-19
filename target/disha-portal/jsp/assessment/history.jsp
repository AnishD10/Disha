<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Assessment History - DISHA Career Portal</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/main.css?v=5">
    <style>
        body {
            background: var(--bg);
            background-image: radial-gradient(ellipse 70% 50% at 85% 5%, rgba(37, 99, 235, 0.05) 0%, transparent 55%);
        }

        /* ---- APP SHELL LAYOUT ---- */
        .sidebar {
            width: 240px;
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
            z-index: 60;
            transition: transform 0.3s cubic-bezier(0.4, 0, 0.2, 1);
        }

        .main-wrapper {
            margin-left: 240px;
            flex: 1;
            display: flex;
            flex-direction: column;
            min-height: 100vh;
        }

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

        .mobile-menu-btn {
            display: none;
            background: transparent;
            border: 1px solid var(--border);
            border-radius: 8px;
            color: var(--text-primary);
            font-size: 20px;
            width: 40px;
            height: 40px;
            cursor: pointer;
            align-items: center;
            justify-content: center;
            transition: var(--transition);
        }

        .mobile-menu-btn:hover {
            background: var(--bg-alt);
        }

        /* ---- RESPONSIVE SHELL OVERRIDES (<= 1024px) ---- */
        @media (max-width: 1024px) {
            .sidebar {
                width: 280px;
                transform: translateX(-100%);
                z-index: 1000;
                box-shadow: var(--shadow-xl);
            }

            .main-wrapper {
                margin-left: 0 !important;
                width: 100% !important;
                max-width: 100vw !important;
            }

            .topnav {
                justify-content: space-between !important;
                padding: 0 20px !important;
            }

            .mobile-menu-btn {
                display: flex !important;
                order: -1; /* Place at the far left */
            }

            body.sidebar-open .sidebar {
                transform: translateX(0) !important;
            }

            body.sidebar-open .sidebar-overlay {
                display: block !important;
                opacity: 1 !important;
                visibility: visible !important;
            }
        }

        .page-header {
            margin-bottom: 32px;
        }

        .page-header-eyebrow {
            font-size: 11px;
            font-weight: 700;
            color: var(--primary);
            text-transform: uppercase;
            letter-spacing: 1.2px;
            margin-bottom: 8px;
            display: flex;
            align-items: center;
            gap: 6px;
        }



        .page-header h1 {
            font-size: 28px;
            font-weight: 800;
            font-family: 'Plus Jakarta Sans', sans-serif;
            letter-spacing: -0.03em;
            color: var(--text-primary);
            margin-bottom: 6px;
        }

        .page-header p {
            font-size: 14px;
            color: var(--text-muted);
        }

        /* Empty state */
        .empty-state {
            padding: 80px 24px;
            text-align: center;
        }

        .empty-state-icon {
            width: 80px;
            height: 80px;
            border-radius: var(--radius-xl);
            background: var(--primary-50);
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 36px;
            margin: 0 auto 20px;
            border: 1px solid var(--primary-100);
        }

        .empty-state h2 {
            font-size: 20px;
            font-weight: 700;
            margin-bottom: 8px;
            color: var(--text-primary);
            letter-spacing: -0.02em;
        }

        .empty-state p {
            color: var(--text-secondary);
            font-size: 14px;
            margin-bottom: 28px;
            max-width: 340px;
            margin-left: auto;
            margin-right: auto;
            line-height: 1.65;
        }

        /* Score values */
        .score-val {
            font-weight: 700;
            font-size: 14px;
        }

        .score-val.apt {
            color: var(--primary-dark);
        }

        .score-val.per {
            color: var(--info);
        }

        .score-val.int {
            color: #16A34A;
        }

        /* View link */
        .view-link {
            display: inline-flex;
            align-items: center;
            gap: 5px;
            color: var(--primary);
            font-weight: 600;
            font-size: 13px;
            background: var(--primary-50);
            padding: 6px 14px;
            border-radius: var(--radius-sm);
            border: 1px solid var(--primary-100);
            transition: var(--transition);
        }

        .view-link:hover {
            background: var(--primary-100);
            border-color: var(--primary-200);
            transform: translateX(2px);
        }

        /* Trend notice */
        .trend-card {
            margin-top: 20px;
            padding: 16px 20px;
            border-radius: var(--radius-lg);
            background: var(--surface);
            border: 1px solid var(--border);
            color: var(--text-secondary);
            font-size: 13px;
            box-shadow: var(--shadow-xs);
            display: flex;
            align-items: center;
            gap: 12px;
        }

        .trend-icon {
            width: 36px;
            height: 36px;
            border-radius: var(--radius-sm);
            background: var(--primary-50);
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 16px;
            flex-shrink: 0;
            border: 1px solid var(--primary-100);
        }

        .trend-card strong {
            color: var(--text-primary);
            font-weight: 700;
        }

        .table-responsive {
            overflow-x: auto;
            -webkit-overflow-scrolling: touch;
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
        <a href="${pageContext.request.contextPath}/assessment/start" class="nav-item">
            <span style="font-size:18px">📝</span> Assessment
        </a>
        <a href="#" class="nav-item active">
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
        <a href="${pageContext.request.contextPath}/assessment/start" class="btn btn-primary" id="btnTakeNewTest"
           style="padding: 8px 16px;">
            + New Assessment
        </a>
        <button class="icon-btn">🔔</button>
        <div class="avatar">S</div>
    </header>

    <div class="content animate-fade-in delay-1">

        <div class="page-header">
            <div class="page-header-eyebrow">Profile</div>
            <h1>Assessment History</h1>
            <p>All past attempts for <strong>${studentName}</strong>, newest first.</p>
        </div>

        <c:if test="${empty attempts}">
            <div class="glass-panel empty-state">
                <div class="empty-state-icon">📊</div>
                <h2>No assessments yet</h2>
                <p>Take your first assessment to unlock your career profile, personality insights, and skill
                    analysis.</p>
                <a href="${pageContext.request.contextPath}/assessment/start" class="btn-accent"
                   id="btnFirstAssessment">
                    Start Assessment →
                </a>
            </div>
        </c:if>

        <c:if test="${not empty attempts}">
            <div class="glass-panel animate-fade-in delay-2">
                <div class="table-responsive">
                    <table class="modern-table">
                        <thead>
                        <tr>
                            <th>#</th>
                            <th>Date</th>
                            <th>Personality Cluster</th>
                            <th>Aptitude</th>
                            <th>Personality</th>
                            <th>Interest</th>
                            <th>Report</th>
                        </tr>
                        </thead>
                        <tbody>
                        <c:forEach var="attempt" items="${attempts}" varStatus="status">
                            <tr>
                                <td>
                                    <span style="font-size: 12px; font-weight: 700; color: var(--text-muted); background: var(--bg-alt); padding: 3px 9px; border-radius: var(--radius-xs); border: 1px solid var(--border);">${status.count}</span>
                                </td>
                                <td style="color: var(--text-secondary); font-size: 13px;">${attempt.attemptDate}</td>
                                <td>
                                    <span class="badge ${fn:toLowerCase(attempt.personalityCluster)}">${attempt.personalityCluster}</span>
                                </td>
                                <td>
                                    <span class="score-val apt">${attempt.aptitudeScore}</span>
                                    <span style="color:var(--text-muted); font-size:12px;"> / 10</span>
                                </td>
                                <td>
                                    <span class="score-val per">${attempt.personalityScore}</span>
                                    <span style="color:var(--text-muted); font-size:12px;"> / 50</span>
                                </td>
                                <td>
                                    <span class="score-val int">${attempt.interestScore}</span>
                                    <span style="color:var(--text-muted); font-size:12px;"> / 50</span>
                                </td>
                                <td>
                                    <a href="${pageContext.request.contextPath}/assessment/result?attemptId=${attempt.attemptId}"
                                       class="view-link">
                                        View →
                                    </a>
                                </td>
                            </tr>
                        </c:forEach>
                        </tbody>
                    </table>
                </div>
            </div>

            <div class="trend-card animate-fade-in delay-3">
                <div class="trend-icon">📈</div>
                <div>
                    You have taken the assessment <strong>${fn:length(attempts)} time(s)</strong>.
                    Compare your results over time to track your skill development and growth.
                </div>
            </div>
        </c:if>

    </div>
</div>

</div>

<script>
    document.addEventListener('DOMContentLoaded', function () {
        const mobileMenuBtn = document.getElementById('mobileMenuBtn');
        const overlay = document.getElementById('sidebarOverlay');

        if (mobileMenuBtn) {
            function toggleMenu() {
                document.body.classList.toggle('sidebar-open');
            }
            mobileMenuBtn.addEventListener('click', toggleMenu);
            if (overlay) overlay.addEventListener('click', toggleMenu);
        }
    });
</script>
</body>
</html>
