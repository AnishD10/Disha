package com.disha.controller.counselor;

import com.disha.dao.counselor.CounselorDashboardDAO;
import com.disha.model.User;
import com.disha.model.counselor.CounselorDashboardData;
import com.disha.util.SessionUtil;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.SQLException;

@WebServlet("/counselor/dashboard")
public class CounselorDashboardServlet extends HttpServlet {
    private final CounselorDashboardDAO dashboardDAO = new CounselorDashboardDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        User user = requireCounselorOrAdmin(request, response);
        if (user == null) {
            return;
        }

        String search = trim(request.getParameter("search"));
        boolean flaggedOnly = "true".equalsIgnoreCase(request.getParameter("flaggedOnly"));

        try {
            CounselorDashboardData data = dashboardDAO.loadDashboard(
                    user.getUserId(), search, flaggedOnly);
            request.setAttribute("dashboardData", data);
            request.setAttribute("search", search);
            request.setAttribute("flaggedOnly", flaggedOnly);
            request.getRequestDispatcher("/JSP/counselor/dashboard.jsp").forward(request, response);
        } catch (SQLException e) {
            log("Counselor dashboard load failed", e);
            request.setAttribute("errorMessage", "Unable to load counselor dashboard data right now.");
            request.getRequestDispatcher("/JSP/counselor/dashboard.jsp").forward(request, response);
        }
    }

    private User requireCounselorOrAdmin(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        User user = SessionUtil.getLoggedInUser(request);
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/JSP/auth/login.jsp");
            return null;
        }
        if (!User.Role.COUNSELOR.equals(user.getRole()) && !User.Role.ADMIN.equals(user.getRole())) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN);
            return null;
        }
        return user;
    }

    private String trim(String value) {
        return value == null ? "" : value.trim();
    }
}
