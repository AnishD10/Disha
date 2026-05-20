package com.disha.career.dao;

import com.disha.career.model.AptitudeProfile;
import com.disha.career.model.Career;
import com.disha.career.model.Career.CareerCourse;
import com.disha.career.model.Career.CareerRoadmap;
import com.disha.career.model.Career.CareerSkill;
import com.disha.career.model.CareerMatchRule;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.List;

/**
 * Raw JDBC DAO for career discovery data.
 */
public class CareerDiscoveryDAO extends com.disha.util.DBUtil {
    private static final String CAREER_COLUMNS =
            "career_id, career_name, overview, responsibilities, industry, future_scope, " +
            "salary_entry, salary_mid, salary_senior, demand_level, automation_risk, " +
            "remote_opportunity, growth_rate, description, suggested_certifications";

    public Career getCareerById(int careerId) throws SQLException {
        String sql = "SELECT " + CAREER_COLUMNS + " FROM careers WHERE career_id = ?";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, careerId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Career career = mapCareer(rs);
                    loadCareerDetails(career);
                    return career;
                }
            }
        } catch (SQLException e) {
            logError("Error fetching career by ID: " + careerId, e);
            throw e;
        }
        return null;
    }

    public List<Career> getAllCareers() throws SQLException {
        String sql = "SELECT " + CAREER_COLUMNS + " FROM careers ORDER BY career_name";
        List<Career> careers = new ArrayList<Career>();
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Career career = mapCareer(rs);
                loadCareerDetails(career);
                careers.add(career);
            }
        } catch (SQLException e) {
            logError("Error fetching all careers", e);
            throw e;
        }
        return careers;
    }

    public List<CareerSkill> getCareerSkills(int careerId) throws SQLException {
        String sql = "SELECT skill_id, career_id, skill_name, skill_type, skill_level " +
                "FROM career_skills WHERE career_id = ? ORDER BY skill_type, skill_name";
        List<CareerSkill> skills = new ArrayList<CareerSkill>();
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, careerId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    skills.add(mapSkill(rs));
                }
            }
        } catch (SQLException e) {
            logError("Error fetching skills for career ID: " + careerId, e);
            throw e;
        }
        return skills;
    }

    public List<CareerRoadmap> getCareerRoadmap(int careerId) throws SQLException {
        String sql = "SELECT roadmap_id, career_id, stage_name, description, estimated_duration " +
                "FROM career_roadmaps WHERE career_id = ? ORDER BY stage_order, roadmap_id";
        List<CareerRoadmap> roadmaps = new ArrayList<CareerRoadmap>();
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, careerId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    roadmaps.add(mapRoadmap(rs));
                }
            }
        } catch (SQLException e) {
            logError("Error fetching roadmap for career ID: " + careerId, e);
            throw e;
        }
        return roadmaps;
    }

    public List<CareerCourse> getCareerCourses(int careerId) throws SQLException {
        String sql = "SELECT course_id, career_id, course_name, platform, difficulty, duration, free_paid " +
                "FROM career_courses WHERE career_id = ? ORDER BY difficulty, course_name";
        List<CareerCourse> courses = new ArrayList<CareerCourse>();
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, careerId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    courses.add(mapCourse(rs));
                }
            }
        } catch (SQLException e) {
            logError("Error fetching courses for career ID: " + careerId, e);
            throw e;
        }
        return courses;
    }

    public List<CareerMatchRule> getCareerMatchRules() throws SQLException {
        String sql = "SELECT rule_id, career_id, required_analytical, required_creativity, " +
                "required_leadership, required_technical, required_communication, " +
                "required_entrepreneurial, required_research FROM career_match_rules";
        List<CareerMatchRule> rules = new ArrayList<CareerMatchRule>();
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                rules.add(mapRule(rs));
            }
        } catch (SQLException e) {
            logError("Error fetching career match rules", e);
            throw e;
        }
        return rules;
    }

    public CareerMatchRule getCareerMatchRule(int careerId) throws SQLException {
        String sql = "SELECT rule_id, career_id, required_analytical, required_creativity, " +
                "required_leadership, required_technical, required_communication, " +
                "required_entrepreneurial, required_research FROM career_match_rules WHERE career_id = ?";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, careerId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapRule(rs);
                }
            }
        } catch (SQLException e) {
            logError("Error fetching match rule for career ID: " + careerId, e);
            throw e;
        }
        return null;
    }

    public AptitudeProfile getAptitudeProfileByStudentId(int studentId) throws SQLException {
        String sql = "SELECT student_id, analytical_score, creativity_score, leadership_score, " +
                "technical_score, communication_score, entrepreneurial_score, research_score " +
                "FROM aptitude_profiles WHERE student_id = ?";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, studentId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapAptitudeProfile(rs);
                }
            }
        } catch (SQLException e) {
            logError("Error fetching aptitude profile for student ID: " + studentId, e);
            throw e;
        }
        return null;
    }

    public Integer getStudentIdByEmail(String email) throws SQLException {
        String sql = "SELECT user_id FROM users WHERE email = ? AND role = 'STUDENT' AND is_active = TRUE";
        if (!hasText(email)) {
            return null;
        }
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, email.trim());
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("user_id");
                }
            }
        } catch (SQLException e) {
            logError("Error resolving student ID by email: " + email, e);
            throw e;
        }
        return null;
    }

    public void saveOrUpdateAptitudeProfile(AptitudeProfile profile) throws SQLException {
        String sql = "INSERT INTO aptitude_profiles (student_id, analytical_score, creativity_score, " +
                "leadership_score, technical_score, communication_score, entrepreneurial_score, research_score) " +
                "VALUES (?, ?, ?, ?, ?, ?, ?, ?) ON DUPLICATE KEY UPDATE " +
                "analytical_score = VALUES(analytical_score), creativity_score = VALUES(creativity_score), " +
                "leadership_score = VALUES(leadership_score), technical_score = VALUES(technical_score), " +
                "communication_score = VALUES(communication_score), entrepreneurial_score = VALUES(entrepreneurial_score), " +
                "research_score = VALUES(research_score), updated_at = CURRENT_TIMESTAMP";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, profile.getStudentId());
            ps.setInt(2, profile.getAnalyticalScore());
            ps.setInt(3, profile.getCreativityScore());
            ps.setInt(4, profile.getLeadershipScore());
            ps.setInt(5, profile.getTechnicalScore());
            ps.setInt(6, profile.getCommunicationScore());
            ps.setInt(7, profile.getEntrepreneurialScore());
            ps.setInt(8, profile.getResearchScore());
            ps.executeUpdate();
        } catch (SQLException e) {
            logError("Error saving aptitude profile for student ID: " + profile.getStudentId(), e);
            throw e;
        }
    }

    public double calculateCareerCompatibility(AptitudeProfile profile, CareerMatchRule rule) {
        if (profile == null || rule == null) {
            return 0.0;
        }
        double weightedMatchedScore = 0.0;
        double totalPossibleScore = 0.0;

        weightedMatchedScore += matchedScore(profile.getAnalyticalScore(), rule.getRequiredAnalytical(), 1.20);
        weightedMatchedScore += matchedScore(profile.getCreativityScore(), rule.getRequiredCreativity(), 1.00);
        weightedMatchedScore += matchedScore(profile.getLeadershipScore(), rule.getRequiredLeadership(), 0.90);
        weightedMatchedScore += matchedScore(profile.getTechnicalScore(), rule.getRequiredTechnical(), 1.25);
        weightedMatchedScore += matchedScore(profile.getCommunicationScore(), rule.getRequiredCommunication(), 1.00);
        weightedMatchedScore += matchedScore(profile.getEntrepreneurialScore(), rule.getRequiredEntrepreneurial(), 0.85);
        weightedMatchedScore += matchedScore(profile.getResearchScore(), rule.getRequiredResearch(), 0.95);

        totalPossibleScore += rule.getRequiredAnalytical() * 1.20;
        totalPossibleScore += rule.getRequiredCreativity() * 1.00;
        totalPossibleScore += rule.getRequiredLeadership() * 0.90;
        totalPossibleScore += rule.getRequiredTechnical() * 1.25;
        totalPossibleScore += rule.getRequiredCommunication() * 1.00;
        totalPossibleScore += rule.getRequiredEntrepreneurial() * 0.85;
        totalPossibleScore += rule.getRequiredResearch() * 0.95;

        if (totalPossibleScore == 0.0) {
            return 0.0;
        }
        return Math.min(100.0, round((weightedMatchedScore / totalPossibleScore) * 100.0));
    }

    public List<Career> getTopCareerMatches(AptitudeProfile profile, int limit) throws SQLException {
        List<Career> careers = getAllCareers();
        List<CareerMatchRule> rules = getCareerMatchRules();
        List<ScoredCareer> scoredCareers = new ArrayList<ScoredCareer>();

        for (Career career : careers) {
            CareerMatchRule rule = findRuleForCareer(rules, career.getCareerId());
            scoredCareers.add(new ScoredCareer(career, calculateCareerCompatibility(profile, rule)));
        }
        Collections.sort(scoredCareers, new Comparator<ScoredCareer>() {
            @Override
            public int compare(ScoredCareer left, ScoredCareer right) {
                return Double.compare(right.score, left.score);
            }
        });

        List<Career> result = new ArrayList<Career>();
        int safeLimit = limit <= 0 ? 5 : limit;
        for (int i = 0; i < scoredCareers.size() && i < safeLimit; i++) {
            result.add(scoredCareers.get(i).career);
        }
        return result;
    }

    public List<Career> searchCareers(String keyword) throws SQLException {
        String sql = "SELECT " + CAREER_COLUMNS + " FROM careers " +
                "WHERE LOWER(career_name) LIKE ? OR LOWER(industry) LIKE ? OR LOWER(description) LIKE ? " +
                "ORDER BY career_name";
        String pattern = "%" + safeLower(keyword) + "%";
        List<Career> careers = new ArrayList<Career>();
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, pattern);
            ps.setString(2, pattern);
            ps.setString(3, pattern);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Career career = mapCareer(rs);
                    loadCareerDetails(career);
                    careers.add(career);
                }
            }
        } catch (SQLException e) {
            logError("Error searching careers by keyword: " + keyword, e);
            throw e;
        }
        return careers;
    }

    public List<Career> filterCareers(String industry, String demandLevel, String remoteOpportunity,
                                      String sortBy) throws SQLException {
        StringBuilder sql = new StringBuilder("SELECT " + CAREER_COLUMNS + " FROM careers WHERE 1 = 1");
        List<Object> params = new ArrayList<Object>();

        if (hasText(industry)) {
            sql.append(" AND industry = ?");
            params.add(industry.trim());
        }
        if (hasText(demandLevel)) {
            sql.append(" AND demand_level = ?");
            params.add(demandLevel.trim().toUpperCase());
        }
        if (hasText(remoteOpportunity)) {
            sql.append(" AND remote_opportunity = ?");
            params.add(remoteOpportunity.trim().toUpperCase());
        }
        sql.append(orderBy(sortBy));

        List<Career> careers = new ArrayList<Career>();
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Career career = mapCareer(rs);
                    loadCareerDetails(career);
                    careers.add(career);
                }
            }
        } catch (SQLException e) {
            logError("Error filtering careers", e);
            throw e;
        }
        return careers;
    }

    public void saveCareerBookmark(int studentId, int careerId) throws SQLException {
        String sql = "INSERT IGNORE INTO saved_careers (student_id, career_id) VALUES (?, ?)";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, studentId);
            ps.setInt(2, careerId);
            ps.executeUpdate();
        } catch (SQLException e) {
            logError("Error saving career bookmark", e);
            throw e;
        }
    }

    public void removeCareerBookmark(int studentId, int careerId) throws SQLException {
        String sql = "DELETE FROM saved_careers WHERE student_id = ? AND career_id = ?";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, studentId);
            ps.setInt(2, careerId);
            ps.executeUpdate();
        } catch (SQLException e) {
            logError("Error removing career bookmark", e);
            throw e;
        }
    }

    public List<Career> getSavedCareers(int studentId) throws SQLException {
        String sql = "SELECT c." + CAREER_COLUMNS.replace(", ", ", c.") + " FROM saved_careers sc " +
                "JOIN careers c ON sc.career_id = c.career_id WHERE sc.student_id = ? ORDER BY sc.created_at DESC";
        List<Career> careers = new ArrayList<Career>();
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, studentId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Career career = mapCareer(rs);
                    loadCareerDetails(career);
                    careers.add(career);
                }
            }
        } catch (SQLException e) {
            logError("Error fetching saved careers for student ID: " + studentId, e);
            throw e;
        }
        return careers;
    }

    public List<Career> compareCareers(List<Integer> careerIds) throws SQLException {
        List<Career> careers = new ArrayList<Career>();
        if (careerIds == null || careerIds.isEmpty()) {
            return careers;
        }
        for (Integer careerId : careerIds) {
            if (careerId != null && careerId > 0) {
                Career career = getCareerById(careerId);
                if (career != null) {
                    careers.add(career);
                }
            }
        }
        return careers;
    }

    public void clearAssessmentForRetake(int studentId) throws SQLException {
        String sql = "DELETE FROM aptitude_profiles WHERE student_id = ?";
        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, studentId);
            ps.executeUpdate();
        } catch (SQLException e) {
            logError("Error clearing aptitude profile for retake. Student ID: " + studentId, e);
            throw e;
        }
    }

    private void loadCareerDetails(Career career) throws SQLException {
        if (career == null) {
            return;
        }
        int careerId = career.getCareerId();
        career.setSkills(getCareerSkills(careerId));
        career.setRoadmaps(getCareerRoadmap(careerId));
        career.setCourses(getCareerCourses(careerId));
    }

    private Career mapCareer(ResultSet rs) throws SQLException {
        Career career = new Career();
        career.setCareerId(rs.getInt("career_id"));
        career.setCareerName(rs.getString("career_name"));
        career.setOverview(rs.getString("overview"));
        career.setResponsibilities(rs.getString("responsibilities"));
        career.setIndustry(rs.getString("industry"));
        career.setFutureScope(rs.getString("future_scope"));
        career.setSalaryEntry(rs.getBigDecimal("salary_entry"));
        career.setSalaryMid(rs.getBigDecimal("salary_mid"));
        career.setSalarySenior(rs.getBigDecimal("salary_senior"));
        career.setDemandLevel(rs.getString("demand_level"));
        career.setAutomationRisk(rs.getString("automation_risk"));
        career.setRemoteOpportunity(rs.getString("remote_opportunity"));
        career.setGrowthRate(rs.getBigDecimal("growth_rate"));
        career.setDescription(rs.getString("description"));
        career.setSuggestedCertifications(rs.getString("suggested_certifications"));
        return career;
    }

    private CareerSkill mapSkill(ResultSet rs) throws SQLException {
        CareerSkill skill = new CareerSkill();
        skill.setSkillId(rs.getInt("skill_id"));
        skill.setCareerId(rs.getInt("career_id"));
        skill.setSkillName(rs.getString("skill_name"));
        skill.setSkillType(rs.getString("skill_type"));
        skill.setSkillLevel(rs.getString("skill_level"));
        return skill;
    }

    private CareerRoadmap mapRoadmap(ResultSet rs) throws SQLException {
        CareerRoadmap roadmap = new CareerRoadmap();
        roadmap.setRoadmapId(rs.getInt("roadmap_id"));
        roadmap.setCareerId(rs.getInt("career_id"));
        roadmap.setStageName(rs.getString("stage_name"));
        roadmap.setDescription(rs.getString("description"));
        roadmap.setEstimatedDuration(rs.getString("estimated_duration"));
        return roadmap;
    }

    private CareerCourse mapCourse(ResultSet rs) throws SQLException {
        CareerCourse course = new CareerCourse();
        course.setCourseId(rs.getInt("course_id"));
        course.setCareerId(rs.getInt("career_id"));
        course.setCourseName(rs.getString("course_name"));
        course.setPlatform(rs.getString("platform"));
        course.setDifficulty(rs.getString("difficulty"));
        course.setDuration(rs.getString("duration"));
        course.setFreePaid(rs.getString("free_paid"));
        return course;
    }

    private CareerMatchRule mapRule(ResultSet rs) throws SQLException {
        CareerMatchRule rule = new CareerMatchRule();
        rule.setRuleId(rs.getInt("rule_id"));
        rule.setCareerId(rs.getInt("career_id"));
        rule.setRequiredAnalytical(rs.getInt("required_analytical"));
        rule.setRequiredCreativity(rs.getInt("required_creativity"));
        rule.setRequiredLeadership(rs.getInt("required_leadership"));
        rule.setRequiredTechnical(rs.getInt("required_technical"));
        rule.setRequiredCommunication(rs.getInt("required_communication"));
        rule.setRequiredEntrepreneurial(rs.getInt("required_entrepreneurial"));
        rule.setRequiredResearch(rs.getInt("required_research"));
        return rule;
    }

    private AptitudeProfile mapAptitudeProfile(ResultSet rs) throws SQLException {
        AptitudeProfile profile = new AptitudeProfile();
        profile.setStudentId(rs.getInt("student_id"));
        profile.setAnalyticalScore(rs.getInt("analytical_score"));
        profile.setCreativityScore(rs.getInt("creativity_score"));
        profile.setLeadershipScore(rs.getInt("leadership_score"));
        profile.setTechnicalScore(rs.getInt("technical_score"));
        profile.setCommunicationScore(rs.getInt("communication_score"));
        profile.setEntrepreneurialScore(rs.getInt("entrepreneurial_score"));
        profile.setResearchScore(rs.getInt("research_score"));
        return profile;
    }

    private double matchedScore(int actualScore, int requiredScore, double weight) {
        if (requiredScore <= 0) {
            return 0.0;
        }
        return Math.min(actualScore, requiredScore) * weight;
    }

    private double round(double value) {
        return Math.round(value * 100.0) / 100.0;
    }

    private CareerMatchRule findRuleForCareer(List<CareerMatchRule> rules, int careerId) {
        for (CareerMatchRule rule : rules) {
            if (rule.getCareerId() == careerId) {
                return rule;
            }
        }
        return null;
    }

    private boolean hasText(String value) {
        return value != null && !value.trim().isEmpty();
    }

    private void logError(String message, SQLException e) {
        System.err.println(message);
        if (e != null) {
            e.printStackTrace();
        }
    }

    private String safeLower(String value) {
        return value == null ? "" : value.trim().toLowerCase();
    }

    private String orderBy(String sortBy) {
        if ("salary".equalsIgnoreCase(sortBy)) {
            return " ORDER BY salary_mid DESC, salary_senior DESC";
        }
        if ("demand".equalsIgnoreCase(sortBy)) {
            return " ORDER BY FIELD(demand_level, 'HIGH', 'MEDIUM', 'LOW'), career_name";
        }
        if ("growth".equalsIgnoreCase(sortBy)) {
            return " ORDER BY growth_rate DESC, career_name";
        }
        return " ORDER BY career_name";
    }

    private static class ScoredCareer {
        private final Career career;
        private final double score;

        private ScoredCareer(Career career, double score) {
            this.career = career;
            this.score = score;
        }
    }
}
