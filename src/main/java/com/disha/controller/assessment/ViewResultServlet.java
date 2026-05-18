package com.disha.controller.assessment;

import com.disha.dao.assessment.AssessmentDAO;
import com.disha.dao.assessment.CareerDAO;
import com.disha.dao.assessment.ResultDAO;
import com.disha.model.assessment.AssessmentAttempt;
import com.disha.model.assessment.AssessmentReport;
import com.disha.model.assessment.AttemptSkill;
import com.disha.model.assessment.NepalCareer;
import com.disha.model.auth.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

// ViewResultServlet loads a completed attempt and builds the full report for the student.
@WebServlet("/assessment/result")
public class ViewResultServlet extends HttpServlet {

    private AssessmentDAO assessmentDAO = new AssessmentDAO();
    private CareerDAO careerDAO = new CareerDAO();
    private ResultDAO resultDAO = new ResultDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("loggedInUser") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String param = request.getParameter("attemptId");
        if (param == null || param.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/assessment/history");
            return;
        }

        int attemptId = Integer.parseInt(param);
        AssessmentAttempt attempt = assessmentDAO.getAttemptById(attemptId);

        if (attempt == null) {
            request.setAttribute("errorMessage", "Result not found.");
            request.getRequestDispatcher("/jsp/assessment/result.jsp").forward(request, response);
            return;
        }

        // Security check: make sure the logged-in student owns this attempt.
        User loggedInUser = (User) session.getAttribute("loggedInUser");
        String role = loggedInUser.getRole();
        if (role.equals("STUDENT") && attempt.getStudentId() != loggedInUser.getUserId()) {
            response.sendRedirect(request.getContextPath() + "/assessment/history");
            return;
        }

        List<NepalCareer> topCareers = careerDAO.getSavedRecommendations(attemptId);
        List<AttemptSkill> skills    = resultDAO.getSkillsByAttempt(attemptId);

        AssessmentReport report = new AssessmentReport();
        report.setAttempt(attempt);
        report.setTopCareers(topCareers);
        report.setSkills(skills);

        request.setAttribute("report", report);
        request.getRequestDispatcher("/jsp/assessment/result.jsp").forward(request, response);
    }
}
