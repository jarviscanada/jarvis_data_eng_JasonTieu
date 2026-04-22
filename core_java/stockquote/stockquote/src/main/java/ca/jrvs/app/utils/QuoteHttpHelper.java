package ca.jrvs.app.utils;

import ca.jrvs.app.entity.Quote;
import okhttp3.OkHttpClient;
import okhttp3.Request;

import java.io.IOException;

public class QuoteHttpHelper {
    private String apiKey;
    private OkHttpClient client;
    
    public QuoteHttpHelper(String apiKey) {
        this.apiKey = apiKey;
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
                throw new IllegalArgumentException("Unexpected code " + response);
            }
            String responseBody = response.body().string();
            Quote quote = new Quote();
            quote.parseQuoteFromJson(responseBody);
            return quote;
        } catch (IOException e) {
            e.printStackTrace();
        }
        return null;
    }
}
