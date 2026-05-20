package com.disha.servlet;

import com.disha.dao.UserDAO;
import com.disha.model.User;
import com.disha.util.PasswordUtil;
import com.disha.util.RoleConstants;
import com.disha.util.SessionUtil;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.SQLException;

/**
 * UserServlet — Handles all authentication for DISHA.
 *
 * Endpoints:
 *   POST /auth/register  → register new user
 *   POST /auth/login     → authenticate and create session
 *   GET  /auth/logout    → destroy session and redirect to login
 *
 * Session handling:
 *   - On login:  old session invalidated, new session created (fixes session fixation)
 *   - On logout: session.invalidate() — old cookie becomes useless
 *   - Timeout:   30 minutes idle (set in SessionUtil)
 */
@WebServlet(urlPatterns = {"/auth/register", "/auth/login", "/auth/logout"})
public class UserServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private final UserDAO userDAO = new UserDAO();

    // ── HTTP Routing ──────────────────────────────────────────────────────────

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        if ("/auth/logout".equals(req.getServletPath())) {
            logoutUser(req, resp);
        } else {
            resp.sendRedirect(req.getContextPath() + "/pages/auth/login.jsp");
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        switch (req.getServletPath()) {
            case "/auth/register": registerUser(req, resp); break;
            case "/auth/login":    loginUser(req, resp);    break;
            default: resp.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }

    // ── REGISTRATION ─────────────────────────────────────────────────────────

    private void registerUser(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        // 1. Read all form fields
        String fullName        = trim(req.getParameter("fullName"));
        String email           = trim(req.getParameter("email"));
        String password        = req.getParameter("password");
        String confirmPassword = req.getParameter("confirmPassword");
        String roleStr         = trim(req.getParameter("role"));
        String phone           = trim(req.getParameter("phone"));
        String address         = trim(req.getParameter("address"));

        // 2. Required field check
        if (isBlank(fullName) || isBlank(email) || isBlank(password) || isBlank(roleStr)) {
            forwardToRegister(req, resp, "All required fields must be filled in.");
            return;
        }

        // 3. Email format check
        if (!email.matches("^[\\w.+\\-]+@[a-zA-Z0-9.\\-]+\\.[a-zA-Z]{2,}$")) {
            forwardToRegister(req, resp, "Please enter a valid email address.");
            return;
        }

        // 4. Password strength check
        String pwError = PasswordUtil.validateStrength(password);
        if (pwError != null) {
            forwardToRegister(req, resp, pwError);
            return;
        }

        // 5. Passwords match check
        if (!password.equals(confirmPassword)) {
            forwardToRegister(req, resp, "Passwords do not match.");
            return;
        }

        // 6. Valid role check
        User.Role role;
        try {
            role = User.Role.valueOf(roleStr.toUpperCase());
        } catch (IllegalArgumentException e) {
            forwardToRegister(req, resp, "Invalid role selected.");
            return;
        }

        // 7. DB operations
        try {
            if (userDAO.emailExists(email)) {
                forwardToRegister(req, resp,
                        "An account with this email already exists. Please log in.");
                return;
            }

            String hash   = PasswordUtil.hash(password);
            User newUser  = new User(fullName, email, hash, role);
            newUser.setPhone(phone);
            newUser.setAddress(address);

            int newId = userDAO.registerUser(newUser);
            if (newId < 0) {
                forwardToRegister(req, resp, "Registration failed. Please try again.");
                return;
            }

            // Success — set flash and redirect to login
            SessionUtil.setFlash(req, "success",
                    "Account created! Welcome to DISHA. Please log in.");
            resp.sendRedirect(req.getContextPath() + "/pages/auth/login.jsp");

        } catch (SQLException e) {
            log("registerUser DB error: " + e.getMessage(), e);
            forwardToRegister(req, resp, "A database error occurred. Please try again.");
        }
    }

    // ── LOGIN ─────────────────────────────────────────────────────────────────

    private void loginUser(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String email    = trim(req.getParameter("email"));
        String password = req.getParameter("password");

        // 1. Empty field check
        if (isBlank(email) || isBlank(password)) {
            forwardToLogin(req, resp, "Email and password are required.", email);
            return;
        }

        // 2. Email format check
        if (!email.matches("^[\\w.+\\-]+@[a-zA-Z0-9.\\-]+\\.[a-zA-Z]{2,}$")) {
            forwardToLogin(req, resp, "Please enter a valid email address.", email);
            return;
        }

        try {
            // 3. Fetch user from DB
            User user = userDAO.findByEmail(email);

            // 4. Verify password — generic message to avoid revealing if email exists
            if (user == null || !PasswordUtil.verify(password, user.getPasswordHash())) {
                forwardToLogin(req, resp,
                        "Invalid email or password. Please try again.", email);
                return;
            }

            // 5. Check account is active
            if (!user.isActive()) {
                forwardToLogin(req, resp,
                        "Your account has been deactivated. Contact admin.", email);
                return;
            }

            // 6. Create fresh session (invalidates old one — session fixation fix)
            SessionUtil.setLoggedInUser(req, user);

            // 7. Redirect to role-specific dashboard
            String dashboardPath = RoleConstants.getDashboardPath(user.getRole().name());
            resp.sendRedirect(req.getContextPath() + dashboardPath);

        } catch (SQLException e) {
            log("loginUser DB error: " + e.getMessage(), e);
            forwardToLogin(req, resp,
                    "A database error occurred. Please try again.", email);
        }
    }

    // ── LOGOUT ────────────────────────────────────────────────────────────────

    private void logoutUser(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {
        // Destroy the entire session — makes captured cookies useless
        SessionUtil.invalidate(req);
        // Set flash message for the login page
        SessionUtil.setFlash(req, "info", "You have been logged out successfully.");
        resp.sendRedirect(req.getContextPath() + "/pages/auth/login.jsp");
    }

    // ── Private helpers ───────────────────────────────────────────────────────

    /** Forward to login JSP with an error message and repopulate email field. */
    private void forwardToLogin(HttpServletRequest req, HttpServletResponse resp,
                                String error, String email)
            throws ServletException, IOException {
        req.setAttribute("errorMessage", error);
        req.setAttribute("formEmail", email);
        req.getRequestDispatcher("/pages/auth/login.jsp").forward(req, resp);
    }

    /** Forward to register JSP with an error message and repopulate all fields. */
    private void forwardToRegister(HttpServletRequest req, HttpServletResponse resp,
                                   String error)
            throws ServletException, IOException {
        req.setAttribute("errorMessage", error);
        req.setAttribute("formName",    req.getParameter("fullName"));
        req.setAttribute("formEmail",   req.getParameter("email"));
        req.setAttribute("formPhone",   req.getParameter("phone"));
        req.setAttribute("formAddress", req.getParameter("address"));
        req.setAttribute("formRole",    req.getParameter("role"));
        req.getRequestDispatcher("/pages/auth/register.jsp").forward(req, resp);
    }

    private String  trim(String s)     { return (s == null) ? "" : s.trim(); }
    private boolean isBlank(String s)  { return s == null || s.trim().isEmpty(); }
}
