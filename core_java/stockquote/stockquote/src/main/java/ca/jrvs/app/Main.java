package ca.jrvs.app;

import ca.jrvs.app.dao.QuoteDao;
import ca.jrvs.app.entity.Quote;
import ca.jrvs.app.utils.QuoteHttpHelper;
public class Main {
    public static void main(String[] args) {
        String symbol = "INTC"; // Example symbol
        String apiKey = "15577394camsheb78e31391269cfp18320cjsn6b88ab5739f9";

        // Testing API key and endpoint by making a direct HTTP request
        /***HttpRequest request = HttpRequest.newBuilder()
                .uri(URI.create("https://alpha-vantage.p.rapidapi.com/query?function=GLOBAL_QUOTE&symbol=" + symbol + "&datatype=json"))
                .header("X-RapidAPI-Key", apiKey)
                .header("X-RapidAPI-Host", "alpha-vantage.p.rapidapi.com")
                .method("GET", HttpRequest.BodyPublishers.noBody())
                .build();

        try {
            HttpResponse<String> response = HttpClient.newHttpClient().send(request, HttpResponse.BodyHandlers.ofString());
            System.out.println(response.body());
        } catch (InterruptedException e) {
            e.printStackTrace();
        } catch (JsonMappingException e) {
            e.printStackTrace();
        } catch (JsonProcessingException e) {
            e.printStackTrace();
        } catch (IOException e) {
            e.printStackTrace();
        } ***/

        QuoteHttpHelper helper = new QuoteHttpHelper(apiKey);
        try {
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
            Quote quote = helper.fetchQouteInfo(symbol);
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
        }
    }
}