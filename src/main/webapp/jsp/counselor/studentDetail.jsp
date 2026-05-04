<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${student.fullName} - DISHA Counselor</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/main.css?v=5">
    <style>
        body {
            background: var(--bg);
            background-image: radial-gradient(ellipse 70% 50% at 85% 5%, rgba(37,99,235,0.05) 0%, transparent 55%);
        }

        .page-wrap {
            max-width: 920px;
            margin: 0 auto;
            padding: 36px 24px 80px;
        }

        /* ── Back button ── */
        .back-btn {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            font-size: 13px;
            font-weight: 600;
            color: var(--text-secondary);
            margin-bottom: 28px;
            transition: var(--transition);
            background: var(--surface);
            border: 1px solid var(--border);
            padding: 8px 16px;
            border-radius: var(--radius-md);
            box-shadow: var(--shadow-xs);
            text-decoration: none;
        }

        .back-btn:hover {
            color: var(--primary);
            border-color: var(--primary-200);
            background: var(--primary-50);
            transform: translateX(-2px);
        }

        /* ── Profile Card ── */
        .profile-card {
            background: var(--surface);
            border: 1px solid var(--border);
            border-radius: var(--radius-xl);
            padding: 32px;
            display: flex;
            align-items: flex-start;
            gap: 24px;
            margin-bottom: 20px;
            flex-wrap: wrap;
            box-shadow: var(--shadow-md);
            position: relative;
            overflow: hidden;
        }

        .profile-card::before {
            content: '';
            position: absolute;
            top: 0; left: 0; right: 0;
            height: 4px;
            background: var(--primary-gradient);
        }

        .profile-avatar {
            width: 72px;
            height: 72px;
            border-radius: 50%;
            background: var(--primary-gradient);
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 28px;
            font-weight: 800;
            color: #fff;
            box-shadow: var(--primary-glow);
            flex-shrink: 0;
            font-family: 'Plus Jakarta Sans', sans-serif;
        }

        .profile-info { flex: 1; min-width: 200px; }

        .profile-info h1 {
            font-size: 22px;
            font-weight: 800;
            font-family: 'Plus Jakarta Sans', sans-serif;
            letter-spacing: -0.03em;
            margin-bottom: 4px;
        }

        .profile-email {
            font-size: 13px;
            color: var(--text-muted);
            margin-bottom: 16px;
        }

        .status-flag-active {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            padding: 6px 14px;
            border-radius: var(--radius-full);
            font-size: 12px;
            font-weight: 700;
            background: var(--danger-bg);
            border: 1px solid var(--danger-border);
            color: #B91C1C;
        }

        .status-flag-normal {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            padding: 6px 14px;
            border-radius: var(--radius-full);
            font-size: 12px;
            font-weight: 700;
            background: var(--success-bg);
            border: 1px solid var(--success-border);
            color: #15803D;
        }

        /* ── Note Card ── */
        .note-card {
            background: var(--surface);
            border: 1px solid var(--border);
            border-radius: var(--radius-xl);
            padding: 28px 32px;
            margin-bottom: 32px;
            box-shadow: var(--shadow-sm);
        }

        .note-card-header {
            display: flex;
            align-items: center;
            gap: 10px;
            margin-bottom: 22px;
        }

        .note-card-icon {
            width: 38px;
            height: 38px;
            border-radius: var(--radius-sm);
            background: var(--primary-50);
            border: 1px solid var(--primary-100);
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 17px;
        }

        .note-card-title {
            font-size: 16px;
            font-weight: 700;
            color: var(--text-primary);
            font-family: 'Plus Jakarta Sans', sans-serif;
            letter-spacing: -0.02em;
        }

        .note-form-row {
            display: grid;
            grid-template-columns: 180px 1fr auto;
            gap: 14px;
            align-items: end;
        }

        .note-form-label {
            font-size: 12px;
            font-weight: 600;
            color: var(--text-secondary);
            margin-bottom: 7px;
            display: block;
            letter-spacing: -0.01em;
        }

        .custom-select {
            width: 100%;
            background: var(--surface);
            border: 1.5px solid var(--border);
            border-radius: var(--radius-md);
            color: var(--text-primary);
            font-size: 14px;
            font-family: 'Inter', sans-serif;
            padding: 10px 14px;
            transition: var(--transition);
            outline: none;
            cursor: pointer;
            appearance: none;
            background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='12' height='8' viewBox='0 0 12 8'%3E%3Cpath d='M1 1l5 5 5-5' stroke='%2394A3B8' stroke-width='1.5' fill='none' stroke-linecap='round'/%3E%3C/svg%3E");
            background-repeat: no-repeat;
            background-position: right 12px center;
            padding-right: 36px;
        }

        .custom-select:focus {
            border-color: var(--primary);
            box-shadow: 0 0 0 3px rgba(37, 99, 235, 0.1);
        }

        .custom-textarea {
            width: 100%;
            background: var(--surface);
            border: 1.5px solid var(--border);
            border-radius: var(--radius-md);
            color: var(--text-primary);
            font-size: 14px;
            font-family: 'Inter', sans-serif;
            padding: 10px 14px;
            transition: var(--transition);
            outline: none;
            min-height: 80px;
            resize: vertical;
            line-height: 1.6;
        }

        .custom-textarea::placeholder { color: var(--text-muted); }

        .custom-textarea:focus {
            border-color: var(--primary);
            box-shadow: 0 0 0 3px rgba(37, 99, 235, 0.1);
        }

        .existing-note {
            margin-top: 20px;
            padding: 16px 18px;
            background: var(--bg-alt);
            border-radius: var(--radius-md);
            border: 1px solid var(--border);
            font-size: 14px;
            color: var(--text-primary);
            line-height: 1.65;
        }

        .existing-note-label {
            font-size: 10px;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 1px;
            color: var(--text-muted);
            display: block;
            margin-bottom: 8px;
        }

        /* ── History Section ── */
        .section-title {
            font-size: 16px;
            font-weight: 700;
            font-family: 'Plus Jakarta Sans', sans-serif;
            color: var(--text-primary);
            margin-bottom: 16px;
            display: flex;
            align-items: center;
            gap: 10px;
            letter-spacing: -0.02em;
        }

        .section-title::after {
            content: '';
            flex: 1;
            height: 1px;
            background: var(--border);
        }

        .score-num { font-weight: 700; font-size: 14px; }
        .apt { color: var(--primary-dark); }
        .per { color: var(--info); }
        .int { color: #16A34A; }

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
            text-decoration: none;
        }

        .view-link:hover {
            background: var(--primary-100);
            border-color: var(--primary-200);
        }

        @media (max-width: 680px) {
            .note-form-row { grid-template-columns: 1fr; }
        }
    </style>
</head>
<body>
<div class="page-wrap">

    <a href="${pageContext.request.contextPath}/counselor/dashboard" class="back-btn animate-fade-in">
        ← Back to Dashboard
    </a>

    <!-- Profile Card -->
    <div class="profile-card animate-fade-in delay-1">
        <div class="profile-avatar">
            ${fn:toUpperCase(fn:substring(student.fullName, 0, 1))}
        </div>
        <div class="profile-info">
            <h1>${student.fullName}</h1>
            <p class="profile-email">${student.email}</p>
            <c:if test="${student.flagged}">
                <span class="status-flag-active">🚩 Flagged as At-Risk</span>
            </c:if>
            <c:if test="${!student.flagged}">
                <span class="status-flag-normal">✓ No concerns flagged</span>
            </c:if>
        </div>
    </div>

    <!-- Counselor Note Card -->
    <div class="note-card animate-fade-in delay-2">
        <div class="note-card-header">
            <div class="note-card-icon">📝</div>
            <div class="note-card-title">Counselor Flag &amp; Note</div>
        </div>
        <form method="post" action="${pageContext.request.contextPath}/counselor/flag">
            <input type="hidden" name="studentId" value="${student.userId}">
            <div class="note-form-row">
                <div>
                    <label class="note-form-label">Flag Status</label>
                    <select name="flagged" class="custom-select">
                        <option value="false" ${!student.flagged ? 'selected' : ''}>Normal</option>
                        <option value="true"  ${student.flagged  ? 'selected' : ''}>At-Risk</option>
                    </select>
                </div>
                <div>
                    <label class="note-form-label">Counselor Note</label>
                    <textarea name="counselorNote" class="custom-textarea" placeholder="Add a private note about this student...">${student.counselorNote}</textarea>
                </div>
                <button type="submit" class="btn-accent" style="padding: 11px 22px; white-space: nowrap; align-self: end;">
                    Save Note
                </button>
            </div>
        </form>

        <c:if test="${not empty student.counselorNote}">
            <div class="existing-note">
                <span class="existing-note-label">Current Note:</span>
                ${student.counselorNote}
            </div>
        </c:if>
    </div>

    <!-- Assessment History -->
    <div class="section-title animate-fade-in delay-3">📊 Assessment History</div>

    <div class="glass-panel table-responsive animate-fade-in delay-3">
        <table class="modern-table" style="margin: 0;">
            <thead>
                <tr>
                    <th>#</th>
                    <th>Date</th>
                    <th>Cluster</th>
                    <th>Aptitude</th>
                    <th>Personality</th>
                    <th>Interest</th>
                    <th>Report</th>
                </tr>
            </thead>
            <tbody>
                <c:if test="${empty attempts}">
                    <tr>
                        <td colspan="7" style="text-align: center; padding: 60px; color: var(--text-muted);">
                            <div style="font-size: 36px; margin-bottom: 12px;">📭</div>
                            <div style="font-weight: 600; margin-bottom: 4px;">No assessments yet</div>
                            <div style="font-size: 13px;">This student has not completed any assessments yet.</div>
                        </td>
                    </tr>
                </c:if>
                <c:forEach var="attempt" items="${attempts}" varStatus="status">
                    <tr>
                        <td>
                            <span style="font-size: 12px; font-weight: 700; color: var(--text-muted);">${status.count}</span>
                        </td>
                        <td style="color:var(--text-secondary); font-size:13px;">${attempt.attemptDate}</td>
                        <td>
                            <span class="badge ${fn:toLowerCase(attempt.personalityCluster)}">${attempt.personalityCluster}</span>
                        </td>
                        <td><span class="score-num apt">${attempt.aptitudeScore}</span><span style="color:var(--text-muted);font-size:12px;">/10</span></td>
                        <td><span class="score-num per">${attempt.personalityScore}</span><span style="color:var(--text-muted);font-size:12px;">/50</span></td>
                        <td><span class="score-num int">${attempt.interestScore}</span><span style="color:var(--text-muted);font-size:12px;">/50</span></td>
                        <td>
                            <a href="${pageContext.request.contextPath}/assessment/result?attemptId=${attempt.attemptId}" class="view-link">
                                View →
                            </a>
                        </td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
    </div>

</div>
</body>
</html>
