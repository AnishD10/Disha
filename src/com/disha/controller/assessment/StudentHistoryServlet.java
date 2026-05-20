package com.disha.controller.assessment;

import com.disha.dao.assessment.AssessmentDAO;
import com.disha.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/assessment/history")
public class StudentHistoryServlet extends HttpServlet {
    private final AssessmentDAO assessmentDAO = new AssessmentDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        User user = (User) request.getSession().getAttribute("loggedInUser");
        if (user == null || !User.Role.STUDENT.equals(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/JSP/auth/login.jsp");
            return;
        }
        request.setAttribute("attempts", assessmentDAO.getAttemptsByStudent(user.getUserId()));
        request.getRequestDispatcher("/JSP/assessment/history.jsp").forward(request, response);
    }
}
