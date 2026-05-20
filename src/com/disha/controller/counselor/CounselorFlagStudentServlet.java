package com.disha.controller.counselor;

import com.disha.dao.counselor.CounselorDashboardDAO;
import com.disha.model.User;
import com.disha.util.SessionUtil;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.SQLException;

@WebServlet("/counselor/flag-student")
public class CounselorFlagStudentServlet extends HttpServlet {
    private final CounselorDashboardDAO dashboardDAO = new CounselorDashboardDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
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

        int studentId = parseInt(request.getParameter("studentId"));
        boolean atRisk = "true".equalsIgnoreCase(request.getParameter("atRisk"));
        String note = request.getParameter("note");

        if (studentId <= 0) {
            response.sendRedirect(request.getContextPath() + "/counselor/dashboard?flagError=invalid");
            return;
        }

        try {
            dashboardDAO.updateStudentFlag(user.getUserId(), studentId, atRisk, note);
            response.sendRedirect(request.getContextPath() + "/counselor/dashboard?flagSuccess=true");
        } catch (SQLException e) {
            log("Counselor flag update failed", e);
            response.sendRedirect(request.getContextPath() + "/counselor/dashboard?flagError=database");
        }
    }

    private int parseInt(String value) {
        try {
            return Integer.parseInt(value);
        } catch (Exception e) {
            return 0;
        }
    }
}
