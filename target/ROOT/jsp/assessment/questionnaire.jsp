<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Assessment - DISHA Career Portal</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/main.css?v=5">
    <style>
        body {
            background: var(--bg);
            margin: 0;
            padding: 0;
            overflow-x: hidden;
        }

        /* -- Layout -- */
        .app-shell {
            display: flex;
            min-height: 100vh;
        }

        /* -- Left Sidebar -- */
        .sidebar {
            width: 260px;
            background: var(--surface);
            border-right: 1px solid var(--border);
            position: fixed;
            top: 0;
            bottom: 0;
            left: 0;
            display: flex;
            flex-direction: column;
            overflow-y: auto;
            box-shadow: 1px 0 0 var(--border), var(--shadow-xs);
            z-index: 60;
            transition: transform 0.3s cubic-bezier(0.4, 0, 0.2, 1);
        }

        .sidebar-top {
            padding: 24px 20px;
            border-bottom: 1px solid var(--border);
        }

        .sidebar-logo {
            display: flex;
            align-items: center;
            gap: 10px;
            text-decoration: none;
            margin-bottom: 0;
        }

        .sidebar-logo img {
            width: 36px;
            height: 36px;
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

        .sidebar-brand-tagline {
            font-size: 10px;
            color: var(--text-muted);
            margin-top: 1px;
        }

        /* Progress ring in sidebar header */
        .sidebar-progress-wrap {
            margin-top: 20px;
            padding: 14px 16px;
            background: var(--bg);
            border: 1px solid var(--border);
            border-radius: var(--radius-md);
        }

        .sidebar-progress-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 8px;
        }

        .sidebar-progress-label {
            font-size: 12px;
            font-weight: 600;
            color: var(--text-secondary);
        }

        .sidebar-progress-count {
            font-size: 12px;
            font-weight: 700;
            color: var(--primary);
            font-family: 'Plus Jakarta Sans', sans-serif;
        }

        .sidebar-progress-bar {
            height: 5px;
            border-radius: var(--radius-full);
            background: var(--bg-alt);
            overflow: hidden;
        }

        .sidebar-progress-fill {
            height: 100%;
            border-radius: var(--radius-full);
            background: var(--primary-gradient);
            transition: width 0.4s cubic-bezier(0.4, 0, 0.2, 1);
            width: 0%;
        }

        /* Tracker */
        .sidebar-body {
            flex: 1;
            padding: 20px 20px;
        }

        .tracker-label {
            font-size: 10px;
            font-weight: 700;
            color: var(--text-muted);
            text-transform: uppercase;
            letter-spacing: 1px;
            margin-bottom: 12px;
        }

        .tracker-list {
            display: flex;
            flex-direction: column;
            gap: 3px;
        }

        .tracker-item {
            display: flex;
            align-items: center;
            gap: 10px;
            padding: 8px 10px;
            border-radius: var(--radius-sm);
            text-decoration: none;
            transition: var(--transition);
            color: var(--text-muted);
            font-size: 13px;
            font-weight: 500;
            position: relative;
        }

        .tracker-item:hover {
            background: var(--bg-alt);
            color: var(--text-primary);
        }

        .tracker-item.done {
            color: var(--text-secondary);
        }

        .tracker-item.done:hover {
            background: var(--primary-50);
            color: var(--primary);
        }

        .tracker-circle {
            width: 28px;
            height: 28px;
            border-radius: 50%;
            border: 1.5px solid var(--border);
            background: var(--surface);
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 11px;
            font-weight: 700;
            transition: var(--transition);
            flex-shrink: 0;
            color: var(--text-muted);
        }

        .tracker-item.done .tracker-circle {
            border-color: var(--primary);
            background: var(--primary-50);
            color: var(--primary-dark);
        }

        /* -- Top Navbar -- */
        .top-bar {
            position: fixed;
            top: 0;
            left: 260px;
            right: 0;
            height: 64px;
            background: rgba(255, 255, 255, 0.92);
            backdrop-filter: blur(20px);
            -webkit-backdrop-filter: blur(20px);
            border-bottom: 1px solid var(--border);
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding: 0 48px;
            z-index: 50;
            box-shadow: var(--shadow-xs);
            transition: left 0.3s cubic-bezier(0.4, 0, 0.2, 1);
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

        /* Global progress pill in top bar */
        .top-bar-progress {
            display: flex;
            align-items: center;
            gap: 12px;
        }

        .progress-pill {
            display: flex;
            align-items: center;
            gap: 8px;
            background: var(--bg-alt);
            border: 1px solid var(--border);
            padding: 7px 16px;
            border-radius: var(--radius-full);
            font-size: 13px;
            font-weight: 600;
            color: var(--text-secondary);
        }

        .progress-pill-dot {
            width: 8px;
            height: 8px;
            border-radius: 50%;
            background: var(--primary);
        }

        .top-bar-right {
            display: flex;
            align-items: center;
            gap: 8px;
        }

        /* -- Main Content -- */
        .main-content {
            flex: 1;
            margin-left: 260px;
            padding: 100px 52px 120px;
            min-height: 100vh;
        }

        /* -- Section Badge -- */
        .section-badge {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            padding: 7px 16px;
            border-radius: var(--radius-full);
            font-size: 11px;
            font-weight: 700;
            letter-spacing: 0.5px;
            text-transform: uppercase;
            margin-bottom: 24px;
        }

        .section-badge::before {
            content: '';
            width: 6px;
            height: 6px;
            border-radius: 50%;
        }

        .section-badge.aptitude {
            background: var(--primary-50);
            color: var(--primary-dark);
            border: 1px solid var(--primary-100);
        }

        .section-badge.aptitude::before {
            background: var(--primary);
        }

        .section-badge.personality {
            background: #F0FDFA;
            color: #0D9488;
            border: 1px solid #CCFBF1;
        }

        .section-badge.personality::before {
            background: #0D9488;
        }

        .section-badge.interest {
            background: var(--success-bg);
            color: #15803D;
            border: 1px solid var(--success-border);
        }

        .section-badge.interest::before {
            background: var(--success);
        }

        /* -- Question Card -- */
        .question-card {
            background: var(--surface);
            border: 1.5px solid var(--border);
            border-radius: var(--radius-xl);
            padding: 36px 40px;
            margin-bottom: 18px;
            transition: var(--transition);
            box-shadow: var(--shadow-sm);
        }

        .question-card:hover,
        .question-card:focus-within {
            border-color: var(--primary-200);
            box-shadow: var(--shadow-md), 0 0 0 3px rgba(37, 99, 235, 0.04);
        }

        .q-header {
            display: flex;
            align-items: flex-start;
            gap: 14px;
            margin-bottom: 24px;
            max-width: 100%;
        }

        .q-badge {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            padding: 5px 12px;
            background: var(--bg-alt);
            border: 1px solid var(--border);
            border-radius: var(--radius-sm);
            font-size: 12px;
            font-weight: 700;
            color: var(--text-muted);
            white-space: nowrap;
            flex-shrink: 0;
            margin-top: 2px;
            font-family: 'Plus Jakarta Sans', sans-serif;
        }

        .q-text {
            font-size: 17px;
            font-weight: 500;
            color: var(--text-primary);
            line-height: 1.65;
        }

        /* -- MCQ Options -- */
        .options-list {
            display: flex;
            flex-direction: column;
            gap: 10px;
            max-width: 100%;
        }

        .option-label {
            display: flex;
            align-items: center;
            gap: 14px;
            padding: 14px 18px;
            background: var(--bg);
            border: 1.5px solid var(--border);
            border-radius: var(--radius-md);
            cursor: pointer;
            transition: var(--transition);
            color: var(--text-secondary);
            font-size: 14px;
            font-weight: 500;
            user-select: none;
        }

        .option-label:hover {
            background: var(--primary-50);
            border-color: var(--primary-200);
            color: var(--text-primary);
        }

        .option-label:has(input:checked) {
            background: var(--primary-50);
            border-color: var(--primary);
            color: var(--text-primary);
            box-shadow: 0 0 0 3px rgba(37, 99, 235, 0.08);
        }

        /* -- Likert Scale -- */
        .likert-scale {
            display: flex;
            gap: 10px;
            max-width: 100%;
        }

        .likert-label {
            flex: 1;
            display: flex;
            flex-direction: column;
            align-items: center;
            gap: 8px;
            padding: 16px 8px;
            background: var(--bg);
            border: 1.5px solid var(--border);
            border-radius: var(--radius-md);
            cursor: pointer;
            transition: var(--transition);
            text-align: center;
            user-select: none;
        }

        .likert-label:hover {
            background: var(--primary-50);
            border-color: var(--primary-200);
        }

        .likert-label:has(input:checked) {
            background: var(--primary-50);
            border-color: var(--primary);
            box-shadow: 0 0 0 3px rgba(37, 99, 235, 0.08);
        }

        .likert-val {
            font-size: 12px;
            color: var(--text-muted);
            font-weight: 500;
            line-height: 1.4;
        }

        .likert-label:has(input:checked) .likert-val {
            color: var(--primary-dark);
            font-weight: 700;
        }

        /* -- Custom Radio -- */
        input[type="radio"] {
            appearance: none;
            -webkit-appearance: none;
            width: 18px;
            height: 18px;
            border: 2px solid var(--border-strong);
            border-radius: 50%;
            margin: 0;
            position: relative;
            cursor: pointer;
            transition: var(--transition);
            flex-shrink: 0;
            background: var(--surface);
        }

        input[type="radio"]:checked {
            border-color: var(--primary);
            background: var(--surface);
        }

        input[type="radio"]:checked::after {
            content: '';
            position: absolute;
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%);
            width: 8px;
            height: 8px;
            background: var(--primary);
            border-radius: 50%;
        }

        /* -- Bottom Submit Bar -- */
        .submit-bar {
            position: fixed;
            bottom: 0;
            left: 260px;
            right: 0;
            height: 76px;
            background: rgba(255, 255, 255, 0.95);
            backdrop-filter: blur(20px);
            -webkit-backdrop-filter: blur(20px);
            border-top: 1px solid var(--border);
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding: 0 52px;
            z-index: 50;
            box-shadow: 0 -4px 24px rgba(15, 23, 42, 0.06);
        }

        .submit-info {
            display: flex;
            align-items: center;
            gap: 14px;
        }

        .submit-icon {
            width: 42px;
            height: 42px;
            background: var(--primary-50);
            border: 1px solid var(--primary-100);
            border-radius: var(--radius-md);
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 18px;
        }

        .submit-text {
            font-size: 15px;
            font-weight: 700;
            color: var(--text-primary);
            margin-bottom: 2px;
            font-family: 'Plus Jakarta Sans', sans-serif;
        }

        .submit-subtext {
            font-size: 12px;
            color: var(--text-muted);
        }

        .btn-submit {
            background: var(--accent-gradient);
            color: #fff;
            border: none;
            padding: 12px 28px;
            border-radius: var(--radius-md);
            font-size: 15px;
            font-weight: 700;
            font-family: 'Plus Jakarta Sans', sans-serif;
            cursor: pointer;
            display: flex;
            align-items: center;
            gap: 10px;
            transition: var(--transition);
            box-shadow: var(--accent-glow);
            letter-spacing: -0.01em;
        }

        .btn-submit:hover {
            transform: translateY(-1px);
            box-shadow: 0 10px 30px rgba(249, 115, 22, 0.4);
        }

        /* -- Responsive -- */
        @media (max-width: 1024px) {
            .sidebar {
                width: 280px;
                transform: translateX(-100%);
                z-index: 1000;
                box-shadow: var(--shadow-xl);
            }

            body.sidebar-open .sidebar {
                transform: translateX(0) !important;
            }

            body.sidebar-open .sidebar-overlay {
                display: block !important;
                opacity: 1 !important;
                visibility: visible !important;
            }

            .main-content {
                margin-left: 0;
                padding: 80px 20px 110px;
            }

            .top-bar {
                left: 0;
                padding: 0 20px;
            }

            .mobile-menu-btn {
                display: flex !important;
            }

            .submit-bar {
                left: 0;
                padding: 0 20px;
            }

            .options-list, .q-header {
                max-width: 100%;
            }

            .likert-scale {
                max-width: 100%;
                flex-wrap: wrap;
            }

            .likert-label {
                min-width: 80px;
            }
        }
    </style>
</head>
<body>
<div class="sidebar-overlay" id="sidebarOverlay"></div>
<div class="app-shell">

    <!-- Left Sidebar -->
    <aside class="sidebar">
        <div class="sidebar-top">
            <a href="#" class="sidebar-logo">
                <img src="${pageContext.request.contextPath}/images/logo.svg?v=1.1" alt="DISHA">
                <div>
                    <div class="sidebar-brand-name">DISHA</div>
                    <div class="sidebar-brand-tagline">Career Portal</div>
                </div>
            </a>

            <div class="sidebar-progress-wrap">
                <div class="sidebar-progress-header">
                    <span class="sidebar-progress-label">Progress</span>
                    <span class="sidebar-progress-count" id="sidebarProgressCount">0 / 30</span>
                </div>
                <div class="sidebar-progress-bar">
                    <div class="sidebar-progress-fill" id="sidebarProgressFill"></div>
                </div>
            </div>
        </div>

        <div class="sidebar-body">
            <div class="tracker-label">Question Groups</div>
            <div class="tracker-list">
                <c:forEach begin="1" end="10" var="i">
                    <a href="#q${(i-1)*3 + 1}" class="tracker-item" id="tracker-${i}">
                        <div class="tracker-circle">${i}</div>
                        <span>Q${(i-1)*3 + 1} – Q${i*3}</span>
                    </a>
                </c:forEach>
            </div>
        </div>
    </aside>

    <!-- Top Bar -->
    <nav class="top-bar">
        <button class="mobile-menu-btn" id="mobileMenuBtn">☰</button>
        <div class="top-bar-progress">
            <div class="progress-pill">
                <div class="progress-pill-dot"></div>
                <span id="navProgressText">0 / 30 answered</span>
            </div>
        </div>
        <div class="top-bar-right">
            <div class="nav-avatar avatar">S</div>
        </div>
    </nav>

    <!-- Main Content -->
    <main class="main-content">
        <form method="post" action="${pageContext.request.contextPath}/assessment/submit" id="assessmentForm">
            <input type="hidden" name="attemptId" value="${attemptId}">

            <!-- Section A -->
            <div class="section-badge aptitude">Section A &bull; Aptitude</div>

            <c:forEach var="q" items="${questions}" varStatus="status">

                <c:if test="${q.questionOrder == 11}">
                    <div class="section-badge personality" style="margin-top: 48px;">Section B &bull; Personality</div>
                </c:if>

                <c:if test="${q.questionOrder == 21}">
                    <div class="section-badge interest" style="margin-top: 48px;">Section C &bull; Interest</div>
                </c:if>

                <div class="question-card" id="q${q.questionOrder}">
                    <div class="q-header">
                        <div class="q-badge">Q${q.questionOrder}</div>
                        <div class="q-text">${q.questionText}</div>
                    </div>

                    <c:if test="${q.questionType == 'MCQ'}">
                        <div class="options-list">
                            <c:forEach var="opt" items="${q.options}">
                                <label class="option-label" for="opt-${opt.optionId}">
                                    <input type="radio" id="opt-${opt.optionId}" name="q_${q.questionId}"
                                           value="${opt.optionId}" class="answer-radio" data-qorder="${q.questionOrder}"
                                           required>
                                        ${opt.optionText}
                                </label>
                            </c:forEach>
                        </div>
                    </c:if>

                    <c:if test="${q.questionType == 'LIKERT'}">
                        <div class="likert-scale">
                            <c:forEach var="opt" items="${q.options}">
                                <label class="likert-label" for="opt-${opt.optionId}">
                                    <input type="radio" id="opt-${opt.optionId}" name="q_${q.questionId}"
                                           value="${opt.optionId}" class="answer-radio" data-qorder="${q.questionOrder}"
                                           required>
                                    <span class="likert-val">${opt.optionText}</span>
                                </label>
                            </c:forEach>
                        </div>
                    </c:if>
                </div>
            </c:forEach>
        </form>
    </main>

    <!-- Bottom Submit Bar -->
    <div class="submit-bar">
        <div class="submit-info">
            <div class="submit-icon">📋</div>
            <div>
                <div class="submit-text" id="bottomProgressText">0 of 30 answered</div>
                <div class="submit-subtext">Answer all 30 questions then submit</div>
            </div>
        </div>
        <button type="submit" form="assessmentForm" class="btn-submit" id="btnSubmitAssessment">
            Submit Assessment →
        </button>
    </div>

</div>

<script>
    function updateProgress() {
        var groups = {};
        var radios = document.querySelectorAll('input.answer-radio:checked');

        radios.forEach(function (radio) {
            groups[radio.name] = true;
            var order = parseInt(radio.getAttribute('data-qorder'));
            var trackerIdx = Math.ceil(order / 3);
            if (trackerIdx > 10) trackerIdx = 10;
            var item = document.getElementById('tracker-' + trackerIdx);
            if (item) item.classList.add('done');
        });

        var count = Object.keys(groups).length;
        var pct = Math.round((count / 30) * 100);

        // Update texts
        document.getElementById('navProgressText').textContent = count + ' / 30 answered';
        document.getElementById('bottomProgressText').textContent = count + ' of 30 answered';
        document.getElementById('sidebarProgressCount').textContent = count + ' / 30';

        // Update progress bar
        var fill = document.getElementById('sidebarProgressFill');
        if (fill) fill.style.width = pct + '%';
    }

    var allRadios = document.querySelectorAll('input.answer-radio');
    for (var i = 0; i < allRadios.length; i++) {
        allRadios[i].addEventListener('change', updateProgress);
    }

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
