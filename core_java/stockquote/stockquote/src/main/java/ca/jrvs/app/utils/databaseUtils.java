package ca.jrvs.app.utils;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class databaseUtils {
    private static final String URL = "jdbc:postgresql://localhost:5432/stock_quote";
    private static final String USERNAME = "postgres";
    private static final String PASSWORD = "password";
    private static final Logger LOGGER = LoggerFactory.getLogger(databaseUtils.class);
    public static final String exceptionFormat = "exception in %s, message: %s, code: %s";
    private static Connection connection;

    public static Connection getConnection(){
        if(connection == null){
            synchronized(databaseUtils.class){
                if(connection == null){
                    try{
                        connection = DriverManager.getConnection(URL, USERNAME, PASSWORD);
                        LOGGER.info("Database connection established successfully");
                    }catch(SQLException e){
                        handleSqlException("databaseUtils.getConnection", e, LOGGER);
                    }
                }
            }
        }
        return connection;
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
                    System.out.println("Connected to database: " + rs.getString(1));
                }
                
                rs = stmt.executeQuery("SELECT COUNT(*) FROM public.\"quote\"");
                if (rs.next()) {
                    System.out.println("Total quotes in table: " + rs.getInt(1));
                }
            } catch (SQLException e) {
                e.printStackTrace();
            }
    }
}
