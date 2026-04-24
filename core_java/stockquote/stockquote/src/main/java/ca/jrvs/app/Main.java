package ca.jrvs.app;

import ca.jrvs.app.dao.PositionDao;
import ca.jrvs.app.dao.QuoteDao;
import ca.jrvs.app.service.PositionService;
import ca.jrvs.app.service.QuoteService;
import ca.jrvs.app.utils.DatabaseUtils;
import ca.jrvs.app.utils.PropertyLoader;
import ca.jrvs.app.utils.QuoteHttpHelper;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class Main {
    private static final Logger log = LoggerFactory.getLogger(Main.class);

    public static void main(String[] args) {
        PropertyLoader loader = new PropertyLoader();
        QuoteHttpHelper helper = new QuoteHttpHelper(loader);
        DatabaseUtils dbUtils = new DatabaseUtils(loader);

        try {
            QuoteDao quoteDao = new QuoteDao(dbUtils.getConnection());
            PositionDao positionDao = new PositionDao(dbUtils.getConnection());
            log.info("DAO instances created successfully");

            QuoteService quoteService = new QuoteService(quoteDao, helper);
            PositionService positionService = new PositionService(positionDao);
            log.info("Service instances created successfully");

            StockQuoteController controller = new StockQuoteController(quoteService, positionService);
            log.info("Controller instance created successfully");
            controller.initClient();

        } catch (Exception e) {
            log.error("Error: " + e.getMessage(), e);
        }
    }
}