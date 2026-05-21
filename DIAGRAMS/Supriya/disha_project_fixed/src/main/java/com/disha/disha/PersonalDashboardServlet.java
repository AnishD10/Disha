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
import java.util.ArrayList;
import java.util.List;

/**
 * PersonalDashboardServlet
 * URL mapping : /PersonalDashboardServlet
 *
 * Loads the logged-in student's profile and test history from the DB,
 * then forwards to personalDashboard.jsp.
 */
@WebServlet("/PersonalDashboardServlet")
public class PersonalDashboardServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        // ── Auth guard ───────────────────────────────────────────────────
        if (session == null || session.getAttribute("username") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        String username = (String) session.getAttribute("username");

        // ── Load data from DB ────────────────────────────────────────────
        try (Connection conn = DBConnection.getConnection()) {

            // 1. User profile
            UserProfile userProfile = getUserProfile(conn, username);
            if (userProfile != null) {
                session.setAttribute("userProfile", userProfile);
            }

            // 2. Test history
            List<TestHistory> testHistoryList = getTestHistory(conn, username);
            request.setAttribute("testHistoryList", testHistoryList);

        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("errorMessage",
                "Could not load dashboard data. Please try again later.");
        }

        request.getRequestDispatcher("/personalDashboard.jsp")
               .forward(request, response);
    }

    /** POST delegates to GET (supports page refresh without re-posting). */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }

    // ── Private helpers ──────────────────────────────────────────────────

    private UserProfile getUserProfile(Connection conn, String username)
            throws SQLException {

        String sql = "SELECT full_name, email, phone, education_level, preferred_career, "
                   + "DATE_FORMAT(created_at, '%d %b %Y') AS member_since "
                   + "FROM users WHERE username = ?";

        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, username);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    UserProfile up = new UserProfile();
                    up.setFullName(rs.getString("full_name"));
                    up.setEmail(rs.getString("email"));
                    up.setPhone(rs.getString("phone"));
                    up.setEducationLevel(rs.getString("education_level"));
                    up.setPreferredCareer(rs.getString("preferred_career"));
                    up.setMemberSince(rs.getString("member_since"));
                    return up;
                }
            }
        }
        return null;
    }

    private List<TestHistory> getTestHistory(Connection conn, String username)
            throws SQLException {

        List<TestHistory> list = new ArrayList<>();

        String sql = "SELECT th.id, a.assessment_name, "
                   + "DATE_FORMAT(th.date_taken, '%d %b %Y') AS date_taken, "
                   + "th.score, th.assessment_id "
                   + "FROM test_history th "
                   + "JOIN assessments a ON th.assessment_id = a.id "
                   + "JOIN users      u ON th.user_id       = u.id "
                   + "WHERE u.username = ? "
                   + "ORDER BY th.date_taken ASC";   // ASC so chart shows oldest→newest

        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, username);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    TestHistory th = new TestHistory();
                    th.setId(rs.getInt("id"));
                    th.setAssessmentName(rs.getString("assessment_name"));
                    th.setDateTaken(rs.getString("date_taken"));
                    th.setScore(rs.getInt("score"));
                    th.setAssessmentId(rs.getInt("assessment_id"));
                    list.add(th);
                }
            }
        }
        return list;
    }
}
