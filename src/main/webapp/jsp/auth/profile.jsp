<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Profile - DISHA Career Portal</title>
    <meta name="description" content="View and manage your DISHA career portal profile and personal details.">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/main.css?v=5">
    <style>
        body {
            background: var(--bg);
            background-image: radial-gradient(ellipse 70% 50% at 85% 5%, rgba(37, 99, 235, 0.06) 0%, transparent 55%);
            min-height: 100vh;
        }

        /* ---- PAGE HEADER ---- */
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

        /* ---- PROFILE CARD ---- */
        .profile-card {
            background: var(--surface);
            border: 1px solid var(--border);
            border-radius: var(--radius-2xl);
            overflow: hidden;
            box-shadow: var(--shadow-lg);
            margin-bottom: 24px;
        }

        .profile-banner {
            height: 120px;
            background: var(--primary-gradient);
            position: relative;
        }

        .profile-avatar-wrap {
            position: absolute;
            bottom: -44px;
            left: 32px;
        }

        .profile-avatar {
            width: 88px;
            height: 88px;
            border-radius: 50%;
            background: var(--primary);
            color: #fff;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 36px;
            font-weight: 800;
            font-family: 'Plus Jakarta Sans', sans-serif;
            border: 4px solid var(--surface);
            box-shadow: var(--shadow-md);
        }

        .profile-body {
            padding: 56px 32px 32px;
        }

        .profile-name {
            font-size: 24px;
            font-weight: 800;
            font-family: 'Plus Jakarta Sans', sans-serif;
            letter-spacing: -0.03em;
            color: var(--text-primary);
            margin-bottom: 4px;
        }

        .profile-role-badge {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            background: var(--primary-50);
            border: 1px solid var(--primary-100);
            color: var(--primary);
            padding: 4px 12px;
            border-radius: var(--radius-full);
            font-size: 12px;
            font-weight: 700;
            letter-spacing: 0.04em;
            text-transform: uppercase;
            margin-bottom: 24px;
        }

        /* ---- INFO GRID ---- */
        .info-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(260px, 1fr));
            gap: 16px;
        }

        .info-item {
            background: var(--bg-alt);
            border: 1px solid var(--border);
            border-radius: var(--radius-lg);
            padding: 18px 20px;
            transition: var(--transition);
        }

        .info-item:hover {
            border-color: var(--primary-200);
            box-shadow: var(--shadow-sm);
        }

        .info-label {
            font-size: 11px;
            font-weight: 700;
            color: var(--text-muted);
            text-transform: uppercase;
            letter-spacing: 0.08em;
            margin-bottom: 6px;
            display: flex;
            align-items: center;
            gap: 6px;
        }

        .info-value {
            font-size: 15px;
            font-weight: 600;
            color: var(--text-primary);
        }

        /* ---- STATUS CARD ---- */
        .status-panel {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(160px, 1fr));
            gap: 16px;
            margin-bottom: 24px;
        }

        .stat-tile {
            background: var(--surface);
            border: 1px solid var(--border);
            border-radius: var(--radius-lg);
            padding: 20px;
            text-align: center;
            box-shadow: var(--shadow-xs);
            transition: var(--transition);
        }

        .stat-tile:hover {
            transform: translateY(-3px);
            box-shadow: var(--shadow-lg);
            border-color: var(--primary-200);
        }

        .stat-tile-icon {
            font-size: 28px;
            margin-bottom: 8px;
        }

        .stat-tile-value {
            font-size: 22px;
            font-weight: 800;
            font-family: 'Plus Jakarta Sans', sans-serif;
            color: var(--text-primary);
            letter-spacing: -0.03em;
        }

        .stat-tile-label {
            font-size: 12px;
            color: var(--text-muted);
            font-weight: 500;
            margin-top: 2px;
        }

        /* ---- COUNSELOR NOTE ---- */
        .note-card {
            background: var(--warning-bg);
            border: 1px solid var(--warning);
            border-radius: var(--radius-lg);
            padding: 18px 20px;
            display: flex;
            align-items: flex-start;
            gap: 12px;
        }

        .note-icon {
            font-size: 20px;
            flex-shrink: 0;
        }

        .note-label {
            font-size: 12px;
            font-weight: 700;
            color: var(--text-muted);
            text-transform: uppercase;
            letter-spacing: 0.08em;
            margin-bottom: 4px;
        }

        .note-text {
            font-size: 14px;
            color: var(--text-secondary);
            line-height: 1.6;
        }

        /* ---- ACTIONS ---- */
        .profile-actions {
            display: flex;
            gap: 12px;
            flex-wrap: wrap;
            margin-top: 28px;
        }

        /* ---- FLAGGED BANNER ---- */
        .flagged-banner {
            background: var(--danger-bg);
            border: 1px solid var(--danger-border);
            border-radius: var(--radius-lg);
            padding: 14px 20px;
            display: flex;
            align-items: center;
            gap: 10px;
            margin-bottom: 20px;
            font-size: 13px;
            color: #B91C1C;
            font-weight: 600;
        }
        /* Responsive Overrides */
        @media (max-width: 768px) {
            body {
                flex-direction: column;
            }
            .sidebar {
                display: none;
            }
            .main-wrapper {
                margin-left: 0;
            }
            .profile-grid {
                grid-template-columns: 1fr;
            }
            .profile-header {
                flex-direction: column;
                align-items: center;
                text-align: center;
            }
            .info-grid {
                grid-template-columns: 1fr;
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
        <a href="${pageContext.request.contextPath}/assessment/history" class="nav-item">
            <span style="font-size:18px">🕒</span> History
        </a>
        <a href="${pageContext.request.contextPath}/profile" class="nav-item active">
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
        <a href="${pageContext.request.contextPath}/assessment/start" class="btn btn-primary"
           style="padding: 8px 16px;" id="btnTakeAssessment">
            📝 Take Assessment
        </a>
        <button class="icon-btn">🔔</button>
        <div class="avatar">${fn:substring(profileUser.fullName, 0, 1)}</div>
    </header>

    <div class="content animate-fade-in delay-1">

        <!-- Page Header -->
        <div class="page-header">
            <div class="page-header-eyebrow">Profile</div>
            <h1>My Profile</h1>
            <p>Your personal information and account details.</p>
        </div>

        <!-- Flagged Banner -->
        <c:if test="${profileUser.flagged}">
            <div class="flagged-banner" id="flaggedBanner">
                ⚠️ Your counselor has flagged your profile for review. Please check with your counselor.
            </div>
        </c:if>

        <!-- Stat tiles -->
        <div class="status-panel animate-fade-in delay-2">
            <div class="stat-tile">
                <div class="stat-tile-icon">🆔</div>
                <div class="stat-tile-value">#${profileUser.userId}</div>
                <div class="stat-tile-label">Student ID</div>
            </div>
            <div class="stat-tile">
                <div class="stat-tile-icon">🎓</div>
                <div class="stat-tile-value">${profileUser.role}</div>
                <div class="stat-tile-label">Account Role</div>
            </div>
            <div class="stat-tile">
                <div class="stat-tile-icon">
                    <c:choose>
                        <c:when test="${profileUser.flagged}">🚩</c:when>
                        <c:otherwise>✅</c:otherwise>
                    </c:choose>
                </div>
                <div class="stat-tile-value">
                    <c:choose>
                        <c:when test="${profileUser.flagged}">Flagged</c:when>
                        <c:otherwise>Active</c:otherwise>
                    </c:choose>
                </div>
                <div class="stat-tile-label">Account Status</div>
            </div>
        </div>

        <!-- Profile Card -->
        <div class="profile-card animate-fade-in delay-2">
            <div class="profile-banner">
                <div class="profile-avatar-wrap">
                    <div class="profile-avatar" id="profileAvatar">
                        ${fn:substring(profileUser.fullName, 0, 1)}
                    </div>
                </div>
            </div>
            <div class="profile-body">
                <div class="profile-name" id="profileName">${profileUser.fullName}</div>
                <div class="profile-role-badge">
                    <span>🎓</span> ${profileUser.role}
                </div>

                <div class="info-grid">
                    <div class="info-item">
                        <div class="info-label">📛 Full Name</div>
                        <div class="info-value" id="infoFullName">${profileUser.fullName}</div>
                    </div>
                    <div class="info-item">
                        <div class="info-label">📧 Email Address</div>
                        <div class="info-value" id="infoEmail">${profileUser.email}</div>
                    </div>
                    <div class="info-item">
                        <div class="info-label">🆔 User ID</div>
                        <div class="info-value">#${profileUser.userId}</div>
                    </div>
                    <div class="info-item">
                        <div class="info-label">🔑 Role</div>
                        <div class="info-value">${profileUser.role}</div>
                    </div>
                </div>

                <!-- Counselor Note -->
                <c:if test="${not empty profileUser.counselorNote}">
                    <div class="note-card" style="margin-top: 20px;">
                        <div class="note-icon">📋</div>
                        <div>
                            <div class="note-label">Counselor Note</div>
                            <div class="note-text">${profileUser.counselorNote}</div>
                        </div>
                    </div>
                </c:if>

                <div class="profile-actions">
                    <a href="${pageContext.request.contextPath}/assessment/history" class="btn btn-outline"
                       id="btnViewHistory">
                        🕒 View Assessment History
                    </a>
                    <a href="${pageContext.request.contextPath}/assessment/start" class="btn btn-primary"
                       id="btnStartAssessment">
                        📝 Start New Assessment
                    </a>
                    <a href="${pageContext.request.contextPath}/logout" class="btn btn-outline"
                       style="color: #B91C1C; border-color: var(--danger-border);" id="btnLogout">
                        🚪 Sign Out
                    </a>
                </div>
            </div>
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
