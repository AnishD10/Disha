package com.disha.controller.assessment;

import com.disha.dao.assessment.AssessmentDAO;
import com.disha.dao.assessment.QuestionDAO;
import com.disha.model.User;
import com.disha.model.assessment.Question;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

@WebServlet("/assessment/start")
public class StartAssessmentServlet extends HttpServlet {
    private final QuestionDAO questionDAO = new QuestionDAO();
    private final AssessmentDAO assessmentDAO = new AssessmentDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        if (requireStudent(request, response) == null) return;
        request.getRequestDispatcher("/JSP/assessment/start.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        User user = requireStudent(request, response);
        if (user == null) return;

        int attemptId = assessmentDAO.createAttempt(user.getUserId());
        List<Question> questions = questionDAO.getAllQuestions();
        if (attemptId <= 0 || questions.isEmpty()) {
            request.setAttribute("errorMessage", "Assessment could not start. Please confirm assessment questions are loaded.");
            request.getRequestDispatcher("/JSP/assessment/start.jsp").forward(request, response);
            return;
        }

        request.setAttribute("attemptId", attemptId);
        request.setAttribute("questions", questions);
        request.getRequestDispatcher("/JSP/assessment/questionnaire.jsp").forward(request, response);
    }

    private User requireStudent(HttpServletRequest request, HttpServletResponse response) throws IOException {
        User user = (User) request.getSession().getAttribute("loggedInUser");
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/JSP/auth/login.jsp");
            return null;
        }
        if (!User.Role.STUDENT.equals(user.getRole())) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN);
            return null;
        }
        return user;
    }
}
