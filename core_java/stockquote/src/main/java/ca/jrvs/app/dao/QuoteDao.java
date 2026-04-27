package ca.jrvs.app.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

import ca.jrvs.app.entity.Quote;
import ca.jrvs.app.utils.DatabaseUtils;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class QuoteDao implements CrudDao<Quote, String> {
    private final Connection c;
    private static final Logger log = LoggerFactory.getLogger(QuoteDao.class);

    public QuoteDao(Connection c) {
        this.c = c;
    }

    @Override
    public Quote save(Quote entity) throws IllegalArgumentException {
        try{
            if ( this.findById(entity.getSymbol()).isPresent()) {
                update(entity);
                return this.findById(entity.getSymbol()).get();
            }
            c.setAutoCommit(false);
            PreparedStatement stmt = c.prepareStatement("INSERT INTO quote (symbol, open, high, low, price, volume, latest_trading_day, previous_close, change, change_percent) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)");
            stmt.setString(1, entity.getSymbol());
            stmt.setDouble(2, entity.getOpen());
            stmt.setDouble(3, entity.getHigh());
            stmt.setDouble(4, entity.getLow());
            stmt.setDouble(5, entity.getPrice());
            stmt.setLong(6, entity.getVolume());
            java.sql.Date sqlDate = new java.sql.Date(entity.getLatestTradingDay().getTime());
            stmt.setDate(7, sqlDate);
            stmt.setDouble(8, entity.getPreviousClose());
            stmt.setDouble(9, entity.getChange());
            stmt.setString(10, entity.getChangePercent());
            stmt.executeUpdate();
            c.commit();
            log.info("Saved quote for " + entity.getSymbol());
            

        } catch (SQLException e) {
            try{
                c.rollback();
            } catch (SQLException ex) {
                DatabaseUtils.handleSqlException("QuoteDao.save.rollback", ex, org.slf4j.LoggerFactory.getLogger(QuoteDao.class));
            }
        } finally {
            try {
                c.setAutoCommit(true);
            } catch (SQLException e) {
                DatabaseUtils.handleSqlException("QuoteDao.save.setAutoCommit", e, org.slf4j.LoggerFactory.getLogger(QuoteDao.class));
            }
        }

        Optional<Quote> savedQuote = this.findById(entity.getSymbol());
        if(!savedQuote.isPresent()){
            return null;
        }

        
        return savedQuote.get();
    }

    @Override
    public Optional<Quote> findById(String id) throws IllegalArgumentException {
        try(PreparedStatement stmt = c.prepareStatement("SELECT symbol, open, high, low, price, volume, latest_trading_day, previous_close, change, change_percent, timestamp FROM quote WHERE symbol = ?")) {
            stmt.setString(1, id);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                Quote quote = new Quote();
                quote.setSymbol(rs.getString("symbol"));
                quote.setOpen(rs.getDouble("open"));
                quote.setHigh(rs.getDouble("high"));
                quote.setLow(rs.getDouble("low"));
                quote.setPrice(rs.getDouble("price"));
                quote.setVolume(rs.getInt("volume"));
                quote.setLatestTradingDay(rs.getDate("latest_trading_day"));
                quote.setPreviousClose(rs.getDouble("previous_close"));
                quote.setChange(rs.getDouble("change"));
                quote.setChangePercent(rs.getString("change_percent"));
                quote.setTimestamp(rs.getTimestamp("timestamp"));
                return Optional.of(quote);
            } else {
                return Optional.empty();
            }
        } catch (SQLException e) {
            DatabaseUtils.handleSqlException("QuoteDao.findById", e, org.slf4j.LoggerFactory.getLogger(QuoteDao.class));
            return Optional.empty();
        }
    }

    @Override
    public Iterable<Quote> findAll() {
        List<Quote> quotes = new ArrayList<>();
        try (PreparedStatement stmt = c.prepareStatement("SELECT symbol, open, high, low, price, volume, latest_trading_day, previous_close, change, change_percent, timestamp FROM quote")) {
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                Quote quote = new Quote();
                quote.setSymbol(rs.getString("symbol"));
                quote.setOpen(rs.getDouble("open"));
                quote.setHigh(rs.getDouble("high"));
                quote.setLow(rs.getDouble("low"));
                quote.setPrice(rs.getDouble("price"));
                quote.setVolume(rs.getInt("volume"));
                quote.setLatestTradingDay(rs.getDate("latest_trading_day"));
                quote.setPreviousClose(rs.getDouble("previous_close"));
                quote.setChange(rs.getDouble("change"));
                quote.setChangePercent(rs.getString("change_percent"));
                quote.setTimestamp(rs.getTimestamp("timestamp"));
                quotes.add(quote);
            }
        } catch (SQLException e) {
            DatabaseUtils.handleSqlException("QuoteDao.findAll", e, org.slf4j.LoggerFactory.getLogger(QuoteDao.class));
        }
        return quotes;
    }

    @Override
    public void deleteById(String id) throws IllegalArgumentException {
        try(PreparedStatement stmt = c.prepareStatement("DELETE FROM quote WHERE symbol = ?")) {
            c.setAutoCommit(false);
            stmt.setString(1, id);
            stmt.executeUpdate();
            c.commit();
            
        } catch (SQLException e) {
            try{
                c.rollback();
                DatabaseUtils.handleSqlException("QuoteDao.deleteById", e, org.slf4j.LoggerFactory.getLogger(QuoteDao.class));
            } catch (SQLException ex) {
                DatabaseUtils.handleSqlException("QuoteDao.deleteById.rollback", ex, org.slf4j.LoggerFactory.getLogger(QuoteDao.class));
            }
        } finally {
            try {
                c.setAutoCommit(true);
            } catch (SQLException e) {
                DatabaseUtils.handleSqlException("QuoteDao.deleteById.setAutoCommit", e, org.slf4j.LoggerFactory.getLogger(QuoteDao.class));
            }
        }
    }

    @Override
    public void deleteAll() {
        try(PreparedStatement stmt = c.prepareStatement("DELETE FROM quote")) {
            c.setAutoCommit(false);
            stmt.executeUpdate();
            c.commit();
         } catch (SQLException e) {
            try{
                c.rollback();
                DatabaseUtils.handleSqlException("QuoteDao.deleteAll", e, org.slf4j.LoggerFactory.getLogger(QuoteDao.class));
            } catch (SQLException ex) {
                DatabaseUtils.handleSqlException("QuoteDao.deleteAll.rollback", ex, org.slf4j.LoggerFactory.getLogger(QuoteDao.class));
            }
        }finally {
            try {
                c.setAutoCommit(true);
            } catch (SQLException e) {
                DatabaseUtils.handleSqlException("QuoteDao.deleteAll.setAutoCommit", e, org.slf4j.LoggerFactory.getLogger(QuoteDao.class));
            }
        }
    }

    public void update(Quote entity) {
        try(PreparedStatement stmt = c.prepareStatement("UPDATE quote SET open = ?, high = ?, low = ?, price = ?, volume = ?, latest_trading_day = ?, previous_close = ?, change = ?, change_percent = ?, timestamp = now() WHERE symbol = ?")) {
            c.setAutoCommit(false);
            stmt.setDouble(1, entity.getOpen());
            stmt.setDouble(2, entity.getHigh());
            stmt.setDouble(3, entity.getLow());
            stmt.setDouble(4, entity.getPrice());
            stmt.setLong(5, entity.getVolume());
            java.sql.Date sqlDate = new java.sql.Date(entity.getLatestTradingDay().getTime());
            stmt.setDate(6, sqlDate);
            stmt.setDouble(7, entity.getPreviousClose());
            stmt.setDouble(8, entity.getChange());
            stmt.setString(9, entity.getChangePercent());
            stmt.setString(10, entity.getSymbol());
            stmt.executeUpdate();
            c.commit();
        } catch (SQLException e) {
            try{
                c.rollback();
                DatabaseUtils.handleSqlException("QuoteDao.update", e, org.slf4j.LoggerFactory.getLogger(QuoteDao.class));
            } catch (SQLException ex) {
                DatabaseUtils.handleSqlException("QuoteDao.update.rollback", ex, org.slf4j.LoggerFactory.getLogger(QuoteDao.class));
            }
        } finally {
            try {
                c.setAutoCommit(true);
            } catch (SQLException e) {
                DatabaseUtils.handleSqlException("QuoteDao.update.setAutoCommit", e, org.slf4j.LoggerFactory.getLogger(QuoteDao.class));
            }
        }
    }
}
