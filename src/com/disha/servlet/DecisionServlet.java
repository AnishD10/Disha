package com.disha.servlet;

import com.disha.dao.DecisionDAO;
import com.disha.model.DecisionPlan;
import com.disha.model.User;
import com.disha.util.SessionUtil;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

/**
 * DecisionServlet — Decision Planning feature.
 *
 * GET  /decision/plan  → load filter form with dropdown data
 * POST /decision/plan  → run constraint filter and show results
 *
 * Access: STUDENT role only (enforced by SessionFilter).
 */
@WebServlet(urlPatterns = {"/decision/plan"})
public class DecisionServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;
    private final DecisionDAO decisionDAO = new DecisionDAO();

    // ── GET — show filter form ────────────────────────────────────────────────

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        loadDropdowns(req);
        req.getRequestDispatcher("/JSP/decision/decision-plan.jsp").forward(req, resp);
    }

    // ── POST — run filter and return results ──────────────────────────────────

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        req.setCharacterEncoding("UTF-8");

        double maxBudget       = parseDouble(req.getParameter("maxBudget"), 0);
        String location        = nullIfBlank(req.getParameter("location"));
        double studentPercent  = parseDouble(req.getParameter("studentPercent"), 0);
        String careerKeyword   = nullIfBlank(req.getParameter("careerPath"));
        String faculty         = nullIfBlank(req.getParameter("faculty"));
        boolean scholarshipOnly = "on".equalsIgnoreCase(req.getParameter("scholarshipOnly"))
                || "true".equalsIgnoreCase(req.getParameter("scholarshipOnly"));

        // Input validation
        if (maxBudget < 0) {
            req.setAttribute("errorMessage", "Budget cannot be negative.");
            loadDropdowns(req);
            req.getRequestDispatcher("/JSP/decision/decision-plan.jsp").forward(req, resp);
            return;
        }
        if (studentPercent < 0 || studentPercent > 100) {
            req.setAttribute("errorMessage", "Academic score must be between 0 and 100.");
            loadDropdowns(req);
            req.getRequestDispatcher("/JSP/decision/decision-plan.jsp").forward(req, resp);
            return;
        }

        try {
            List<DecisionPlan> results = decisionDAO.filterProgrammes(
                    maxBudget, location, studentPercent, careerKeyword, faculty, scholarshipOnly);

            // Log search history (non-critical — failure does not block results)
            User currentUser = SessionUtil.getLoggedInUser(req);
            if (currentUser != null) {
                try {
                    decisionDAO.saveSearchHistory(
                            currentUser.getUserId(), maxBudget, location,
                            studentPercent, careerKeyword, results.size());
                } catch (SQLException logEx) {
                    log("Search history log failed (non-critical): " + logEx.getMessage());
                }
            }

            // Pass results and filter state back to JSP
            req.setAttribute("results",           results);
            req.setAttribute("resultCount",       results.size());
            req.setAttribute("filterMaxBudget",   maxBudget);
            req.setAttribute("filterLocation",    location);
            req.setAttribute("filterPercent",     studentPercent);
            req.setAttribute("filterCareer",      careerKeyword);
            req.setAttribute("filterFaculty",     faculty);
            req.setAttribute("filterScholarship", scholarshipOnly);

            loadDropdowns(req);
            req.getRequestDispatcher("/JSP/decision/decision-plan.jsp").forward(req, resp);

        } catch (SQLException e) {
            log("DecisionServlet DB error: " + e.getMessage(), e);
            req.setAttribute("errorMessage", "Database error. Please try again.");
            loadDropdowns(req);
            req.getRequestDispatcher("/JSP/decision/decision-plan.jsp").forward(req, resp);
        }
    }

    // ── Helpers ───────────────────────────────────────────────────────────────

    private void loadDropdowns(HttpServletRequest req) {
        try {
            req.setAttribute("faculties",   decisionDAO.getAllFaculties());
            req.setAttribute("locations",   decisionDAO.getAllLocations());
            req.setAttribute("careerPaths", decisionDAO.getAllCareerPaths());
        } catch (SQLException e) {
            log("loadDropdowns failed: " + e.getMessage());
        }
    }

    private double parseDouble(String s, double def) {
        if (s == null || s.trim().isEmpty()) return def;
        try { return Double.parseDouble(s.trim()); } catch (NumberFormatException e) { return def; }
    }

    private String nullIfBlank(String s) {
        return (s == null || s.trim().isEmpty()) ? null : s.trim();
    }
}
