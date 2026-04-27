package ca.jrvs.app.dao;
import ca.jrvs.app.entity.Quote;

import org.junit.*;
import java.sql.*;
import java.util.Optional;

import static org.junit.Assert.*;

public class QuoteDaoTest {

    private static Connection connection;
    private QuoteDao dao;

    @BeforeClass
    public static void init() throws Exception {
        connection = DriverManager.getConnection(
            "jdbc:postgresql://localhost:5432/testdb", "postgres", "password"
        );
    }

    @Before
    public void setUp() throws Exception {
        dao = new QuoteDao(connection);

        // Clean table before each test
        Statement stmt = connection.createStatement();
        stmt.execute("DELETE FROM position");
        stmt.execute("DELETE FROM quote");
    }

    private Quote buildQuote(String symbol) {
        Quote q = new Quote();
        q.setSymbol(symbol);
        q.setOpen(10);
        q.setHigh(20);
        q.setLow(5);
        q.setPrice(15);
        q.setVolume(1000);
        q.setLatestTradingDay(new java.util.Date());
        q.setPreviousClose(14);
        q.setChange(1);
        q.setChangePercent("5%");
        return q;
    }

    @Test
    public void save_shouldInsertQuote() {
        Quote q = buildQuote("APPL");

        Quote saved = dao.save(q);

        assertNotNull(saved);
        assertEquals("APPL", saved.getSymbol());
    }

    @Test
    public void findById_shouldReturnQuote() {
        Quote q = buildQuote("TSLA");
        dao.save(q);

        Optional<Quote> result = dao.findById("TSLA");

        assertTrue(result.isPresent());
        assertEquals("TSLA", result.get().getSymbol());
    }

    @Test
    public void findAll_shouldReturnMultipleQuotes() {
        dao.save(buildQuote("AAPL"));
        dao.save(buildQuote("TSLA"));

        Iterable<Quote> quotes = dao.findAll();

        int count = 0;
        for (Quote q : quotes) count++;

        assertEquals(2, count);
    }

    @Test
    public void deleteById_shouldRemoveQuote() {
        dao.save(buildQuote("AAPL"));

        dao.deleteById("AAPL");

        Optional<Quote> result = dao.findById("AAPL");
        assertFalse(result.isPresent());
    }

    @Test
    public void update_shouldModifyExistingQuote() {
        Quote q = buildQuote("AAPL");
        dao.save(q);

        q.setPrice(999);
        dao.save(q); // triggers update

        Optional<Quote> updated = dao.findById("AAPL");

        assertEquals(999, updated.get().getPrice(), 0.001);
    }

}