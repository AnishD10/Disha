package com.disha.career.servlet;

import com.disha.career.model.AptitudeProfile;
import com.disha.career.model.Career;
import com.disha.career.model.CareerMatch;
import com.disha.career.service.CareerRecommendationService;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.lang.reflect.Method;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

/**
 * MVC controller for the Career Discovery module.
 */
public class CareerDiscoveryServlet extends HttpServlet {
    private static final String JSP_RECOMMENDATIONS = "/JSP/career/recommendations.jsp";
    private static final String JSP_DETAILS = "/JSP/career/details.jsp";
    private static final String JSP_SEARCH = "/JSP/career/search.jsp";
    private static final String JSP_COMPARE = "/JSP/career/compare.jsp";
    private static final String JSP_SAVED = "/JSP/career/saved.jsp";
    private static final String JSP_ASSESSMENT = "/JSP/career/assessment.jsp";
    private static final String LOGIN_PATH = "JSP/auth/login.jsp";

    private CareerRecommendationService recommendationService;

    @Override
    public void init() {
        recommendationService = new CareerRecommendationService();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        StudentSession studentSession = requireStudentSession(request, response);
        if (studentSession == null) {
            return;
        }

        String action = safeAction(request.getParameter("action"));
        try {
            if ("details".equals(action)) {
                showCareerDetails(request, response);
            } else if ("search".equals(action)) {
                searchCareers(request, response);
            } else if ("filter".equals(action)) {
                filterCareers(request, response);
            } else if ("saved".equals(action)) {
                showSavedCareers(request, response, studentSession.studentId);
            } else if ("compare".equals(action)) {
                compareCareers(request, response);
            } else if ("retake".equals(action)) {
                forward(request, response, JSP_ASSESSMENT);
            } else {
                showRecommendations(request, response, studentSession.studentId);
            }
        } catch (IllegalArgumentException e) {
            handleBadRequest(request, response, e.getMessage());
        } catch (SQLException e) {
            handleServerError(request, response, e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        StudentSession studentSession = requireStudentSession(request, response);
        if (studentSession == null) {
            return;
        }

        String action = safeAction(request.getParameter("action"));
        try {
            if ("bookmark".equals(action)) {
                recommendationService.bookmarkCareer(studentSession.studentId, parsePositiveInt(request.getParameter("careerId"), "Career ID"));
                response.sendRedirect(request.getContextPath() + "/career?action=saved");
            } else if ("removeBookmark".equals(action)) {
                recommendationService.removeBookmark(studentSession.studentId, parsePositiveInt(request.getParameter("careerId"), "Career ID"));
                response.sendRedirect(request.getContextPath() + "/career?action=saved");
            } else if ("retake".equals(action)) {
                recommendationService.retakeAssessment(studentSession.studentId);
                response.sendRedirect(request.getContextPath() + "/career?action=retake");
            } else if ("saveScores".equals(action)) {
                recommendationService.saveAssessmentScores(buildProfileFromRequest(request, studentSession.studentId));
                response.sendRedirect(request.getContextPath() + "/career");
            } else {
                handleBadRequest(request, response, "Unsupported career action.");
            }
        } catch (IllegalArgumentException e) {
            handleBadRequest(request, response, e.getMessage());
        } catch (SQLException e) {
            handleServerError(request, response, e);
        }
    }

    private void showRecommendations(HttpServletRequest request, HttpServletResponse response, int studentId)
            throws SQLException, ServletException, IOException {
        List<CareerMatch> recommendations = recommendationService.recommendCareersForStudent(studentId);
        request.setAttribute("recommendedCareers", recommendations);
        request.setAttribute("hasRecommendations", !recommendations.isEmpty());
        forward(request, response, JSP_RECOMMENDATIONS);
    }

    private void showCareerDetails(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {
        int careerId = parsePositiveInt(request.getParameter("careerId"), "Career ID");
        Career career = recommendationService.getCareerDetails(careerId);
        if (career == null) {
            throw new IllegalArgumentException("Career not found.");
        }
        request.setAttribute("career", career);
        forward(request, response, JSP_DETAILS);
    }

    private void searchCareers(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {
        String keyword = request.getParameter("keyword");
        request.setAttribute("careers", recommendationService.searchCareers(keyword));
        request.setAttribute("keyword", keyword);
        forward(request, response, JSP_SEARCH);
    }

    private void filterCareers(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {
        List<Career> careers = recommendationService.filterCareers(
                request.getParameter("industry"),
                request.getParameter("demandLevel"),
                request.getParameter("remoteOpportunity"),
                request.getParameter("sortBy")
        );
        request.setAttribute("careers", careers);
        forward(request, response, JSP_SEARCH);
    }

    private void showSavedCareers(HttpServletRequest request, HttpServletResponse response, int studentId)
            throws SQLException, ServletException, IOException {
        request.setAttribute("savedCareers", recommendationService.getSavedCareers(studentId));
        forward(request, response, JSP_SAVED);
    }

    private void compareCareers(HttpServletRequest request, HttpServletResponse response)
            throws SQLException, ServletException, IOException {
        List<Integer> careerIds = parseCareerIds(request.getParameterValues("careerId"));
        request.setAttribute("careersToCompare", recommendationService.compareCareers(careerIds));
        forward(request, response, JSP_COMPARE);
    }

    private AptitudeProfile buildProfileFromRequest(HttpServletRequest request, int studentId) {
        AptitudeProfile profile = new AptitudeProfile();
        profile.setStudentId(studentId);
        profile.setAnalyticalScore(parseScore(request.getParameter("analyticalScore"), "Analytical score"));
        profile.setCreativityScore(parseScore(request.getParameter("creativityScore"), "Creativity score"));
        profile.setLeadershipScore(parseScore(request.getParameter("leadershipScore"), "Leadership score"));
        profile.setTechnicalScore(parseScore(request.getParameter("technicalScore"), "Technical score"));
        profile.setCommunicationScore(parseScore(request.getParameter("communicationScore"), "Communication score"));
        profile.setEntrepreneurialScore(parseScore(request.getParameter("entrepreneurialScore"), "Entrepreneurial score"));
        profile.setResearchScore(parseScore(request.getParameter("researchScore"), "Research score"));
        return profile;
    }

    private StudentSession requireStudentSession(HttpServletRequest request, HttpServletResponse response)
            throws IOException, ServletException {
        HttpSession session = request.getSession(false);
        if (session == null) {
            response.sendRedirect(request.getContextPath() + "/" + LOGIN_PATH);
            return null;
        }

        Object user = firstNonNull(session.getAttribute("loggedInUser"), session.getAttribute("user"));
        Object role = firstNonNull(session.getAttribute("role"), extractByGetter(user, "getRole"));
        if (!isStudentRole(role)) {
            response.setStatus(HttpServletResponse.SC_FORBIDDEN);
            forward(request, response, "/JSP/error/403.jsp");
            return null;
        }

        Integer studentId = asInteger(firstNonNull(
                session.getAttribute("studentId"),
                session.getAttribute("student_id"),
                session.getAttribute("userId"),
                extractByGetter(user, "getUserId"),
                extractByGetter(user, "getId")
        ));
        if (studentId == null || studentId <= 0) {
            studentId = resolveStudentIdFromUserEmail(user);
            if (studentId != null && studentId > 0) {
                session.setAttribute("studentId", studentId);
                session.setAttribute("role", "STUDENT");
            }
        }
        if (studentId == null || studentId <= 0) {
            response.setStatus(HttpServletResponse.SC_FORBIDDEN);
            request.setAttribute("errorMessage", "Student session is missing a valid student ID.");
            forward(request, response, "/JSP/error/403.jsp");
            return null;
        }
        return new StudentSession(studentId);
    }

    private boolean isStudentRole(Object role) {
        if (role == null) {
            return false;
        }
        return "STUDENT".equalsIgnoreCase(String.valueOf(role));
    }

    private Integer resolveStudentIdFromUserEmail(Object user) {
        Object email = extractByGetter(user, "getEmail");
        if (email == null) {
            return null;
        }
        try {
            return recommendationService.findStudentIdByEmail(String.valueOf(email));
        } catch (SQLException e) {
            log("Unable to resolve student ID from session user email.", e);
            return null;
        }
    }

    private Object extractByGetter(Object target, String getterName) {
        if (target == null) {
            return null;
        }
        try {
            Method method = target.getClass().getMethod(getterName);
            return method.invoke(target);
        } catch (Exception ignored) {
            return null;
        }
    }

    private Object firstNonNull(Object... values) {
        for (Object value : values) {
            if (value != null) {
                return value;
            }
        }
        return null;
    }

    private Integer asInteger(Object value) {
        if (value instanceof Number) {
            return ((Number) value).intValue();
        }
        if (value instanceof String) {
            try {
                return Integer.valueOf((String) value);
            } catch (NumberFormatException ignored) {
                return null;
            }
        }
        return null;
    }

    private List<Integer> parseCareerIds(String[] values) {
        List<Integer> ids = new ArrayList<Integer>();
        if (values == null) {
            return ids;
        }
        for (String value : values) {
            ids.add(parsePositiveInt(value, "Career ID"));
        }
        return ids;
    }

    private int parseScore(String rawValue, String label) {
        int score = parsePositiveInt(rawValue, label);
        if (score > 100) {
            throw new IllegalArgumentException(label + " must be between 0 and 100.");
        }
        return score;
    }

    private int parsePositiveInt(String rawValue, String label) {
        try {
            int value = Integer.parseInt(rawValue);
            if (value < 0) {
                throw new NumberFormatException();
            }
            return value;
        } catch (NumberFormatException e) {
            throw new IllegalArgumentException(label + " must be a valid positive number.");
        }
    }

    private String safeAction(String action) {
        return action == null ? "recommendations" : action.trim();
    }

    private void handleBadRequest(HttpServletRequest request, HttpServletResponse response, String message)
            throws ServletException, IOException {
        response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
        request.setAttribute("errorMessage", message);
        forward(request, response, "/JSP/error/400.jsp");
    }

    private void handleServerError(HttpServletRequest request, HttpServletResponse response, Exception e)
            throws ServletException, IOException {
        log("Career module failure", e);
        response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
        request.setAttribute("errorMessage", "Career recommendations are temporarily unavailable.");
        forward(request, response, "/JSP/error/500.jsp");
    }

    private void forward(HttpServletRequest request, HttpServletResponse response, String jspPath)
            throws ServletException, IOException {
        RequestDispatcher dispatcher = request.getRequestDispatcher(jspPath);
        dispatcher.forward(request, response);
    }

    private static class StudentSession {
        private final int studentId;

        private StudentSession(int studentId) {
            this.studentId = studentId;
        }
    }
}

