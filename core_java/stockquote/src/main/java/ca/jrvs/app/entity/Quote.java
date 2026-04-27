package ca.jrvs.app.entity;

import java.sql.Timestamp;
import java.text.SimpleDateFormat;
import java.util.Date;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;

public class Quote {


    private String symbol;
    private double open;
    private double high;
    private double low;
    private double price;
    private int volume;
    private Date latestTradingDay;
    private double previousClose;
    private double change;  
    private String changePercent;
    private Timestamp timestamp;
    
    public void parseQuoteFromJson(String json) {
        try {
                ObjectMapper mapper = new ObjectMapper();
                JsonNode root = mapper.readTree(json);
                JsonNode globalQuote = root.get("Global Quote");
                
                if (globalQuote != null) {
                    SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
                    
                    this.setSymbol(globalQuote.get("01. symbol").asText());
                    this.setOpen(Double.parseDouble(globalQuote.get("02. open").asText()));
                    this.setHigh(Double.parseDouble(globalQuote.get("03. high").asText()));
                    this.setLow(Double.parseDouble(globalQuote.get("04. low").asText()));
                    this.setPrice(Double.parseDouble(globalQuote.get("05. price").asText()));
                    this.setVolume(Integer.parseInt(globalQuote.get("06. volume").asText()));
                    
                    // Parse date string to Date object
                    String dateStr = globalQuote.get("07. latest trading day").asText();
                    Date latestTradingDay = dateFormat.parse(dateStr);
                    this.setLatestTradingDay(latestTradingDay);
                    
                    this.setPreviousClose(Double.parseDouble(globalQuote.get("08. previous close").asText()));
                    this.setChange(Double.parseDouble(globalQuote.get("09. change").asText()));
                    this.setChangePercent(globalQuote.get("10. change percent").asText());
                    
                    // Set current timestamp
                    this.setTimestamp(new Timestamp(System.currentTimeMillis()));
                }
            } catch (Exception e) {
                throw new RuntimeException("Failed to parse JSON response", e);
            }
    }

    public String getSymbol() {
        return symbol;
    }

    public void setSymbol(String symbol) {
        this.symbol = symbol;
    }

    public double getOpen() {
        return open;
    }

    public void setOpen(double open) {
        this.open = open;
    }

    public double getHigh() {
        return high;
    }

    public void setHigh(double high) {
        this.high = high;
    }

    public double getLow() {
        return low;
    }

    public void setLow(double low) {
        this.low = low;
    }

    public double getPrice() {
        return price;
    }

    public void setPrice(double price) {
        this.price = price;
    }

    public int getVolume() {
        return volume;
    }

    public void setVolume(int volume) {
        this.volume = volume;
    }

    public Date getLatestTradingDay() {
        return latestTradingDay;
    }

    public void setLatestTradingDay(Date latestTradingDay) {
        this.latestTradingDay = latestTradingDay;
    }

    public double getPreviousClose() {
        return previousClose;
    }

    public void setPreviousClose(double previousClose) {
        this.previousClose = previousClose;
    }

    public double getChange() {
        return change;
    }

    public void setChange(double change) {
        this.change = change;
    }

    public String getChangePercent() {
        return changePercent;
    }

    public void setChangePercent(String changePercent) {
        this.changePercent = changePercent;
    }

    public Timestamp getTimestamp() {
        return timestamp;
    }

    public void setTimestamp(Timestamp timestamp) {
        this.timestamp = timestamp;
    }

    @Override
    public String toString() {
        return "Quote [symbol=" + symbol + ", open=" + open + ", high=" + high + ", low=" + low + ", price=" + price
                + ", volume=" + volume + ", latestTradingDay=" + latestTradingDay + ", previousClose="
                + previousClose + ", change=" + change + ", changePercent=" + changePercent + ", timestamp="
                + timestamp + "]";
    }
    
}
