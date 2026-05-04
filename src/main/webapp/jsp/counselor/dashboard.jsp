<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Counselor Dashboard - DISHA</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/main.css?v=5">
    <style>
        body {
            background: var(--bg);
            background-image: radial-gradient(ellipse 70% 50% at 90% 0%, rgba(37,99,235,0.05) 0%, transparent 55%);
        }

        .layout { display: flex; min-height: 100vh; }

        /* ── Sidebar ── */
        .sidebar {
            width: 240px;
            background: var(--surface);
            border-right: 1px solid var(--border);
            padding: 0;
            display: flex;
            flex-direction: column;
            flex-shrink: 0;
            position: sticky;
            top: 0;
            height: 100vh;
            overflow-y: auto;
            box-shadow: 1px 0 0 var(--border);
        }

        .sidebar-header {
            padding: 24px 20px;
            border-bottom: 1px solid var(--border);
        }

        .sidebar-brand {
            display: flex;
            align-items: center;
            gap: 10px;
            text-decoration: none;
            margin-bottom: 20px;
        }

        .sidebar-brand img {
            width: 34px;
            height: 34px;
            object-fit: contain;
        }

        .sidebar-brand-name {
            font-size: 16px;
            font-weight: 800;
            font-family: 'Plus Jakarta Sans', sans-serif;
            letter-spacing: 2px;
            background: var(--primary-gradient);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
            background-clip: text;
        }

        .role-badge {
            display: inline-flex;
            align-items: center;
            gap: 5px;
            padding: 5px 10px;
            background: var(--primary-50);
            border: 1px solid var(--primary-100);
            border-radius: var(--radius-full);
            font-size: 11px;
            font-weight: 700;
            color: var(--primary-dark);
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }

        .sidebar-nav {
            padding: 12px 12px;
            flex: 1;
        }

        .nav-section-label {
            font-size: 10px;
            font-weight: 700;
            color: var(--text-muted);
            text-transform: uppercase;
            letter-spacing: 1px;
            padding: 6px 8px 8px;
        }

        .sidebar-link {
            display: flex;
            align-items: center;
            gap: 10px;
            padding: 10px 12px;
            border-radius: var(--radius-md);
            font-size: 14px;
            color: var(--text-secondary);
            font-weight: 500;
            transition: var(--transition);
            text-decoration: none;
            margin-bottom: 2px;
        }

        .sidebar-link:hover {
            background: var(--bg-alt);
            color: var(--text-primary);
        }

        .sidebar-link.active {
            background: var(--primary-50);
            color: var(--primary-dark);
            font-weight: 600;
            border: 1px solid var(--primary-100);
        }

        .sidebar-link-icon {
            font-size: 16px;
            flex-shrink: 0;
        }

        /* ── Main ── */
        .main { flex: 1; padding: 40px 44px; overflow-x: hidden; }

        /* ── Page Top ── */
        .page-top {
            margin-bottom: 32px;
            display: flex;
            align-items: flex-start;
            justify-content: space-between;
            gap: 16px;
            flex-wrap: wrap;
        }

        .page-top-left {}

        .page-eyebrow {
            font-size: 11px;
            font-weight: 700;
            color: var(--primary);
            text-transform: uppercase;
            letter-spacing: 1.2px;
            margin-bottom: 6px;
            display: flex;
            align-items: center;
            gap: 6px;
        }

        .page-eyebrow::before {
            content: '';
            width: 14px;
            height: 2px;
            background: var(--primary);
            border-radius: 2px;
        }

        .page-top h1 {
            font-size: 26px;
            font-weight: 800;
            font-family: 'Plus Jakarta Sans', sans-serif;
            letter-spacing: -0.03em;
            margin-bottom: 4px;
        }

        .page-top p { color: var(--text-muted); font-size: 14px; }

        /* ── Stats Row ── */
        .stats-row {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 16px;
            margin-bottom: 32px;
        }

        .stat-card {
            background: var(--surface);
            border: 1px solid var(--border);
            border-radius: var(--radius-lg);
            padding: 22px 22px 20px;
            display: flex;
            flex-direction: column;
            box-shadow: var(--shadow-sm);
            transition: var(--transition);
            position: relative;
            overflow: hidden;
        }

        .stat-card::before {
            content: '';
            position: absolute;
            top: 0; left: 0; right: 0;
            height: 3px;
        }

        .stat-card.apt::before  { background: var(--primary-gradient); }
        .stat-card.clus::before { background: linear-gradient(135deg, #0EA5E9, #06B6D4); }
        .stat-card.tot::before  { background: linear-gradient(135deg, #22C55E, #16A34A); }

        .stat-card:hover { transform: translateY(-2px); box-shadow: var(--shadow-lg); }

        .stat-card-label {
            font-size: 11px;
            font-weight: 700;
            color: var(--text-muted);
            text-transform: uppercase;
            letter-spacing: 0.8px;
            margin-bottom: 10px;
        }

        .stat-card-value {
            font-size: 32px;
            font-weight: 800;
            font-family: 'Plus Jakarta Sans', sans-serif;
            letter-spacing: -0.04em;
            color: var(--text-primary);
            line-height: 1;
        }

        .stat-card.apt  .stat-card-value { color: var(--primary-dark); }
        .stat-card.clus .stat-card-value { color: var(--info); font-size: 22px; }
        .stat-card.tot  .stat-card-value { color: #16A34A; }

        .stat-card-sub {
            font-size: 12px;
            color: var(--text-muted);
            margin-top: 6px;
        }

        /* ── Filter + Table Area ── */
        .table-area-header {
            display: flex;
            align-items: center;
            justify-content: space-between;
            margin-bottom: 16px;
            gap: 12px;
            flex-wrap: wrap;
        }

        .filter-bar {
            display: flex;
            align-items: center;
            gap: 6px;
        }

        .filter-label {
            font-size: 12px;
            font-weight: 600;
            color: var(--text-muted);
            margin-right: 2px;
        }

        .filter-btn {
            padding: 7px 16px;
            border-radius: var(--radius-full);
            font-size: 13px;
            font-weight: 600;
            background: var(--surface);
            border: 1px solid var(--border);
            color: var(--text-secondary);
            transition: var(--transition);
            cursor: pointer;
            text-decoration: none;
        }

        .filter-btn:hover {
            background: var(--bg-alt);
            border-color: var(--border-strong);
            color: var(--text-primary);
        }

        .filter-btn.active {
            background: var(--primary-50);
            color: var(--primary-dark);
            border-color: var(--primary-200);
            font-weight: 700;
        }

        /* Table cell extras */
        .student-cell {}
        .student-name  { font-weight: 600; color: var(--text-primary); font-size: 14px; letter-spacing: -0.01em; }
        .student-email { font-size: 12px; color: var(--text-muted); margin-top: 3px; }

        .flag-badge {
            display: inline-flex;
            align-items: center;
            gap: 4px;
            padding: 4px 10px;
            border-radius: var(--radius-full);
            font-size: 11px;
            font-weight: 700;
            background: var(--danger-bg);
            color: #B91C1C;
            border: 1px solid var(--danger-border);
        }

        .normal-badge {
            display: inline-flex;
            align-items: center;
            gap: 4px;
            font-size: 12px;
            color: var(--text-muted);
            font-weight: 500;
        }

        .score-num { font-weight: 700; font-size: 14px; }
        .apt { color: var(--primary-dark); }
        .per { color: var(--info); }
        .int { color: #16A34A; }
        .no-data { color: var(--text-muted); font-size: 14px; }

        .view-btn {
            display: inline-flex;
            align-items: center;
            gap: 5px;
            padding: 7px 14px;
            background: var(--bg-alt);
            border: 1px solid var(--border);
            border-radius: var(--radius-sm);
            color: var(--text-secondary);
            font-size: 13px;
            font-weight: 600;
            transition: var(--transition);
            text-decoration: none;
        }

        .view-btn:hover {
            background: var(--primary-50);
            color: var(--primary-dark);
            border-color: var(--primary-200);
        }

        .mobile-header {
            display: none;
            align-items: center;
            justify-content: space-between;
            padding: 12px 20px;
            background: var(--surface);
            border-bottom: 1px solid var(--border);
            position: sticky;
            top: 0;
            z-index: 50;
        }

        .mobile-header-brand {
            font-size: 16px;
            font-weight: 800;
            font-family: 'Plus Jakarta Sans', sans-serif;
            background: var(--primary-gradient);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
        }

        /* Responsive */
        @media (max-width: 900px) {
            .layout { flex-direction: column; }
            .sidebar {
                position: fixed;
                left: 0; top: 0;
                width: 280px;
                height: 100vh;
                transform: translateX(-100%);
                z-index: 60;
                transition: transform 0.3s ease;
                border-right: 1px solid var(--border);
            }
            .sidebar.open {
                transform: translateX(0);
            }
            .mobile-header { display: flex; }
            .main { padding: 24px 20px; }
            .stats-row { grid-template-columns: 1fr; }
        }
    </style>
</head>
<body>
<div class="sidebar-overlay" id="sidebarOverlay"></div>

<div class="mobile-header">
    <div class="mobile-header-brand">DISHA Counselor</div>
    <button class="mobile-menu-btn" id="mobileMenuBtn" style="display:block; padding: 4px; margin: 0; border-radius: 4px; border: 1px solid var(--border); background: var(--surface);">☰</button>
</div>

<div class="layout">

    <!-- Sidebar -->
    <nav class="sidebar animate-fade-in">
        <div class="sidebar-header">
            <a href="#" class="sidebar-brand">
                <img src="${pageContext.request.contextPath}/images/logo.svg" alt="DISHA">
                <span class="sidebar-brand-name">DISHA</span>
            </a>
            <div class="role-badge">⚙️ Counselor</div>
        </div>

        <div class="sidebar-nav">
            <div class="nav-section-label">Navigation</div>
            <a href="${pageContext.request.contextPath}/counselor/dashboard"
               class="sidebar-link ${activeFilter != 'flagged' ? 'active' : ''}">
                <span class="sidebar-link-icon">📊</span>
                Dashboard
            </a>
            <a href="${pageContext.request.contextPath}/counselor/dashboard?filter=flagged"
               class="sidebar-link ${activeFilter == 'flagged' ? 'active' : ''}">
                <span class="sidebar-link-icon">🚩</span>
                Flagged Students
            </a>
        </div>
    </nav>

    <!-- Main -->
    <main class="main animate-fade-in delay-1">

        <div class="page-top">
            <div class="page-top-left">
                <div class="page-eyebrow">Counselor Panel</div>
                <h1>Student Dashboard</h1>
                <p>Overview of all students and their latest assessment results.</p>
            </div>
        </div>

        <!-- Stats -->
        <div class="stats-row animate-fade-in delay-2">
            <div class="stat-card apt">
                <div class="stat-card-label">Avg Aptitude</div>
                <div class="stat-card-value">
                    ${avgAptitude}
                    <span style="font-size: 15px; color: var(--text-muted); font-weight: 500;">/10</span>
                </div>
                <div class="stat-card-sub">Across all students</div>
            </div>
            <div class="stat-card clus">
                <div class="stat-card-label">Top Cluster</div>
                <div class="stat-card-value">${topCluster}</div>
                <div class="stat-card-sub">Most common personality type</div>
            </div>
            <div class="stat-card tot">
                <div class="stat-card-label">Total Attempts</div>
                <div class="stat-card-value">${totalAttempts}</div>
                <div class="stat-card-sub">All assessments completed</div>
            </div>
        </div>

        <!-- Table header + filters -->
        <div class="table-area-header">
            <div class="filter-bar">
                <span class="filter-label">Filter:</span>
                <a href="${pageContext.request.contextPath}/counselor/dashboard"
                   class="filter-btn ${activeFilter == 'all' ? 'active' : ''}">All Students</a>
                <a href="${pageContext.request.contextPath}/counselor/dashboard?filter=flagged"
                   class="filter-btn ${activeFilter == 'flagged' ? 'active' : ''}">🚩 Flagged Only</a>
            </div>
        </div>

        <!-- Table -->
        <div class="glass-panel table-responsive animate-fade-in delay-2">
            <table class="modern-table" style="margin: 0;">
                <thead>
                    <tr>
                        <th>Student</th>
                        <th>Status</th>
                        <th>Cluster</th>
                        <th>Aptitude</th>
                        <th>Personality</th>
                        <th>Interest</th>
                        <th>Action</th>
                    </tr>
                </thead>
                <tbody>
                    <c:if test="${empty students}">
                        <tr>
                            <td colspan="7" style="text-align: center; padding: 60px; color: var(--text-muted);">
                                <div style="font-size: 36px; margin-bottom: 12px;">📭</div>
                                <div style="font-weight: 600; margin-bottom: 4px;">No students found</div>
                                <div style="font-size: 13px;">Try adjusting your filter settings</div>
                            </td>
                        </tr>
                    </c:if>
                    <c:forEach var="student" items="${students}">
                        <tr>
                            <td>
                                <div class="student-name">${student.fullName}</div>
                                <div class="student-email">${student.email}</div>
                            </td>
                            <td>
                                <c:if test="${student.flagged}">
                                    <span class="flag-badge">🚩 At-Risk</span>
                                </c:if>
                                <c:if test="${!student.flagged}">
                                    <span class="normal-badge">● Normal</span>
                                </c:if>
                            </td>

                            <c:set var="attempt" value="${latestAttempts[student.userId]}" />

                            <td>
                                <c:if test="${not empty attempt}">
                                    <span class="badge ${fn:toLowerCase(attempt.personalityCluster)}">${attempt.personalityCluster}</span>
                                </c:if>
                                <c:if test="${empty attempt}">
                                    <span class="badge" style="background:var(--bg-alt); color:var(--text-muted);">No test</span>
                                </c:if>
                            </td>
                            <td>
                                <c:if test="${not empty attempt}"><span class="score-num apt">${attempt.aptitudeScore}</span><span style="color:var(--text-muted);font-size:12px;">/10</span></c:if>
                                <c:if test="${empty attempt}"><span class="no-data">-</span></c:if>
                            </td>
                            <td>
                                <c:if test="${not empty attempt}"><span class="score-num per">${attempt.personalityScore}</span><span style="color:var(--text-muted);font-size:12px;">/50</span></c:if>
                                <c:if test="${empty attempt}"><span class="no-data">-</span></c:if>
                            </td>
                            <td>
                                <c:if test="${not empty attempt}"><span class="score-num int">${attempt.interestScore}</span><span style="color:var(--text-muted);font-size:12px;">/50</span></c:if>
                                <c:if test="${empty attempt}"><span class="no-data">-</span></c:if>
                            </td>
                            <td>
                                <a href="${pageContext.request.contextPath}/counselor/student?studentId=${student.userId}" class="view-btn">
                                    View →
                                </a>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </div>

    </main>
</div>

<script>
    document.addEventListener('DOMContentLoaded', function() {
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
