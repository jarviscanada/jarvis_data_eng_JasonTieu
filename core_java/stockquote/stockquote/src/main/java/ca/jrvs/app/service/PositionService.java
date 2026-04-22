package ca.jrvs.app.service;

import ca.jrvs.app.dao.PositionDao;
import ca.jrvs.app.entity.Position;

public class PositionService {
    private PositionDao positionDao;
    
    public PositionService(PositionDao positionDao) {
        this.positionDao = positionDao;
    }

    public Position buy(String ticker, int numOfShares, double valuePaid) {
        Position position = new Position();
        position.setTicker(ticker);
        position.setNumOfShares(numOfShares);
        position.setValuePaid(valuePaid);
        return positionDao.save(position);
    }

    public void sell(String ticker) {
        positionDao.deleteById(ticker);
    }
}
