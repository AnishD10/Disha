package com.disha.controller;

import com.disha.model.LabourMarketData;
import com.disha.model.User;
import dao.CareerDAO;
import dao.LabourMarketDAO;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.math.BigDecimal;

/**
 * Admin CRUD controller for Nepal labour market data.
 */
public class LabourMarketServlet extends HttpServlet {
    private final LabourMarketDAO labourMarketDAO = new LabourMarketDAO();
    private final CareerDAO careerDAO = new CareerDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        if (!requireAdmin(request, response)) {
            return;
        }

        String action = request.getParameter("action");
        if ("delete".equals(action)) {
            int id = parseInt(request.getParameter("id"), 0);
            if (id > 0) {
                labourMarketDAO.deleteRecord(id);
            }
            response.sendRedirect(request.getContextPath() + "/admin/labour-market?msg=deleted");
            return;
        }

        if ("edit".equals(action)) {
            int id = parseInt(request.getParameter("id"), 0);
            request.setAttribute("editRecord", labourMarketDAO.getRecordById(id));
        }

        request.setAttribute("records", labourMarketDAO.getAllRecords());
        request.setAttribute("careers", careerDAO.getAllCareers());
        request.getRequestDispatcher("/JSP/admin/manage-labour-market.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        if (!requireAdmin(request, response)) {
            return;
        }

        User currentUser = (User) request.getSession().getAttribute("loggedInUser");
        LabourMarketData record = buildRecord(request, currentUser);
        String action = request.getParameter("action");

        if ("edit".equals(action)) {
            record.setMarketDataId(parseInt(request.getParameter("marketDataId"), 0));
            labourMarketDAO.updateRecord(record);
            response.sendRedirect(request.getContextPath() + "/admin/labour-market?msg=updated");
        } else {
            labourMarketDAO.createRecord(record);
            response.sendRedirect(request.getContextPath() + "/admin/labour-market?msg=added");
        }
    }

    private LabourMarketData buildRecord(HttpServletRequest request, User currentUser) {
        LabourMarketData record = new LabourMarketData();
        record.setCareerId(parseInt(request.getParameter("careerId"), 0));
        record.setDataYear(parseInt(request.getParameter("dataYear"), 0));
        record.setJobOpenings(parseInt(request.getParameter("jobOpenings"), 0));
        record.setAverageSalary(parseDecimal(request.getParameter("averageSalary")));
        record.setSalaryCurrency(defaultString(request.getParameter("salaryCurrency"), "NPR"));
        record.setMarketDemand(defaultString(request.getParameter("marketDemand"), "MEDIUM"));
        record.setRiskIndex(parseInt(request.getParameter("riskIndex"), 0));
        record.setGrowthRate(parseDecimal(request.getParameter("growthRate")));
        record.setUpdatedBy(currentUser.getUserId());
        return record;
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

    private int parseInt(String value, int fallback) {
        try { return Integer.parseInt(value); } catch (Exception e) { return fallback; }
    }

    private BigDecimal parseDecimal(String value) {
        try { return new BigDecimal(value); } catch (Exception e) { return BigDecimal.ZERO; }
    }

    private String defaultString(String value, String fallback) {
        return value == null || value.trim().isEmpty() ? fallback : value.trim();
    }
}
