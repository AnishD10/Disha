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
 * RetestServlet
 * URL mapping : /RetestServlet
 *
 * Handles the Re-Test button from personalDashboard.jsp.
 * Validates the assessmentId, sets session attributes,
 * then redirects to assessment.jsp with the id parameter.
 */
@WebServlet("/RetestServlet")
public class RetestServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // ── Auth guard ───────────────────────────────────────────────────
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("username") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }

        // ── Parse assessmentId parameter ─────────────────────────────────
        String assessmentIdStr = request.getParameter("assessmentId");

        if (assessmentIdStr == null || assessmentIdStr.trim().isEmpty()) {
            redirectWithError(request, response, "Invalid re-test request: missing assessment ID.");
            return;
        }

        int assessmentId;
        try {
            assessmentId = Integer.parseInt(assessmentIdStr.trim());
        } catch (NumberFormatException e) {
            redirectWithError(request, response, "Invalid assessment ID format.");
            return;
        }

        // ── Validate assessment exists in DB ─────────────────────────────
        try (Connection conn = DBConnection.getConnection()) {

            String sql = "SELECT id FROM assessments WHERE id = ?";
            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setInt(1, assessmentId);
                try (ResultSet rs = ps.executeQuery()) {
                    if (!rs.next()) {
                        redirectWithError(request, response,
                            "Assessment not found. Please choose a valid assessment.");
                        return;
                    }
                }
            }

            // Store retest state in session so assessment.jsp knows
            session.setAttribute("retestAssessmentId", assessmentId);
            session.setAttribute("isRetest", true);

        } catch (SQLException e) {
            e.printStackTrace();
            redirectWithError(request, response,
                "Database error while starting re-test. Please try again.");
            return;
        }

        // ── Redirect to assessment page ───────────────────────────────────
        // NOTE: assessment.jsp must exist in your project (built by Ashmit).
        //       If it doesn't exist yet, this redirect will show a 404 — that is normal
        //       until the assessment feature is integrated.
        response.sendRedirect(request.getContextPath()
            + "/assessment.jsp?id=" + assessmentId + "&retest=true");
    }

    /** GET simply sends back to the dashboard. */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendRedirect(request.getContextPath() + "/PersonalDashboardServlet");
    }

    // ── Helper ───────────────────────────────────────────────────────────

    private void redirectWithError(HttpServletRequest request,
                                   HttpServletResponse response,
                                   String message)
            throws ServletException, IOException {

        request.setAttribute("errorMessage", message);
        request.getRequestDispatcher("/PersonalDashboardServlet")
               .forward(request, response);
    }
}
