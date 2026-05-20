<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, com.disha.model.assessment.Question, com.disha.model.assessment.Option" %>
<%
    List<Question> questions = (List<Question>) request.getAttribute("questions");
    Integer attemptId = (Integer) request.getAttribute("attemptId");
    if (questions == null || attemptId == null) {
        response.sendRedirect(request.getContextPath() + "/assessment/start");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Assessment Questions - DISHA</title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/disha-main.css">
</head>
<body>
<div class="dashboard-layout">
    <jsp:include page="../includes/sidebar.jsp" />
    <div class="main-content">
        <jsp:include page="../includes/dashboard-header.jsp" />
        <main class="dashboard-body">
            <div class="page-header" style="margin-bottom:2rem;">
                <h1 style="color:var(--color-primary);">Aptitude Assessment</h1>
                <p style="color:var(--color-text-muted);">Complete every question before submitting.</p>
            </div>
            <form method="post" action="<%= request.getContextPath() %>/assessment/submit">
                <input type="hidden" name="attemptId" value="<%= attemptId %>">
                <% for (Question q : questions) { %>
                    <div class="card" style="margin-bottom:1rem;">
                        <div style="display:flex; justify-content:space-between; gap:1rem; margin-bottom:1rem;">
                            <h3 style="font-size:1rem;">Q<%= q.getQuestionOrder() %>. <%= q.getQuestionText() %></h3>
                            <span class="badge badge-warning"><%= q.getSection() %></span>
                        </div>
                        <div style="display:grid; gap:.65rem;">
                            <% for (Option option : q.getOptions()) { %>
                                <label style="display:flex; align-items:center; gap:.65rem; padding:.75rem; border:1px solid var(--color-border); border-radius:var(--radius-md);">
                                    <input type="radio" name="q_<%= q.getQuestionId() %>" value="<%= option.getOptionId() %>" required style="width:auto;">
                                    <span><%= option.getOptionText() %></span>
                                </label>
                            <% } %>
                        </div>
                    </div>
                <% } %>
                <button type="submit" class="btn btn-primary" style="width:auto;">Submit Assessment</button>
            </form>
        </main>
    </div>
</div>
</body>
</html>
