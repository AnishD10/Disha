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
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/main.css?v=7">
    <style>
        body {
            background: var(--bg);
            background-image: radial-gradient(ellipse 70% 50% at 85% 5%, rgba(37, 99, 235, 0.06) 0%, transparent 55%);
            min-height: 100vh;
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

        .content {
            padding: 32px 40px;
            max-width: 1200px;
            width: 100%;
            margin: 0 auto;
            flex: 1;
            box-sizing: border-box;
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

            .content {
                padding: 24px 20px !important;
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

        /* ---- DYNAMIC LAYOUT UPGRADES ---- */
        .card {
            background: var(--surface);
            border: 1px solid var(--border);
            border-radius: var(--radius-2xl);
            box-shadow: var(--shadow-sm);
            transition: var(--transition);
        }

        .profile-summary-section {
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 32px;
            flex-wrap: wrap;
        }

        .profile-summary-left {
            display: flex;
            align-items: center;
            gap: 24px;
        }

        .summary-avatar-circle {
            width: 80px;
            height: 80px;
            border-radius: 50%;
            background: linear-gradient(135deg, var(--primary) 0%, var(--primary-dark) 100%);
            color: #fff;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 32px;
            font-weight: 800;
            font-family: 'Plus Jakarta Sans', sans-serif;
            box-shadow: 0 4px 20px rgba(37, 99, 235, 0.2);
            transition: var(--transition);
        }

        .summary-avatar-circle:hover {
            transform: scale(1.05);
        }

        .summary-name-row {
            display: flex;
            align-items: center;
            gap: 12px;
            flex-wrap: wrap;
        }

        .summary-name {
            font-size: 24px;
            font-weight: 800;
            letter-spacing: -0.02em;
            color: var(--text-primary);
            margin: 0;
            font-family: 'Plus Jakarta Sans', sans-serif;
        }

        .summary-badge {
            background: var(--primary-50);
            border: 1px solid var(--primary-100);
            color: var(--primary);
            padding: 3px 10px;
            border-radius: var(--radius-full);
            font-size: 10px;
            font-weight: 700;
            letter-spacing: 0.05em;
            text-transform: uppercase;
        }

        .summary-email {
            font-size: 14px;
            color: var(--text-muted);
            margin-top: 4px;
        }

        .profile-details-grid {
            display: grid;
            grid-template-columns: repeat(2, 180px);
            gap: 20px 40px;
        }

        .details-field {
            display: flex;
            flex-direction: column;
            gap: 4px;
        }

        .details-label {
            font-size: 11px;
            font-weight: 700;
            color: var(--text-muted);
            text-transform: uppercase;
            letter-spacing: 0.08em;
        }

        .details-value {
            font-size: 14px;
            font-weight: 600;
            color: var(--text-primary);
        }

        .profile-details-card {
            padding: 32px;
        }

        /* Two column layout */
        .profile-lower-grid {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 24px;
            margin-bottom: 24px;
        }

        .column-card {
            background: var(--surface);
            border: 1px solid var(--border);
            border-radius: var(--radius-2xl);
            padding: 28px;
            box-shadow: var(--shadow-sm);
            display: flex;
            flex-direction: column;
            gap: 20px;
        }

        .column-card-title {
            font-size: 18px;
            font-weight: 800;
            color: var(--text-primary);
            margin: 0;
            font-family: 'Plus Jakarta Sans', sans-serif;
            letter-spacing: -0.01em;
        }

        .overview-list {
            display: flex;
            flex-direction: column;
            gap: 12px;
        }

        .overview-item {
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding: 16px;
            background: var(--bg-alt);
            border: 1px solid var(--border);
            border-radius: var(--radius-xl);
            transition: var(--transition);
        }

        .overview-item:hover {
            transform: translateY(-2px);
            border-color: var(--primary-light);
            box-shadow: var(--shadow-md);
        }

        .action-item {
            text-decoration: none;
            color: inherit;
        }

        .overview-icon {
            width: 40px;
            height: 40px;
            border-radius: 10px;
            background: rgba(37, 99, 235, 0.08);
            color: var(--primary);
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 18px;
            transition: var(--transition);
        }

        .action-icon.blue { background: rgba(37, 99, 235, 0.08); color: #2563EB; }
        .action-icon.green { background: rgba(16, 185, 129, 0.08); color: #10B981; }
        .action-icon.purple { background: rgba(139, 92, 246, 0.08); color: #8B5CF6; }
        .action-icon.amber { background: rgba(245, 158, 11, 0.08); color: #F59E0B; }

        .overview-item:hover .overview-icon {
            transform: scale(1.08);
        }

        .overview-label {
            font-size: 13px;
            font-weight: 700;
            color: var(--text-secondary);
        }

        .overview-desc {
            font-size: 14px;
            font-weight: 800;
            color: var(--text-primary);
            margin-top: 2px;
            font-family: 'Plus Jakarta Sans', sans-serif;
        }

        .overview-chevron {
            font-size: 12px;
            color: var(--text-muted);
            transition: transform 0.3s ease;
        }

        .overview-item:hover .overview-chevron {
            transform: translateX(4px);
            color: var(--primary);
        }

        /* ---- STATUS CARD ---- */
        .status-panel {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(220px, 1fr));
            gap: 20px;
            margin-bottom: 28px;
        }

        .stat-tile {
            background: var(--surface);
            border: 1px solid var(--border);
            border-radius: var(--radius-xl);
            padding: 24px 20px;
            text-align: center;
            box-shadow: var(--shadow-sm);
            transition: var(--transition);
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            position: relative;
            overflow: hidden;
        }

        .stat-tile::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 4px;
            background: transparent;
            transition: var(--transition);
        }

        .stat-tile:nth-child(1)::before {
            background: linear-gradient(90deg, #3B82F6, #2563EB);
        }

        .stat-tile:nth-child(2)::before {
            background: linear-gradient(90deg, #F59E0B, #D97706);
        }

        .stat-tile:nth-child(3)::before {
            background: linear-gradient(90deg, #10B981, #059669);
        }

        .stat-tile:hover {
            transform: translateY(-4px);
            box-shadow: var(--shadow-xl), 0 0 0 1px rgba(37, 99, 235, 0.08);
            border-color: transparent;
        }

        .stat-tile-icon {
            font-size: 24px;
            width: 48px;
            height: 48px;
            border-radius: 12px;
            background: var(--bg-alt);
            display: flex;
            align-items: center;
            justify-content: center;
            margin-bottom: 12px;
            transition: var(--transition);
        }

        .stat-tile:hover .stat-tile-icon {
            transform: scale(1.1);
        }

        .stat-tile:nth-child(1) .stat-tile-icon { background: rgba(37, 99, 235, 0.08); color: #2563EB; }
        .stat-tile:nth-child(2) .stat-tile-icon { background: rgba(245, 158, 11, 0.08); color: #F59E0B; }
        .stat-tile:nth-child(3) .stat-tile-icon { background: rgba(16, 185, 129, 0.08); color: #10B981; }

        .stat-tile-value {
            font-size: 20px;
            font-weight: 800;
            font-family: 'Plus Jakarta Sans', sans-serif;
            color: var(--text-primary);
            letter-spacing: -0.03em;
        }

        .stat-tile-label {
            font-size: 12px;
            color: var(--text-muted);
            font-weight: 500;
            margin-top: 4px;
        }

        /* ---- COUNSELOR NOTE ---- */
        .note-card {
            background: linear-gradient(135deg, #FEF3C7 0%, #FFFBEB 100%);
            border: 1px solid #F59E0B;
            border-radius: var(--radius-2xl);
            padding: 24px;
            display: flex;
            align-items: flex-start;
            gap: 16px;
            box-shadow: var(--shadow-sm);
            position: relative;
            overflow: hidden;
            margin-bottom: 24px;
        }

        .note-card::before {
            content: '“';
            position: absolute;
            right: 24px;
            bottom: -10px;
            font-size: 80px;
            font-family: serif;
            color: rgba(245, 158, 11, 0.12);
            line-height: 1;
        }

        .note-icon {
            font-size: 22px;
            flex-shrink: 0;
            background: rgba(245, 158, 11, 0.15);
            width: 40px;
            height: 40px;
            border-radius: 10px;
            display: flex;
            align-items: center;
            justify-content: center;
            color: #D97706;
        }

        .note-label {
            font-size: 11px;
            font-weight: 700;
            color: #D97706;
            text-transform: uppercase;
            letter-spacing: 0.08em;
            margin-bottom: 4px;
        }

        .note-text {
            font-size: 14px;
            color: var(--text-secondary);
            line-height: 1.6;
            position: relative;
            z-index: 1;
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

        /* Modal custom design */
        .modal-overlay {
            position: fixed;
            inset: 0;
            background: rgba(15, 23, 42, 0.4);
            backdrop-filter: blur(8px);
            -webkit-backdrop-filter: blur(8px);
            z-index: 1000;
            display: none;
            align-items: center;
            justify-content: center;
            padding: 20px;
            opacity: 0;
            transition: opacity 0.3s ease;
        }

        .modal-overlay.active {
            display: flex;
            opacity: 1;
        }

        .modal-box {
            background: var(--surface);
            border: 1px solid var(--border);
            border-radius: 24px;
            width: 100%;
            max-width: 460px;
            padding: 32px;
            box-shadow: var(--shadow-2xl);
            transform: scale(0.95);
            transition: transform 0.3s cubic-bezier(0.34, 1.56, 0.64, 1);
            position: relative;
        }

        .modal-overlay.active .modal-box {
            transform: scale(1);
        }

        .modal-header {
            display: flex;
            align-items: center;
            justify-content: space-between;
            margin-bottom: 24px;
        }

        .modal-title {
            font-size: 20px;
            font-weight: 800;
            color: var(--text-primary);
            margin: 0;
            font-family: 'Plus Jakarta Sans', sans-serif;
            letter-spacing: -0.02em;
        }

        .modal-close {
            background: transparent;
            border: none;
            font-size: 24px;
            color: var(--text-muted);
            cursor: pointer;
            transition: var(--transition);
        }

        .modal-close:hover {
            color: var(--text-primary);
            transform: rotate(90deg);
        }

        .form-group {
            display: flex;
            flex-direction: column;
            gap: 6px;
            margin-bottom: 20px;
        }

        .form-label {
            font-size: 12px;
            font-weight: 700;
            color: var(--text-secondary);
        }

        .form-input {
            background: var(--bg-alt);
            border: 1px solid var(--border);
            border-radius: 12px;
            padding: 12px 16px;
            font-size: 14px;
            color: var(--text-primary);
            transition: var(--transition);
        }

        .form-input:focus {
            outline: none;
            border-color: var(--primary);
            box-shadow: 0 0 0 4px rgba(37, 99, 235, 0.1);
            background: var(--surface);
        }

        .modal-footer {
            display: flex;
            justify-content: flex-end;
            gap: 12px;
            margin-top: 28px;
        }

        /* Toast notifications */
        .toast {
            position: fixed;
            bottom: 24px;
            right: 24px;
            background: var(--surface);
            border: 1px solid var(--border);
            border-radius: 16px;
            padding: 16px 20px;
            box-shadow: var(--shadow-xl);
            display: flex;
            align-items: center;
            gap: 16px;
            z-index: 1000;
            animation: toast-slide-in 0.4s cubic-bezier(0.34, 1.56, 0.64, 1);
            max-width: 360px;
        }

        .success-toast { border-left: 4px solid #10B981; }
        .error-toast { border-left: 4px solid #EF4444; }

        .toast-icon { font-size: 20px; }
        .toast-content { flex: 1; }
        .toast-title { font-size: 14px; font-weight: 700; color: var(--text-primary); }
        .toast-desc { font-size: 12px; color: var(--text-secondary); margin-top: 2px; }
        .toast-close { background: transparent; border: none; font-size: 18px; color: var(--text-muted); cursor: pointer; }

        @keyframes toast-slide-in {
            from { transform: translateY(100px); opacity: 0; }
            to { transform: translateY(0); opacity: 1; }
        }

        @media (max-width: 1024px) {
            .profile-lower-grid {
                grid-template-columns: 1fr;
            }
        }

        @media (max-width: 768px) {
            .content {
                padding: 16px 12px !important;
            }
            .profile-details-card {
                padding: 20px !important;
            }
            .column-card {
                padding: 20px !important;
                gap: 16px !important;
            }
            .note-card {
                padding: 16px !important;
                gap: 12px !important;
            }
            .stat-tile {
                padding: 16px 12px !important;
            }
            .status-panel {
                gap: 12px !important;
                margin-bottom: 20px !important;
            }
            .overview-item {
                padding: 12px !important;
            }
            .profile-summary-section {
                flex-direction: column;
                align-items: flex-start;
                gap: 20px !important;
            }
            .profile-summary-left {
                gap: 16px !important;
                width: 100% !important;
            }
            .profile-details-grid {
                grid-template-columns: 1fr;
                gap: 16px;
            }
        }
    </style>
</head>
<body>
<div class="sidebar-overlay" id="sidebarOverlay"></div>

<!-- Sidebar -->
<aside class="sidebar">
    <div style="display: flex; flex-direction: column; height: 100%; justify-content: space-between; flex: 1;">
        <div style="display: flex; flex-direction: column; gap: 24px;">
            <a href="${pageContext.request.contextPath}/" class="brand">
                <div class="brand-icon">
                    <img src="${pageContext.request.contextPath}/images/logo.svg?v=1.1" alt="DISHA Logo">
                </div>
                <div class="brand-text">DISHA</div>
            </a>
            <nav style="display: flex; flex-direction: column; gap: 8px;">
                <a href="${pageContext.request.contextPath}/" class="nav-item">
                    <span style="font-size:18px">⌂</span> Dashboard
                </a>
                <a href="${pageContext.request.contextPath}/assessment/start" class="nav-item">
                    <span style="font-size:18px">📝</span> Assessments
                </a>
                <a href="${pageContext.request.contextPath}/assessment/history" class="nav-item">
                    <span style="font-size:18px">🕒</span> History
                </a>
                <a href="${pageContext.request.contextPath}/profile" class="nav-item active">
                    <span style="font-size:18px">👤</span> Profile
                </a>
                <a href="#" class="nav-item" onclick="openEditProfileModal(); return false;">
                    <span style="font-size:18px">⚙️</span> Settings
                </a>
            </nav>
        </div>
        <a href="${pageContext.request.contextPath}/logout" class="nav-item" style="color: #EF4444; border-top: 1px solid var(--border); padding-top: 16px;">
            <span style="font-size:18px">🚪</span> Sign Out
        </a>
    </div>
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
        <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 32px; flex-wrap: wrap; gap: 16px;">
            <div>
                <h1 style="font-size: 32px; font-weight: 800; font-family: 'Plus Jakarta Sans', sans-serif; color: var(--text-primary); margin: 0 0 6px 0;">My Profile</h1>
                <p style="font-size: 14px; color: var(--text-muted); margin: 0;">Manage your personal information and account settings.</p>
            </div>
            <button class="btn btn-outline" style="display: flex; align-items: center; gap: 8px; font-size: 14px; padding: 10px 18px;" onclick="openEditProfileModal()">
                <span>✏️</span> Edit Profile
            </button>
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
                <div class="stat-tile-label" style="font-weight: 700; color: var(--text-muted); margin-top: 4px;">Student ID</div>
                <div style="font-size: 11px; color: var(--text-muted); margin-top: 2px;">Unique identifier</div>
            </div>
            <div class="stat-tile">
                <div class="stat-tile-icon">🎓</div>
                <div class="stat-tile-value" style="text-transform: uppercase;">${profileUser.role}</div>
                <div class="stat-tile-label" style="font-weight: 700; color: var(--text-muted); margin-top: 4px;">Account Role</div>
                <div style="font-size: 11px; color: var(--text-muted); margin-top: 2px;">Your current role</div>
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
                <div class="stat-tile-label" style="font-weight: 700; color: var(--text-muted); margin-top: 4px;">Account Status</div>
                <div style="font-size: 11px; color: var(--text-muted); margin-top: 2px;">
                    <c:choose>
                        <c:when test="${profileUser.flagged}">Your account is flagged</c:when>
                        <c:otherwise>Your account is active</c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>

        <!-- Profile Details Card -->
        <div class="card profile-details-card animate-fade-in delay-2" style="margin-bottom: 24px;">
            <div class="profile-summary-section">
                <div class="profile-summary-left">
                    <div class="summary-avatar-circle">
                        ${fn:substring(profileUser.fullName, 0, 1)}
                    </div>
                    <div>
                        <div class="summary-name-row">
                            <h2 class="summary-name">${profileUser.fullName}</h2>
                            <span class="summary-badge">${profileUser.role}</span>
                        </div>
                        <div class="summary-email" style="margin-top: 6px; font-weight: 500;">
                            📧 ${profileUser.email}
                        </div>
                    </div>
                </div>
                
                <div class="profile-details-grid">
                    <div class="details-field">
                        <span class="details-label">User ID</span>
                        <span class="details-value" style="font-weight: 700;">#${profileUser.userId}</span>
                    </div>
                    <div class="details-field">
                        <span class="details-label">Role</span>
                        <span class="details-value" style="font-weight: 700;">${profileUser.role}</span>
                    </div>
                    <div class="details-field">
                        <span class="details-label">Member Since</span>
                        <span class="details-value" style="font-weight: 700;">
                            <c:choose>
                                <c:when test="${not empty pastAttempts}">
                                    <c:forEach var="att" items="${pastAttempts}" varStatus="status">
                                        <c:if test="${status.last}">
                                            ${fn:substring(att.attemptDate, 0, 12)}
                                        </c:if>
                                    </c:forEach>
                                </c:when>
                                <c:otherwise>May 20, 2024</c:otherwise>
                            </c:choose>
                        </span>
                    </div>
                    <div class="details-field">
                        <span class="details-label">Last Login</span>
                        <span class="details-value" style="font-weight: 700;">
                            <c:choose>
                                <c:when test="${not empty pastAttempts}">
                                    ${fn:substring(pastAttempts[0].attemptDate, 0, 16)}
                                </c:when>
                                <c:otherwise>May 20, 2024 10:30 AM</c:otherwise>
                            </c:choose>
                        </span>
                    </div>
                </div>
            </div>
        </div>

        <!-- Lower Columns Grid -->
        <div class="profile-lower-grid animate-fade-in delay-3">
            <!-- Column 1: Account Overview -->
            <div class="column-card">
                <h3 class="column-card-title">Account Overview</h3>
                <div class="overview-list">
                    <div class="overview-item">
                        <div style="display: flex; align-items: center; gap: 16px;">
                            <span class="overview-icon">📊</span>
                            <div>
                                <div class="overview-label">Assessments Taken</div>
                                <div class="overview-desc">${assessmentsTaken}</div>
                            </div>
                        </div>
                        <span class="overview-chevron">➔</span>
                    </div>
                    <div class="overview-item">
                        <div style="display: flex; align-items: center; gap: 16px;">
                            <span class="overview-icon" style="background: rgba(16, 185, 129, 0.08); color: #10B981;">🎯</span>
                            <div>
                                <div class="overview-label">Average Score</div>
                                <div class="overview-desc">${avgScore}%</div>
                            </div>
                        </div>
                        <span class="overview-chevron">➔</span>
                    </div>
                    <div class="overview-item">
                        <div style="display: flex; align-items: center; gap: 16px;">
                            <span class="overview-icon" style="background: rgba(245, 158, 11, 0.08); color: #F59E0B;">⏱️</span>
                            <div>
                                <div class="overview-label">Total Time Spent</div>
                                <div class="overview-desc">${totalTimeSpent}</div>
                            </div>
                        </div>
                        <span class="overview-chevron">➔</span>
                    </div>
                </div>
            </div>

            <!-- Column 2: Quick Actions -->
            <div class="column-card">
                <h3 class="column-card-title">Quick Actions</h3>
                <div class="overview-list">
                    <a href="${pageContext.request.contextPath}/assessment/history" class="overview-item action-item">
                        <div style="display: flex; align-items: center; gap: 16px;">
                            <span class="overview-icon action-icon blue">🕒</span>
                            <div class="overview-label" style="font-weight: 700;">View Assessment History</div>
                        </div>
                        <span class="overview-chevron">➔</span>
                    </a>
                    <a href="${pageContext.request.contextPath}/assessment/start" class="overview-item action-item">
                        <div style="display: flex; align-items: center; gap: 16px;">
                            <span class="overview-icon action-icon green">📝</span>
                            <div class="overview-label" style="font-weight: 700;">Start New Assessment</div>
                        </div>
                        <span class="overview-chevron">➔</span>
                    </a>
                    <div class="overview-item action-item" onclick="openEditProfileModal()" style="cursor: pointer;">
                        <div style="display: flex; align-items: center; gap: 16px;">
                            <span class="overview-icon action-icon purple">🔑</span>
                            <div class="overview-label" style="font-weight: 700;">Update Password</div>
                        </div>
                        <span class="overview-chevron">➔</span>
                    </div>
                    <div class="overview-item action-item" onclick="showNotificationToast()" style="cursor: pointer;">
                        <div style="display: flex; align-items: center; gap: 16px;">
                            <span class="overview-icon action-icon amber">🔔</span>
                            <div class="overview-label" style="font-weight: 700;">Notification Settings</div>
                        </div>
                        <span class="overview-chevron">➔</span>
                    </div>
                </div>
            </div>
        </div>

        <!-- Counselor Note -->
        <c:if test="${not empty profileUser.counselorNote}">
            <div class="note-card animate-fade-in delay-3">
                <div class="note-icon">📋</div>
                <div>
                    <div class="note-label">Counselor Note</div>
                    <div class="note-text">${profileUser.counselorNote}</div>
                </div>
            </div>
        </c:if>

    </div>
</div>

<!-- Edit Profile Modal Overlay -->
<div class="modal-overlay" id="editProfileModal">
    <div class="modal-box animate-scale-up">
        <div class="modal-header">
            <h3 class="modal-title">Edit Profile</h3>
            <button class="modal-close" onclick="closeEditProfileModal()">×</button>
        </div>
        <form action="${pageContext.request.contextPath}/profile" method="post" id="editProfileForm">
            <div class="form-group">
                <label class="form-label" for="fullNameInput">Full Name</label>
                <input type="text" name="fullName" id="fullNameInput" class="form-input" value="${profileUser.fullName}" required>
            </div>
            <div class="form-group">
                <label class="form-label" for="emailInput">Email Address</label>
                <input type="email" name="email" id="emailInput" class="form-input" value="${profileUser.email}" required>
            </div>
            <div class="form-group">
                <label class="form-label" for="passwordInput">New Password</label>
                <input type="password" name="password" id="passwordInput" class="form-input" placeholder="••••••••" minlength="6">
                <span style="font-size: 11px; color: var(--text-muted); margin-top: 4px;">Leave blank if you do not want to change your password.</span>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-outline" onclick="closeEditProfileModal()">Cancel</button>
                <button type="submit" class="btn btn-primary" style="background: var(--primary);">Save Changes</button>
            </div>
        </form>
    </div>
</div>

<!-- Toast notifications -->
<c:if test="${param.success == 'true'}">
    <div class="toast success-toast" id="statusToast">
        <span class="toast-icon">✨</span>
        <div class="toast-content">
            <div class="toast-title">Success</div>
            <div class="toast-desc">Profile updated successfully!</div>
        </div>
        <button class="toast-close" onclick="document.getElementById('statusToast').remove()">×</button>
    </div>
</c:if>
<c:if test="${not empty param.error}">
    <div class="toast error-toast" id="statusToast">
        <span class="toast-icon">⚠️</span>
        <div class="toast-content">
            <div class="toast-title">Error</div>
            <div class="toast-desc">
                <c:choose>
                    <c:when test="${param.error == 'invalid_inputs'}">Please fill in all required fields.</c:when>
                    <c:otherwise>Failed to update profile. Please try again.</c:otherwise>
                </c:choose>
            </div>
        </div>
        <button class="toast-close" onclick="document.getElementById('statusToast').remove()">×</button>
    </div>
</c:if>

<!-- Dynamic alert toast for settings/notifications -->
<div class="toast success-toast" id="dynamicToast" style="display: none;">
    <span class="toast-icon">🔔</span>
    <div class="toast-content">
        <div class="toast-title">Settings</div>
        <div class="toast-desc" id="dynamicToastDesc">Settings updated successfully!</div>
    </div>
    <button class="toast-close" onclick="closeDynamicToast()">×</button>
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

        // Auto-dismiss URL parameters toast after 4 seconds
        const statusToast = document.getElementById('statusToast');
        if (statusToast) {
            setTimeout(function() {
                statusToast.style.opacity = '0';
                statusToast.style.transition = 'opacity 0.5s ease';
                setTimeout(function() {
                    statusToast.remove();
                }, 500);
            }, 4000);
        }
    });

    function openEditProfileModal() {
        const modal = document.getElementById('editProfileModal');
        modal.classList.add('active');
    }

    function closeEditProfileModal() {
        const modal = document.getElementById('editProfileModal');
        modal.classList.remove('active');
    }

    function showNotificationToast() {
        const toast = document.getElementById('dynamicToast');
        document.getElementById('dynamicToastDesc').innerText = "Notification preferences saved successfully!";
        toast.style.display = 'flex';
        setTimeout(closeDynamicToast, 5000);
    }

    function closeDynamicToast() {
        const toast = document.getElementById('dynamicToast');
        toast.style.display = 'none';
    }
</script>
</body>
</html>
