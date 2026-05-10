package com.disha.dao;

import com.disha.model.User;
import com.disha.util.DBUtil;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * UserDAO — All database operations for the User entity.
 *
 * Extends DBUtil so that all raw JDBC boilerplate (getConnection, closing)
 * is handled by the shared utility class — per the project agreement.
 *
 * Author: Joyal Karki — Authentication Lead
 */
public class UserDAO extends DBUtil {

    // ── SQL Constants ─────────────────────────────────────────────────────────

    private static final String INSERT_USER = "INSERT INTO users (full_name, email, password_hash, role, phone, address, is_active) "
            +
            "VALUES (?, ?, ?, ?, ?, ?, ?)";

    private static final String SELECT_BY_EMAIL = "SELECT user_id, full_name, email, password_hash, role, phone, address, created_at, is_active "
            +
            "FROM users WHERE email = ? AND is_active = 1";

    private static final String SELECT_BY_ID = "SELECT user_id, full_name, email, password_hash, role, phone, address, created_at, is_active "
            +
            "FROM users WHERE user_id = ?";

    private static final String EMAIL_EXISTS = "SELECT COUNT(*) FROM users WHERE email = ?";

    private static final String UPDATE_PASSWORD = "UPDATE users SET password_hash = ? WHERE user_id = ?";

    private static final String DEACTIVATE_USER = "UPDATE users SET is_active = 0 WHERE user_id = ?";

    private static final String SELECT_ALL_BY_ROLE = "SELECT user_id, full_name, email, password_hash, role, phone, address, created_at, is_active "
            +
            "FROM users WHERE role = ? ORDER BY full_name";

    // ── Write Operations ──────────────────────────────────────────────────────

    /**
     * Register a new user into the system.
     * The password MUST already be hashed before calling this method.
     *
     * @return the generated user_id, or -1 on failure
     */
    public int registerUser(User user) throws SQLException {
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = getConnection();
            ps = conn.prepareStatement(INSERT_USER, Statement.RETURN_GENERATED_KEYS);
            ps.setString(1, user.getFullName());
            ps.setString(2, user.getEmail());
            ps.setString(3, user.getPasswordHash());
            ps.setString(4, user.getRole().name());
            ps.setString(5, user.getPhone());
            ps.setString(6, user.getAddress());
            ps.setBoolean(7, true);

            int rowsAffected = ps.executeUpdate();
            if (rowsAffected == 0)
                return -1;

            rs = ps.getGeneratedKeys();
            if (rs.next()) {
                return rs.getInt(1);
            }
            return -1;

        } finally {
            closeResources(conn, ps, rs);
        }
    }

    // ── Read Operations ───────────────────────────────────────────────────────

    /**
     * Fetch a user by their email address.
     * Used during login to retrieve the stored password hash for verification.
     *
     * @return the User object, or null if not found / inactive
     */
    public User findByEmail(String email) throws SQLException {
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = getConnection();
            ps = conn.prepareStatement(SELECT_BY_EMAIL);
            ps.setString(1, email);
            rs = ps.executeQuery();
            if (rs.next()) {
                return mapRow(rs);
            }
            return null;
        } finally {
            closeResources(conn, ps, rs);
        }
    }

    /**
     * Fetch a user by their primary key.
     * Used to refresh session data when needed.
     *
     * @return the User object, or null if not found
     */
    public User findById(int userId) throws SQLException {
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = getConnection();
            ps = conn.prepareStatement(SELECT_BY_ID);
            ps.setInt(1, userId);
            rs = ps.executeQuery();
            if (rs.next()) {
                return mapRow(rs);
            }
            return null;
        } finally {
            closeResources(conn, ps, rs);
        }
    }

    /**
     * Check if an email address is already registered.
     * Used during registration to prevent duplicate accounts.
     */
    public boolean emailExists(String email) throws SQLException {
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = getConnection();
            ps = conn.prepareStatement(EMAIL_EXISTS);
            ps.setString(1, email);
            rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
            return false;
        } finally {
            closeResources(conn, ps, rs);
        }
    }

    /**
     * Retrieve all users with a specific role (used by Admin and Counselor
     * dashboards).
     */
    public List<User> findAllByRole(User.Role role) throws SQLException {
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        List<User> users = new ArrayList<>();
        try {
            conn = getConnection();
            ps = conn.prepareStatement(SELECT_ALL_BY_ROLE);
            ps.setString(1, role.name());
            rs = ps.executeQuery();
            while (rs.next()) {
                users.add(mapRow(rs));
            }
            return users;
        } finally {
            closeResources(conn, ps, rs);
        }
    }

    // ── Update Operations ─────────────────────────────────────────────────────

    /**
     * Update the stored password hash for a user.
     * 
     * @return true if the update succeeded
     */
    public boolean updatePassword(int userId, String newPasswordHash) throws SQLException {
        Connection conn = null;
        PreparedStatement ps = null;
        try {
            conn = getConnection();
            ps = conn.prepareStatement(UPDATE_PASSWORD);
            ps.setString(1, newPasswordHash);
            ps.setInt(2, userId);
            return ps.executeUpdate() > 0;
        } finally {
            closeResources(conn, ps, null);
        }
    }

    /**
     * Soft-delete a user by setting is_active = 0.
     * We NEVER hard-delete user records to preserve audit trails.
     */
    public boolean deactivateUser(int userId) throws SQLException {
        Connection conn = null;
        PreparedStatement ps = null;
        try {
            conn = getConnection();
            ps = conn.prepareStatement(DEACTIVATE_USER);
            ps.setInt(1, userId);
            return ps.executeUpdate() > 0;
        } finally {
            closeResources(conn, ps, null);
        }
    }

    // ── Private Helpers ───────────────────────────────────────────────────────

    /**
     * Map a single ResultSet row into a User object.
     * Centralised here so any schema change only needs one edit.
     */
    private User mapRow(ResultSet rs) throws SQLException {
        User user = new User();
        user.setUserId(rs.getInt("user_id"));
        user.setFullName(rs.getString("full_name"));
        user.setEmail(rs.getString("email"));
        user.setPasswordHash(rs.getString("password_hash"));
        user.setRole(User.Role.valueOf(rs.getString("role")));
        user.setPhone(rs.getString("phone"));
        user.setAddress(rs.getString("address"));
        user.setCreatedAt(rs.getTimestamp("created_at"));
        user.setActive(rs.getBoolean("is_active"));
        return user;
    }
}
