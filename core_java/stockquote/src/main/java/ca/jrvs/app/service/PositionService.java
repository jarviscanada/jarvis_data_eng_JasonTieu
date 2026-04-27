package ca.jrvs.app.service;

import java.util.Optional;

import ca.jrvs.app.dao.PositionDao;
import ca.jrvs.app.entity.Position;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class PositionService {
    private PositionDao positionDao;
    private static final Logger log = LoggerFactory.getLogger(PositionService.class);
    
    public PositionService(PositionDao positionDao) {
        this.positionDao = positionDao;
    }

    public void buy(String ticker, int shares, double price) {

        Optional<Position> posOpt = positionDao.findById(ticker);

        if (!posOpt.isPresent()) {

            Position newPos = new Position();
            newPos.setTicker(ticker);
            newPos.setNumOfShares(shares);
            newPos.setValuePaid(price * shares);

            positionDao.save(newPos);

            log.info("Created new position for " + ticker);
            return;
        }


        positionDao.addShares(posOpt.get());

        log.info("Updated position for " + ticker);
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
