package ca.jrvs.app.service;

import ca.jrvs.app.dao.PositionDao;
import ca.jrvs.app.entity.Position;

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