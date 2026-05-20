package com.disha.controller;

import dao.UserDAO;
import dao.CareerDAO;
import dao.CollegeDAO;
import com.disha.model.User;
import javax.servlet.ServletException;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;

/**
 * DashboardServlet populates admin dashboard with live DB counts.
 */
public class DashboardServlet extends HttpServlet {
    private UserDAO userDAO = new UserDAO();
    private CareerDAO careerDAO = new CareerDAO();
    private CollegeDAO collegeDAO = new CollegeDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        if (!requireAdmin(request, response)) {
            return;
        }

        // Dashboard statistics from DB
        request.setAttribute("totalStudents", userDAO.countByRole("STUDENT"));
        request.setAttribute("totalParents", userDAO.countByRole("PARENT"));
        request.setAttribute("totalCounselors", userDAO.countByRole("COUNSELOR"));
        request.setAttribute("totalAdmins", userDAO.countByRole("ADMIN"));
        request.setAttribute("totalCareers", careerDAO.countAll());
        request.setAttribute("totalColleges", collegeDAO.countAll());
        request.setAttribute("totalUsers", userDAO.countAll());

        // Recent users for activity table
        List<User> recentUsers = userDAO.getRecentUsers(5);
        request.setAttribute("recentUsers", recentUsers);

        request.getRequestDispatcher("/JSP/admin/dashboard.jsp").forward(request, response);
    }

    private boolean requireAdmin(HttpServletRequest request, HttpServletResponse response) throws IOException {
        User currentUser = (User) request.getSession().getAttribute("loggedInUser");
        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/JSP/auth/login.jsp");
            return false;
        }
        if (!User.Role.ADMIN.equals(currentUser.getRole())) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN);
            return false;
        }
        return true;
    }
}
