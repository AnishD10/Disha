package com.disha.controller.assessment;

import com.disha.dao.assessment.AssessmentDAO;
import com.disha.dao.assessment.QuestionDAO;
import com.disha.model.assessment.Question;
import com.disha.model.auth.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

/**
 * StartAssessmentServlet handles student requests to begin a new career portal assessment.
 * Serves the initial landing/instructions page via GET, and handles attempt initialization 
 * and question loading via POST.
 * 
 * @author DISHA Team
 */
@WebServlet("/assessment/start")
public class StartAssessmentServlet extends HttpServlet {

    private QuestionDAO questionDAO = new QuestionDAO();
    private AssessmentDAO assessmentDAO = new AssessmentDAO();

    /**
     * Handles HTTP GET requests to display the assessment introduction and instructions.
     * Validates active session and forwards the student to the assessment start page view.
     * 
     * @param request  The HttpServletRequest object
     * @param response The HttpServletResponse object
     * @throws ServletException If a servlet-specific error occurs
     * @throws IOException      If an input/output exception occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("loggedInUser") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        request.getRequestDispatcher("/jsp/assessment/start.jsp").forward(request, response);
    }

    /**
     * Handles HTTP POST requests to initialize a fresh assessment attempt.
     * Generates a new attempt ID in the database for the active student, retrieves 
     * the complete list of 30 structured assessment questions, and forwards them 
     * to the interactive questionnaire workspace JSP view.
     * 
     * @param request  The HttpServletRequest object
     * @param response The HttpServletResponse object
     * @throws ServletException If database mapping or forwarding fails
     * @throws IOException      If transmission input/output fails
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("loggedInUser") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        User loggedInUser = (User) session.getAttribute("loggedInUser");
        int studentId = loggedInUser.getUserId();

        int attemptId = assessmentDAO.createAttempt(studentId);

        if (attemptId == -1) {
            request.setAttribute("errorMessage", "Could not start the assessment. Please try again.");
            request.getRequestDispatcher("/jsp/assessment/start.jsp").forward(request, response);
            return;
        }

        List<Question> questions = questionDAO.getAllQuestions();
        request.setAttribute("questions", questions);
        request.setAttribute("attemptId", attemptId);
        request.getRequestDispatcher("/jsp/assessment/questionnaire.jsp").forward(request, response);
    }
}
