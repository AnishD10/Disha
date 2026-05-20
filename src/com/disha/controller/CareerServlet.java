package com.disha.controller;

import dao.CareerDAO;
import com.disha.model.Career;
import com.disha.model.User;
import javax.servlet.ServletException;
import javax.servlet.http.*;
import java.io.IOException;
import java.math.BigDecimal;
import java.util.List;

/**
 * CareerServlet handles all career management CRUD operations.
 */
public class CareerServlet extends HttpServlet {
    private CareerDAO careerDAO = new CareerDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        if (!requireAdmin(request, response)) {
            return;
        }

        String action = request.getParameter("action");
        if (action == null) action = "list";

        switch (action) {
            case "add":
                request.getRequestDispatcher("/JSP/admin/add-career.jsp").forward(request, response);
                break;
            case "edit":
                int editId = Integer.parseInt(request.getParameter("id"));
                Career editCareer = careerDAO.getCareerById(editId);
                request.setAttribute("editCareer", editCareer);
                request.getRequestDispatcher("/JSP/admin/edit-career.jsp").forward(request, response);
                break;
            case "delete":
                int deleteId = Integer.parseInt(request.getParameter("id"));
                boolean deleted = careerDAO.deleteCareer(deleteId);
                response.sendRedirect(request.getContextPath() + "/admin/careers?action=list&msg=" + (deleted ? "deleted" : "delete_blocked"));
                break;
            default:
                String search = request.getParameter("search");
                List<Career> careers;
                if (search != null && !search.trim().isEmpty()) {
                    careers = careerDAO.searchCareers(search.trim());
                } else {
                    careers = careerDAO.getAllCareers();
                }
                request.setAttribute("careers", careers);
                request.setAttribute("searchQuery", search);
                request.getRequestDispatcher("/JSP/admin/manage-careers.jsp").forward(request, response);
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        if (!requireAdmin(request, response)) {
            return;
        }

        String action = request.getParameter("action");

        Career career = new Career();
        career.setCareerName(request.getParameter("careerName"));
        career.setOverview(request.getParameter("overview"));
        career.setResponsibilities(request.getParameter("responsibilities"));
        career.setIndustry(request.getParameter("industry"));
        career.setFutureScope(request.getParameter("futureScope"));
        career.setDemandLevel(request.getParameter("demandLevel"));
        career.setAutomationRisk(request.getParameter("automationRisk"));
        career.setRemoteOpportunity(request.getParameter("remoteOpportunity"));
        career.setDescription(request.getParameter("description"));
        career.setSuggestedCertifications(request.getParameter("suggestedCertifications"));
        career.setSalaryEntry(parseDecimal(request.getParameter("salaryEntry")));
        career.setSalaryMid(parseDecimal(request.getParameter("salaryMid")));
        career.setSalarySenior(parseDecimal(request.getParameter("salarySenior")));
        career.setGrowthRate(parseDecimal(request.getParameter("growthRate")));

        if ("add".equals(action)) {
            careerDAO.createCareer(career);
            response.sendRedirect(request.getContextPath() + "/admin/careers?action=list&msg=added");
        } else if ("edit".equals(action)) {
            career.setCareerId(Integer.parseInt(request.getParameter("careerId")));
            careerDAO.updateCareer(career);
            response.sendRedirect(request.getContextPath() + "/admin/careers?action=list&msg=updated");
        }
    }

    private BigDecimal parseDecimal(String value) {
        try { return new BigDecimal(value); } catch (Exception e) { return BigDecimal.ZERO; }
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
