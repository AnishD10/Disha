package com.disha.dao.assessment;

import com.disha.model.assessment.NepalCareer;
import com.disha.util.DBUtil;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class CareerDAO extends DBUtil {
    public List<NepalCareer> getMatchingCareers(String personalityCluster, int aptitudeScore) {
        List<NepalCareer> careers = new ArrayList<>();
        String sql = "SELECT * FROM nepal_careers WHERE suitable_clusters LIKE ? AND min_aptitude_score <= ? " +
                "ORDER BY min_aptitude_score DESC, career_name ASC";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = getConnection();
            ps = conn.prepareStatement(sql);
            ps.setString(1, "%" + (personalityCluster == null ? "" : personalityCluster) + "%");
            ps.setInt(2, aptitudeScore);
            rs = ps.executeQuery();
            while (rs.next()) careers.add(mapRow(rs));
        } catch (SQLException e) {
            System.err.println("Error loading career matches: " + e.getMessage());
        } finally {
            closeResources(conn, ps, rs);
        }
        return careers;
    }

    public void saveCareerRecommendations(int attemptId, List<NepalCareer> topCareers) {
        String sql = "INSERT INTO attempt_career_recs (attempt_id, career_id, career_rank) VALUES (?, ?, ?)";
        Connection conn = null;
        PreparedStatement ps = null;
        try {
            conn = getConnection();
            ps = conn.prepareStatement(sql);
            int rank = 1;
            for (NepalCareer career : topCareers) {
                ps.setInt(1, attemptId);
                ps.setInt(2, career.getCareerId());
                ps.setInt(3, rank++);
                ps.executeUpdate();
            }
        } catch (SQLException e) {
            System.err.println("Error saving career recommendations: " + e.getMessage());
        } finally {
            closeResources(conn, ps, null);
        }
    }

    public List<NepalCareer> getSavedRecommendations(int attemptId) {
        List<NepalCareer> careers = new ArrayList<>();
        String sql = "SELECT nc.* FROM nepal_careers nc " +
                "JOIN attempt_career_recs acr ON nc.career_id = acr.career_id " +
                "WHERE acr.attempt_id = ? ORDER BY acr.career_rank ASC";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, attemptId);
            rs = ps.executeQuery();
            while (rs.next()) careers.add(mapRow(rs));
        } catch (SQLException e) {
            System.err.println("Error loading saved recommendations: " + e.getMessage());
        } finally {
            closeResources(conn, ps, rs);
        }
        return careers;
    }

    private NepalCareer mapRow(ResultSet rs) throws SQLException {
        NepalCareer c = new NepalCareer();
        c.setCareerId(rs.getInt("career_id"));
        c.setCareerName(rs.getString("career_name"));
        c.setCareerDescription(rs.getString("career_description"));
        c.setSuitableClusters(rs.getString("suitable_clusters"));
        c.setMinAptitudeScore(rs.getInt("min_aptitude_score"));
        c.setNepalRelevanceNote(rs.getString("nepal_relevance_note"));
        return c;
    }
}
