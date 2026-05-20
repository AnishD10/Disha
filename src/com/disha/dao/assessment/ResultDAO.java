package com.disha.dao.assessment;

import com.disha.model.assessment.AttemptSkill;
import com.disha.util.DBUtil;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class ResultDAO extends DBUtil {
    public void saveSkills(int attemptId, List<AttemptSkill> skills) {
        String sql = "INSERT INTO attempt_skills (attempt_id, skill_name, skill_score, skill_level) VALUES (?, ?, ?, ?)";
        Connection conn = null;
        PreparedStatement ps = null;
        try {
            conn = getConnection();
            ps = conn.prepareStatement(sql);
            for (AttemptSkill skill : skills) {
                ps.setInt(1, attemptId);
                ps.setString(2, skill.getSkillName());
                ps.setInt(3, skill.getSkillScore());
                ps.setString(4, skill.getSkillLevel());
                ps.executeUpdate();
            }
        } catch (SQLException e) {
            System.err.println("Error saving assessment skills: " + e.getMessage());
        } finally {
            closeResources(conn, ps, null);
        }
    }

    public List<AttemptSkill> getSkillsByAttempt(int attemptId) {
        List<AttemptSkill> skills = new ArrayList<>();
        String sql = "SELECT * FROM attempt_skills WHERE attempt_id = ?";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, attemptId);
            rs = ps.executeQuery();
            while (rs.next()) {
                AttemptSkill s = new AttemptSkill();
                s.setSkillId(rs.getInt("skill_id"));
                s.setAttemptId(rs.getInt("attempt_id"));
                s.setSkillName(rs.getString("skill_name"));
                s.setSkillScore(rs.getInt("skill_score"));
                s.setSkillLevel(rs.getString("skill_level"));
                skills.add(s);
            }
        } catch (SQLException e) {
            System.err.println("Error loading assessment skills: " + e.getMessage());
        } finally {
            closeResources(conn, ps, rs);
        }
        return skills;
    }
}
