package com.disha.disha;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

/**
 * LoginServlet — temporary login for testing Supriya's dashboard.
 * Joyal will replace this with the full auth system (hashed passwords, roles, etc.)
 */
@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String username = request.getParameter("username");
        String password = request.getParameter("password");

        if (username == null || password == null ||
            username.trim().isEmpty() || password.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/login.jsp?error=1");
            return;
        }

        try (Connection conn = DBConnection.getConnection()) {
            // NOTE: plain-text password check — for testing only.
            // Joyal's auth will use SHA-256/BCrypt hashing.
            String sql = "SELECT id, username FROM users WHERE username = ? AND password = ?";
            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setString(1, username.trim());
                ps.setString(2, password);
                try (ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        // Valid login — create session
                        HttpSession session = request.getSession(true);
                        session.setAttribute("username", rs.getString("username"));
                        session.setAttribute("userId",   rs.getInt("id"));
                        response.sendRedirect(request.getContextPath() + "/PersonalDashboardServlet");
                        return;
                    }
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        // Invalid credentials
        response.sendRedirect(request.getContextPath() + "/login.jsp?error=1");
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
    }
}
