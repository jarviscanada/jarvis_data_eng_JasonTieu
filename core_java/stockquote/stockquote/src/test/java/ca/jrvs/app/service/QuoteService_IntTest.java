package ca.jrvs.app.service;

import ca.jrvs.app.dao.QuoteDao;
import ca.jrvs.app.entity.Quote;
import ca.jrvs.app.utils.FakeQuoteHttpHelper;
import ca.jrvs.app.utils.PropertyLoader;
import ca.jrvs.app.utils.QuoteHttpHelper;

import org.junit.*;

import java.sql.Connection;
import java.sql.DriverManager;
import java.util.Optional;

import static org.junit.Assert.*;

public class QuoteService_IntTest {

    private QuoteService service;
    private QuoteDao dao;
    private Connection connection;

    @Before
    public void setUp() throws Exception {

        // REAL DB connection (integration test)
        connection = DriverManager.getConnection(
                "jdbc:postgresql://localhost:5432/testdb",
                "postgres",
                "password"
        );

        dao = new QuoteDao(connection);

        // FAKE HTTP helper (no API call)
       QuoteHttpHelper fakeHttp =
        new FakeQuoteHttpHelper(new PropertyLoader() {
            @Override
            public String getProperty(String key) {
                return "fake";
            }
        });

        service = new QuoteService(dao, fakeHttp);
    }

    @After
    public void tearDown() throws Exception {
        connection.close();
    }

    @Test
    public void fetchQuoteDataFromAPI_shouldPersistAndReturn() {

        Optional<Quote> result = service.fetchQuoteDataFromAPI("AAPL");

        assertTrue(result.isPresent());
        assertEquals("AAPL", result.get().getSymbol());
        assertEquals(100, result.get().getPrice(), 0.001);

        // verify DB persistence
        Quote dbQuote = service.findQuoteByTicker("AAPL");
        assertNotNull(dbQuote);
    }
}