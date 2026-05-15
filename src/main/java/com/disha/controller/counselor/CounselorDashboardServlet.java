package com.disha.controller.counselor;

import com.disha.dao.counselor.CounselorDAO;
import com.disha.model.assessment.AssessmentAttempt;
import com.disha.model.auth.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

// CounselorDashboardServlet loads all students and their latest attempt data.
// Only users with role COUNSELOR or ADMIN can access this.
@WebServlet("/counselor/dashboard")
public class CounselorDashboardServlet extends HttpServlet {

    private CounselorDAO counselorDAO = new CounselorDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("loggedInUser") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        User loggedInUser = (User) session.getAttribute("loggedInUser");
        String role = loggedInUser.getRole();
        if (!role.equals("COUNSELOR") && !role.equals("ADMIN")) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String filter = request.getParameter("filter");
        List<User> students;
        if ("flagged".equals(filter)) {
            students = counselorDAO.getFlaggedStudents();
            request.setAttribute("activeFilter", "flagged");
        } else {
            students = counselorDAO.getAllStudents();
            request.setAttribute("activeFilter", "all");
        }

        // Build a map of studentId to latest attempt so the JSP can display scores per student.
        Map<Integer, AssessmentAttempt> latestAttempts = new HashMap<Integer, AssessmentAttempt>();
        for (User student : students) {
            AssessmentAttempt latest = counselorDAO.getLatestAttempt(student.getUserId());
            if (latest != null) {
                latestAttempts.put(student.getUserId(), latest);
            }
        }

        double avgAptitude  = counselorDAO.getAverageAptitudeScore();
        String topCluster   = counselorDAO.getMostCommonCluster();
        int totalAttempts   = counselorDAO.getTotalAttempts();

        request.setAttribute("students", students);
        request.setAttribute("latestAttempts", latestAttempts);
        request.setAttribute("avgAptitude", String.format("%.1f", avgAptitude));
        request.setAttribute("topCluster", topCluster);
        request.setAttribute("totalAttempts", totalAttempts);

        // Flash messages after add-student redirect
        String addSuccess = request.getParameter("addSuccess");
        String addError   = request.getParameter("addError");
        if ("1".equals(addSuccess)) {
            request.setAttribute("addSuccess", true);
        } else if ("duplicate".equals(addError)) {
            request.setAttribute("addError", "A student with that email already exists.");
        } else if ("empty".equals(addError)) {
            request.setAttribute("addError", "Please fill in all required fields.");
        }

        request.getRequestDispatcher("/jsp/counselor/dashboard.jsp").forward(request, response);
    }
}
