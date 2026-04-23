package ca.jrvs.app;

import ca.jrvs.app.dao.QuoteDao;
import ca.jrvs.app.entity.Quote;
import ca.jrvs.app.utils.PropertyLoader;
import ca.jrvs.app.utils.QuoteHttpHelper;
public class Main {
    public static void main(String[] args) {
        //QuoteHttpHelper helper = new QuoteHttpHelper();

         try {
            // Test property loading
            PropertyLoader loader = new PropertyLoader();
            
            // Test reading properties
            System.out.println("Server: " + loader.getServer());
            System.out.println("Database: " + loader.getDatabase());
            System.out.println("JDBC URL: " + loader.getJdbcUrl());
            System.out.println("API Key: " + loader.getApiKey().substring(0, 10) + "...");
            
            System.out.println("\n✓ Properties loaded successfully!");
            
        } catch (Exception e) {
            System.err.println("Error: " + e.getMessage());
            e.printStackTrace();
        }
        
        /*try {
            String[] symbols = {"MSFT", "AMD", "GOOG", "AAPL"};

            QuoteDao quoteDao = new QuoteDao();
            for (String symbo : symbols) {
                try {
                    Quote json = helper.fetchQouteInfo(symbo);
                    quoteDao.save(json);
                    
                    // Wait 2 seconds between requests
                    Thread.sleep(2000);
                    
                } catch (InterruptedException e) {
                    e.printStackTrace();
                }
            }
            Quote quote = helper.fetchQouteInfo("INTC");
            System.out.println(quote);
            quoteDao.save(quote);
            quoteDao.findById("MSFT").ifPresent(System.out::println);
            quoteDao.findAll().forEach(System.out::println);
            quoteDao.deleteById("INTC");
            quoteDao.findAll().forEach(System.out::println);
            //quoteDao.deleteAll();
            //quoteDao.findAll().forEach(System.out::println);
        } catch (IllegalArgumentException e) {
            e.printStackTrace();
        }*/
    }
}