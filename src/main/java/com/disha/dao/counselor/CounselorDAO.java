package com.disha.dao.counselor;

import com.disha.model.assessment.AssessmentAttempt;
import com.disha.model.auth.User;
import com.disha.util.DBUtil;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

// CounselorDAO handles all database queries needed for the counselor dashboard.
/**
 * CounselorDAO handles all database operations specific to the Counselor role.
 * This includes student registration, fetching dashboard statistics, and 
 * tracking recent assessment attempts across the portal.
 * 
 * @author Ashmit
 * @version 1.0
 */
public class CounselorDAO {

    /**
     * Retrieves all students registered in the DISHA portal.
     * 
     * @return A list of User objects with the role 'STUDENT'
     */
    public List<User> getAllStudents() {
        List<User> students = new ArrayList<User>();
        String sql = "SELECT * FROM users WHERE role = 'STUDENT' ORDER BY full_name ASC";
        Connection conn = null; PreparedStatement ps = null; ResultSet rs = null;
        try {
            conn = DBUtil.getConnection(); ps = conn.prepareStatement(sql); rs = ps.executeQuery();
            while (rs.next()) { students.add(mapUser(rs)); }
        } catch (SQLException e) {
            System.out.println("Error loading all students: " + e.getMessage());
        } finally { closeResources(conn, ps, rs); }
        return students;
    }

    /**
     * Retrieves a list of students who have been flagged for further review.
     * 
     * @return A list of User objects where is_flagged = 1
     */
    public List<User> getFlaggedStudents() {
        List<User> students = new ArrayList<User>();
        String sql = "SELECT * FROM users WHERE role = 'STUDENT' AND is_flagged = 1 ORDER BY full_name ASC";
        Connection conn = null; PreparedStatement ps = null; ResultSet rs = null;
        try {
            conn = DBUtil.getConnection(); ps = conn.prepareStatement(sql); rs = ps.executeQuery();
            while (rs.next()) { students.add(mapUser(rs)); }
        } catch (SQLException e) {
            System.out.println("Error loading flagged students: " + e.getMessage());
        } finally { closeResources(conn, ps, rs); }
        return students;
    }

    /**
     * Retrieves a specific student's profile by their unique ID.
     * 
     * @param userId The unique ID of the student
     * @return User object if found and is a student, null otherwise
     */
    public User getStudentById(int userId) {
        User student = null;
        String sql = "SELECT * FROM users WHERE user_id = ? AND role = 'STUDENT'";
        Connection conn = null; PreparedStatement ps = null; ResultSet rs = null;
        try {
            conn = DBUtil.getConnection(); ps = conn.prepareStatement(sql);
            ps.setInt(1, userId); rs = ps.executeQuery();
            if (rs.next()) { student = mapUser(rs); }
        } catch (SQLException e) {
            System.out.println("Error loading student by ID: " + e.getMessage());
        } finally { closeResources(conn, ps, rs); }
        return student;
    }

    // Returns the most recent completed attempt for a given student.
    /**
     * Retrieves the single most recent completed assessment for a specific student.
     * 
     * @param studentId The unique ID of the student
     * @return AssessmentAttempt object if found, null otherwise
     */
    public AssessmentAttempt getLatestAttempt(int studentId) {
        AssessmentAttempt attempt = null;
        String sql = "SELECT * FROM assessment_attempts WHERE student_id = ? AND is_completed = 1 ORDER BY attempt_date DESC LIMIT 1";
        Connection conn = null; PreparedStatement ps = null; ResultSet rs = null;
        try {
            conn = DBUtil.getConnection(); ps = conn.prepareStatement(sql);
            ps.setInt(1, studentId); rs = ps.executeQuery();
            if (rs.next()) { attempt = mapAttempt(rs); }
        } catch (SQLException e) {
            System.out.println("Error loading latest attempt: " + e.getMessage());
        } finally { closeResources(conn, ps, rs); }
        return attempt;
    }

    /**
     * Calculates the average aptitude score across all completed assessments in the portal.
     * 
     * @return The average score (0 to 10)
     */
    public double getAverageAptitudeScore() {
        double avg = 0;
        String sql = "SELECT AVG(aptitude_score) FROM assessment_attempts WHERE is_completed = 1";
        Connection conn = null; PreparedStatement ps = null; ResultSet rs = null;
        try {
            conn = DBUtil.getConnection(); ps = conn.prepareStatement(sql); rs = ps.executeQuery();
            if (rs.next()) { avg = rs.getDouble(1); }
        } catch (SQLException e) {
            System.out.println("Error getting average aptitude: " + e.getMessage());
        } finally { closeResources(conn, ps, rs); }
        return avg;
    }

    /**
     * Identifies the most common personality cluster among all students who have finished the assessment.
     * 
     * @return The name of the cluster (e.g., "Analytical") or "N/A" if no data exists
     */
    public String getMostCommonCluster() {
        String cluster = "N/A";
        String sql = "SELECT personality_cluster, COUNT(*) AS total FROM assessment_attempts " +
                "WHERE is_completed = 1 AND personality_cluster IS NOT NULL " +
                "GROUP BY personality_cluster ORDER BY total DESC LIMIT 1";
        Connection conn = null; PreparedStatement ps = null; ResultSet rs = null;
        try {
            conn = DBUtil.getConnection(); ps = conn.prepareStatement(sql); rs = ps.executeQuery();
            if (rs.next()) { cluster = rs.getString("personality_cluster"); }
        } catch (SQLException e) {
            System.out.println("Error getting most common cluster: " + e.getMessage());
        } finally { closeResources(conn, ps, rs); }
        return cluster;
    }

    /**
     * Counts the total number of assessment attempts that have been successfully submitted.
     * 
     * @return Total count of rows in assessment_attempts where is_completed = 1
     */
    public int getTotalAttempts() {
        int count = 0;
        String sql = "SELECT COUNT(*) FROM assessment_attempts WHERE is_completed = 1";
        Connection conn = null; PreparedStatement ps = null; ResultSet rs = null;
        try {
            conn = DBUtil.getConnection(); ps = conn.prepareStatement(sql); rs = ps.executeQuery();
            if (rs.next()) { count = rs.getInt(1); }
        } catch (SQLException e) {
            System.out.println("Error getting total attempts: " + e.getMessage());
        } finally { closeResources(conn, ps, rs); }
        return count;
    }

    // Inserts a new student user into the users table.
    // Returns true on success, false if the email already exists or insert fails.
    /**
     * Registers a new student in the database.
     * Checks for email duplicates before inserting.
     * 
     * @param fullName The student's full name
     * @param email The student's unique email address
     * @param password The student's password
     * @return true if successful, false if email exists or error occurs
     */
    public boolean addStudent(String fullName, String email, String password) {
        // Check for duplicate email first
        String checkSql = "SELECT COUNT(*) FROM users WHERE email = ?";
        String insertSql = "INSERT INTO users (full_name, email, password, role, is_flagged) VALUES (?, ?, ?, 'STUDENT', 0)";
        Connection conn = null; PreparedStatement ps = null; ResultSet rs = null;
        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(checkSql);
            ps.setString(1, email);
            rs = ps.executeQuery();
            if (rs.next() && rs.getInt(1) > 0) {
                return false; // email already taken
            }
            closeResources(null, ps, rs); ps = null; rs = null;
            ps = conn.prepareStatement(insertSql);
            ps.setString(1, fullName);
            ps.setString(2, email);
            ps.setString(3, password);
            ps.executeUpdate();
            return true;
        } catch (SQLException e) {
            System.out.println("Error adding student: " + e.getMessage());
            return false;
        } finally { closeResources(conn, ps, rs); }
    }

    // Updates the is_flagged column and counselor_note for a student.
    /**
     * Updates the flagging status and adds a counselor's note for a specific student.
     * 
     * @param studentId The unique ID of the student
     * @param flagged True to flag the student, false to unflag
     * @param note The counselor's feedback or observation note
     */
    public void updateStudentFlag(int studentId, boolean flagged, String note) {
        String sql = "UPDATE users SET is_flagged = ?, counselor_note = ? WHERE user_id = ?";
        Connection conn = null; PreparedStatement ps = null;
        try {
            conn = DBUtil.getConnection(); ps = conn.prepareStatement(sql);
            ps.setInt(1, flagged ? 1 : 0); ps.setString(2, note); ps.setInt(3, studentId);
            ps.executeUpdate();
        } catch (SQLException e) {
            System.out.println("Error updating student flag: " + e.getMessage());
        } finally { closeResources(conn, ps, null); }
    }

    private User mapUser(ResultSet rs) throws SQLException {
        User u = new User();
        u.setUserId(rs.getInt("user_id")); u.setFullName(rs.getString("full_name"));
        u.setEmail(rs.getString("email")); u.setRole(rs.getString("role"));
        u.setFlagged(rs.getInt("is_flagged") == 1);
        u.setCounselorNote(rs.getString("counselor_note"));
        return u;
    }

    private AssessmentAttempt mapAttempt(ResultSet rs) throws SQLException {
        AssessmentAttempt a = new AssessmentAttempt();
        a.setAttemptId(rs.getInt("attempt_id")); a.setStudentId(rs.getInt("student_id"));
        a.setAttemptDate(rs.getTimestamp("attempt_date"));
        a.setCompleted(rs.getInt("is_completed") == 1);
        a.setAptitudeScore(rs.getInt("aptitude_score"));
        a.setPersonalityScore(rs.getInt("personality_score"));
        a.setInterestScore(rs.getInt("interest_score"));
        a.setPersonalityCluster(rs.getString("personality_cluster"));
        return a;
    }

    private void closeResources(Connection conn, PreparedStatement ps, ResultSet rs) {
        try { if (rs != null) rs.close(); } catch (SQLException e) { e.printStackTrace(); }
        try { if (ps != null) ps.close(); } catch (SQLException e) { e.printStackTrace(); }
        try { if (conn != null) conn.close(); } catch (SQLException e) { e.printStackTrace(); }
    }
}
