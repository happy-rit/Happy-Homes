package com.happyhomes.db;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

/** Oracle connection helper. Configure the three environment variables documented in README.md. */
public final class Database {
    private Database() { }

    public static Connection getConnection() throws SQLException {
        String url = System.getenv("HAPPY_HOME_DB_URL");
        String user = System.getenv("HAPPY_HOME_DB_USER");
        String password = System.getenv("HAPPY_HOME_DB_PASSWORD");
        if (isBlank(url) || isBlank(user) || password == null) {
            throw new SQLException("Database is not configured. Set HAPPY_HOME_DB_URL, HAPPY_HOME_DB_USER and HAPPY_HOME_DB_PASSWORD in the Tomcat environment.");
        }
        try {
            Class.forName("oracle.jdbc.OracleDriver");
        } catch (ClassNotFoundException e) {
            throw new SQLException("Oracle JDBC driver was not found in WEB-INF/lib.", e);
        }
        return DriverManager.getConnection(url, user, password);
    }

    private static boolean isBlank(String value) {
        return value == null || value.trim().isEmpty();
    }
}
