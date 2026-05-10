package com.disha.servlet;

import com.disha.dao.DecisionDAO;
import com.disha.model.DecisionPlan;
import com.disha.model.User;
import com.disha.util.SessionUtil;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

/**
 * DecisionServlet — Handles the Decision Planning feature for DISHA.
 *
 * URL Mappings:
 * GET /decision/plan → Load filter form with dropdown data
 * POST /decision/plan → Run the constraint filter and display results
 *
 * Access: STUDENT role only (enforced by SessionFilter).
 * The filter logic lives in DecisionDAO — this servlet handles HTTP I/O only.
 *
 * Author: Joyal Karki — Decision Planning Feature Owner
 */
@WebServlet(urlPatterns = { "/decision/plan" })
public class DecisionServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private final DecisionDAO decisionDAO = new DecisionDAO();

    // ── GET — Load filter form ────────────────────────────────────────────────

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        // Guard: only students should access this feature
        if (!SessionUtil.hasRole(req, User.Role.STUDENT)) {
            resp.sendError(HttpServletResponse.SC_FORBIDDEN,
                    "Decision Planning is only available to students.");
            return;
        }

        loadDropdowns(req);
        req.getRequestDispatcher("/pages/decision/decision-plan.jsp").forward(req, resp);
    }

    // ── POST — Run constraint filter ──────────────────────────────────────────

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");

        if (!SessionUtil.hasRole(req, User.Role.STUDENT)) {
            resp.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }

        // ── Parse filter parameters ───────────────────────────────────────────
        double maxBudget = parseDouble(req.getParameter("maxBudget"), 0);
        String location = trim(req.getParameter("location"));
        double studentPercent = parseDouble(req.getParameter("studentPercent"), 0);
        String careerKeyword = trim(req.getParameter("careerPath"));
        String faculty = trim(req.getParameter("faculty"));
        boolean scholarshipOnly = "on".equalsIgnoreCase(req.getParameter("scholarshipOnly"))
                || "true".equalsIgnoreCase(req.getParameter("scholarshipOnly"));

        // Input validation
        if (maxBudget < 0) {
            req.setAttribute("errorMessage", "Budget cannot be negative.");
            loadDropdowns(req);
            req.getRequestDispatcher("/pages/decision/decision-plan.jsp").forward(req, resp);
            return;
        }
        if (studentPercent < 0 || studentPercent > 100) {
            req.setAttribute("errorMessage", "Academic percentage must be between 0 and 100.");
            loadDropdowns(req);
            req.getRequestDispatcher("/pages/decision/decision-plan.jsp").forward(req, resp);
            return;
        }

        try {
            List<DecisionPlan> results = decisionDAO.filterProgrammes(
                    maxBudget, location, studentPercent, careerKeyword, faculty, scholarshipOnly);

            // Log the search for counselor visibility
            User currentUser = SessionUtil.getLoggedInUser(req);
            if (currentUser != null) {
                try {
                    decisionDAO.saveSearchHistory(
                            currentUser.getUserId(), maxBudget, location,
                            studentPercent, careerKeyword, results.size());
                } catch (SQLException logEx) {
                    // Non-critical — search logging should not block results
                    log("DecisionServlet: Could not save search history: " + logEx.getMessage());
                }
            }

            // Pass results and applied filters back to JSP for display
            req.setAttribute("results", results);
            req.setAttribute("resultCount", results.size());
            req.setAttribute("filterMaxBudget", maxBudget);
            req.setAttribute("filterLocation", location);
            req.setAttribute("filterPercent", studentPercent);
            req.setAttribute("filterCareer", careerKeyword);
            req.setAttribute("filterFaculty", faculty);
            req.setAttribute("filterScholarship", scholarshipOnly);

            loadDropdowns(req);
            req.getRequestDispatcher("/pages/decision/decision-plan.jsp").forward(req, resp);

        } catch (SQLException e) {
            log("DecisionServlet.doPost() — DB error: " + e.getMessage(), e);
            req.setAttribute("errorMessage",
                    "A database error occurred while searching. Please try again.");
            loadDropdowns(req);
            req.getRequestDispatcher("/pages/decision/decision-plan.jsp").forward(req, resp);
        }
    }

    // ── Private Helpers ───────────────────────────────────────────────────────

    /**
     * Load dropdown data (faculties, locations, career paths) for the filter form.
     * Failures here are non-fatal — the user can still type into text fields.
     */
    private void loadDropdowns(HttpServletRequest req) {
        try {
            req.setAttribute("faculties", decisionDAO.getAllFaculties());
            req.setAttribute("locations", decisionDAO.getAllLocations());
            req.setAttribute("careerPaths", decisionDAO.getAllCareerPaths());
        } catch (SQLException e) {
            log("DecisionServlet.loadDropdowns() — DB error: " + e.getMessage());
            // Dropdowns will be empty; user can type values manually
        }
    }

    private double parseDouble(String s, double defaultVal) {
        if (s == null || s.trim().isEmpty())
            return defaultVal;
        try {
            return Double.parseDouble(s.trim());
        } catch (NumberFormatException e) {
            return defaultVal;
        }
    }

    private String trim(String s) {
        return (s == null || s.trim().isEmpty()) ? null : s.trim();
    }
}
