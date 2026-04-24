package ca.jrvs.app.dao;
import ca.jrvs.app.entity.Position;
import ca.jrvs.app.entity.Quote;

import org.junit.*;
import java.sql.*;
import java.util.Optional;

import static org.junit.Assert.*;

public class PositionDaoTest {

    private static Connection connection;
    private PositionDao pDao;
    private QuoteDao qDao;


    @BeforeClass
    public static void init() throws Exception {
        connection = DriverManager.getConnection(
            "jdbc:postgresql://localhost:5432/testdb", "postgres", "password"
        );


    }

    @Before
    public void setUp() throws Exception {
        pDao = new PositionDao(connection);
        qDao = new QuoteDao(connection);
        Quote q = buildQuote("APPL");

        qDao.save(q);

        Statement stmt = connection.createStatement();
        stmt.execute("DELETE FROM position");
        
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

    private Position buildPosition(String ticker, int shares, double value) {
        Position p = new Position();
        p.setTicker(ticker);
        p.setNumOfShares(shares);
        p.setValuePaid(value);
        return p;
    }

    @Test
    public void save_shouldInsertPosition() {
        Position p = buildPosition("APPL", 10, 1000);

        Position saved = pDao.save(p);

        assertNotNull(saved);
        assertEquals("APPL", saved.getTicker());
    }

    @Test
    public void addShares_shouldIncreaseShares() {
        pDao.save(buildPosition("APPL", 10, 1000));

        pDao.addShares(buildPosition("APPL", 5, 500));

        Optional<Position> result = pDao.findById("APPL");

        assertEquals(15, result.get().getNumOfShares());
        assertEquals(1500, result.get().getValuePaid(), 0.001);
    }

    @Test
    public void removeShares_shouldDecreaseShares() {
        pDao.save(buildPosition("APPL", 10, 1000));

        pDao.removeShares("APPL", 5);

        Optional<Position> result = pDao.findById("APPL");

        assertEquals(5, result.get().getNumOfShares());
    }

    @Test(expected = IllegalArgumentException.class)
    public void removeShares_shouldThrow_whenRemovingTooMuch() {
        pDao.save(buildPosition("APPL", 10, 1000));

        pDao.removeShares("APPL", 20);
    }

    @Test
    public void deleteById_shouldRemovePosition() {
        pDao.save(buildPosition("APPL", 10, 1000));

        pDao.deleteById("APPL");

        Optional<Position> result = pDao.findById("APPL");

        assertFalse(result.isPresent());
    }

}