package ca.jrvs.app;

import java.util.Optional;

import ca.jrvs.app.entity.Position;

public class PositionDao implements CrudDao<Position, String> {

    @Override
    public Position save(Position entity) throws IllegalArgumentException {
        return null;
    }

    @Override
    public Optional<Position> findById(String id) throws IllegalArgumentException {
        return Optional.empty();
    }

    @Override
    public Iterable<Position> findAll() {
        return null;
    }

    @Override
    public void deleteById(String id) throws IllegalArgumentException {

    }

    @Override
    public void deleteAll() {

    }

}
