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

/**
 * StudentDetailServlet handles requests for retrieving and presenting a specific student's
 * complete profile details, including their assessment logs and demographic data,
 * for review by counselors or administrators.
 * 
 * Access is restricted to authorized roles (COUNSELOR, ADMIN).
 * 
 * @author Ashmit
 */
@WebServlet("/counselor/student")
public class StudentDetailServlet extends HttpServlet {

    private CounselorDAO counselorDAO = new CounselorDAO();
    private AssessmentDAO assessmentDAO = new AssessmentDAO();

    /**
     * Handles HTTP GET requests to fetch and display student details.
     * Validates session authenticity and checks that the logged-in user possesses 
     * counselor or administrator privileges. Retrieves the student demographic profile 
     * and their past completed assessment attempt history from the database, and forwards 
     * the request to the student detail review JSP view.
     * 
     * @param request  The HttpServletRequest object containing request parameters (e.g., studentId)
     * @param response The HttpServletResponse object for redirecting or sending a response
     * @throws ServletException If a servlet-specific error occurs during forwarding
     * @throws IOException      If an input/output exception occurs during request handling
     */
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
