package ca.jrvs.app.service;

import ca.jrvs.app.dao.QuoteDao;
import ca.jrvs.app.entity.Quote;
import ca.jrvs.app.utils.QuoteHttpHelper;

import org.junit.*;
import org.mockito.*;

import java.util.Optional;

import static org.junit.Assert.*;
import static org.mockito.Mockito.*;

public class QuoteService_UnitTest {

    @Mock
    private QuoteDao quoteDao;

    @Mock
    private QuoteHttpHelper httpHelper;

    private QuoteService service;

    @Before
    public void setUp() {
        MockitoAnnotations.initMocks(this);
        service = new QuoteService(quoteDao, httpHelper);
    }

    @Test
    public void fetchQuoteDataFromAPI_success() {
        Quote quote = new Quote();
        quote.setSymbol("AAPL");

        when(httpHelper.fetchQuoteInfo("AAPL")).thenReturn(quote);
        when(quoteDao.save(quote)).thenReturn(quote);

        Optional<Quote> result = service.fetchQuoteDataFromAPI("AAPL");

        assertTrue(result.isPresent());
        assertEquals("AAPL", result.get().getSymbol());

        verify(httpHelper, times(1)).fetchQuoteInfo("AAPL");
        verify(quoteDao, times(1)).save(quote);
    }

    @Test
    public void fetchQuoteDataFromAPI_shouldReturnEmpty_onException() {
        when(httpHelper.fetchQuoteInfo("AAPL"))
                .thenThrow(new RuntimeException("API error"));

        Optional<Quote> result = service.fetchQuoteDataFromAPI("AAPL");

        assertFalse(result.isPresent());
    }
}