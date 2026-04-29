package ca.jrvs.app.entity;

import org.junit.*;
import static org.junit.Assert.*;

import java.text.SimpleDateFormat;
import java.util.Date;

public class QuoteTest {

    private Quote quote;

    @Before
    public void setUp() {
        quote = new Quote();
    }

    private String getValidJson() {
        return "{\n" +
                "  \"Global Quote\": {\n" +
                "    \"01. symbol\": \"AAPL\",\n" +
                "    \"02. open\": \"150.00\",\n" +
                "    \"03. high\": \"155.00\",\n" +
                "    \"04. low\": \"149.00\",\n" +
                "    \"05. price\": \"154.00\",\n" +
                "    \"06. volume\": \"1000000\",\n" +
                "    \"07. latest trading day\": \"2024-01-01\",\n" +
                "    \"08. previous close\": \"148.00\",\n" +
                "    \"09. change\": \"6.00\",\n" +
                "    \"10. change percent\": \"4%\"\n" +
                "  }\n" +
                "}";
    }

    @Test
    public void parseQuoteFromJson_shouldParseCorrectly() throws Exception {
        quote.parseQuoteFromJson(getValidJson());

        assertEquals("AAPL", quote.getSymbol());
        assertEquals(150.00, quote.getOpen(), 0.001);
        assertEquals(155.00, quote.getHigh(), 0.001);
        assertEquals(149.00, quote.getLow(), 0.001);
        assertEquals(154.00, quote.getPrice(), 0.001);
        assertEquals(1000000, quote.getVolume());
        assertEquals(148.00, quote.getPreviousClose(), 0.001);
        assertEquals(6.00, quote.getChange(), 0.001);
        assertEquals("4%", quote.getChangePercent());

        // Check date
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
        Date expectedDate = sdf.parse("2024-01-01");
        assertEquals(expectedDate, quote.getLatestTradingDay());

        // Timestamp should not be null
        assertNotNull(quote.getTimestamp());
    }

    @Test(expected = RuntimeException.class)
    public void parseQuoteFromJson_shouldThrowException_onInvalidJson() {
        String invalidJson = "{ invalid json }";
        quote.parseQuoteFromJson(invalidJson);
    }

    @Test
    public void parseQuoteFromJson_shouldHandleMissingGlobalQuote() {
        String json = "{ \"SomeOtherKey\": {} }";

        quote.parseQuoteFromJson(json);

        // Nothing should be set
        assertNull(quote.getSymbol());
        assertEquals(0.0, quote.getOpen(), 0.001);
    }

    @Test(expected = RuntimeException.class)
    public void parseQuoteFromJson_shouldThrowException_whenFieldMissing() {
        String json = "{\n" +
                "  \"Global Quote\": {\n" +
                "    \"01. symbol\": \"AAPL\"\n" + // missing other fields
                "  }\n" +
                "}";

        quote.parseQuoteFromJson(json);
    }

    @Test
    public void parseQuoteFromJson_shouldSetTimestampCloseToNow() {
        long before = System.currentTimeMillis();

        quote.parseQuoteFromJson(getValidJson());

        long after = System.currentTimeMillis();

        assertTrue(quote.getTimestamp().getTime() >= before);
        assertTrue(quote.getTimestamp().getTime() <= after);
    }
}