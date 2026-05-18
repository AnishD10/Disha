package com.disha.util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

// DBUtil gives a fresh database connection to any class that needs one.
// This is the ONLY place in the project where DriverManager.getConnection() is called.
// Every DAO must use DBUtil.getConnection() and never create its own connection.
public class DBUtil {

    private static final String DEFAULT_URL =
            "jdbc:mysql://localhost:3306/Disha_db?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC";
    private static final String DEFAULT_USERNAME = "root";
    private static final String DEFAULT_PASSWORD = "";

    // Static block runs once when the class is first loaded.
    // It registers the MySQL driver with Java so connections can be made.
    static {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            System.out.println("MySQL Driver not found: " + e.getMessage());
        }
    }

    // Returns a new Connection to the database.
    // The caller is responsible for closing the connection after use.
    public static Connection getConnection() throws SQLException {
        String url = readSetting("DISHA_DB_URL", "disha.db.url", DEFAULT_URL);
        String username = readSetting("DISHA_DB_USERNAME", "disha.db.username", DEFAULT_USERNAME);
        String password = readSetting("DISHA_DB_PASSWORD", "disha.db.password", DEFAULT_PASSWORD);
        return DriverManager.getConnection(url, username, password);
    }

    private static String readSetting(String envKey, String propertyKey, String defaultValue) {
        String envValue = System.getenv(envKey);
        if (envValue != null && !envValue.isBlank()) {
            return envValue;
        }

        String propertyValue = System.getProperty(propertyKey);
        if (propertyValue != null && !propertyValue.isBlank()) {
            return propertyValue;
        }

        return defaultValue;
    }
}
