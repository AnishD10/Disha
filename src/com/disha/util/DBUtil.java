package com.disha.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

/**
 * Shared JDBC connection utility.
 *
 * Defaults match the shared local DISHA development database. Both the
 * integration-wide DB_* variables and Joyal module DISHA_DB_* variables are
 * supported so all modules can point at the same database.
 */
public abstract class DBUtil {

    private static final String DB_HOST = env("DISHA_DB_HOST", env("DB_HOST", "localhost"));
    private static final String DB_PORT = env("DISHA_DB_PORT", env("DB_PORT", "3306"));
    private static final String DB_NAME = env("DISHA_DB_NAME", env("DB_NAME", "disha_career_portal"));
    private static final String DB_USER = env("DISHA_DB_USER", env("DB_USER", "root"));
    private static final String DB_PASSWORD = env("DISHA_DB_PASSWORD", env("DB_PASSWORD", "its2026"));
    private static final String DB_URL = env("DISHA_DB_URL",
            "jdbc:mysql://" + DB_HOST + ":" + DB_PORT + "/" + DB_NAME +
                    "?useSSL=false&serverTimezone=UTC&allowPublicKeyRetrieval=true");

    static {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            throw new RuntimeException("MySQL JDBC Driver not found.", e);
        }
    }

    protected Connection getConnection() throws SQLException {
        return DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
    }

    protected void closeResources(Connection conn, PreparedStatement ps, ResultSet rs) {
        try { if (rs != null) rs.close(); } catch (SQLException ignored) {}
        try { if (ps != null) ps.close(); } catch (SQLException ignored) {}
        try { if (conn != null) conn.close(); } catch (SQLException ignored) {}
    }

    private static String env(String key, String defaultValue) {
        String value = System.getenv(key);
        return (value == null || value.trim().isEmpty()) ? defaultValue : value.trim();
    }
}
