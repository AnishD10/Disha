package com.disha.dao;

import com.disha.model.User;
import com.disha.util.DBUtil;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * UserDAO — All DB operations for the users table.
 * Extends DBUtil — never write raw Connection code here.
 */
public class UserDAO extends DBUtil {

    private static final String INSERT_USER =
            "INSERT INTO users (full_name, email, password_hash, role, phone, address, is_active) " +
                    "VALUES (?, ?, ?, ?, ?, ?, 1)";

    private static final String SELECT_BY_EMAIL =
            "SELECT user_id, full_name, email, password_hash, role, phone, address, created_at, is_active " +
                    "FROM users WHERE email = ? AND is_active = 1";

    private static final String SELECT_BY_ID =
            "SELECT user_id, full_name, email, password_hash, role, phone, address, created_at, is_active " +
                    "FROM users WHERE user_id = ?";

    private static final String EMAIL_EXISTS =
            "SELECT COUNT(*) FROM users WHERE email = ?";

    private static final String UPDATE_PASSWORD =
            "UPDATE users SET password_hash = ? WHERE user_id = ?";

    private static final String DEACTIVATE_USER =
            "UPDATE users SET is_active = 0 WHERE user_id = ?";

    private static final String SELECT_ALL_BY_ROLE =
            "SELECT user_id, full_name, email, password_hash, role, phone, address, created_at, is_active " +
                    "FROM users WHERE role = ? AND is_active = 1 ORDER BY full_name";

    // ── Write ─────────────────────────────────────────────────────────────────

    /**
     * Insert a new user. Password MUST be hashed before calling this.
     * @return generated user_id, or -1 on failure
     */
    public int registerUser(User user) throws SQLException {
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = getConnection();
            ps   = conn.prepareStatement(INSERT_USER, Statement.RETURN_GENERATED_KEYS);
            ps.setString(1, user.getFullName());
            ps.setString(2, user.getEmail());
            ps.setString(3, user.getPasswordHash());
            ps.setString(4, user.getRole().name());
            ps.setString(5, user.getPhone()    != null ? user.getPhone()    : "");
            ps.setString(6, user.getAddress()  != null ? user.getAddress()  : "");
            if (ps.executeUpdate() == 0) return -1;
            rs = ps.getGeneratedKeys();
            return rs.next() ? rs.getInt(1) : -1;
        } finally {
            closeResources(conn, ps, rs);
        }
    }

    // ── Read ──────────────────────────────────────────────────────────────────

    /**
     * Find active user by email — used in login to fetch the stored hash.
     * Returns null if not found or account is deactivated.
     */
    public User findByEmail(String email) throws SQLException {
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = getConnection();
            ps   = conn.prepareStatement(SELECT_BY_EMAIL);
            ps.setString(1, email);
            rs = ps.executeQuery();
            return rs.next() ? mapRow(rs) : null;
        } finally {
            closeResources(conn, ps, rs);
        }
    }

    /**
     * Find user by primary key — used to refresh session data.
     */
    public User findById(int userId) throws SQLException {
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = getConnection();
            ps   = conn.prepareStatement(SELECT_BY_ID);
            ps.setInt(1, userId);
            rs = ps.executeQuery();
            return rs.next() ? mapRow(rs) : null;
        } finally {
            closeResources(conn, ps, rs);
        }
    }

    /**
     * Check if an email is already registered.
     * Used during registration to prevent duplicate accounts.
     */
    public boolean emailExists(String email) throws SQLException {
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = getConnection();
            ps   = conn.prepareStatement(EMAIL_EXISTS);
            ps.setString(1, email);
            rs = ps.executeQuery();
            return rs.next() && rs.getInt(1) > 0;
        } finally {
            closeResources(conn, ps, rs);
        }
    }

    /**
     * Fetch all active users with a given role.
     * Used by Admin Dashboard (Biraj) and Counselor Dashboard (Ashmit).
     */
    public List<User> findAllByRole(User.Role role) throws SQLException {
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        List<User> list = new ArrayList<>();
        try {
            conn = getConnection();
            ps   = conn.prepareStatement(SELECT_ALL_BY_ROLE);
            ps.setString(1, role.name());
            rs = ps.executeQuery();
            while (rs.next()) list.add(mapRow(rs));
            return list;
        } finally {
            closeResources(conn, ps, rs);
        }
    }

    // ── Update ────────────────────────────────────────────────────────────────

    public boolean updatePassword(int userId, String newHash) throws SQLException {
        Connection conn = null;
        PreparedStatement ps = null;
        try {
            conn = getConnection();
            ps   = conn.prepareStatement(UPDATE_PASSWORD);
            ps.setString(1, newHash);
            ps.setInt(2, userId);
            return ps.executeUpdate() > 0;
        } finally {
            closeResources(conn, ps, null);
        }
    }

    /** Soft-delete — never hard-delete users to preserve audit trail. */
    public boolean deactivateUser(int userId) throws SQLException {
        Connection conn = null;
        PreparedStatement ps = null;
        try {
            conn = getConnection();
            ps   = conn.prepareStatement(DEACTIVATE_USER);
            ps.setInt(1, userId);
            return ps.executeUpdate() > 0;
        } finally {
            closeResources(conn, ps, null);
        }
    }

    // ── Private helper ────────────────────────────────────────────────────────

    private User mapRow(ResultSet rs) throws SQLException {
        User u = new User();
        u.setUserId(rs.getInt("user_id"));
        u.setFullName(rs.getString("full_name"));
        u.setEmail(rs.getString("email"));
        u.setPasswordHash(rs.getString("password_hash"));
        u.setRole(User.Role.valueOf(rs.getString("role")));
        u.setPhone(rs.getString("phone"));
        u.setAddress(rs.getString("address"));
        u.setCreatedAt(rs.getTimestamp("created_at"));
        u.setActive(rs.getBoolean("is_active"));
        return u;
    }
}
