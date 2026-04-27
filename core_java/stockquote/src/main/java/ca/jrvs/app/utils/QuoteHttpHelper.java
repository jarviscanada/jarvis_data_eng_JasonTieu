package ca.jrvs.app.utils;

import ca.jrvs.app.entity.Quote;
import okhttp3.OkHttpClient;
import okhttp3.Request;

import java.io.IOException;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class QuoteHttpHelper {
    private final PropertyLoader loader;
    private OkHttpClient client;
    private static final Logger log = LoggerFactory.getLogger(QuoteHttpHelper.class);
    
    public QuoteHttpHelper(OkHttpClient client, PropertyLoader loader) {
        this.client = client;
        this.loader = loader;
    }

    public Quote fetchQuoteInfo (String symbol) throws IllegalArgumentException {
        Request request = new Request.Builder()
                .url("https://alpha-vantage.p.rapidapi.com/query?function=GLOBAL_QUOTE&symbol=" + symbol + "&datatype=json")
                .addHeader("X-RapidAPI-Key", loader.getProperty("api-key"))
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

    public Quote fetchQouteInfo(String symbol) {
        // TODO Auto-generated method stub
        throw new UnsupportedOperationException("Unimplemented method 'fetchQouteInfo'");
    }
}
