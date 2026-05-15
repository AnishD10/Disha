package com.disha.controller.assessment;

import com.disha.dao.assessment.AssessmentDAO;
import com.disha.model.assessment.AssessmentAttempt;
import com.disha.model.auth.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

// StudentHistoryServlet loads all past completed attempts for the logged-in student.
@WebServlet("/assessment/history")
public class StudentHistoryServlet extends HttpServlet {

    private AssessmentDAO assessmentDAO = new AssessmentDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("loggedInUser") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        User loggedInUser = (User) session.getAttribute("loggedInUser");
        int studentId = loggedInUser.getUserId();

        List<AssessmentAttempt> attempts = assessmentDAO.getAttemptsByStudent(studentId);
        request.setAttribute("attempts", attempts);
        request.setAttribute("studentName", loggedInUser.getFullName());
        request.getRequestDispatcher("/jsp/assessment/history.jsp").forward(request, response);
    }
}
