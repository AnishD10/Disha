<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="utils.DBUtil" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%--
    LOCAL TEST ONLY.
    This page bypasses the real login flow by creating a student session for the
    local career-module smoke test. Do not deploy this page in production or use
    it as the integration login path.
--%>
<%
    int studentId = 0;
    try (Connection conn = DBUtil.getConnection();
         PreparedStatement ps = conn.prepareStatement(
                 "SELECT user_id FROM users WHERE email = ? AND role = 'STUDENT' AND is_active = TRUE")) {
        ps.setString(1, "career_test_student@disha.local");
        try (ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                studentId = rs.getInt("user_id");
            }
        }
    }

    if (studentId <= 0) {
        response.sendError(500, "Local career test student was not found. Run database/local_career_sample_student.sql first.");
        return;
    }

    session.setAttribute("role", "STUDENT");
    session.setAttribute("studentId", studentId);
    session.setAttribute("userId", studentId);
    response.sendRedirect(request.getContextPath() + "/career");
%>
