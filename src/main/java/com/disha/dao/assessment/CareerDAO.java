package com.disha.dao.assessment;

import com.disha.model.assessment.NepalCareer;
import com.disha.util.DBUtil;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

/**
 * CareerDAO handles all database operations related to Nepal-specific careers.
 * This includes finding matches based on assessment results and managing
 * career recommendations for students.
 * 
 * @author Ashmit
 */
public class CareerDAO {

    /**
     * Finds careers that match a specific personality cluster and aptitude requirement.
     * 
     * @param personalityCluster The student's determined cluster (e.g., "Creative")
     * @param aptitudeScore The student's aptitude score (0 to 10)
     * @return A list of matching NepalCareer objects ordered by relevance
     */
    public List<NepalCareer> getMatchingCareers(String personalityCluster, int aptitudeScore) {
        List<NepalCareer> careers = new ArrayList<NepalCareer>();

        // LIKE %cluster% finds the cluster name anywhere in the comma-separated field
        String sql = "SELECT * FROM nepal_careers " +
                "WHERE suitable_clusters LIKE ? AND min_aptitude_score <= ? " +
                "ORDER BY min_aptitude_score DESC";

        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setString(1, "%" + personalityCluster + "%");
            ps.setInt(2, aptitudeScore);
            rs = ps.executeQuery();

            while (rs.next()) {
                careers.add(mapRow(rs));
            }

        } catch (SQLException e) {
            System.out.println("Error loading matching careers: " + e.getMessage());
        } finally {
            closeResources(conn, ps, rs);
        }

        return careers;
    }

    /**
     * Saves the top 3 recommended careers for a specific assessment attempt.
     * 
     * @param attemptId The unique assessment attempt ID
     * @param topCareers A list of exactly 3 NepalCareer recommendations
     */
    public void saveCareerRecommendations(int attemptId, List<NepalCareer> topCareers) {
        String sql = "INSERT INTO attempt_career_recs (attempt_id, career_id, career_rank) VALUES (?, ?, ?)";

        Connection conn = null;
        PreparedStatement ps = null;

        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql);

            int rank = 1;
            for (NepalCareer career : topCareers) {
                ps.setInt(1, attemptId);
                ps.setInt(2, career.getCareerId());
                ps.setInt(3, rank);
                ps.executeUpdate();
                rank++;
            }

        } catch (SQLException e) {
            System.out.println("Error saving career recommendations: " + e.getMessage());
        } finally {
            closeResources(conn, ps, null);
        }
    }

    /**
     * Retrieves the saved career recommendations for a past assessment attempt.
     * 
     * @param attemptId The unique assessment attempt ID
     * @return A list of NepalCareer objects, ordered by their recommendation rank
     */
    public List<NepalCareer> getSavedRecommendations(int attemptId) {
        List<NepalCareer> careers = new ArrayList<NepalCareer>();

        String sql = "SELECT nc.* FROM nepal_careers nc " +
                "JOIN attempt_career_recs acr ON nc.career_id = acr.career_id " +
                "WHERE acr.attempt_id = ? " +
                "ORDER BY acr.career_rank ASC";

        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;

        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, attemptId);
            rs = ps.executeQuery();

            while (rs.next()) {
                careers.add(mapRow(rs));
            }

        } catch (SQLException e) {
            System.out.println("Error loading saved recommendations: " + e.getMessage());
        } finally {
            closeResources(conn, ps, rs);
        }

        return careers;
    }

    // Converts one ResultSet row into a NepalCareer object.
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

    // Closes all database resources safely.
    private void closeResources(Connection conn, PreparedStatement ps, ResultSet rs) {
        try {
            if (rs != null) rs.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        try {
            if (ps != null) ps.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        try {
            if (conn != null) conn.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}
