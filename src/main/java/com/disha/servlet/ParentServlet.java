package com.disha.servlet;

import com.disha.dao.ParentDAO;
import com.disha.model.ParentDashboardData;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.SQLException;

@WebServlet("/parent-dashboard")
public class ParentServlet extends HttpServlet {

    private final ParentDAO parentDAO = new ParentDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String role = (String) session.getAttribute("role");
        if (!"PARENT".equals(role)) {
            response.sendRedirect(request.getContextPath() + "/login?error=unauthorized");
            return;
        }

        int parentUserId = (int) session.getAttribute("userId");

        try {
            int studentId = parentDAO.getLinkedStudentId(parentUserId);
            if (studentId == -1) {
                request.setAttribute("errorMessage",
                    "No student account is linked to your profile. Please contact your counselor.");
                request.getRequestDispatcher("/JSP/parent/dashboard.jsp").forward(request, response);
                return;
            }

            String childName = parentDAO.getChildName(studentId);
            ParentDashboardData data = parentDAO.getAptitudeResult(studentId);
            data.setChildName(childName);
            data.setMatchedCareers(parentDAO.getMatchedCareers(studentId));

            int budget = 200000;
            String budgetParam = request.getParameter("budget");
            if (budgetParam != null && !budgetParam.isEmpty()) {
                try { budget = Integer.parseInt(budgetParam); }
                catch (NumberFormatException ignored) {}
            }
            data.setDegreeOptions(parentDAO.getDegreesByBudget(budget));

            request.setAttribute("dashboardData", data);
            request.setAttribute("selectedBudget", budget);
            request.getRequestDispatcher("/JSP/parent/dashboard.jsp").forward(request, response);

        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("errorMessage", "A database error occurred. Please try again later.");
            request.getRequestDispatcher("/JSP/parent/dashboard.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String budget = request.getParameter("budget");
        response.sendRedirect(request.getContextPath() + "/parent-dashboard?budget=" + budget);
    }
}
