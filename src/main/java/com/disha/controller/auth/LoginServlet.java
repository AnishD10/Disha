package com.disha.controller.auth;

import com.disha.dao.auth.UserDAO;
import com.disha.model.auth.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

// LoginServlet handles user authentication.
@WebServlet("/login")
public class LoginServlet extends HttpServlet {

    private UserDAO userDAO = new UserDAO();

    // Show the login page.
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/jsp/auth/login.jsp").forward(request, response);
    }

    // Process the login form.
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String email = request.getParameter("email");
        String password = request.getParameter("password");

        User user = userDAO.authenticate(email, password);

        if (user != null) {
            HttpSession session = request.getSession(true);
            session.setAttribute("loggedInUser", user);

            String role = user.getRole();
            if ("COUNSELOR".equals(role) || "ADMIN".equals(role)) {
                response.sendRedirect(request.getContextPath() + "/counselor/dashboard?loginSuccess=true");
            } else {
                response.sendRedirect(request.getContextPath() + "/assessment/start?loginSuccess=true");
            }
        } else {
            request.setAttribute("errorMessage", "Invalid email or password.");
            request.getRequestDispatcher("/jsp/auth/login.jsp").forward(request, response);
        }
    }
}
