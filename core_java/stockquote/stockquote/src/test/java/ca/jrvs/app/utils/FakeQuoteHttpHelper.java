package ca.jrvs.app.utils;

import ca.jrvs.app.entity.Quote;

public class FakeQuoteHttpHelper extends QuoteHttpHelper {

    public FakeQuoteHttpHelper(PropertyLoader loader) {
        super(loader); // ✅ ONLY valid constructor
    }

    @Override
    public Quote fetchQouteInfo(String symbol) {
        Quote q = new Quote();
        q.setSymbol(symbol);
        q.setPrice(100);
        q.setOpen(95);
        q.setHigh(110);
        q.setLow(90);
        q.setVolume(1000);
        return q;
    }
}