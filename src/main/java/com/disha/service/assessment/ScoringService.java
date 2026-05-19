package com.disha.service.assessment;

import com.disha.dao.assessment.QuestionDAO;
import com.disha.model.assessment.AttemptAnswer;
import com.disha.model.assessment.AttemptSkill;

import java.util.ArrayList;
import java.util.List;

/**
 * ScoringService is responsible for processing student answers and calculating
 * their aptitude, personality, and interest scores. It also determines the
 * student's personality cluster and skill classification.
 * 
 * @author Ashmit
 */
public class ScoringService {

    private QuestionDAO questionDAO = new QuestionDAO();

    /**
     * Calculates the total aptitude score based on Section A answers.
     * Each correct answer is worth 1 point (Max 10).
     * 
     * @param answers The list of student's answers for all 30 questions
     * @return Total correct answers for questions 1 to 10
     */
    public int calculateAptitudeScore(List<AttemptAnswer> answers) {
        int score = 0;
        for (AttemptAnswer answer : answers) {
            if (answer.getQuestionId() >= 1 && answer.getQuestionId() <= 10) {
                if (questionDAO.isCorrectOption(answer.getSelectedOptionId())) score++;
            }
        }
        return score;
    }

    /**
     * Calculates the total personality score based on Section B answers.
     * Score is based on Likert scale values (1 to 5) for questions 11 to 20.
     * 
     * @param answers The list of student's answers
     * @return Sum of Likert values for Section B (Max 50)
     */
    public int calculatePersonalityScore(List<AttemptAnswer> answers) {
        int score = 0;
        for (AttemptAnswer answer : answers) {
            if (answer.getQuestionId() >= 11 && answer.getQuestionId() <= 20) {
                score += questionDAO.getScoreValueByOptionId(answer.getSelectedOptionId());
            }
        }
        return score;
    }

    /**
     * Calculates the total interest score based on Section C answers.
     * Score is based on Likert scale values (1 to 5) for questions 21 to 30.
     * 
     * @param answers The list of student's answers
     * @return Sum of Likert values for Section C (Max 50)
     */
    public int calculateInterestScore(List<AttemptAnswer> answers) {
        int score = 0;
        for (AttemptAnswer answer : answers) {
            if (answer.getQuestionId() >= 21 && answer.getQuestionId() <= 30) {
                score += questionDAO.getScoreValueByOptionId(answer.getSelectedOptionId());
            }
        }
        return score;
    }

    /**
     * Analyzes answers to determine the student's dominant personality cluster.
     * Clusters are determined by comparing scores in: Analytical (Q11-13), 
     * Social (Q14-16), Creative (Q17-19), and Practical (Q20).
     * 
     * @param answers The list of student's answers
     * @return The name of the highest-scoring cluster
     */
    public String calculateCluster(List<AttemptAnswer> answers) {
        int analyticalScore = 0, socialScore = 0, creativeScore = 0, practicalScore = 0;
        for (AttemptAnswer answer : answers) {
            int qId = answer.getQuestionId();
            int val = questionDAO.getScoreValueByOptionId(answer.getSelectedOptionId());
            if (qId == 11 || qId == 12 || qId == 13)       analyticalScore += val;
            else if (qId == 14 || qId == 15 || qId == 16)  socialScore += val;
            else if (qId == 17 || qId == 18 || qId == 19)  creativeScore += val;
            else if (qId == 20)                             practicalScore += val;
        }

        double analyticalPct = (analyticalScore / 15.0) * 100;
        double socialPct     = (socialScore / 15.0) * 100;
        double creativePct   = (creativeScore / 15.0) * 100;
        double practicalPct  = (practicalScore / 5.0) * 100;

        String cluster = "Analytical";
        double highest = analyticalPct;
        if (socialPct > highest)    { highest = socialPct;   cluster = "Social"; }
        if (creativePct > highest)  { highest = creativePct; cluster = "Creative"; }
        if (practicalPct > highest) {                        cluster = "Practical"; }
        return cluster;
    }

    /**
     * Converts raw scores into descriptive skill objects for report display.
     * Maps scores to "Logical Thinking", "Communication", and "Work Ethic".
     * 
     * @param aptitudeScore Raw score from Section A
     * @param personalityScore Raw score from Section B
     * @param interestScore Raw score from Section C
     * @return A list of AttemptSkill objects with levels (STRONG, AVERAGE, WEAK)
     */
    public List<AttemptSkill> calculateSkills(int aptitudeScore, int personalityScore, int interestScore) {
        List<AttemptSkill> skills = new ArrayList<AttemptSkill>();

        AttemptSkill logical = new AttemptSkill();
        logical.setSkillName("Logical Thinking");
        logical.setSkillScore(aptitudeScore);
        logical.setSkillLevel(classifySkill(aptitudeScore, 10));
        skills.add(logical);

        AttemptSkill communication = new AttemptSkill();
        communication.setSkillName("Communication");
        communication.setSkillScore(personalityScore);
        communication.setSkillLevel(classifySkill(personalityScore, 50));
        skills.add(communication);

        AttemptSkill workEthic = new AttemptSkill();
        workEthic.setSkillName("Work Ethic");
        workEthic.setSkillScore(interestScore);
        workEthic.setSkillLevel(classifySkill(interestScore, 50));
        skills.add(workEthic);

        return skills;
    }

    // Classifies a score as STRONG, AVERAGE, or WEAK based on its percentage of the maximum.
    // 80% and above = STRONG, 50% to 79% = AVERAGE, below 50% = WEAK.
    private String classifySkill(int score, int maxScore) {
        double percentage = (score / (double) maxScore) * 100;
        if (percentage >= 80) return "STRONG";
        else if (percentage >= 50) return "AVERAGE";
        else return "WEAK";
    }
}
