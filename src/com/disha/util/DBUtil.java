package com.disha.util;

import java.sql.*;

/**
 * DBUtil — Shared JDBC Connection Utility
 * =========================================
 * OWNER : Anish Dangal (DB Architect)
 * STATUS: ⚠️  Fill in DB credentials before running
 *
 * ALL DAOs extend this class. Never write raw Connection code outside here.
 */
public abstract class DBUtil {

    // ── Change these to match your MySQL setup ────────────────────────────────
    private static final String DB_URL      =
            "jdbc:mysql://localhost:3306/disha_db?useSSL=false&serverTimezone=UTC&allowPublicKeyRetrieval=true";
    private static final String DB_USER     = "disha_user";
    private static final String DB_PASSWORD = "disha2024";
    // ─────────────────────────────────────────────────────────────────────────

    static {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            throw new RuntimeException(
                    "MySQL JDBC Driver not found. Check pom.xml for mysql-connector-java.", e);
        }
    }

    protected Connection getConnection() throws SQLException {
        return DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
    }

    protected void closeResources(Connection conn, PreparedStatement ps, ResultSet rs) {
        try { if (rs   != null) rs.close();   } catch (SQLException ignored) {}
        try { if (ps   != null) ps.close();   } catch (SQLException ignored) {}
        try { if (conn != null) conn.close(); } catch (SQLException ignored) {}
    }
}
