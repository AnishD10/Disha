package com.disha.controller.counselor;

import com.disha.dao.counselor.CounselorDashboardDAO;
import com.disha.model.User;
import com.disha.model.counselor.CounselorDashboardData.StudentSummary;
import com.disha.util.SessionUtil;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

@WebServlet("/counselor/export")
public class CounselorExportServlet extends HttpServlet {
    private final CounselorDashboardDAO dashboardDAO = new CounselorDashboardDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        User user = SessionUtil.getLoggedInUser(request);
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/JSP/auth/login.jsp");
            return;
        }
        if (!User.Role.COUNSELOR.equals(user.getRole()) && !User.Role.ADMIN.equals(user.getRole())) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }

        response.setContentType("text/csv; charset=UTF-8");
        response.setHeader("Content-Disposition", "attachment; filename=\"disha-student-reports.csv\"");
        try {
            List<StudentSummary> students = dashboardDAO.loadStudents(user.getUserId(), "", false);
            response.getWriter().println("Student,Email,Assessment Status,Aptitude Score,Cluster,At Risk,Note");
            for (StudentSummary student : students) {
                response.getWriter().println(csv(student.getFullName()) + "," +
                        csv(student.getEmail()) + "," +
                        csv(student.getAssessmentStatusLabel()) + "," +
                        csv(student.getAptitudeScore() == null ? "" : String.valueOf(student.getAptitudeScore())) + "," +
                        csv(student.getPersonalityCluster()) + "," +
                        csv(student.isAtRisk() ? "Yes" : "No") + "," +
                        csv(student.getCounselorNote()));
            }
        } catch (SQLException e) {
            log("Counselor export failed", e);
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                    "Unable to export counselor report.");
        }
    }

    private String csv(String value) {
        String safe = value == null ? "" : value;
        return "\"" + safe.replace("\"", "\"\"") + "\"";
    }
}
