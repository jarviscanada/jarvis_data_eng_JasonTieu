package ca.jrvs.app.utils;

import org.junit.*;
import static org.junit.Assert.*;

public class PropertyLoaderTest {

    private PropertyLoader loader;

    @Before
    public void setUp() {
        loader = new PropertyLoader();
    }

    @Test
    public void getServer_shouldReturnCorrectValue() {
        assertEquals("localhost", loader.getServer());
    }

    @Test
    public void getPort_shouldReturnCorrectValue() {
        assertEquals("5432", loader.getPort());
    }

    @Test
    public void getDatabase_shouldReturnCorrectValue() {
        assertEquals("testdb", loader.getDatabase());
    }

    @Test
    public void getApiKey_shouldReturnCorrectValue() {
        assertEquals("12345", loader.getApiKey());
    }

    @Test
    public void getJdbcUrl_shouldFormatCorrectly() {
        String expected = "jdbc:postgresql://localhost:5432/testdb";
        assertEquals(expected, loader.getJdbcUrl());
    }

    @Test
    public void getProperty_shouldReturnGenericValue() {
        assertEquals("postgres", loader.getProperty("username"));
    }
}