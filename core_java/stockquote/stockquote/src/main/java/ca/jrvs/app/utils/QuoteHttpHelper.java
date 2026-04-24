package ca.jrvs.app.utils;

import ca.jrvs.app.entity.Quote;
import okhttp3.OkHttpClient;
import okhttp3.Request;

import java.io.IOException;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class QuoteHttpHelper {
    private String apiKey;
    private OkHttpClient client;
    private static final Logger log = LoggerFactory.getLogger(QuoteHttpHelper.class);
    
    public QuoteHttpHelper(PropertyLoader propertyLoader) {
        this.apiKey = propertyLoader.getProperty("api-key");
        this.client = new OkHttpClient();
    }

    public Quote fetchQouteInfo (String symbol) throws IllegalArgumentException {
        Request request = new Request.Builder()
                .url("https://alpha-vantage.p.rapidapi.com/query?function=GLOBAL_QUOTE&symbol=" + symbol + "&datatype=json")
                .addHeader("X-RapidAPI-Key", apiKey)
                .addHeader("X-RapidAPI-Host", "alpha-vantage.p.rapidapi.com")
                .build();

        try (okhttp3.Response response = client.newCall(request).execute()) {
            if (!response.isSuccessful()) {
                log.error("Unexpected code " + response);
                throw new IllegalArgumentException("Unexpected code " + response);
            }
            String responseBody = response.body().string();
            Quote quote = new Quote();
            quote.parseQuoteFromJson(responseBody);
            log.info("Fetched quote info for symbol " + symbol + ": " + quote);
            return quote;
        } catch (IOException e) {
            log.error("Error fetching quote info for symbol " + symbol, e);
        }
        return null;
    }
}
