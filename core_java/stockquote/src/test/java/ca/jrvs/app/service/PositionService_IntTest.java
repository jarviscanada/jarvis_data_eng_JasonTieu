package ca.jrvs.app.service;

import ca.jrvs.app.dao.PositionDao;
import ca.jrvs.app.dao.QuoteDao;
import ca.jrvs.app.entity.Position;
import ca.jrvs.app.entity.Quote;

import org.junit.*;

import java.sql.Connection;
import java.sql.DriverManager;
import java.util.Optional;

import static org.junit.Assert.*;

public class PositionService_IntTest {

    private PositionService service;
    private PositionDao dao;
    private Connection connection;

    @Before
    public void setUp() throws Exception {
        connection = DriverManager.getConnection(
                "jdbc:postgresql://localhost:5432/testdb",
                "postgres",
                "password"
        );

        QuoteDao quoteDao = new QuoteDao(connection);

        Quote q = new Quote();
        q.setSymbol("AAPL");
        q.setPrice(100);
        q.setOpen(100);
        q.setHigh(100);
        q.setLow(100);
        q.setVolume(100);
        q.setPreviousClose(100);
        q.setChange(0);
        q.setChangePercent("0%");
        q.setLatestTradingDay(new java.util.Date());

        quoteDao.save(q);

        dao = new PositionDao(connection);
        service = new PositionService(dao);
    }

    @Test
    public void saveAndFindPosition() {
        Position p = new Position();
        p.setTicker("AAPL");
        p.setNumOfShares(10);
        p.setValuePaid(1000);

        dao.save(p);

        Optional<Position> result = service.findByTicker("AAPL");

        assertNotNull(result);
        assertEquals(10, result.get().getNumOfShares());
    }
}