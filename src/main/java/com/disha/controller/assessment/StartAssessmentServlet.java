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

// StartAssessmentServlet handles the page where the student begins the test.
// GET shows the intro/start page. POST creates a new attempt and loads the questions.
@WebServlet("/assessment/start")
public class StartAssessmentServlet extends HttpServlet {

    private QuestionDAO questionDAO = new QuestionDAO();
    private AssessmentDAO assessmentDAO = new AssessmentDAO();

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

    // Creates a fresh attempt in the database and loads all 30 questions.
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
