package com.disha.controller;

import com.disha.model.User;
import dao.CareerDAO;
import dao.CollegeDAO;
import dao.UserDAO;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

/**
 * Populates the admin reports view with platform counts.
 */
public class ReportServlet extends HttpServlet {
    private final UserDAO userDAO = new UserDAO();
    private final CareerDAO careerDAO = new CareerDAO();
    private final CollegeDAO collegeDAO = new CollegeDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        if (!requireAdmin(request, response)) {
            return;
        }

        int totalStudents = userDAO.countByRole("STUDENT");
        int totalParents = userDAO.countByRole("PARENT");
        int totalCounselors = userDAO.countByRole("COUNSELOR");
        int totalAdmins = userDAO.countByRole("ADMIN");
        int totalUsers = userDAO.countAll();

        request.setAttribute("totalStudents", totalStudents);
        request.setAttribute("totalParents", totalParents);
        request.setAttribute("totalCounselors", totalCounselors);
        request.setAttribute("totalAdmins", totalAdmins);
        request.setAttribute("totalUsers", totalUsers);
        request.setAttribute("totalCareers", careerDAO.countAll());
        request.setAttribute("totalColleges", collegeDAO.countAll());
        request.setAttribute("maxRoleCount", Math.max(1,
                Math.max(totalStudents, Math.max(totalParents, Math.max(totalCounselors, totalAdmins)))));

        request.getRequestDispatcher("/JSP/admin/reports.jsp").forward(request, response);
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
