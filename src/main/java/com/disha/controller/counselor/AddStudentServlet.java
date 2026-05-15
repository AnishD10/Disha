package com.disha.controller.counselor;

import com.disha.dao.counselor.CounselorDAO;
import com.disha.model.auth.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

// AddStudentServlet lets counselors/admins register new student accounts.
@WebServlet("/counselor/addStudent")
public class AddStudentServlet extends HttpServlet {

    private CounselorDAO counselorDAO = new CounselorDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Auth check
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("loggedInUser") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        User loggedInUser = (User) session.getAttribute("loggedInUser");
        String role = loggedInUser.getRole();
        if (!"COUNSELOR".equals(role) && !"ADMIN".equals(role)) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String firstName = request.getParameter("firstName") != null ? request.getParameter("firstName").trim() : "";
        String lastName  = request.getParameter("lastName")  != null ? request.getParameter("lastName").trim()  : "";
        String email     = request.getParameter("email")     != null ? request.getParameter("email").trim()     : "";
        String password  = request.getParameter("password")  != null ? request.getParameter("password").trim()  : "";

        String fullName = (firstName + " " + lastName).trim();

        if (fullName.isEmpty() || email.isEmpty() || password.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/counselor/dashboard?addError=empty");
            return;
        }

        boolean success = counselorDAO.addStudent(fullName, email, password);
        if (success) {
            response.sendRedirect(request.getContextPath() + "/counselor/dashboard?addSuccess=1");
        } else {
            response.sendRedirect(request.getContextPath() + "/counselor/dashboard?addError=duplicate");
        }
    }
}
