package com.disha.controller.parent;

import com.disha.dao.parent.ParentDashboardDAO;
import com.disha.model.User;
import com.disha.model.parent.ParentDashboardData;
import com.disha.util.SessionUtil;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.SQLException;

@WebServlet("/parent/dashboard")
public class ParentDashboardServlet extends HttpServlet {
    private static final int DEFAULT_BUDGET_NPR = 200000;
    private final ParentDashboardDAO dashboardDAO = new ParentDashboardDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        User user = SessionUtil.getLoggedInUser(request);
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/JSP/auth/login.jsp");
            return;
        }
        if (!User.Role.PARENT.equals(user.getRole())) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }

        int budget = parseBudget(request.getParameter("budget"));
        try {
            ParentDashboardData data = dashboardDAO.loadDashboard(user.getUserId(), budget);
            request.setAttribute("dashboardData", data);
            request.getRequestDispatcher("/JSP/parent/dashboard.jsp").forward(request, response);
        } catch (SQLException e) {
            log("Parent dashboard load failed", e);
            request.setAttribute("errorMessage", "Unable to load parent dashboard data right now.");
            request.getRequestDispatcher("/JSP/parent/dashboard.jsp").forward(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int budget = parseBudget(request.getParameter("budget"));
        response.sendRedirect(request.getContextPath() + "/parent/dashboard?budget=" + budget);
    }

    private int parseBudget(String value) {
        if (value == null || value.trim().isEmpty()) {
            return DEFAULT_BUDGET_NPR;
        }
        try {
            int parsed = Integer.parseInt(value.trim());
            if (parsed < 10000) return 10000;
            if (parsed > 5000000) return 5000000;
            return parsed;
        } catch (NumberFormatException e) {
            return DEFAULT_BUDGET_NPR;
        }
    }
}
