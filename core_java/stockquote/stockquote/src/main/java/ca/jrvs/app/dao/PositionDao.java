package ca.jrvs.app.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

import ca.jrvs.app.entity.Position;
import ca.jrvs.app.utils.DatabaseUtils;

public class PositionDao implements CrudDao<Position, String> {
    private final Connection c;

    public PositionDao(Connection c) {
        this.c = c;
    }

    @Override
    public Position save(Position entity) throws IllegalArgumentException {
        try{
            if ( this.findById(entity.getTicker()).isPresent()) {
                update(entity);
                return this.findById(entity.getTicker()).get();
            }
            c.setAutoCommit(false);
            PreparedStatement stmt = c.prepareStatement("INSERT INTO position (symbol, number_of_shares, value_paid) VALUES (?, ?, ?)");
            stmt.setString(1, entity.getTicker());
            stmt.setInt(2, entity.getNumOfShares());
            stmt.setDouble(3, entity.getValuePaid());
            stmt.executeUpdate();

        }catch (Exception e) {
            try{
                c.rollback();
            } catch (SQLException ex) {
                DatabaseUtils.handleSqlException("PositionDao.save.rollback", ex, org.slf4j.LoggerFactory.getLogger(PositionDao.class));
            }
        } finally {
            try {
                c.setAutoCommit(true);
            } catch (SQLException e) {
                DatabaseUtils.handleSqlException("PositionDao.save.setAutoCommit", e, org.slf4j.LoggerFactory.getLogger(PositionDao.class));
            }
        }

            Optional<Position> savedPosition = this.findById(entity.getTicker());
            if(!savedPosition.isPresent()){
                return null;
            }

            return savedPosition.get();
    }

    @Override
    public Optional<Position> findById(String id) throws IllegalArgumentException {
        try(PreparedStatement stmt = c.prepareStatement("SELECT symbol, number_of_shares, value_paid FROM position WHERE symbol = ?")){
            stmt.setString(1, id);
            ResultSet rs = stmt.executeQuery();
            if(rs.next()){
                Position position = new Position();
                position.setTicker(rs.getString("symbol"));
                position.setNumOfShares(rs.getInt("number_of_shares"));
                position.setValuePaid(rs.getDouble("value_paid"));
                return Optional.of(position);
            } else {
                return Optional.empty();
            }
        } catch (SQLException e) {
            DatabaseUtils.handleSqlException("PositionDao.findById", e, org.slf4j.LoggerFactory.getLogger(PositionDao.class));
            return Optional.empty();
        }
    }

    @Override
    public Iterable<Position> findAll() {
        List<Position> positions = new ArrayList<>();
        try(PreparedStatement stmt = c.prepareStatement("SELECT symbol, number_of_shares, value_paid FROM position")){
            ResultSet rs = stmt.executeQuery();
            while(rs.next()){
                Position position = new Position();
                position.setTicker(rs.getString("symbol"));
                position.setNumOfShares(rs.getInt("number_of_shares"));
                position.setValuePaid(rs.getDouble("value_paid"));
                positions.add(position);
            }
        } catch (SQLException e) {
            DatabaseUtils.handleSqlException("PositionDao.findAll", e, org.slf4j.LoggerFactory.getLogger(PositionDao.class));
        }
        return positions;
    }

    @Override
    public void deleteById(String id) throws IllegalArgumentException {
        try(PreparedStatement stmt = c.prepareStatement("DELETE FROM position WHERE symbol = ?")){
            c.setAutoCommit(false);
            stmt.setString(1, id);
            stmt.executeUpdate();
            c.commit();
        } catch (SQLException e) {
            try {
                c.rollback();
                DatabaseUtils.handleSqlException("PositionDao.deleteById", e, org.slf4j.LoggerFactory.getLogger(PositionDao.class));
            } catch (SQLException ex) {
                DatabaseUtils.handleSqlException("PositionDao.deleteById.rollback", ex, org.slf4j.LoggerFactory.getLogger(PositionDao.class));
            }
        }finally {
            try {
                c.setAutoCommit(true);
            } catch (SQLException e) {
                DatabaseUtils.handleSqlException("PositionDao.deleteById.setAutoCommit", e, org.slf4j.LoggerFactory.getLogger(PositionDao.class));
            }
        }
    }

    @Override
    public void deleteAll() {
        try(PreparedStatement stmt = c.prepareStatement("DELETE FROM position")){
            stmt.executeUpdate();
        } catch (SQLException e) {
            DatabaseUtils.handleSqlException("PositionDao.deleteAll", e, org.slf4j.LoggerFactory.getLogger(PositionDao.class));
        }
    }

    public void update(Position position) {
        try(PreparedStatement stmt = c.prepareStatement("UPDATE position SET number_of_shares = ?, value_paid = ? WHERE symbol = ?")){
            c.setAutoCommit(false);
            stmt.setInt(1, position.getNumOfShares());
            stmt.setDouble(2, position.getValuePaid());
            stmt.setString(3, position.getTicker());
            stmt.executeUpdate();
            c.commit();
        } catch (SQLException e) {
            try {
                c.rollback();
                DatabaseUtils.handleSqlException("PositionDao.update", e, org.slf4j.LoggerFactory.getLogger(PositionDao.class));
            } catch (SQLException ex) {
                DatabaseUtils.handleSqlException("PositionDao.update.rollback", ex, org.slf4j.LoggerFactory.getLogger(PositionDao.class));
            }
        } finally {
            try {
                c.setAutoCommit(true);
            } catch (SQLException e) {
                DatabaseUtils.handleSqlException("PositionDao.update.setAutoCommit", e, org.slf4j.LoggerFactory.getLogger(PositionDao.class));
            }
        }
    }

    public void addShares(String ticker, int additionalShares, double additionalValue) {
        Optional<Position> positionOpt = findById(ticker);
        if(positionOpt.isPresent()){
            Position position = positionOpt.get();
            int newNumOfShares = position.getNumOfShares() + additionalShares;
            double newValuePaid = position.getValuePaid() + additionalValue;
            position.setNumOfShares(newNumOfShares);
            position.setValuePaid(newValuePaid);
            update(position);
        } else {
            throw new IllegalArgumentException("Position with ticker " + ticker + " not found.");
        }
    }

}
