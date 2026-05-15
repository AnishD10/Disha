package com.disha.dao.assessment;

import com.disha.model.assessment.AttemptSkill;
import com.disha.util.DBUtil;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

/**
 * ResultDAO manages the storage and retrieval of skill analysis results
 * for each assessment attempt. This includes "Logical Thinking", 
 * "Communication", and "Work Ethic".
 * 
 * @author DISHA Team
 */
public class ResultDAO {

    /**
     * Saves the detailed skill breakdown for a student's assessment attempt.
     * 
     * @param attemptId The ID of the assessment attempt
     * @param skills A list of calculated AttemptSkill objects
     */
    public void saveSkills(int attemptId, List<AttemptSkill> skills) {
        String sql = "INSERT INTO attempt_skills (attempt_id, skill_name, skill_score, skill_level) VALUES (?, ?, ?, ?)";
        Connection conn = null; PreparedStatement ps = null;
        try {
            conn = DBUtil.getConnection(); ps = conn.prepareStatement(sql);
            for (AttemptSkill skill : skills) {
                ps.setInt(1, attemptId); ps.setString(2, skill.getSkillName());
                ps.setInt(3, skill.getSkillScore()); ps.setString(4, skill.getSkillLevel());
                ps.executeUpdate();
            }
        } catch (SQLException e) {
            System.out.println("Error saving skills: " + e.getMessage());
        } finally { closeResources(conn, ps, null); }
    }

    /**
     * Retrieves the skill analysis results for a past assessment attempt.
     * 
     * @param attemptId The unique ID of the attempt
     * @return A list of AttemptSkill objects for the report
     */
    public List<AttemptSkill> getSkillsByAttempt(int attemptId) {
        List<AttemptSkill> skills = new ArrayList<AttemptSkill>();
        String sql = "SELECT * FROM attempt_skills WHERE attempt_id = ?";
        Connection conn = null; PreparedStatement ps = null; ResultSet rs = null;
        try {
            conn = DBUtil.getConnection(); ps = conn.prepareStatement(sql);
            ps.setInt(1, attemptId); rs = ps.executeQuery();
            while (rs.next()) {
                AttemptSkill s = new AttemptSkill();
                s.setSkillId(rs.getInt("skill_id")); s.setAttemptId(rs.getInt("attempt_id"));
                s.setSkillName(rs.getString("skill_name")); s.setSkillScore(rs.getInt("skill_score"));
                s.setSkillLevel(rs.getString("skill_level"));
                skills.add(s);
            }
        } catch (SQLException e) {
            System.out.println("Error loading skills: " + e.getMessage());
        } finally { closeResources(conn, ps, rs); }
        return skills;
    }

    private void closeResources(Connection conn, PreparedStatement ps, ResultSet rs) {
        try { if (rs != null) rs.close(); } catch (SQLException e) { e.printStackTrace(); }
        try { if (ps != null) ps.close(); } catch (SQLException e) { e.printStackTrace(); }
        try { if (conn != null) conn.close(); } catch (SQLException e) { e.printStackTrace(); }
    }
}
