package ca.jrvs.app.service;

import java.util.Optional;

import ca.jrvs.app.dao.QuoteDao;
import ca.jrvs.app.entity.Quote;
import ca.jrvs.app.utils.QuoteHttpHelper;

public class QuoteService {
    private QuoteDao quoteDao;
    private QuoteHttpHelper quoteHttpHelper;

    public Optional<Quote> fetchQuoteDataFromAPI(String ticker) {
        try {
            Quote quote = quoteHttpHelper.fetchQuoteInfo(ticker);
            quoteDao.save(quote);
            return Optional.of(quote);
        } catch (Exception e) {
            // Log the exception and return an empty Optional
            org.slf4j.LoggerFactory.getLogger(QuoteService.class).warn(String.format("Exception in fetchQuoteDataFromAPI, message: %s", e.getMessage()));
            return Optional.empty();
        }
    }

    public Quote findQuoteByTicker(String ticker) {
        return quoteDao.findById(ticker).orElse(null);
    }

    public QuoteService(QuoteDao quoteDao, QuoteHttpHelper quoteHttpHelper) {
        this.quoteDao = quoteDao;
        this.quoteHttpHelper = quoteHttpHelper;
    }

}
