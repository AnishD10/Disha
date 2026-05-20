package com.disha.dao.counselor;

import com.disha.model.counselor.CounselorDashboardData;
import com.disha.model.counselor.CounselorDashboardData.CareerInterestStat;
import com.disha.model.counselor.CounselorDashboardData.ClusterStat;
import com.disha.model.counselor.CounselorDashboardData.StudentSummary;
import com.disha.util.DBUtil;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class CounselorDashboardDAO extends DBUtil {
    public CounselorDashboardData loadDashboard(int counselorUserId, String search, boolean flaggedOnly)
            throws SQLException {
        CounselorDashboardData data = new CounselorDashboardData();
        data.setTotalStudents(countStudents());
        data.setCompletedAssessments(countCompletedAttempts());
        data.setFlaggedStudents(countFlaggedStudents(counselorUserId));
        data.setAverageAptitudeScore(loadAverageAptitudeScore());
        data.setTopCluster(loadTopCluster());
        data.setStudents(loadStudents(counselorUserId, search, flaggedOnly));
        data.setClusterStats(loadClusterStats());
        data.setCareerInterestStats(loadCareerInterestStats());
        return data;
    }

    public List<StudentSummary> loadStudents(int counselorUserId, String search, boolean flaggedOnly)
            throws SQLException {
        StringBuilder sql = new StringBuilder();
        sql.append("SELECT u.user_id, u.first_name, u.last_name, u.email, ")
                .append("aa.attempt_id, aa.attempt_date, aa.aptitude_score, aa.personality_score, ")
                .append("aa.interest_score, aa.personality_cluster, ")
                .append("COALESCE(ca.is_at_risk, 0) AS is_at_risk, ca.status, ca.notes ")
                .append("FROM users u ")
                .append("LEFT JOIN assessment_attempts aa ON aa.attempt_id = (")
                .append("SELECT aa2.attempt_id FROM assessment_attempts aa2 ")
                .append("WHERE aa2.student_id = u.user_id AND aa2.is_completed = 1 ")
                .append("ORDER BY aa2.attempt_date DESC, aa2.attempt_id DESC LIMIT 1) ")
                .append("LEFT JOIN counselor_assignments ca ON ca.student_user_id = u.user_id ")
                .append("AND ca.counselor_user_id = ? ")
                .append("WHERE u.role = 'STUDENT' AND u.is_active = 1 ");

        List<Object> params = new ArrayList<Object>();
        params.add(counselorUserId);
        if (search != null && !search.trim().isEmpty()) {
            sql.append("AND (LOWER(u.first_name) LIKE ? OR LOWER(u.last_name) LIKE ? OR LOWER(u.email) LIKE ?) ");
            String pattern = "%" + search.trim().toLowerCase() + "%";
            params.add(pattern);
            params.add(pattern);
            params.add(pattern);
        }
        if (flaggedOnly) {
            sql.append("AND COALESCE(ca.is_at_risk, 0) = 1 ");
        }
        sql.append("ORDER BY COALESCE(ca.is_at_risk, 0) DESC, u.first_name ASC, u.last_name ASC");

        List<StudentSummary> students = new ArrayList<StudentSummary>();
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = getConnection();
            ps = conn.prepareStatement(sql.toString());
            setParams(ps, params);
            rs = ps.executeQuery();
            while (rs.next()) {
                students.add(mapStudentSummary(rs));
            }
            return students;
        } finally {
            closeResources(conn, ps, rs);
        }
    }

    public void updateStudentFlag(int counselorUserId, int studentUserId, boolean atRisk, String note)
            throws SQLException {
        String sql = "INSERT INTO counselor_assignments " +
                "(counselor_user_id, student_user_id, notes, status, is_at_risk) " +
                "VALUES (?, ?, ?, ?, ?) " +
                "ON DUPLICATE KEY UPDATE notes = VALUES(notes), status = VALUES(status), " +
                "is_at_risk = VALUES(is_at_risk)";
        Connection conn = null;
        PreparedStatement ps = null;
        try {
            conn = getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, counselorUserId);
            ps.setInt(2, studentUserId);
            ps.setString(3, note == null ? "" : note.trim());
            ps.setString(4, atRisk ? "FLAGGED" : "ACTIVE");
            ps.setBoolean(5, atRisk);
            ps.executeUpdate();
        } finally {
            closeResources(conn, ps, null);
        }
    }

    private int countStudents() throws SQLException {
        return count("SELECT COUNT(*) FROM users WHERE role = 'STUDENT' AND is_active = 1");
    }

    private int countCompletedAttempts() throws SQLException {
        return count("SELECT COUNT(*) FROM assessment_attempts WHERE is_completed = 1");
    }

    private int countFlaggedStudents(int counselorUserId) throws SQLException {
        String sql = "SELECT COUNT(*) FROM counselor_assignments " +
                "WHERE counselor_user_id = ? AND is_at_risk = 1";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, counselorUserId);
            rs = ps.executeQuery();
            return rs.next() ? rs.getInt(1) : 0;
        } finally {
            closeResources(conn, ps, rs);
        }
    }

    private double loadAverageAptitudeScore() throws SQLException {
        String sql = "SELECT AVG(aptitude_score) FROM assessment_attempts WHERE is_completed = 1";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = getConnection();
            ps = conn.prepareStatement(sql);
            rs = ps.executeQuery();
            return rs.next() ? rs.getDouble(1) : 0.0;
        } finally {
            closeResources(conn, ps, rs);
        }
    }

    private String loadTopCluster() throws SQLException {
        String sql = "SELECT personality_cluster, COUNT(*) AS total " +
                "FROM assessment_attempts " +
                "WHERE is_completed = 1 AND personality_cluster IS NOT NULL " +
                "GROUP BY personality_cluster ORDER BY total DESC LIMIT 1";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = getConnection();
            ps = conn.prepareStatement(sql);
            rs = ps.executeQuery();
            return rs.next() ? rs.getString("personality_cluster") : "N/A";
        } finally {
            closeResources(conn, ps, rs);
        }
    }

    private List<ClusterStat> loadClusterStats() throws SQLException {
        String sql = "SELECT COALESCE(personality_cluster, 'Unclassified') AS cluster_name, COUNT(*) AS total " +
                "FROM assessment_attempts WHERE is_completed = 1 " +
                "GROUP BY COALESCE(personality_cluster, 'Unclassified') ORDER BY total DESC";
        List<ClusterStat> stats = new ArrayList<ClusterStat>();
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = getConnection();
            ps = conn.prepareStatement(sql);
            rs = ps.executeQuery();
            while (rs.next()) {
                ClusterStat stat = new ClusterStat();
                stat.setClusterName(rs.getString("cluster_name"));
                stat.setTotal(rs.getInt("total"));
                stats.add(stat);
            }
            return stats;
        } finally {
            closeResources(conn, ps, rs);
        }
    }

    private List<CareerInterestStat> loadCareerInterestStats() throws SQLException {
        String sql = "SELECT nc.career_name, COUNT(*) AS total " +
                "FROM attempt_career_recs acr " +
                "JOIN nepal_careers nc ON nc.career_id = acr.career_id " +
                "GROUP BY nc.career_name ORDER BY total DESC, nc.career_name ASC LIMIT 8";
        List<CareerInterestStat> stats = new ArrayList<CareerInterestStat>();
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = getConnection();
            ps = conn.prepareStatement(sql);
            rs = ps.executeQuery();
            while (rs.next()) {
                CareerInterestStat stat = new CareerInterestStat();
                stat.setCareerName(rs.getString("career_name"));
                stat.setTotal(rs.getInt("total"));
                stats.add(stat);
            }
            return stats;
        } finally {
            closeResources(conn, ps, rs);
        }
    }

    private int count(String sql) throws SQLException {
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = getConnection();
            ps = conn.prepareStatement(sql);
            rs = ps.executeQuery();
            return rs.next() ? rs.getInt(1) : 0;
        } finally {
            closeResources(conn, ps, rs);
        }
    }

    private StudentSummary mapStudentSummary(ResultSet rs) throws SQLException {
        StudentSummary student = new StudentSummary();
        student.setUserId(rs.getInt("user_id"));
        String first = rs.getString("first_name");
        String last = rs.getString("last_name");
        String fullName = ((first == null ? "" : first) + " " + (last == null ? "" : last)).trim();
        student.setFullName(fullName.isEmpty() ? "Unnamed Student" : fullName);
        student.setEmail(rs.getString("email"));

        int attemptId = rs.getInt("attempt_id");
        if (!rs.wasNull()) {
            student.setAttemptId(attemptId);
            student.setAttemptDate(rs.getTimestamp("attempt_date"));
            student.setAptitudeScore(rs.getInt("aptitude_score"));
            student.setPersonalityScore(rs.getInt("personality_score"));
            student.setInterestScore(rs.getInt("interest_score"));
            student.setPersonalityCluster(rs.getString("personality_cluster"));
        }

        student.setAtRisk(rs.getBoolean("is_at_risk"));
        student.setAssignmentStatus(rs.getString("status"));
        student.setCounselorNote(rs.getString("notes"));
        return student;
    }

    private void setParams(PreparedStatement ps, List<Object> params) throws SQLException {
        for (int i = 0; i < params.size(); i++) {
            ps.setObject(i + 1, params.get(i));
        }
    }
}
