package ca.jrvs.app.service;

import ca.jrvs.app.dao.PositionDao;
import ca.jrvs.app.entity.Position;

import org.junit.*;
import org.mockito.*;

import java.util.Optional;

import static org.junit.Assert.*;
import static org.mockito.Mockito.*;

public class PositionService_UnitTest {

    @Mock
    private PositionDao positionDao;

    private PositionService service;

    @Before
    public void setUp() {
        MockitoAnnotations.initMocks(this);
        service = new PositionService(positionDao);
    }

    @Test
    public void findByTicker_success() {
        Position pos = new Position();
        pos.setTicker("TSLA");

        when(positionDao.findById("TSLA")).thenReturn(Optional.of(pos));

        Optional<Position> result = service.findByTicker("TSLA");

        assertNotNull(result);
        assertEquals("TSLA", result.get().getTicker());
    }

    @Test
    public void findByTicker_notFound() {
        when(positionDao.findById("TSLA")).thenReturn(Optional.empty());

        Optional<Position> result = service.findByTicker("TSLA");

        assertFalse(result.isPresent());
    }
}