package com.disha.controller.assessment;

import com.disha.dao.assessment.AssessmentDAO;
import com.disha.dao.assessment.CareerDAO;
import com.disha.dao.assessment.ResultDAO;
import com.disha.model.assessment.AttemptAnswer;
import com.disha.model.assessment.AttemptSkill;
import com.disha.model.assessment.NepalCareer;
import com.disha.service.assessment.RecommendationService;
import com.disha.service.assessment.ScoringService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

// SubmitAssessmentServlet receives all 30 answers from the questionnaire form.
// It scores them, finds career matches, saves everything, then redirects to results.
@WebServlet("/assessment/submit")
public class SubmitAssessmentServlet extends HttpServlet {

    private AssessmentDAO assessmentDAO = new AssessmentDAO();
    private CareerDAO careerDAO = new CareerDAO();
    private ResultDAO resultDAO = new ResultDAO();
    private ScoringService scoringService = new ScoringService();
    private RecommendationService recommendationService = new RecommendationService();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("loggedInUser") == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        int attemptId = Integer.parseInt(request.getParameter("attemptId"));

        // Build the list of answers from the submitted form data.
        // The form sends one parameter per question named "q_<questionId>" with the chosen option ID.
        List<AttemptAnswer> answers = new ArrayList<AttemptAnswer>();
        for (int qId = 1; qId <= 30; qId++) {
            String param = request.getParameter("q_" + qId);
            if (param == null || param.isEmpty()) continue;

            int selectedOptionId = Integer.parseInt(param);
            assessmentDAO.saveAnswer(attemptId, qId, selectedOptionId);

            AttemptAnswer answer = new AttemptAnswer();
            answer.setAttemptId(attemptId);
            answer.setQuestionId(qId);
            answer.setSelectedOptionId(selectedOptionId);
            answers.add(answer);
        }

        int aptitudeScore    = scoringService.calculateAptitudeScore(answers);
        int personalityScore = scoringService.calculatePersonalityScore(answers);
        int interestScore    = scoringService.calculateInterestScore(answers);
        String cluster       = scoringService.calculateCluster(answers);

        assessmentDAO.updateAttemptScores(attemptId, aptitudeScore, personalityScore, interestScore, cluster);

        List<AttemptSkill> skills = scoringService.calculateSkills(aptitudeScore, personalityScore, interestScore);
        resultDAO.saveSkills(attemptId, skills);

        List<NepalCareer> topCareers = recommendationService.getTopThreeCareers(cluster, aptitudeScore);
        careerDAO.saveCareerRecommendations(attemptId, topCareers);

        response.sendRedirect(request.getContextPath() + "/assessment/result?attemptId=" + attemptId);
    }
}
