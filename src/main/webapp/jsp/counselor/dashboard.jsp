<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Counselor Dashboard - DISHA</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/main.css?v=7">
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <style>
        body {
            background: var(--bg);
            background-image: radial-gradient(ellipse 70% 50% at 90% 0%, rgba(37, 99, 235, 0.05) 0%, transparent 55%);
        }

        /* Summary cards grid */
        .dash-summary-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(220px, 1fr));
            gap: 20px;
            margin-bottom: 32px;
        }

        /* Inner analytics / quick-action grid */
        .dash-inner-grid {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 24px;
        }

        /* Quick actions row */
        .dash-qa-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 16px;
            margin-bottom: 16px;
        }

        /* ── Tablet (≤ 1024px) ── */
        @media (max-width: 1024px) {
            main[style] { padding: 24px 20px !important; }
            header.topnav[style] { padding: 0 20px !important; justify-content: flex-start !important; }
        }

        /* ── Mobile (≤ 768px) ── */
        @media (max-width: 768px) {
            .dash-summary-grid {
                grid-template-columns: repeat(2, 1fr);
                gap: 12px;
                margin-bottom: 20px;
            }
            .dash-inner-grid {
                grid-template-columns: 1fr;
                gap: 16px;
            }
            .dash-qa-grid {
                grid-template-columns: 1fr;
                gap: 10px;
            }
            main[style] { padding: 16px !important; }
            header.topnav[style] {
                height: 60px !important;
                padding: 0 16px !important;
            }
            /* Hide date chip on small screens */
            header.topnav > div:last-child { display: none !important; }
            /* Hide greeting on very small */
            .topnav-greeting { display: none !important; }
        }

        .chart-container {
            position: relative;
            height: 320px;
            width: 100%;
            overflow: hidden;
        }

        /* ── Mobile (≤ 768px) ── */
        @media (max-width: 768px) {
            .sc-value { font-size: 18px; }
            h1[style] { font-size: 20px !important; }
            .chart-container { height: 180px !important; }
            .glass-panel { padding: 10px !important; }
            .dash-summary-grid { grid-template-columns: 1fr !important; gap: 10px !important; }
            .close-sidebar-btn { display: flex !important; }
            
            /* FORCE SIDEBAR HIDE */
            .sidebar {
                transform: translateX(-100%) !important;
                left: 0 !important;
                top: 0 !important;
                position: fixed !important;
                z-index: 1000 !important;
                display: flex !important;
            }
            
            .main-wrapper {
                margin-left: 0 !important;
                width: 100% !important;
                max-width: 100vw !important;
            }
            
            body.sidebar-open .sidebar {
                transform: translateX(0) !important;
            }
            
            .topnav {
                justify-content: space-between !important;
                padding: 0 12px !important;
            }
            
            .mobile-menu-btn {
                display: flex !important;
                order: -1;
            }
        }

        .chart-container {
            position: relative;
            height: 320px;
            width: 100%;
            overflow: hidden;
        }

        body.sidebar-open {
            overflow: hidden;
        }
    </style>
</head>
<body>
<div class="sidebar-overlay" id="sidebarOverlay"></div>

<div class="layout" style="display: flex; min-height: 100vh;">

    <!-- -- Sidebar -- -->
    <nav class="sidebar animate-fade-in" style="flex-shrink: 0; z-index: 1000; box-shadow: 1px 0 0 var(--border);">
        <div class="sidebar-header" style="padding: 24px 20px; border-bottom: 1px solid var(--border); position: relative;">
            <!-- Close Button for Mobile -->
            <button class="close-sidebar-btn" onclick="document.body.classList.remove('sidebar-open')" style="display: none; position: absolute; top: 12px; right: 12px; width: 32px; height: 32px; background: var(--bg-alt); border: 1px solid var(--border); border-radius: 50%; align-items: center; justify-content: center; font-size: 18px; cursor: pointer; color: var(--text-primary); z-index: 1001;">&times;</button>
            
            <a href="#" class="sidebar-brand" style="display: flex; align-items: center; gap: 10px; text-decoration: none; margin-bottom: 20px;">
                <img src="${pageContext.request.contextPath}/images/logo.svg" alt="DISHA" style="width: 34px; height: 34px;">
                <span style="font-size: 16px; font-weight: 800; font-family: 'Plus Jakarta Sans', sans-serif; letter-spacing: 2px; color: var(--primary);">DISHA</span>
            </a>
            
            <!-- Profile Block -->
            <div class="sidebar-profile">
                <div class="sp-avatar">
                    <img src="https://ui-avatars.com/api/?name=Counselor+Dev&background=2563EB&color=fff" alt="Avatar">
                    <div class="sp-status"></div>
                </div>
                <div class="sp-info">
                    <div class="sp-name">Counselor Dev</div>
                    <div class="sp-role">Career Counselor</div>
                </div>
            </div>
        </div>

        <div class="sidebar-nav" style="padding: 12px; flex: 1; overflow-y: auto; display: flex; flex-direction: column;">
            <a href="#" class="nav-item active"><span>📊</span> Overview</a>
            <a href="#" class="nav-item"><span>👥</span> My Students</a>
            <a href="#" class="nav-item"><span>📝</span> Assessments</a>
            <a href="#" class="nav-item"><span>🎯</span> Career Insights</a>
            <a href="#" class="nav-item"><span>📚</span> Resources</a>
            <a href="#" class="nav-item"><span>🤝</span> Counseling Sessions</a>
            <a href="#" class="nav-item"><span>📈</span> Reports & Analytics</a>
            <a href="#" class="nav-item" style="position: relative;">
                <span>💬</span> Messages
                <span style="position: absolute; right: 12px; background: var(--primary); color: white; border-radius: 50%; width: 20px; height: 20px; display: flex; align-items: center; justify-content: center; font-size: 10px; font-weight: bold;">3</span>
            </a>
            <a href="#" class="nav-item"><span>📅</span> Calendar</a>
            <a href="${pageContext.request.contextPath}/logout" class="nav-item" style="margin-top: auto; color: var(--danger);">
                <span>🚪</span> Sign Out
            </a>
        </div>
        
        <div style="padding: 16px; margin: 16px; background: var(--warning-bg); border: 1px solid var(--warning); border-radius: var(--radius-md); text-align: center;">
            <div style="font-size: 24px; margin-bottom: 8px;">✨</div>
            <div style="font-weight: 700; font-size: 13px; margin-bottom: 4px;">Empower Better Futures</div>
            <div style="font-size: 11px; color: var(--text-muted); margin-bottom: 12px;">Help students discover the right career path.</div>
            <a href="#" class="btn-outline" style="width: 100%; display: block; font-size: 12px; padding: 6px;">View Resources</a>
        </div>
    </nav>

    <!-- -- Main Content Wrapper -- -->
    <div class="main-wrapper" style="flex: 1; display: flex; flex-direction: column; overflow-x: hidden;">
        
        <!-- Topnav -->
        <header class="topnav" style="height: 72px; display: flex; align-items: center; justify-content: space-between; padding: 0 40px; background: rgba(255,255,255,0.8); backdrop-filter: blur(10px); border-bottom: 1px solid var(--border); position: sticky; top: 0; z-index: 10;">
            <button class="mobile-menu-btn" id="mobileMenuBtn" style="border: 1px solid var(--border); border-radius: 8px; background: var(--surface); width: 42px; height: 42px; display: none; align-items: center; justify-content: center; font-size: 20px; cursor: pointer; margin-right: 12px;">☰</button>
            <div class="topnav-greeting" style="flex: 1; font-size: 14px; font-weight: 600; color: var(--text-secondary);">Good afternoon, Counselor Dev! 👋</div>
            <div class="date-chip" style="border: 1px solid var(--border); border-radius: var(--radius-md); padding: 8px 16px; font-size: 13px; font-weight: 600; color: var(--text-secondary); background: var(--surface); display: flex; align-items: center; gap: 8px;">
                📅 May 14, 2025
            </div>
        </header>

        <!-- Main Dashboard Content -->
        <main style="padding: 32px 40px; flex: 1;">
            
            <div style="margin-bottom: 32px;">
                <h1 style="font-size: 28px; font-weight: 800; font-family: 'Plus Jakarta Sans', sans-serif; letter-spacing: -0.02em; margin-bottom: 4px;">Counselor Dashboard</h1>
                <p style="color: var(--text-muted); font-size: 14px;">Empower students to discover the right career path.</p>
            </div>

            <c:if test="${addSuccess}">
                <div class="toast toast-success" style="padding: 12px 20px; background: #DCFCE7; color: #15803D; border: 1px solid #86EFAC; border-radius: var(--radius-md); margin-bottom: 24px; font-weight: 600; font-size: 13px;">
                    ✅ Student added successfully!
                </div>
            </c:if>
            <c:if test="${not empty addError}">
                <div class="toast toast-error" style="padding: 12px 20px; background: #FEE2E2; color: #B91C1C; border: 1px solid #FCA5A5; border-radius: var(--radius-md); margin-bottom: 24px; font-weight: 600; font-size: 13px;">
                    ❌ ${addError}
                </div>
            </c:if>

            <!-- Summary Cards -->
            <div class="dash-summary-grid">
                <div class="summary-card sc-purple animate-fade-in">
                    <div class="sc-icon">👥</div>
                    <div class="sc-content">
                        <div class="sc-label">Total Students</div>
                        <div class="sc-value">128</div>
                        <div class="sc-trend up">+12 this month</div>
                    </div>
                </div>
                <div class="summary-card sc-blue animate-fade-in delay-1">
                    <div class="sc-icon">🎓</div>
                    <div class="sc-content">
                        <div class="sc-label">Assessments Completed</div>
                        <div class="sc-value">86</div>
                        <div class="sc-trend neutral">67.2% completion rate</div>
                    </div>
                </div>
                <div class="summary-card sc-green animate-fade-in delay-2" style="display: none;">
                    <div class="sc-icon">🎯</div>
                    <div class="sc-content">
                        <div class="sc-label">Career Matches Generated</div>
                        <div class="sc-value">42</div>
                        <div class="sc-trend up">+8 this week</div>
                    </div>
                </div>
                <div class="summary-card sc-orange animate-fade-in delay-3">
                    <div class="sc-icon">🤝</div>
                    <div class="sc-content">
                        <div class="sc-label">Counseling Sessions</div>
                        <div class="sc-value">18</div>
                        <div class="sc-trend neutral">Upcoming this week</div>
                    </div>
                </div>
            </div>

            <div class="dashboard-grid animate-fade-in delay-2">
                <!-- Left Column -->
                <div class="main-column">
                    
                    <!-- Assessment Completion Trends Chart -->
                    <div class="chart-card" style="margin-bottom: 24px;">
                        <div class="chart-header">
                            <div class="chart-title">Assessment Completion Trends</div>
                        </div>
                        <div class="chart-container">
                            <canvas id="completionChart"></canvas>
                        </div>
                    </div>

                    <!-- Recent Student Activity Table -->
                    <div class="glass-panel" style="margin-bottom: 24px; overflow: hidden;">
                        <div style="padding: 20px 24px; border-bottom: 1px solid var(--border); display: flex; justify-content: space-between; align-items: center;">
                            <h2 style="font-size: 16px; margin: 0;">Recent Student Activity</h2>
                            <a href="#" style="font-size: 13px; color: var(--primary); font-weight: 600;">View All Students →</a>
                        </div>
                        <div class="table-responsive">
                            <table class="modern-table" style="margin: 0; min-width: 100%;">
                                <thead>
                                    <tr>
                                        <th>Student</th>
                                        <th>Latest Assessment</th>
                                        <th>Interest Area</th>
                                        <th>Last Active</th>
                                        <th>Status</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="student" items="${students}" end="4">
                                        <c:set var="latest" value="${latestAttempts[student.userId]}" />
                                        <tr>
                                            <td style="display: flex; align-items: center; gap: 12px;">
                                                <div class="avatar" style="width: 32px; height: 32px; font-size: 12px; background: #E0E7FF; color: #4338CA; box-shadow: none;">${fn:substring(student.fullName, 0, 1)}</div>
                                                <div>
                                                    <div style="font-weight: 600; color: var(--text-primary); font-size: 13px;">${student.fullName}</div>
                                                    <div style="font-size: 11px; color: var(--text-muted);">${student.email}</div>
                                                </div>
                                            </td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${not empty latest}">
                                                        <div style="font-size: 13px; font-weight: 500;">Career Assessment</div>
                                                        <div style="font-size: 11px; color: #16A34A; font-weight: 600;">Score: ${latest.aptitudeScore} / 10</div>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <div style="font-size: 13px; font-weight: 500;">No Assessment</div>
                                                        <div style="font-size: 11px; color: var(--text-muted);">Not Started</div>
                                                    </c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td style="font-size: 13px; color: var(--text-secondary);">
                                                <c:choose>
                                                    <c:when test="${not empty latest and not empty latest.personalityCluster}">
                                                        ${latest.personalityCluster}
                                                    </c:when>
                                                    <c:otherwise>N/A</c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td>
                                                <div style="font-size: 13px; color: var(--text-muted);">Just now</div>
                                            </td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${student.flagged}"><span class="badge badge-orange">Flagged</span></c:when>
                                                    <c:otherwise><span class="badge badge-green">Active</span></c:otherwise>
                                                </c:choose>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </div>

                    <!-- Bottom Blocks -->
                    <div class="dash-inner-grid">
                        <div class="glass-panel" style="padding: 24px;">
                            <h2 style="font-size: 14px; margin-bottom: 16px;">Upcoming Sessions</h2>
                            <div style="display: flex; align-items: center; justify-content: space-between; padding: 16px; border: 1px solid var(--border); border-radius: var(--radius-md); background: var(--bg-alt);">
                                <div style="display: flex; align-items: center; gap: 12px;">
                                    <div style="width: 40px; height: 40px; background: #EFF6FF; color: #2563EB; border-radius: 8px; display: flex; align-items: center; justify-content: center; font-size: 20px;">📅</div>
                                    <div>
                                        <div style="font-weight: 700; font-size: 13px;">Career Counseling Session</div>
                                        <div style="font-size: 11px; color: var(--text-muted);">with Aarav Sharma</div>
                                    </div>
                                </div>
                                <div style="text-align: right;">
                                    <div style="font-size: 12px; font-weight: 600; color: var(--text-secondary); margin-bottom: 4px;">Today, 3:30 PM</div>
                                    <a href="#" class="btn-outline" style="padding: 4px 12px; font-size: 11px;">+ Join</a>
                                </div>
                            </div>
                        </div>

                        <div class="glass-panel" style="padding: 24px;">
                            <h2 style="font-size: 14px; margin-bottom: 16px;">Recent Resources Shared</h2>
                            <div style="display: flex; align-items: center; justify-content: space-between;">
                                <div style="display: flex; align-items: center; gap: 12px;">
                                    <div style="width: 36px; height: 36px; background: #FEF2F2; color: #DC2626; border-radius: 8px; display: flex; align-items: center; justify-content: center; font-size: 16px; font-weight: bold;">PDF</div>
                                    <div>
                                        <div style="font-weight: 600; font-size: 13px;">Top Engineering Careers in 2025</div>
                                        <div style="font-size: 11px; color: var(--text-muted);">Shared with 12 students</div>
                                    </div>
                                </div>
                                <div style="font-size: 11px; color: var(--text-muted);">2 hours ago</div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Right Column (Panel) -->
                <div class="side-column">
                    <div class="glass-panel" style="padding: 24px; margin-bottom: 24px;">
                        <h2 style="font-size: 16px; margin-bottom: 16px;">Quick Actions</h2>
                        <a href="#" id="openAddStudentModalBtn" class="quick-action-btn">
                            <div class="quick-action-icon qa-blue">👥</div>
                            <div class="quick-action-text">
                                <div class="quick-action-title">Add New Student</div>
                                <div class="quick-action-desc">Register and onboard a new student</div>
                            </div>
                        </a>
                        <a href="#" class="quick-action-btn">
                            <div class="quick-action-icon qa-orange">📅</div>
                            <div class="quick-action-text">
                                <div class="quick-action-title">Schedule Session</div>
                                <div class="quick-action-desc">Book a counseling session</div>
                            </div>
                        </a>
                        <a href="#" class="quick-action-btn">
                            <div class="quick-action-icon qa-green">📚</div>
                            <div class="quick-action-text">
                                <div class="quick-action-title">Share Resource</div>
                                <div class="quick-action-desc">Send resources to students</div>
                            </div>
                        </a>
                        <a href="#" class="quick-action-btn">
                            <div class="quick-action-icon qa-purple">📊</div>
                            <div class="quick-action-text">
                                <div class="quick-action-title">Generate Report</div>
                                <div class="quick-action-desc">Create student progress report</div>
                            </div>
                        </a>
                    </div>

                    <!-- Career Interest Distribution Chart -->
                    <div class="chart-card" style="margin-bottom: 24px;">
                        <div class="chart-header">
                            <div class="chart-title">Career Interest Distribution</div>
                        </div>
                        <div class="chart-container" style="height: 220px;">
                            <canvas id="interestChart"></canvas>
                        </div>
                    </div>

                    <div class="glass-panel" style="padding: 24px; margin-bottom: 24px;">
                        <h2 style="font-size: 14px; margin-bottom: 16px;">Student Status Overview</h2>
                        <div class="progress-widget">
                            <div class="progress-widget-header">
                                <span class="progress-widget-label">On Track</span>
                                <span class="progress-widget-value">68%</span>
                            </div>
                            <div class="progress-bar-bg">
                                <div class="progress-bar-fill green" style="width: 68%;"></div>
                            </div>
                        </div>
                        <div class="progress-widget">
                            <div class="progress-widget-header">
                                <span class="progress-widget-label">Needs Review</span>
                                <span class="progress-widget-value">22%</span>
                            </div>
                            <div class="progress-bar-bg">
                                <div class="progress-bar-fill orange" style="width: 22%;"></div>
                            </div>
                        </div>
                        <div class="progress-widget">
                            <div class="progress-widget-header">
                                <span class="progress-widget-label">At Risk</span>
                                <span class="progress-widget-value">10%</span>
                            </div>
                            <div class="progress-bar-bg">
                                <div class="progress-bar-fill pink" style="width: 10%;"></div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

        </main>
    </div>
</div>

<!-- Add Student Modal -->
<div id="addStudentModal" class="modal-overlay" style="display: none; position: fixed; top: 0; left: 0; right: 0; bottom: 0; background: rgba(0,0,0,0.5); z-index: 100; align-items: center; justify-content: center; backdrop-filter: blur(4px);">
    <div class="glass-panel" style="width: 100%; max-width: 480px; padding: 32px; position: relative;">
        <button id="closeModalBtn" style="position: absolute; top: 20px; right: 20px; background: none; border: none; font-size: 20px; cursor: pointer; color: var(--text-muted);">&times;</button>
        <h2 style="font-size: 20px; margin-bottom: 8px;">Add New Student</h2>
        <p style="font-size: 13px; color: var(--text-muted); margin-bottom: 24px;">Register a new student account. They can use these credentials to log in.</p>
        
        <form action="${pageContext.request.contextPath}/counselor/addStudent" method="post">
            <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 16px; margin-bottom: 16px;">
                <div>
                    <label style="display: block; font-size: 12px; font-weight: 600; margin-bottom: 6px; color: var(--text-secondary);">First Name</label>
                    <input type="text" name="firstName" required style="width: 100%; padding: 10px 12px; border: 1px solid var(--border); border-radius: var(--radius-md); font-size: 14px; background: var(--bg-alt); box-sizing: border-box;">
                </div>
                <div>
                    <label style="display: block; font-size: 12px; font-weight: 600; margin-bottom: 6px; color: var(--text-secondary);">Last Name</label>
                    <input type="text" name="lastName" required style="width: 100%; padding: 10px 12px; border: 1px solid var(--border); border-radius: var(--radius-md); font-size: 14px; background: var(--bg-alt); box-sizing: border-box;">
                </div>
            </div>
            <div style="margin-bottom: 16px;">
                <label style="display: block; font-size: 12px; font-weight: 600; margin-bottom: 6px; color: var(--text-secondary);">Email Address</label>
                <input type="email" name="email" required style="width: 100%; padding: 10px 12px; border: 1px solid var(--border); border-radius: var(--radius-md); font-size: 14px; background: var(--bg-alt); box-sizing: border-box;">
            </div>
            <div style="margin-bottom: 24px;">
                <label style="display: block; font-size: 12px; font-weight: 600; margin-bottom: 6px; color: var(--text-secondary);">Password</label>
                <input type="password" name="password" required style="width: 100%; padding: 10px 12px; border: 1px solid var(--border); border-radius: var(--radius-md); font-size: 14px; background: var(--bg-alt); box-sizing: border-box;">
            </div>
            <div style="display: flex; justify-content: flex-end; gap: 12px;">
                <button type="button" id="cancelModalBtn" class="btn-outline" style="padding: 10px 20px;">Cancel</button>
                <button type="submit" class="btn-primary" style="padding: 10px 20px;">Add Student</button>
            </div>
        </form>
    </div>
</div>

<script>
    document.addEventListener('DOMContentLoaded', function () {
        // Mobile Sidebar Toggle
        const mobileMenuBtn = document.getElementById('mobileMenuBtn');
        const sidebar = document.querySelector('.sidebar');
        const overlay = document.getElementById('sidebarOverlay');

        if (mobileMenuBtn) {
            function toggleMenu() {
                document.body.classList.toggle('sidebar-open');
            }
            mobileMenuBtn.addEventListener('click', toggleMenu);
            if (overlay) overlay.addEventListener('click', toggleMenu);
        }

        // Add Student Modal Logic
        const modal = document.getElementById('addStudentModal');
        const openModalBtn = document.getElementById('openAddStudentModalBtn');
        const closeModalBtn = document.getElementById('closeModalBtn');
        const cancelModalBtn = document.getElementById('cancelModalBtn');

        if (openModalBtn && modal) {
            openModalBtn.addEventListener('click', (e) => {
                e.preventDefault();
                modal.style.display = 'flex';
            });
        }
        
        function hideModal() {
            if (modal) modal.style.display = 'none';
        }

        if (closeModalBtn) closeModalBtn.addEventListener('click', hideModal);
        if (cancelModalBtn) cancelModalBtn.addEventListener('click', hideModal);
        
        // Close modal when clicking outside
        if (modal) {
            modal.addEventListener('click', (e) => {
                if (e.target === modal) hideModal();
            });
        }

        // Chart.js Global Settings
        Chart.defaults.font.family = "'Inter', 'Plus Jakarta Sans', sans-serif";
        Chart.defaults.color = '#94A3B8';
        Chart.defaults.scale.grid.color = '#F1F5F9';
        
        // 1. Career Interest Distribution (Doughnut Chart)
        const ctxInterest = document.getElementById('interestChart').getContext('2d');
        new Chart(ctxInterest, {
            type: 'doughnut',
            data: {
                labels: ['Engineering', 'Business', 'Design', 'Healthcare', 'Others'],
                datasets: [{
                    data: [42, 28, 16, 10, 4],
                    backgroundColor: ['#3B82F6', '#8B5CF6', '#EC4899', '#10B981', '#F59E0B'],
                    borderWidth: 0,
                    hoverOffset: 4
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: {
                    legend: { 
                        position: 'bottom', 
                        labels: { boxWidth: 6, usePointStyle: true, padding: 6, font: { size: 8 } } 
                    }
                },
                cutout: '65%'
            }
        });

        // 2. Assessment Completion Trends (Line Chart)
        const ctxCompletion = document.getElementById('completionChart').getContext('2d');
        new Chart(ctxCompletion, {
            type: 'line',
            data: {
                labels: ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun'],
                datasets: [{
                    label: 'Completed Assessments',
                    data: [45, 52, 38, 65, 78, 86],
                    borderColor: '#3B82F6',
                    backgroundColor: 'rgba(59, 130, 246, 0.1)',
                    borderWidth: 3,
                    fill: true,
                    tension: 0.4,
                    pointBackgroundColor: '#FFFFFF',
                    pointBorderColor: '#3B82F6',
                    pointBorderWidth: 2,
                    pointRadius: 4
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: { legend: { display: false } },
                scales: {
                    y: { beginAtZero: true, border: { display: false } },
                    x: { border: { display: false }, grid: { display: false } }
                }
            }
        });


    });
</script>
</body>
</html>
