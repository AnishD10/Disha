<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%--
    LOCAL TEST ONLY.
    This page bypasses the real login flow by creating a student session for the
    local career-module smoke test. Do not deploy this page in production or use
    it as the integration login path.
--%>
<%
    session.setAttribute("role", "STUDENT");
    session.setAttribute("studentId", 15);
    session.setAttribute("userId", 15);
    response.sendRedirect(request.getContextPath() + "/career");
%>
