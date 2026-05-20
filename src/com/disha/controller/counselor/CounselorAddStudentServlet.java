package com.disha.controller.counselor;

import com.disha.dao.UserDAO;
import com.disha.model.User;
import com.disha.util.PasswordUtil;
import com.disha.util.SessionUtil;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.SQLException;

@WebServlet("/counselor/add-student")
public class CounselorAddStudentServlet extends HttpServlet {
    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        User currentUser = requireCounselorOrAdmin(request, response);
        if (currentUser == null) {
            return;
        }

        String fullName = trim(request.getParameter("fullName"));
        String email = trim(request.getParameter("email"));
        String password = request.getParameter("password");

        if (fullName.isEmpty() || email.isEmpty() || password == null || password.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/counselor/dashboard?addError=empty");
            return;
        }

        String passwordError = PasswordUtil.validateStrength(password);
        if (passwordError != null) {
            response.sendRedirect(request.getContextPath() + "/counselor/dashboard?addError=password");
            return;
        }

        try {
            if (userDAO.emailExists(email)) {
                response.sendRedirect(request.getContextPath() + "/counselor/dashboard?addError=duplicate");
                return;
            }

            User student = new User(fullName, email, PasswordUtil.hash(password), User.Role.STUDENT);
            int newId = userDAO.registerUser(student);
            if (newId < 0) {
                response.sendRedirect(request.getContextPath() + "/counselor/dashboard?addError=failed");
                return;
            }
            response.sendRedirect(request.getContextPath() + "/counselor/dashboard?addSuccess=true");
        } catch (SQLException e) {
            log("Counselor add student failed", e);
            response.sendRedirect(request.getContextPath() + "/counselor/dashboard?addError=database");
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
