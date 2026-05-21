package com.disha.disha;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

/**
 * DBConnection — shared JDBC utility.
 * Change DB_URL, DB_USER, DB_PASSWORD to match your local MySQL setup.
 *
 * Default MySQL port is 3306.
 * If your XAMPP/MySQL runs on a different port, update DB_URL accordingly.
 */
public class DBConnection {

    // ── CHANGE THESE TO MATCH YOUR SETUP ───────────────────────────────────
    private static final String DB_URL  = "jdbc:mysql://localhost:3308/disha_db"
                                        + "?useSSL=false&serverTimezone=UTC"
                                        + "&allowPublicKeyRetrieval=true";
    private static final String DB_USER = "root";
    private static final String DB_PASS = "";          // set your MySQL password here
    // ───────────────────────────────────────────────────────────────────────

    static {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            throw new RuntimeException("MySQL JDBC Driver not found. "
                + "Make sure mysql-connector-j is in your pom.xml.", e);
        }
    }

    /** Returns a new connection from DriverManager. Caller must close it. */
    public static Connection getConnection() throws SQLException {
        return DriverManager.getConnection(DB_URL, DB_USER, DB_PASS);
    }

    private DBConnection() {} // prevent instantiation
}
