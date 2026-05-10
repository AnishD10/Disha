package com.disha.servlet;

import com.disha.dao.UserDAO;
import com.disha.model.User;
import com.disha.util.PasswordUtil;
import com.disha.util.RoleConstants;
import com.disha.util.SessionUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.SQLException;

/**
 * UserServlet — Handles all authentication flows for DISHA.
 *
 * URL Mappings:
 * POST /auth/register → registerUser()
 * POST /auth/login → loginUser()
 * GET /auth/logout → logoutUser()
 *
 * After login, users are redirected to their role-specific dashboard.
 * All error messages are stored as request attributes and forwarded
 * back to the JSP so the form retains the user's input.
 *
 * Author: Joyal Karki — Authentication Lead
 */
@WebServlet(urlPatterns = { "/auth/register", "/auth/login", "/auth/logout" })
public class UserServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private final UserDAO userDAO = new UserDAO();

    // ── Routing ───────────────────────────────────────────────────────────────

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String path = req.getServletPath();

        if ("/auth/logout".equals(path)) {
            logoutUser(req, resp);
        } else {
            // GET requests to login/register just forward to the JSP pages
            resp.sendRedirect(req.getContextPath() + "/pages/auth/login.jsp");
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");
        String path = req.getServletPath();

        switch (path) {
            case "/auth/register":
                registerUser(req, resp);
                break;
            case "/auth/login":
                loginUser(req, resp);
                break;
            default:
                resp.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }

    // ── Registration ──────────────────────────────────────────────────────────

    /**
     * Process new user registration.
     *
     * Validation order:
     * 1. All required fields present
     * 2. Valid email format
     * 3. Password strength rules
     * 4. Passwords match
     * 5. Email not already registered
     * 6. Valid role selected
     */
    private void registerUser(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        // ── Read form fields ──────────────────────────────────────────────────
        String fullName = trim(req.getParameter("fullName"));
        String email = trim(req.getParameter("email"));
        String password = req.getParameter("password");
        String confirmPassword = req.getParameter("confirmPassword");
        String roleStr = trim(req.getParameter("role"));
        String phone = trim(req.getParameter("phone"));
        String address = trim(req.getParameter("address"));

        // ── Validate ──────────────────────────────────────────────────────────
        if (isBlank(fullName) || isBlank(email) || isBlank(password) || isBlank(roleStr)) {
            forwardWithError(req, resp, "/pages/auth/register.jsp",
                    "All required fields must be filled in.");
            return;
        }

        if (!email.matches("^[\\w.+\\-]+@[a-zA-Z0-9.\\-]+\\.[a-zA-Z]{2,}$")) {
            forwardWithError(req, resp, "/pages/auth/register.jsp",
                    "Please enter a valid email address.");
            return;
        }

        String strengthError = PasswordUtil.validateStrength(password);
        if (strengthError != null) {
            forwardWithError(req, resp, "/pages/auth/register.jsp", strengthError);
            return;
        }

        if (!password.equals(confirmPassword)) {
            forwardWithError(req, resp, "/pages/auth/register.jsp",
                    "Passwords do not match. Please try again.");
            return;
        }

        // Validate role value is one of the four allowed roles
        User.Role role;
        try {
            role = User.Role.valueOf(roleStr.toUpperCase());
        } catch (IllegalArgumentException e) {
            forwardWithError(req, resp, "/pages/auth/register.jsp",
                    "Invalid role selected. Please choose from the dropdown.");
            return;
        }

        try {
            // Check for duplicate email
            if (userDAO.emailExists(email)) {
                forwardWithError(req, resp, "/pages/auth/register.jsp",
                        "An account with this email already exists. Please log in.");
                return;
            }

            // Hash password and create user
            String hash = PasswordUtil.hash(password);
            User newUser = new User(fullName, email, hash, role);
            newUser.setPhone(phone);
            newUser.setAddress(address);

            int generatedId = userDAO.registerUser(newUser);
            if (generatedId < 0) {
                forwardWithError(req, resp, "/pages/auth/register.jsp",
                        "Registration failed due to a server error. Please try again.");
                return;
            }

            // Registration success — redirect to login with a flash message
            newUser.setUserId(generatedId);
            SessionUtil.setFlash(req, "success",
                    "Account created successfully! Please log in to continue.");
            resp.sendRedirect(req.getContextPath() + "/pages/auth/login.jsp");

        } catch (SQLException e) {
            log("UserServlet.registerUser() — DB error: " + e.getMessage(), e);
            forwardWithError(req, resp, "/pages/auth/register.jsp",
                    "A database error occurred. Please try again later.");
        }
    }

    // ── Login ─────────────────────────────────────────────────────────────────

    /**
     * Authenticate a user and establish their session.
     *
     * Deliberately uses a generic error message for failed credentials
     * to avoid revealing whether the email exists in the system.
     */
    private void loginUser(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String email = trim(req.getParameter("email"));
        String password = req.getParameter("password");

        if (isBlank(email) || isBlank(password)) {
            forwardWithError(req, resp, "/pages/auth/login.jsp",
                    "Email and password are required.");
            return;
        }

        try {
            User user = userDAO.findByEmail(email);

            // Generic error — do not reveal whether email exists
            if (user == null || !PasswordUtil.verify(password, user.getPasswordHash())) {
                forwardWithError(req, resp, "/pages/auth/login.jsp",
                        "Invalid email or password. Please check your credentials.");
                return;
            }

            // Establish session
            SessionUtil.setLoggedInUser(req, user);

            // Redirect to the correct dashboard for this role
            String dashboardPath = RoleConstants.getDashboardPath(user.getRole().name());
            resp.sendRedirect(req.getContextPath() + dashboardPath);

        } catch (SQLException e) {
            log("UserServlet.loginUser() — DB error: " + e.getMessage(), e);
            forwardWithError(req, resp, "/pages/auth/login.jsp",
                    "A database error occurred. Please try again later.");
        }
    }

    // ── Logout ────────────────────────────────────────────────────────────────

    /**
     * Invalidate the session and redirect to the login page.
     */
    private void logoutUser(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {
        SessionUtil.invalidate(req);
        resp.sendRedirect(req.getContextPath() + "/pages/auth/login.jsp");
    }

    // ── Private Helpers ───────────────────────────────────────────────────────

    private void forwardWithError(HttpServletRequest req, HttpServletResponse resp,
            String jspPath, String errorMessage)
            throws ServletException, IOException {
        req.setAttribute("errorMessage", errorMessage);
        // Re-populate form fields so the user doesn't retype everything
        req.setAttribute("formEmail", req.getParameter("email"));
        req.setAttribute("formName", req.getParameter("fullName"));
        req.setAttribute("formPhone", req.getParameter("phone"));
        req.setAttribute("formAddress", req.getParameter("address"));
        req.setAttribute("formRole", req.getParameter("role"));
        req.getRequestDispatcher(jspPath).forward(req, resp);
    }

    private String trim(String s) {
        return (s == null) ? "" : s.trim();
    }

    private boolean isBlank(String s) {
        return s == null || s.trim().isEmpty();
    }
}
