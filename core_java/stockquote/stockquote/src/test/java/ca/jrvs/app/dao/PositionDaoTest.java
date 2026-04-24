package ca.jrvs.app.dao;
import ca.jrvs.app.dao.PositionDao;
import ca.jrvs.app.entity.Position;

import org.junit.*;
import java.sql.*;
import java.util.Optional;

import static org.junit.Assert.*;

public class PositionDaoTest {

    private static Connection connection;
    private PositionDao dao;

    @BeforeClass
    public static void init() throws Exception {
        connection = DriverManager.getConnection(
            "jdbc:postgresql://localhost:5432/testdb", "postgres", "password"
        );
    }

    @Before
    public void setUp() throws Exception {
        dao = new PositionDao(connection);

        Statement stmt = connection.createStatement();
        stmt.execute("DELETE FROM position");
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
        Position p = buildPosition("AAPL", 10, 1000);

        Position saved = dao.save(p);

        assertNotNull(saved);
        assertEquals("AAPL", saved.getTicker());
    }

    @Test
    public void addShares_shouldIncreaseShares() {
        dao.save(buildPosition("AAPL", 10, 1000));

        dao.addShares(buildPosition("AAPL", 5, 500));

        Optional<Position> result = dao.findById("AAPL");

        assertEquals(15, result.get().getNumOfShares());
        assertEquals(1500, result.get().getValuePaid(), 0.001);
    }

    @Test
    public void removeShares_shouldDecreaseShares() {
        dao.save(buildPosition("AAPL", 10, 1000));

        dao.removeShares("AAPL", 5);

        Optional<Position> result = dao.findById("AAPL");

        assertEquals(5, result.get().getNumOfShares());
    }

    @Test(expected = IllegalArgumentException.class)
    public void removeShares_shouldThrow_whenRemovingTooMuch() {
        dao.save(buildPosition("AAPL", 10, 1000));

        dao.removeShares("AAPL", 20);
    }

    @Test
    public void deleteById_shouldRemovePosition() {
        dao.save(buildPosition("AAPL", 10, 1000));

        dao.deleteById("AAPL");

        Optional<Position> result = dao.findById("AAPL");

        assertFalse(result.isPresent());
    }
}