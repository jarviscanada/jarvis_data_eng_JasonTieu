package ca.jrvs.app.utils;

import ca.jrvs.app.entity.Quote;
import okhttp3.*;
import org.junit.*;
import static org.junit.Assert.*;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.*;

import java.io.IOException;

public class QuoteHttpHelper_UnitTest {

    private OkHttpClient mockClient;
    private Call mockCall;
    private PropertyLoader mockLoader;
    private QuoteHttpHelper helper;

    @Before
    public void setUp() {
        mockClient = mock(OkHttpClient.class);
        mockCall = mock(Call.class);
        mockLoader = mock(PropertyLoader.class);

        when(mockLoader.getProperty("api-key")).thenReturn("fake-key");

        helper = new QuoteHttpHelper(mockClient, mockLoader);
    }

    private String fakeJson() {
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
    public void fetchQuoteInfo_shouldReturnQuote_success() throws Exception {

        Response response = new Response.Builder()
                .request(new Request.Builder().url("http://HTTP.dev").build())
                .protocol(Protocol.HTTP_1_1)
                .code(200)
                .message("OK")
                .body(ResponseBody.create(
                        fakeJson(),
                        MediaType.parse("application/json")
                ))
                .build();

        when(mockClient.newCall(any(Request.class))).thenReturn(mockCall);
        when(mockCall.execute()).thenReturn(response);

        Quote result = helper.fetchQuoteInfo("AAPL");

        assertNotNull(result);
        assertEquals("AAPL", result.getSymbol());
        assertEquals(154.00, result.getPrice(), 0.001);
    }

    @Test
    public void fetchQuoteInfo_shouldReturnNull_onIOException() throws Exception {

        when(mockClient.newCall(any(Request.class))).thenReturn(mockCall);
        when(mockCall.execute()).thenThrow(new IOException("network error"));

        Quote result = helper.fetchQuoteInfo("AAPL");

        assertNull(result);
    }

    @Test(expected = IllegalArgumentException.class)
    public void fetchQuoteInfo_shouldThrow_onBadResponse() throws Exception {

        Response response = new Response.Builder()
                .request(new Request.Builder().url("http://test.com").build())
                .protocol(Protocol.HTTP_1_1)
                .code(500)
                .message("error")
                .body(ResponseBody.create("error", null))
                .build();

        when(mockClient.newCall(any(Request.class))).thenReturn(mockCall);
        when(mockCall.execute()).thenReturn(response);

        helper.fetchQuoteInfo("AAPL");
    }
}