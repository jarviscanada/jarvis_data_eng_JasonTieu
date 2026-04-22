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
            Quote quote = quoteHttpHelper.fetchQouteInfo(ticker);
            quoteDao.save(quote);
            return Optional.ofNullable(quote);
        } catch (Exception e) {
            // Log the exception and return an empty Optional
            org.slf4j.LoggerFactory.getLogger(QuoteService.class).warn(String.format("Exception in fetchQuoteDataFromAPI, message: %s", e.getMessage()));
            return Optional.empty();
        }
    }

    public QuoteService(QuoteDao quoteDao, QuoteHttpHelper quoteHttpHelper) {
        this.quoteDao = quoteDao;
        this.quoteHttpHelper = quoteHttpHelper;
    }

}
