package com.disha.dao.auth;

import com.disha.model.auth.User;
import com.disha.util.DBUtil;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

/**
 * UserDAO handles authentication and profile management for all users
 * (Students and Counselors) in the DISHA portal.
 * 
 * @author Ashmit
 */
public class UserDAO {

    /**
     * Authenticates a user by checking their email and password against the database.
     * 
     * @param email The user's email address
     * @param password The user's password (stored as plain text in this version)
     * @return User object if credentials are correct, null otherwise
     */
    public User authenticate(String email, String password) {
        User user = null;
        String sql = "SELECT * FROM users WHERE email = ? AND password = ?";
        Connection conn = null; PreparedStatement ps = null; ResultSet rs = null;
        try {
            conn = DBUtil.getConnection(); ps = conn.prepareStatement(sql);
            ps.setString(1, email); ps.setString(2, password); rs = ps.executeQuery();
            if (rs.next()) { user = mapUser(rs); }
        } catch (SQLException e) {
            System.out.println("Authentication error: " + e.getMessage());
        } finally { closeResources(conn, ps, rs); }
        return user;
    }

    /**
     * Updates the profile information of an existing user.
     * 
     * @param userId The ID of the user to update
     * @param fullName The new full name
     * @param email The new email address
     * @param password The new password (if not empty)
     * @return true if update succeeded, false otherwise
     */
    public boolean updateProfile(int userId, String fullName, String email, String password) {
        String sql;
        boolean hasPassword = password != null && !password.trim().isEmpty();
        if (hasPassword) {
            sql = "UPDATE users SET full_name = ?, email = ?, password = ? WHERE user_id = ?";
        } else {
            sql = "UPDATE users SET full_name = ?, email = ? WHERE user_id = ?";
        }
        
        Connection conn = null;
        PreparedStatement ps = null;
        try {
            conn = DBUtil.getConnection();
            ps = conn.prepareStatement(sql);
            ps.setString(1, fullName);
            ps.setString(2, email);
            if (hasPassword) {
                ps.setString(3, password);
                ps.setInt(4, userId);
            } else {
                ps.setInt(3, userId);
            }
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.out.println("Error updating profile: " + e.getMessage());
            return false;
        } finally {
            closeResources(conn, ps, null);
        }
    }

    private User mapUser(ResultSet rs) throws SQLException {
        User u = new User();
        u.setUserId(rs.getInt("user_id")); u.setFullName(rs.getString("full_name"));
        u.setEmail(rs.getString("email")); u.setRole(rs.getString("role"));
        u.setFlagged(rs.getInt("is_flagged") == 1);
        u.setCounselorNote(rs.getString("counselor_note"));
        return u;
    }

    private void closeResources(Connection conn, PreparedStatement ps, ResultSet rs) {
        try { if (rs != null) rs.close(); } catch (SQLException e) { e.printStackTrace(); }
        try { if (ps != null) ps.close(); } catch (SQLException e) { e.printStackTrace(); }
        try { if (conn != null) conn.close(); } catch (SQLException e) { e.printStackTrace(); }
    }
}
