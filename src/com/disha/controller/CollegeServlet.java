package com.disha.controller;

import dao.CollegeDAO;
import com.disha.model.College;
import com.disha.model.User;
import javax.servlet.ServletException;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;

/**
 * CollegeServlet handles all college management CRUD operations.
 */
public class CollegeServlet extends HttpServlet {
    private CollegeDAO collegeDAO = new CollegeDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        if (!requireAdmin(request, response)) {
            return;
        }

        String action = request.getParameter("action");
        if (action == null) action = "list";

        switch (action) {
            case "add":
                request.getRequestDispatcher("/JSP/admin/add-college.jsp").forward(request, response);
                break;
            case "edit":
                int editId = Integer.parseInt(request.getParameter("id"));
                College editCollege = collegeDAO.getCollegeById(editId);
                request.setAttribute("editCollege", editCollege);
                request.getRequestDispatcher("/JSP/admin/edit-college.jsp").forward(request, response);
                break;
            case "delete":
                int deleteId = Integer.parseInt(request.getParameter("id"));
                collegeDAO.deleteCollege(deleteId);
                response.sendRedirect(request.getContextPath() + "/admin/colleges?action=list&msg=deleted");
                break;
            default:
                List<College> colleges = collegeDAO.getAllColleges();
                request.setAttribute("colleges", colleges);
                request.getRequestDispatcher("/JSP/admin/manage-colleges.jsp").forward(request, response);
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        if (!requireAdmin(request, response)) {
            return;
        }

        String action = request.getParameter("action");

        College college = new College();
        college.setCollegeName(request.getParameter("collegeName"));
        college.setCollegeLocation(request.getParameter("collegeLocation"));
        college.setCollegeCity(request.getParameter("collegeCity"));
        college.setCollegeDescription(request.getParameter("collegeDescription"));
        college.setWebsiteUrl(request.getParameter("websiteUrl"));
        college.setContactEmail(request.getParameter("contactEmail"));
        college.setContactPhone(request.getParameter("contactPhone"));
        college.setPublic("on".equals(request.getParameter("isPublic")));
        college.setVerified("on".equals(request.getParameter("isVerified")));

        if ("add".equals(action)) {
            collegeDAO.createCollege(college);
            response.sendRedirect(request.getContextPath() + "/admin/colleges?action=list&msg=added");
        } else if ("edit".equals(action)) {
            college.setCollegeId(Integer.parseInt(request.getParameter("collegeId")));
            collegeDAO.updateCollege(college);
            response.sendRedirect(request.getContextPath() + "/admin/colleges?action=list&msg=updated");
        }
    }

    private boolean requireAdmin(HttpServletRequest request, HttpServletResponse response) throws IOException {
        User currentUser = (User) request.getSession().getAttribute("loggedInUser");
        if (currentUser == null) {
            response.sendRedirect(request.getContextPath() + "/JSP/auth/login.jsp");
            return false;
        }
        if (!User.Role.ADMIN.equals(currentUser.getRole())) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN);
            return false;
        }
        return true;
    }
}
