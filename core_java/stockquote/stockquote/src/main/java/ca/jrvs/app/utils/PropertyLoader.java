package ca.jrvs.app.utils;

import java.util.MissingResourceException;
import java.util.ResourceBundle;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class PropertyLoader {
    private ResourceBundle bundle;
    private static final Logger logger = LoggerFactory.getLogger(PropertyLoader.class);

    public PropertyLoader() {
        // This looks for properties.txt in src/main/resources
        // Don't include the .txt extension
        // ResourceBundle looks for properties.properties or properties.txt
        // in src/main/resources/
        try {
            this.bundle = ResourceBundle.getBundle("properties");
            logger.info("Loaded properties file using ResourceBundle");
            
            // Debug: Print loaded properties
            logger.info("  - database: " + getDatabase());
            logger.info("  - server: " + getServer());
            logger.info("  - user: " + getUsername());
            
        } catch (MissingResourceException e) {
            logger.error("properties file not found.\n" +
                "Make sure 'properties.properties' or 'properties.txt' exists in:\n" +
                "src/main/resources/\n" +
                "Current working directory: " + System.getProperty("user.dir"), e);
            throw new RuntimeException(e);
        }
    }

    public String getProperty(String key) {
        return bundle.getString(key);
    }
    
    public String getDbClass() {
        return bundle.getString("db-class");
    }
    
    public String getServer() {
        return bundle.getString("server");
    }
    
    public String getDatabase() {
        return bundle.getString("database");
    }
    
    public String getPort() {
        return bundle.getString("port");
    }
    
    public String getUsername() {
        return bundle.getString("username");
    }
    
    public String getPassword() {
        return bundle.getString("password");
    }
    
    public String getApiKey() {
        return bundle.getString("api-key");
    }
    
    public String getJdbcUrl() {
        return String.format("jdbc:postgresql://%s:%s/%s", 
            getServer(), getPort(), getDatabase());
    }
    
}
