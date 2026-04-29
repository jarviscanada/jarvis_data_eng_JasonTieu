package ca.jrvs.app.utils;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class DatabaseUtils {
    public static final String exceptionFormat = "exception in %s, message: %s, code: %s";
    private static final Logger log = LoggerFactory.getLogger(DatabaseUtils.class);
    private static Connection connection;
    private final String url;
    private final String username;
    private final String password;

    public DatabaseUtils(PropertyLoader propertyLoader) {
        this.url = propertyLoader.getJdbcUrl();
        this.username = propertyLoader.getUsername();
        this.password = propertyLoader.getPassword();
        
        log.info("Database URL: " + url);
    }

    public Connection getConnection() throws SQLException {
        if (connection == null || connection.isClosed()) {
            connection = DriverManager.getConnection(url, username, password);
            log.info("Database connection established");
        }
        return connection;
    }
    
    public void closeConnection() {
        if (connection != null) {
            try {
                connection.close();
                log.info("Database connection closed");
            } catch (SQLException e) {
                log.error("Error closing connection: " + e.getMessage());
            }
        }
    }

    public static void handleSqlException(String method, SQLException e, Logger log){
        log.warn(String.format(exceptionFormat, method, e.getMessage(), e.getErrorCode()));
        throw new RuntimeException(e);
    }

    public static void checkConnections() {
        try {
                Statement stmt = connection.createStatement();
                ResultSet rs = stmt.executeQuery("SELECT current_database()");
                if (rs.next()) {
                    log.info("Connected to database: " + rs.getString(1));
                }
                
                rs = stmt.executeQuery("SELECT COUNT(*) FROM public.\"quote\"");
                if (rs.next()) {
                    log.info("Total quotes in table: " + rs.getInt(1));
                }
            } catch (SQLException e) {
                log.error("Error checking database connection: " + e.getMessage());
            }
    }
}
