package ca.jrvs.app.service;

import java.util.Optional;

import ca.jrvs.app.dao.PositionDao;
import ca.jrvs.app.entity.Position;

public class PositionService {
    private PositionDao positionDao;
    
    public PositionService(PositionDao positionDao) {
        this.positionDao = positionDao;
    }

    public void buy(String ticker, int numOfShares, double valuePaid) {
        Optional<Position> positionOpt = positionDao.findById(ticker);
        if(positionOpt.isPresent()){
            Position position = new Position();
            position.setTicker(ticker);
            position.setNumOfShares(numOfShares);
            position.setValuePaid(valuePaid);
            positionDao.addShares(position);
        } else {
            throw new IllegalArgumentException("Position with ticker " + ticker + " not found.");
        }
    }

    public void sell(String ticker, int numOfSharesToSell) {
        Optional<Position> positionOpt = positionDao.findById(ticker);
        if(positionOpt.isPresent()){
            positionDao.removeShares(ticker, numOfSharesToSell);
        } else {
            throw new IllegalArgumentException("Position with ticker " + ticker + " not found.");
        }
    }

    public Optional<Position> findByTicker(String ticker) {
        return positionDao.findById(ticker);
    }
}
