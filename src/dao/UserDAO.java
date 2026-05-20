package dao;

import com.disha.model.User;
import java.sql.*;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * Data Access Object for User CRUD operations.
 * Uses PreparedStatement to prevent SQL injection.
 */
public class UserDAO extends BaseDAO {

    // ── Authentication ────────────────────────────────────
    public User authenticate(String email, String passwordHash) {
        String sql = "SELECT * FROM users WHERE email = ? AND password_hash = ? AND is_active = TRUE";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = getConnection();
            ps = conn.prepareStatement(sql);
            ps.setString(1, email);
            ps.setString(2, passwordHash);
            rs = ps.executeQuery();
            if (rs.next())
                return mapUser(rs);
        } catch (SQLException e) {
            logError("Error authenticating user", e);
        } finally {
            closeAllResources(rs, ps, conn);
        }
        return null;
    }

    // ── CREATE ────────────────────────────────────────────
    public User createUser(User user, String passwordHash) {
        String sql = "INSERT INTO users (username, email, password_hash, role, first_name, last_name, phone, is_active) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = getConnection();
            ps = conn.prepareStatement(sql, PreparedStatement.RETURN_GENERATED_KEYS);
            String username = user.getEmail().split("@")[0] + System.currentTimeMillis() % 10000;
            ps.setString(1, username);
            ps.setString(2, user.getEmail());
            ps.setString(3, passwordHash);
            ps.setString(4, user.getRole().name());
            ps.setString(5, user.getFirstName());
            ps.setString(6, user.getLastName() != null ? user.getLastName() : "");
            ps.setString(7, user.getPhone() != null ? user.getPhone() : "");
            ps.setBoolean(8, true);
            int affected = ps.executeUpdate();
            if (affected > 0) {
                rs = ps.getGeneratedKeys();
                if (rs.next()) {
                    user.setUserId(rs.getInt(1));
                    return user;
                }
            }
        } catch (SQLException e) {
            logError("Error creating user", e);
        } finally {
            closeAllResources(rs, ps, conn);
        }
        return null;
    }

    // ── READ ALL ──────────────────────────────────────────
    public List<User> getAllUsers() {
        List<User> users = new ArrayList<>();
        String sql = "SELECT * FROM users ORDER BY created_at DESC";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = getConnection();
            ps = conn.prepareStatement(sql);
            rs = ps.executeQuery();
            while (rs.next())
                users.add(mapUser(rs));
        } catch (SQLException e) {
            logError("Error fetching all users", e);
        } finally {
            closeAllResources(rs, ps, conn);
        }
        return users;
    }

    // ── READ BY ROLE ──────────────────────────────────────
    public List<User> getUsersByRole(String role) {
        List<User> users = new ArrayList<>();
        String sql = "SELECT * FROM users WHERE role = ? ORDER BY created_at DESC";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = getConnection();
            ps = conn.prepareStatement(sql);
            ps.setString(1, role);
            rs = ps.executeQuery();
            while (rs.next())
                users.add(mapUser(rs));
        } catch (SQLException e) {
            logError("Error fetching users by role", e);
        } finally {
            closeAllResources(rs, ps, conn);
        }
        return users;
    }

    // ── SEARCH ────────────────────────────────────────────
    public List<User> searchUsers(String keyword) {
        List<User> users = new ArrayList<>();
        String sql = "SELECT * FROM users WHERE first_name LIKE ? OR last_name LIKE ? OR email LIKE ? ORDER BY created_at DESC";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = getConnection();
            ps = conn.prepareStatement(sql);
            String like = "%" + keyword + "%";
            ps.setString(1, like);
            ps.setString(2, like);
            ps.setString(3, like);
            rs = ps.executeQuery();
            while (rs.next())
                users.add(mapUser(rs));
        } catch (SQLException e) {
            logError("Error searching users", e);
        } finally {
            closeAllResources(rs, ps, conn);
        }
        return users;
    }

    // ── READ BY ID ────────────────────────────────────────
    public User getUserById(int userId) {
        String sql = "SELECT * FROM users WHERE user_id = ?";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, userId);
            rs = ps.executeQuery();
            if (rs.next())
                return mapUser(rs);
        } catch (SQLException e) {
            logError("Error fetching user by ID", e);
        } finally {
            closeAllResources(rs, ps, conn);
        }
        return null;
    }

    // ── UPDATE ────────────────────────────────────────────
    public boolean updateUser(User user) {
        String sql = "UPDATE users SET first_name=?, last_name=?, email=?, phone=?, role=?, is_active=? WHERE user_id=?";
        Connection conn = null;
        PreparedStatement ps = null;
        try {
            conn = getConnection();
            ps = conn.prepareStatement(sql);
            ps.setString(1, user.getFirstName());
            ps.setString(2, user.getLastName());
            ps.setString(3, user.getEmail());
            ps.setString(4, user.getPhone());
            ps.setString(5, user.getRole().name());
            ps.setBoolean(6, user.isActive());
            ps.setInt(7, user.getUserId());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            logError("Error updating user", e);
        } finally {
            closeResources(ps, conn);
        }
        return false;
    }

    // ── DELETE ─────────────────────────────────────────────
    public boolean deleteUser(int userId) {
        String sql = "DELETE FROM users WHERE user_id = ?";
        Connection conn = null;
        PreparedStatement ps = null;
        try {
            conn = getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, userId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            logError("Error deleting user", e);
        } finally {
            closeResources(ps, conn);
        }
        return false;
    }

    // ── COUNTS ────────────────────────────────────────────
    public int countByRole(String role) {
        String sql = "SELECT COUNT(*) FROM users WHERE role = ?";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = getConnection();
            ps = conn.prepareStatement(sql);
            ps.setString(1, role);
            rs = ps.executeQuery();
            if (rs.next())
                return rs.getInt(1);
        } catch (SQLException e) {
            logError("Error counting users by role", e);
        } finally {
            closeAllResources(rs, ps, conn);
        }
        return 0;
    }

    public int countAll() {
        String sql = "SELECT COUNT(*) FROM users";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = getConnection();
            ps = conn.prepareStatement(sql);
            rs = ps.executeQuery();
            if (rs.next())
                return rs.getInt(1);
        } catch (SQLException e) {
            logError("Error counting all users", e);
        } finally {
            closeAllResources(rs, ps, conn);
        }
        return 0;
    }

    // ── RECENT USERS ──────────────────────────────────────
    public List<User> getRecentUsers(int limit) {
        List<User> users = new ArrayList<>();
        String sql = "SELECT * FROM users ORDER BY created_at DESC LIMIT ?";
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        try {
            conn = getConnection();
            ps = conn.prepareStatement(sql);
            ps.setInt(1, limit);
            rs = ps.executeQuery();
            while (rs.next())
                users.add(mapUser(rs));
        } catch (SQLException e) {
            logError("Error fetching recent users", e);
        } finally {
            closeAllResources(rs, ps, conn);
        }
        return users;
    }

    // ── Helper: Map ResultSet -> User ─────────────────────
    private User mapUser(ResultSet rs) throws SQLException {
        User user = new User();
        user.setUserId(rs.getInt("user_id"));
        user.setUsername(rs.getString("username"));
        user.setEmail(rs.getString("email"));
        user.setPasswordHash(rs.getString("password_hash"));
        user.setFirstName(rs.getString("first_name"));
        user.setLastName(rs.getString("last_name"));
        user.setPhone(rs.getString("phone"));
        user.setActive(rs.getBoolean("is_active"));
        user.setCreatedAt(rs.getTimestamp("created_at"));
        user.setUpdatedAt(rs.getTimestamp("updated_at"));
        try {
            user.setRole(User.Role.valueOf(rs.getString("role")));
        } catch (Exception e) {
            user.setRole(User.Role.STUDENT);
        }
        return user;
    }
}
