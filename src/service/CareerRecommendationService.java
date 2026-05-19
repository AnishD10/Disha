package service;

import dao.CareerDAO;
import model.AptitudeProfile;
import model.Career;
import model.CareerMatch;
import model.CareerMatchRule;

import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.List;

/**
 * Business layer for career recommendation, ranking, labeling, and explanations.
 */
public class CareerRecommendationService {
    private static final int DEFAULT_LIMIT = 5;
    private final CareerDAO careerDAO;

    public CareerRecommendationService() {
        this(new CareerDAO());
    }

    public CareerRecommendationService(CareerDAO careerDAO) {
        this.careerDAO = careerDAO;
    }

    public List<CareerMatch> recommendCareersForStudent(int studentId) throws SQLException {
        return recommendCareersForStudent(studentId, DEFAULT_LIMIT);
    }

    public List<CareerMatch> recommendCareersForStudent(int studentId, int limit) throws SQLException {
        validateStudentId(studentId);
        AptitudeProfile profile = careerDAO.getAptitudeProfileByStudentId(studentId);
        if (profile == null) {
            return new ArrayList<CareerMatch>();
        }
        return buildMatches(profile, limit);
    }

    public Career getCareerDetails(int careerId) throws SQLException {
        validateCareerId(careerId);
        return careerDAO.getCareerById(careerId);
    }

    public Integer findStudentIdByEmail(String email) throws SQLException {
        if (email == null || email.trim().isEmpty()) {
            return null;
        }
        return careerDAO.getStudentIdByEmail(email);
    }

    public List<Career> searchCareers(String keyword) throws SQLException {
        if (keyword == null || keyword.trim().length() < 2) {
            return careerDAO.getAllCareers();
        }
        return careerDAO.searchCareers(keyword.trim());
    }

    public List<Career> filterCareers(String industry, String demandLevel, String remoteOpportunity,
                                      String sortBy) throws SQLException {
        return careerDAO.filterCareers(industry, demandLevel, remoteOpportunity, sortBy);
    }

    public void bookmarkCareer(int studentId, int careerId) throws SQLException {
        validateStudentId(studentId);
        validateCareerId(careerId);
        careerDAO.saveCareerBookmark(studentId, careerId);
    }

    public void removeBookmark(int studentId, int careerId) throws SQLException {
        validateStudentId(studentId);
        validateCareerId(careerId);
        careerDAO.removeCareerBookmark(studentId, careerId);
    }

    public List<Career> getSavedCareers(int studentId) throws SQLException {
        validateStudentId(studentId);
        return careerDAO.getSavedCareers(studentId);
    }

    public List<Career> compareCareers(List<Integer> careerIds) throws SQLException {
        if (careerIds == null || careerIds.size() < 2) {
            return new ArrayList<Career>();
        }
        return careerDAO.compareCareers(careerIds.subList(0, Math.min(4, careerIds.size())));
    }

    public void retakeAssessment(int studentId) throws SQLException {
        validateStudentId(studentId);
        careerDAO.clearAssessmentForRetake(studentId);
    }

    public void saveAssessmentScores(AptitudeProfile profile) throws SQLException {
        if (profile == null) {
            throw new IllegalArgumentException("Aptitude profile is required.");
        }
        validateStudentId(profile.getStudentId());
        normalizeScores(profile);
        careerDAO.saveOrUpdateAptitudeProfile(profile);
    }

    private List<CareerMatch> buildMatches(AptitudeProfile profile, int limit) throws SQLException {
        List<Career> careers = careerDAO.getAllCareers();
        List<CareerMatchRule> rules = careerDAO.getCareerMatchRules();
        List<CareerMatch> matches = new ArrayList<CareerMatch>();

        for (Career career : careers) {
            CareerMatchRule rule = findRuleForCareer(rules, career.getCareerId());
            if (rule == null) {
                continue;
            }
            double compatibility = applyCareerSpecificBoosts(
                    career,
                    profile,
                    careerDAO.calculateCareerCompatibility(profile, rule)
            );
            CareerMatch match = new CareerMatch();
            match.setCareer(career);
            match.setCompatibilityPercentage(compatibility);
            match.setMatchStrength(matchStrength(compatibility));
            match.setExplanation(generateExplanation(career, profile, rule));
            match.setDemandBadge(demandBadge(career.getDemandLevel()));
            match.setAutomationRiskBadge(automationRiskBadge(career.getAutomationRisk()));
            match.setRemoteOpportunityBadge(remoteBadge(career.getRemoteOpportunity()));
            match.setGrowthTrendBadge(growthBadge(career));
            matches.add(match);
        }

        Collections.sort(matches, new Comparator<CareerMatch>() {
            @Override
            public int compare(CareerMatch left, CareerMatch right) {
                return Double.compare(right.getCompatibilityPercentage(), left.getCompatibilityPercentage());
            }
        });
        int safeLimit = limit <= 0 ? DEFAULT_LIMIT : limit;
        return new ArrayList<CareerMatch>(matches.subList(0, Math.min(safeLimit, matches.size())));
    }

    private double applyCareerSpecificBoosts(Career career, AptitudeProfile profile, double baseScore) {
        double score = baseScore;
        String name = career.getCareerName() == null ? "" : career.getCareerName().toLowerCase();

        if (name.contains("software") && profile.getTechnicalScore() > 80 && profile.getAnalyticalScore() > 75) {
            score += 6.0;
        }
        if ((name.contains("ui") || name.contains("ux") || name.contains("designer"))
                && profile.getCreativityScore() > 85 && profile.getCommunicationScore() > 70) {
            score += 6.0;
        }
        if (name.contains("data") && profile.getAnalyticalScore() > 80 && profile.getResearchScore() > 70) {
            score += 5.0;
        }
        if (name.contains("entrepreneur") && profile.getEntrepreneurialScore() > 80
                && profile.getLeadershipScore() > 70) {
            score += 5.0;
        }
        return Math.min(100.0, Math.round(score * 100.0) / 100.0);
    }

    private String generateExplanation(Career career, AptitudeProfile profile, CareerMatchRule rule) {
        List<String> strengths = topAlignedStrengths(profile, rule);
        String careerName = career.getCareerName() == null ? "this career" : career.getCareerName();
        if (strengths.isEmpty()) {
            return "Recommended because the student's balanced aptitude profile has a usable foundation for " +
                    careerName + ".";
        }
        if (strengths.size() == 1) {
            return "Recommended because the student scored strongly in " + strengths.get(0) +
                    ", which aligns with " + careerName + ".";
        }
        return "Recommended because the student scored highly in " + strengths.get(0) + " and " + strengths.get(1) +
                ", which strongly align with " + careerName + ".";
    }

    private List<String> topAlignedStrengths(AptitudeProfile profile, CareerMatchRule rule) {
        List<Strength> strengths = new ArrayList<Strength>();
        addStrength(strengths, "analytical thinking", profile.getAnalyticalScore(), rule.getRequiredAnalytical());
        addStrength(strengths, "creativity", profile.getCreativityScore(), rule.getRequiredCreativity());
        addStrength(strengths, "leadership", profile.getLeadershipScore(), rule.getRequiredLeadership());
        addStrength(strengths, "technical aptitude", profile.getTechnicalScore(), rule.getRequiredTechnical());
        addStrength(strengths, "communication", profile.getCommunicationScore(), rule.getRequiredCommunication());
        addStrength(strengths, "entrepreneurial thinking", profile.getEntrepreneurialScore(), rule.getRequiredEntrepreneurial());
        addStrength(strengths, "research ability", profile.getResearchScore(), rule.getRequiredResearch());
        Collections.sort(strengths, new Comparator<Strength>() {
            @Override
            public int compare(Strength left, Strength right) {
                return Integer.compare(right.score, left.score);
            }
        });

        List<String> labels = new ArrayList<String>();
        for (Strength strength : strengths) {
            labels.add(strength.label);
        }
        return labels;
    }

    private void addStrength(List<Strength> strengths, String label, int actual, int required) {
        if (required > 0 && actual >= Math.max(70, required - 5)) {
            strengths.add(new Strength(label, actual));
        }
    }

    private String matchStrength(double percentage) {
        if (percentage >= 85.0) {
            return "EXCELLENT MATCH";
        }
        if (percentage >= 70.0) {
            return "STRONG MATCH";
        }
        if (percentage >= 55.0) {
            return "MODERATE MATCH";
        }
        return "DEVELOPING MATCH";
    }

    private String demandBadge(String demandLevel) {
        if ("HIGH".equalsIgnoreCase(demandLevel)) {
            return "HIGH DEMAND";
        }
        if ("MEDIUM".equalsIgnoreCase(demandLevel)) {
            return "MEDIUM DEMAND";
        }
        return "LOW DEMAND";
    }

    private String automationRiskBadge(String automationRisk) {
        if ("LOW".equalsIgnoreCase(automationRisk)) {
            return "LOW AI RISK";
        }
        if ("MEDIUM".equalsIgnoreCase(automationRisk)) {
            return "MEDIUM AI RISK";
        }
        return "HIGH AI RISK";
    }

    private String remoteBadge(String remoteOpportunity) {
        if ("HIGH".equalsIgnoreCase(remoteOpportunity)) {
            return "REMOTE FRIENDLY";
        }
        if ("MEDIUM".equalsIgnoreCase(remoteOpportunity)) {
            return "HYBRID FRIENDLY";
        }
        return "LOCATION BASED";
    }

    private String growthBadge(Career career) {
        if (career.getGrowthRate() == null) {
            return "GROWTH DATA UNAVAILABLE";
        }
        double growth = career.getGrowthRate().doubleValue();
        if (growth >= 15.0) {
            return "FAST GROWTH";
        }
        if (growth >= 8.0) {
            return "STEADY GROWTH";
        }
        return "LIMITED GROWTH";
    }

    private CareerMatchRule findRuleForCareer(List<CareerMatchRule> rules, int careerId) {
        for (CareerMatchRule rule : rules) {
            if (rule.getCareerId() == careerId) {
                return rule;
            }
        }
        return null;
    }

    private void normalizeScores(AptitudeProfile profile) {
        profile.setAnalyticalScore(boundScore(profile.getAnalyticalScore()));
        profile.setCreativityScore(boundScore(profile.getCreativityScore()));
        profile.setLeadershipScore(boundScore(profile.getLeadershipScore()));
        profile.setTechnicalScore(boundScore(profile.getTechnicalScore()));
        profile.setCommunicationScore(boundScore(profile.getCommunicationScore()));
        profile.setEntrepreneurialScore(boundScore(profile.getEntrepreneurialScore()));
        profile.setResearchScore(boundScore(profile.getResearchScore()));
    }

    private int boundScore(int score) {
        if (score < 0) {
            return 0;
        }
        return Math.min(score, 100);
    }

    private void validateStudentId(int studentId) {
        if (studentId <= 0) {
            throw new IllegalArgumentException("Valid student ID is required.");
        }
    }

    private void validateCareerId(int careerId) {
        if (careerId <= 0) {
            throw new IllegalArgumentException("Valid career ID is required.");
        }
    }

    private static class Strength {
        private final String label;
        private final int score;

        private Strength(String label, int score) {
            this.label = label;
            this.score = score;
        }
    }
}
