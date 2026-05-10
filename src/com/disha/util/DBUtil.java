package com.disha.util;

import java.sql.*;

/**
 * DBUtil — Shared JDBC Connection Utility
 * =========================================
 *
 * This file provides centralized database connection management.
 * All DAOs in this project extend this class.
 *
 * This file must provide:
 * 1. getConnection() — returns a live java.sql.Connection to disha_db
 * 2. closeResources() — closes Connection, PreparedStatement, ResultSet
 *
 * The DB URL, username, and password below match the setup in setup.sh.
 * Change them if your local MySQL uses different credentials.
 */
public abstract class DBUtil {

    // ── CHANGE THESE to match your local MySQL setup ──────────────────────────
    private static final String DB_URL = "jdbc:mysql://localhost:3306/disha_career_portal"
            + "?useSSL=false&serverTimezone=UTC&allowPublicKeyRetrieval=true";
    private static final String DB_USERNAME = "root";
    private static final String DB_PASSWORD = "its2026";
    // ─────────────────────────────────────────────────────────────────────────

    static {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            throw new RuntimeException(
                    "MySQL JDBC Driver not found. Ensure mysql-connector-java is in classpath.", e);
        }
    }

    /**
     * Returns a new JDBC connection from DriverManager.
     * Each DAO method opens and closes its own connection.
     * (Connection pooling can be added here later without changing any DAO.)
     */
    protected Connection getConnection() throws SQLException {
        return DriverManager.getConnection(DB_URL, DB_USERNAME, DB_PASSWORD);
    }

    /**
     * Safely close JDBC resources in reverse order (ResultSet → Statement →
     * Connection).
     * Call this in every DAO's finally block.
     *
     * @param conn the Connection to close (may be null)
     * @param ps   the PreparedStatement to close (may be null)
     * @param rs   the ResultSet to close (may be null)
     */
    protected void closeResources(Connection conn, PreparedStatement ps, ResultSet rs) {
        try {
            if (rs != null)
                rs.close();
        } catch (SQLException ignored) {
        }
        try {
            if (ps != null)
                ps.close();
        } catch (SQLException ignored) {
        }
        try {
            if (conn != null)
                conn.close();
        } catch (SQLException ignored) {
        }
    }
}
