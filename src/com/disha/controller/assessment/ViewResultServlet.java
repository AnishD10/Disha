package com.disha.controller.assessment;

import com.disha.dao.assessment.AssessmentDAO;
import com.disha.dao.assessment.CareerDAO;
import com.disha.dao.assessment.ResultDAO;
import com.disha.model.User;
import com.disha.model.assessment.AssessmentAttempt;
import com.disha.model.assessment.AssessmentReport;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/assessment/result")
public class ViewResultServlet extends HttpServlet {
    private final AssessmentDAO assessmentDAO = new AssessmentDAO();
    private final CareerDAO careerDAO = new CareerDAO();
    private final ResultDAO resultDAO = new ResultDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        User user = (User) request.getSession().getAttribute("loggedInUser");
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/JSP/auth/login.jsp");
            return;
        }

        int attemptId = parseInt(request.getParameter("attemptId"));
        AssessmentAttempt attempt = assessmentDAO.getAttemptById(attemptId);
        if (attempt == null || (User.Role.STUDENT.equals(user.getRole()) && attempt.getStudentId() != user.getUserId())) {
            response.sendRedirect(request.getContextPath() + "/assessment/history");
            return;
        }

        AssessmentReport report = new AssessmentReport();
        report.setAttempt(attempt);
        report.setSkills(resultDAO.getSkillsByAttempt(attemptId));
        report.setTopCareers(careerDAO.getSavedRecommendations(attemptId));
        request.setAttribute("report", report);
        request.getRequestDispatcher("/JSP/assessment/result.jsp").forward(request, response);
    }

    private int parseInt(String value) {
        try { return Integer.parseInt(value); } catch (Exception e) { return 0; }
    }
}
