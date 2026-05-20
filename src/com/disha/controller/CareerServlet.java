package com.disha.controller;

import dao.CareerDAO;
import com.disha.model.Career;
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
                careerDAO.deleteCareer(deleteId);
                response.sendRedirect(request.getContextPath() + "/admin/careers?action=list&msg=deleted");
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
        String action = request.getParameter("action");

        Career career = new Career();
        career.setCareerName(request.getParameter("careerName"));
        career.setCareerDescription(request.getParameter("careerDescription"));
        career.setRequiredAptitudeCluster(request.getParameter("requiredAptitudeCluster"));
        career.setMarketDemand(request.getParameter("marketDemand"));
        try { career.setAverageSalary(new BigDecimal(request.getParameter("averageSalary"))); } catch (Exception e) { career.setAverageSalary(BigDecimal.ZERO); }
        try { career.setRiskIndex(Integer.parseInt(request.getParameter("riskIndex"))); } catch (Exception e) { career.setRiskIndex(0); }
        try { career.setJobMarketGrowthRate(new BigDecimal(request.getParameter("jobMarketGrowthRate"))); } catch (Exception e) { career.setJobMarketGrowthRate(BigDecimal.ZERO); }

        if ("add".equals(action)) {
            careerDAO.createCareer(career);
            response.sendRedirect(request.getContextPath() + "/admin/careers?action=list&msg=added");
        } else if ("edit".equals(action)) {
            career.setCareerId(Integer.parseInt(request.getParameter("careerId")));
            careerDAO.updateCareer(career);
            response.sendRedirect(request.getContextPath() + "/admin/careers?action=list&msg=updated");
        }
    }
}
