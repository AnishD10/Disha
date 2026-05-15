package com.disha.controller.counselor;

import com.disha.dao.assessment.AssessmentDAO;
import com.disha.dao.counselor.CounselorDAO;
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

// StudentDetailServlet loads one student's full profile for the counselor to review.
@WebServlet("/counselor/student")
public class StudentDetailServlet extends HttpServlet {

    private CounselorDAO counselorDAO = new CounselorDAO();
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
        String role = loggedInUser.getRole();
        if (!role.equals("COUNSELOR") && !role.equals("ADMIN")) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String param = request.getParameter("studentId");
        if (param == null || param.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/counselor/dashboard");
            return;
        }

        int studentId = Integer.parseInt(param);
        User student = counselorDAO.getStudentById(studentId);

        if (student == null) {
            response.sendRedirect(request.getContextPath() + "/counselor/dashboard");
            return;
        }

        List<AssessmentAttempt> attempts = assessmentDAO.getAttemptsByStudent(studentId);
        request.setAttribute("student", student);
        request.setAttribute("attempts", attempts);
        request.getRequestDispatcher("/jsp/counselor/studentDetail.jsp").forward(request, response);
    }
}
