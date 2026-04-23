package ca.jrvs.app;

import ca.jrvs.app.dao.PositionDao;
import ca.jrvs.app.dao.QuoteDao;
import ca.jrvs.app.service.PositionService;
import ca.jrvs.app.service.QuoteService;
import ca.jrvs.app.utils.DatabaseUtils;
import ca.jrvs.app.utils.PropertyLoader;
import ca.jrvs.app.utils.QuoteHttpHelper;

public class Main {
    public static void main(String[] args) {
        PropertyLoader loader = new PropertyLoader();
        QuoteHttpHelper helper = new QuoteHttpHelper(loader);
        DatabaseUtils dbUtils = new DatabaseUtils(loader);

        try {
            QuoteDao quoteDao = new QuoteDao(dbUtils.getConnection());
            PositionDao positionDao = new PositionDao(dbUtils.getConnection());

            QuoteService quoteService = new QuoteService(quoteDao, helper);
            PositionService positionService = new PositionService(positionDao);

            StockQuoteController controller = new StockQuoteController(quoteService, positionService);
            controller.initClient();

        } catch (Exception e) {
            System.err.println("Error: " + e.getMessage());
            e.printStackTrace();
        }
    }
}