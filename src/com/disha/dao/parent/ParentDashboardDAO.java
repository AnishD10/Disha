package com.disha.dao.parent;

import com.disha.dao.UserDAO;
import com.disha.model.User;
import com.disha.model.assessment.AssessmentAttempt;
import com.disha.model.assessment.AttemptSkill;
import com.disha.model.parent.ParentDashboardData;
import com.disha.model.parent.ParentDashboardData.CareerRecommendation;
import com.disha.model.parent.ParentDashboardData.DegreeOption;
import com.disha.util.DBUtil;

import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class ParentDashboardDAO extends DBUtil {
    private static final int DEFAULT_CAREER_LIMIT = 5;
    private final UserDAO userDAO = new UserDAO();

    public ParentDashboardData loadDashboard(int parentUserId, int budgetNpr) throws SQLException {
        ParentDashboardData data = new ParentDashboardData();
        data.setSelectedBudget(budgetNpr);

        Integer childId = findLinkedStudentId(parentUserId);
        if (childId == null) {
            data.setDegreeOptions(findDegreeOptionsByBudget(budgetNpr));
            return data;
        }

        User child = userDAO.findById(childId);
        data.setChild(child);

        AssessmentAttempt latestAttempt = findLatestCompletedAttempt(childId);
        data.setLatestAttempt(latestAttempt);

        if (latestAttempt != null) {
            data.setSkills(findSkills(latestAttempt.getAttemptId()));
            data.setCareerRecommendations(findSavedCareerRecommendations(latestAttempt.getAttemptId()));
            if (data.getCareerRecommendations().isEmpty()) {
                data.setCareerRecommendations(findRecommendedCareersFromAttempt(latestAttempt));
            }
        }

        data.setDegreeOptions(findDegreeOptionsByBudget(budgetNpr));
        return data;
    }

    private Integer findLinkedStudentId(int parentUserId) throws SQLException {
        String sql = "SELECT student_user_id FROM parent_student_links " +
                "WHERE parent_user_id = ? ORDER BY created_at DESC LIMIT 1";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, parentUserId);
            rs = ps.executeQuery();
            return rs.next() ? rs.getInt("student_user_id") : null;
        } finally {
            closeResources(conn, ps, rs);
        }
    }

    private AssessmentAttempt findLatestCompletedAttempt(int studentId) throws SQLException {
        String sql = "SELECT attempt_id, student_id, attempt_date, is_completed, aptitude_score, " +
                "personality_score, interest_score, personality_cluster " +
                "FROM assessment_attempts WHERE student_id = ? AND is_completed = 1 " +
                "ORDER BY attempt_date DESC, attempt_id DESC LIMIT 1";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, studentId);
            rs = ps.executeQuery();
            return rs.next() ? mapAttempt(rs) : null;
        } finally {
            closeResources(conn, ps, rs);
        }
    }

    private List<AttemptSkill> findSkills(int attemptId) throws SQLException {
        String sql = "SELECT skill_id, attempt_id, skill_name, skill_score, skill_level " +
                "FROM attempt_skills WHERE attempt_id = ? ORDER BY skill_level, skill_score DESC";
        List<AttemptSkill> skills = new ArrayList<AttemptSkill>();
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, attemptId);
            rs = ps.executeQuery();
            while (rs.next()) {
                AttemptSkill skill = new AttemptSkill();
                skill.setSkillId(rs.getInt("skill_id"));
                skill.setAttemptId(rs.getInt("attempt_id"));
                skill.setSkillName(rs.getString("skill_name"));
                skill.setSkillScore(rs.getInt("skill_score"));
                skill.setSkillLevel(rs.getString("skill_level"));
                skills.add(skill);
            }
            return skills;
        } finally {
            closeResources(conn, ps, rs);
        }
    }

    private List<CareerRecommendation> findSavedCareerRecommendations(int attemptId) throws SQLException {
        String sql = "SELECT nc.career_name, nc.career_description, nc.nepal_relevance_note, " +
                "c.average_salary, c.market_demand, c.risk_index " +
                "FROM attempt_career_recs acr " +
                "JOIN nepal_careers nc ON nc.career_id = acr.career_id " +
                "LEFT JOIN careers c ON LOWER(c.career_name) = LOWER(nc.career_name) " +
                "WHERE acr.attempt_id = ? ORDER BY acr.career_rank ASC LIMIT ?";
        List<CareerRecommendation> careers = new ArrayList<CareerRecommendation>();
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, attemptId);
            ps.setInt(2, DEFAULT_CAREER_LIMIT);
            rs = ps.executeQuery();
            while (rs.next()) {
                careers.add(mapCareerRecommendation(rs));
            }
            return careers;
        } finally {
            closeResources(conn, ps, rs);
        }
    }

    private List<CareerRecommendation> findRecommendedCareersFromAttempt(AssessmentAttempt attempt)
            throws SQLException {
        String cluster = attempt.getPersonalityCluster() == null ? "" : attempt.getPersonalityCluster();
        String sql = "SELECT nc.career_name, nc.career_description, nc.nepal_relevance_note, " +
                "c.average_salary, c.market_demand, c.risk_index " +
                "FROM nepal_careers nc " +
                "LEFT JOIN careers c ON LOWER(c.career_name) = LOWER(nc.career_name) " +
                "WHERE nc.min_aptitude_score <= ? " +
                "AND (? = '' OR LOWER(nc.suitable_clusters) LIKE ?) " +
                "ORDER BY nc.min_aptitude_score DESC, nc.career_name ASC LIMIT ?";
        List<CareerRecommendation> careers = new ArrayList<CareerRecommendation>();
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, attempt.getAptitudeScore());
            ps.setString(2, cluster);
            ps.setString(3, "%" + cluster.toLowerCase() + "%");
            ps.setInt(4, DEFAULT_CAREER_LIMIT);
            rs = ps.executeQuery();
            while (rs.next()) {
                careers.add(mapCareerRecommendation(rs));
            }
            return careers;
        } finally {
            closeResources(conn, ps, rs);
        }
    }

    private List<DegreeOption> findDegreeOptionsByBudget(int budgetNpr) throws SQLException {
        String sql = "SELECT college_name, degree_name, faculty, location, annual_fee_npr, " +
                "minimum_percentage, duration_years, scholarship_available " +
                "FROM college_programmes WHERE is_active = 1 AND annual_fee_npr <= ? " +
                "ORDER BY annual_fee_npr ASC, college_name ASC LIMIT 10";
        List<DegreeOption> options = new ArrayList<DegreeOption>();
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, budgetNpr);
            rs = ps.executeQuery();
            while (rs.next()) {
                DegreeOption option = new DegreeOption();
                option.setCollegeName(rs.getString("college_name"));
                option.setDegreeName(rs.getString("degree_name"));
                option.setFaculty(rs.getString("faculty"));
                option.setLocation(rs.getString("location"));
                option.setAnnualFeeNpr(rs.getBigDecimal("annual_fee_npr"));
                option.setMinimumPercentage(rs.getBigDecimal("minimum_percentage"));
                option.setDuration(rs.getInt("duration_years") + " years");
                option.setScholarshipAvailable(rs.getBoolean("scholarship_available"));
                options.add(option);
            }
            return options;
        } finally {
            closeResources(conn, ps, rs);
        }
    }

    private AssessmentAttempt mapAttempt(ResultSet rs) throws SQLException {
        AssessmentAttempt attempt = new AssessmentAttempt();
        attempt.setAttemptId(rs.getInt("attempt_id"));
        attempt.setStudentId(rs.getInt("student_id"));
        attempt.setAttemptDate(rs.getTimestamp("attempt_date"));
        attempt.setCompleted(rs.getBoolean("is_completed"));
        attempt.setAptitudeScore(rs.getInt("aptitude_score"));
        attempt.setPersonalityScore(rs.getInt("personality_score"));
        attempt.setInterestScore(rs.getInt("interest_score"));
        attempt.setPersonalityCluster(rs.getString("personality_cluster"));
        return attempt;
    }

    private CareerRecommendation mapCareerRecommendation(ResultSet rs) throws SQLException {
        CareerRecommendation career = new CareerRecommendation();
        career.setCareerName(rs.getString("career_name"));
        career.setDescription(rs.getString("career_description"));
        career.setNepalRelevanceNote(rs.getString("nepal_relevance_note"));
        BigDecimal salary = rs.getBigDecimal("average_salary");
        career.setAverageSalary(salary);
        career.setDemandLevel(valueOrPending(rs.getString("market_demand"), "Demand data pending"));
        int risk = rs.getInt("risk_index");
        career.setRiskIndex(rs.wasNull() ? "Risk data pending" : String.valueOf(risk));
        return career;
    }

    private String valueOrPending(String value, String fallback) {
        return value == null || value.trim().isEmpty() ? fallback : value;
    }
}
