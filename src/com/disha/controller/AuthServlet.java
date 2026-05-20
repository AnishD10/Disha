package com.disha.controller;

import dao.UserDAO;
import com.disha.model.User;
import javax.servlet.ServletException;
import javax.servlet.http.*;
import java.io.IOException;
import java.security.MessageDigest;

/**
 * AuthServlet handles login, register, and logout.
 * Mapped via web.xml to /auth/*
 */
public class AuthServlet extends HttpServlet {
    private UserDAO userDAO = new UserDAO();

    /** SHA-256 hash helper */
    private String hashPassword(String password) {
        try {
            MessageDigest md = MessageDigest.getInstance("SHA-256");
            byte[] hash = md.digest(password.getBytes("UTF-8"));
            StringBuilder sb = new StringBuilder();
            for (byte b : hash) { String hex = Integer.toHexString(0xff & b); if (hex.length() == 1) sb.append('0'); sb.append(hex); }
            return sb.toString();
        } catch (Exception ex) { throw new RuntimeException(ex); }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String path = request.getServletPath();

        if ("/auth/login".equals(path)) {
            handleLogin(request, response);
        } else if ("/auth/register".equals(path)) {
            handleRegister(request, response);
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        if ("/auth/logout".equals(request.getServletPath())) {
            request.getSession().invalidate();
            response.sendRedirect(request.getContextPath() + "/JSP/auth/login.jsp");
        }
    }

    private void handleLogin(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String email = request.getParameter("email");
        String password = request.getParameter("password");

        User user = userDAO.authenticate(email, hashPassword(password));
        if (user != null) {
            HttpSession session = request.getSession();
            session.setAttribute("loggedInUser", user);
            session.setAttribute("userRole", user.getRole().name());
            session.setAttribute("userName", user.getFullName());
            session.setMaxInactiveInterval(30 * 60); // 30 minutes

            // Role-based redirect with a one-time dashboard toast flag.
            switch (user.getRole()) {
                case ADMIN:     response.sendRedirect(request.getContextPath() + "/admin/dashboard?loginSuccess=true"); break;
                case PARENT:    response.sendRedirect(request.getContextPath() + "/JSP/parent/dashboard.jsp?loginSuccess=true"); break;
                case COUNSELOR: response.sendRedirect(request.getContextPath() + "/JSP/counselor/dashboard.jsp?loginSuccess=true"); break;
                default:        response.sendRedirect(request.getContextPath() + "/JSP/student/dashboard.jsp?loginSuccess=true"); break;
            }
        } else {
            request.setAttribute("errorMessage", "Invalid email or password.");
            request.setAttribute("formEmail", email);
            request.getRequestDispatcher("/JSP/auth/login.jsp").forward(request, response);
        }
    }

    private void handleRegister(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String fullName = request.getParameter("fullName");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String roleStr = request.getParameter("role");
        String phone = request.getParameter("phone");

        User.Role role = User.Role.STUDENT;
        try { if (roleStr != null) role = User.Role.valueOf(roleStr.toUpperCase()); } catch (Exception ignored) {}

        User newUser = new User();
        newUser.setFullName(fullName);
        newUser.setEmail(email);
        newUser.setRole(role);
        newUser.setPhone(phone != null ? phone : "");

        User created = userDAO.createUser(newUser, hashPassword(password));
        if (created != null) {
            request.getSession().setAttribute("flashMessage", "Account created successfully! Please login.");
            request.getSession().setAttribute("flashType", "success");
            response.sendRedirect(request.getContextPath() + "/JSP/auth/login.jsp");
        } else {
            request.setAttribute("errorMessage", "Registration failed. Email might already exist.");
            request.setAttribute("formEmail", email);
            request.setAttribute("formName", fullName);
            request.setAttribute("formRole", roleStr);
            request.getRequestDispatcher("/JSP/auth/register.jsp").forward(request, response);
        }
    }
}
