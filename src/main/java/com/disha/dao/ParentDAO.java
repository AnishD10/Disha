package com.disha.dao;

import com.disha.model.ParentDashboardData;
import com.disha.model.ParentDashboardData.CareerMatch;
import com.disha.model.ParentDashboardData.DegreeOption;
import utils.DBUtil;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ParentDAO {

    public int getLinkedStudentId(int parentUserId) throws SQLException {
        String sql = "SELECT linked_student_id FROM users WHERE user_id = ? AND role = 'PARENT'";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, parentUserId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getInt("linked_student_id");
            return -1;
        }
    }

    public String getChildName(int studentId) throws SQLException {
        String sql = "SELECT full_name FROM users WHERE user_id = ? AND role = 'STUDENT'";
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, studentId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getString("full_name");
            return "Unknown Student";
        }
    }

    public ParentDashboardData getAptitudeResult(int studentId) throws SQLException {
        String sql = "SELECT summary, strength_clusters, weakness_clusters " +
                     "FROM aptitude_results WHERE student_id = ? " +
                     "ORDER BY taken_date DESC LIMIT 1";
        ParentDashboardData data = new ParentDashboardData();
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, studentId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                data.setAptitudeSummary(rs.getString("summary"));
                data.setStrengthClusters(rs.getString("strength_clusters"));
                data.setWeaknessClusters(rs.getString("weakness_clusters"));
            } else {
                data.setAptitudeSummary("Your child has not completed the aptitude assessment yet.");
                data.setStrengthClusters("N/A");
                data.setWeaknessClusters("N/A");
            }
        }
        return data;
    }

    public List<CareerMatch> getMatchedCareers(int studentId) throws SQLException {
        String sql = "SELECT c.career_name, lm.salary_min, lm.salary_max, " +
                     "lm.demand_level, lm.risk_index, c.plain_description " +
                     "FROM career_matches cm " +
                     "JOIN careers c ON cm.career_id = c.career_id " +
                     "JOIN labour_market lm ON c.career_id = lm.career_id " +
                     "WHERE cm.student_id = ? ORDER BY cm.match_score DESC LIMIT 5";
        List<CareerMatch> list = new ArrayList<>();
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, studentId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(new CareerMatch(
                    rs.getString("career_name"),
                    "NPR " + rs.getInt("salary_min") + " – " + rs.getInt("salary_max") + " / month",
                    rs.getString("demand_level"),
                    rs.getString("risk_index"),
                    rs.getString("plain_description")
                ));
            }
        }
        return list;
    }

    public List<DegreeOption> getDegreesByBudget(int budgetNPR) throws SQLException {
        String sql = "SELECT d.degree_name, c.college_name, c.location, " +
                     "d.annual_fee_npr, d.duration_years " +
                     "FROM degrees d JOIN colleges c ON d.college_id = c.college_id " +
                     "WHERE d.annual_fee_npr <= ? ORDER BY d.annual_fee_npr ASC LIMIT 10";
        List<DegreeOption> list = new ArrayList<>();
        try (Connection conn = DBUtil.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, budgetNPR);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(new DegreeOption(
                    rs.getString("degree_name"),
                    rs.getString("college_name"),
                    rs.getString("location"),
                    "NPR " + rs.getInt("annual_fee_npr") + " / year",
                    rs.getInt("duration_years") + " years"
                ));
            }
        }
        return list;
    }
}
