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

// FlagStudentServlet lets a counselor mark or un-mark a student as at-risk.
// After saving, it redirects back to the student detail page.
@WebServlet("/counselor/flag")
public class FlagStudentServlet extends HttpServlet {

    private CounselorDAO counselorDAO = new CounselorDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
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

        int studentId    = Integer.parseInt(request.getParameter("studentId"));
        String flagParam = request.getParameter("flagged");
        String note      = request.getParameter("counselorNote");
        boolean flagged  = "true".equals(flagParam);

        counselorDAO.updateStudentFlag(studentId, flagged, note);
        response.sendRedirect(request.getContextPath() + "/counselor/student?studentId=" + studentId);
    }
}
