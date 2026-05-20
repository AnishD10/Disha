package com.disha.service.assessment;

import com.disha.dao.assessment.QuestionDAO;
import com.disha.model.assessment.AttemptAnswer;
import com.disha.model.assessment.AttemptSkill;

import java.util.ArrayList;
import java.util.List;

public class ScoringService {
    private final QuestionDAO questionDAO = new QuestionDAO();

    public int calculateAptitudeScore(List<AttemptAnswer> answers) {
        int score = 0;
        for (AttemptAnswer answer : answers) {
            if (answer.getQuestionId() >= 1 && answer.getQuestionId() <= 10
                    && questionDAO.isCorrectOption(answer.getSelectedOptionId())) {
                score++;
            }
        }
        return score;
    }

    public int calculatePersonalityScore(List<AttemptAnswer> answers) {
        return calculateLikertScore(answers, 11, 20);
    }

    public int calculateInterestScore(List<AttemptAnswer> answers) {
        return calculateLikertScore(answers, 21, 30);
    }

    public String calculateCluster(List<AttemptAnswer> answers) {
        int analytical = 0;
        int social = 0;
        int creative = 0;
        int practical = 0;
        for (AttemptAnswer answer : answers) {
            int questionId = answer.getQuestionId();
            int score = questionDAO.getScoreValueByOptionId(answer.getSelectedOptionId());
            if (questionId >= 11 && questionId <= 13) analytical += score;
            else if (questionId >= 14 && questionId <= 16) social += score;
            else if (questionId >= 17 && questionId <= 19) creative += score;
            else if (questionId == 20) practical += score * 3;
        }
        String cluster = "Analytical";
        int highest = analytical;
        if (social > highest) { highest = social; cluster = "Social"; }
        if (creative > highest) { highest = creative; cluster = "Creative"; }
        if (practical > highest) { cluster = "Practical"; }
        return cluster;
    }

    public List<AttemptSkill> calculateSkills(int aptitudeScore, int personalityScore, int interestScore) {
        List<AttemptSkill> skills = new ArrayList<>();
        skills.add(skill("Logical Thinking", aptitudeScore, 10));
        skills.add(skill("Communication", personalityScore, 50));
        skills.add(skill("Career Motivation", interestScore, 50));
        return skills;
    }

    private int calculateLikertScore(List<AttemptAnswer> answers, int minQuestion, int maxQuestion) {
        int score = 0;
        for (AttemptAnswer answer : answers) {
            if (answer.getQuestionId() >= minQuestion && answer.getQuestionId() <= maxQuestion) {
                score += questionDAO.getScoreValueByOptionId(answer.getSelectedOptionId());
            }
        }
        return score;
    }

    private AttemptSkill skill(String name, int score, int maxScore) {
        AttemptSkill skill = new AttemptSkill();
        skill.setSkillName(name);
        skill.setSkillScore(score);
        double percent = maxScore == 0 ? 0 : (score * 100.0 / maxScore);
        skill.setSkillLevel(percent >= 80 ? "STRONG" : percent >= 50 ? "AVERAGE" : "WEAK");
        return skill;
    }
}
