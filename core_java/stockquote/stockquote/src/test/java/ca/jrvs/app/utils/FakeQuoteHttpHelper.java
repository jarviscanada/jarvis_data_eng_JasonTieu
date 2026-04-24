package ca.jrvs.app.utils;

import ca.jrvs.app.entity.Quote;

public class FakeQuoteHttpHelper extends QuoteHttpHelper {

    public FakeQuoteHttpHelper(PropertyLoader loader) {
        super(null, loader);
    }

    @Override
    public Quote fetchQuoteInfo(String symbol) {

        Quote q = new Quote();
        q.setSymbol(symbol);
        q.setPrice(100);
        q.setOpen(100);
        q.setHigh(100);
        q.setLow(100);
        q.setVolume(100);
        q.setPreviousClose(100);
        q.setChange(0);
        q.setChangePercent("0%");
        q.setLatestTradingDay(new java.util.Date());

        return q;
    }
}