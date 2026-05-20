package com.disha.dao;

import com.disha.model.User;
import com.disha.util.DBUtil;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

/**
 * Database operations for authentication users.
 *
 * The DAO is aligned to the shared development users table:
 * username is required by the table, while login still uses email.
 */
public class UserDAO extends DBUtil {

    private static final String INSERT_USER =
            "INSERT INTO users (username, email, password_hash, role, first_name, last_name, phone, is_active) " +
                    "VALUES (?, ?, ?, ?, ?, ?, ?, 1)";

    private static final String SELECT_BY_EMAIL =
            "SELECT user_id, username, email, password_hash, role, first_name, last_name, phone, created_at, is_active " +
                    "FROM users WHERE email = ? AND is_active = 1";

    private static final String SELECT_BY_ID =
            "SELECT user_id, username, email, password_hash, role, first_name, last_name, phone, created_at, is_active " +
                    "FROM users WHERE user_id = ?";

    private static final String EMAIL_EXISTS =
            "SELECT COUNT(*) FROM users WHERE email = ?";

    private static final String UPDATE_PASSWORD =
            "UPDATE users SET password_hash = ? WHERE user_id = ?";

    private static final String DEACTIVATE_USER =
            "UPDATE users SET is_active = 0 WHERE user_id = ?";

    private static final String SELECT_ALL_BY_ROLE =
            "SELECT user_id, username, email, password_hash, role, first_name, last_name, phone, created_at, is_active " +
                    "FROM users WHERE role = ? AND is_active = 1 ORDER BY first_name, last_name";

    public int registerUser(User user) throws SQLException {
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = getConnection();
            ps = conn.prepareStatement(INSERT_USER, Statement.RETURN_GENERATED_KEYS);
            ps.setString(1, createUsername(user.getEmail()));
            ps.setString(2, user.getEmail());
            ps.setString(3, user.getPasswordHash());
            ps.setString(4, user.getRole().name());
            ps.setString(5, user.getFirstName());
            ps.setString(6, user.getLastName() != null ? user.getLastName() : "");
            ps.setString(7, user.getPhone() != null ? user.getPhone() : "");
            if (ps.executeUpdate() == 0) return -1;
            rs = ps.getGeneratedKeys();
            return rs.next() ? rs.getInt(1) : -1;
        } finally {
            closeResources(conn, ps, rs);
        }
    }

    public User findByEmail(String email) throws SQLException {
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = getConnection();
            ps = conn.prepareStatement(SELECT_BY_EMAIL);
            ps.setString(1, email);
            rs = ps.executeQuery();
            return rs.next() ? mapRow(rs) : null;
        } finally {
            closeResources(conn, ps, rs);
        }
    }

    public User findById(int userId) throws SQLException {
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = getConnection();
            ps = conn.prepareStatement(SELECT_BY_ID);
            ps.setInt(1, userId);
            rs = ps.executeQuery();
            return rs.next() ? mapRow(rs) : null;
        } finally {
            closeResources(conn, ps, rs);
        }
    }

    public boolean emailExists(String email) throws SQLException {
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = getConnection();
            ps = conn.prepareStatement(EMAIL_EXISTS);
            ps.setString(1, email);
            rs = ps.executeQuery();
            return rs.next() && rs.getInt(1) > 0;
        } finally {
            closeResources(conn, ps, rs);
        }
    }

    public List<User> findAllByRole(User.Role role) throws SQLException {
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        List<User> list = new ArrayList<>();
        try {
            conn = getConnection();
            ps = conn.prepareStatement(SELECT_ALL_BY_ROLE);
            ps.setString(1, role.name());
            rs = ps.executeQuery();
            while (rs.next()) list.add(mapRow(rs));
            return list;
        } finally {
            closeResources(conn, ps, rs);
        }
    }

    public boolean updatePassword(int userId, String newHash) throws SQLException {
        Connection conn = null;
        PreparedStatement ps = null;
        try {
            conn = getConnection();
            ps = conn.prepareStatement(UPDATE_PASSWORD);
            ps.setString(1, newHash);
            ps.setInt(2, userId);
            return ps.executeUpdate() > 0;
        } finally {
            closeResources(conn, ps, null);
        }
    }

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

    private User mapRow(ResultSet rs) throws SQLException {
        User u = new User();
        u.setUserId(rs.getInt("user_id"));
        u.setUsername(rs.getString("username"));
        u.setFirstName(rs.getString("first_name"));
        u.setLastName(rs.getString("last_name"));
        u.setEmail(rs.getString("email"));
        u.setPasswordHash(rs.getString("password_hash"));
        u.setRole(User.Role.valueOf(rs.getString("role")));
        u.setPhone(rs.getString("phone"));
        u.setAddress("");
        u.setCreatedAt(rs.getTimestamp("created_at"));
        u.setActive(rs.getBoolean("is_active"));
        return u;
    }

    private String createUsername(String email) {
        String localPart = email == null ? "user" : email.split("@", 2)[0];
        String safe = localPart.toLowerCase().replaceAll("[^a-z0-9_]", "_");
        if (safe.isEmpty()) safe = "user";
        if (safe.length() > 35) safe = safe.substring(0, 35);
        return safe + "_" + Long.toHexString(System.currentTimeMillis());
    }
}
