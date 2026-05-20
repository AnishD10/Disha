package com.disha.controller.assessment;

import com.disha.dao.assessment.AssessmentDAO;
import com.disha.dao.assessment.CareerDAO;
import com.disha.dao.assessment.ResultDAO;
import com.disha.model.User;
import com.disha.model.assessment.AttemptAnswer;
import com.disha.model.assessment.AttemptSkill;
import com.disha.model.assessment.NepalCareer;
import com.disha.service.assessment.RecommendationService;
import com.disha.service.assessment.ScoringService;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Enumeration;
import java.util.List;

@WebServlet("/assessment/submit")
public class SubmitAssessmentServlet extends HttpServlet {
    private final AssessmentDAO assessmentDAO = new AssessmentDAO();
    private final CareerDAO careerDAO = new CareerDAO();
    private final ResultDAO resultDAO = new ResultDAO();
    private final ScoringService scoringService = new ScoringService();
    private final RecommendationService recommendationService = new RecommendationService();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        User user = (User) request.getSession().getAttribute("loggedInUser");
        if (user == null || !User.Role.STUDENT.equals(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/JSP/auth/login.jsp");
            return;
        }

        int attemptId = parseInt(request.getParameter("attemptId"));
        if (attemptId <= 0) {
            response.sendRedirect(request.getContextPath() + "/assessment/start");
            return;
        }

        List<AttemptAnswer> answers = new ArrayList<>();
        Enumeration<String> names = request.getParameterNames();
        while (names.hasMoreElements()) {
            String name = names.nextElement();
            if (!name.startsWith("q_")) continue;
            int questionId = parseInt(name.substring(2));
            int optionId = parseInt(request.getParameter(name));
            if (questionId <= 0 || optionId <= 0) continue;
            assessmentDAO.saveAnswer(attemptId, questionId, optionId);
            AttemptAnswer answer = new AttemptAnswer();
            answer.setAttemptId(attemptId);
            answer.setQuestionId(questionId);
            answer.setSelectedOptionId(optionId);
            answers.add(answer);
        }

        int aptitudeScore = scoringService.calculateAptitudeScore(answers);
        int personalityScore = scoringService.calculatePersonalityScore(answers);
        int interestScore = scoringService.calculateInterestScore(answers);
        String cluster = scoringService.calculateCluster(answers);

        assessmentDAO.updateAttemptScores(attemptId, aptitudeScore, personalityScore, interestScore, cluster);
        List<AttemptSkill> skills = scoringService.calculateSkills(aptitudeScore, personalityScore, interestScore);
        resultDAO.saveSkills(attemptId, skills);
        List<NepalCareer> careers = recommendationService.getTopThreeCareers(cluster, aptitudeScore);
        careerDAO.saveCareerRecommendations(attemptId, careers);

        response.sendRedirect(request.getContextPath() + "/assessment/result?attemptId=" + attemptId);
    }

    private int parseInt(String value) {
        try { return Integer.parseInt(value); } catch (Exception e) { return 0; }
    }
}
