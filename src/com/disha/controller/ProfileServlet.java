package com.disha.controller;

import com.disha.model.User;
import com.disha.util.SessionUtil;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

public class ProfileServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        User currentUser = SessionUtil.getLoggedInUser(request);
        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/JSP/auth/login.jsp");
            return;
        }

        request.setAttribute("profileUser", currentUser);
        request.getRequestDispatcher("/JSP/profile/profile.jsp").forward(request, response);
    }
}
