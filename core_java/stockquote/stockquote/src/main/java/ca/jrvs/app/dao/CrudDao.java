package ca.jrvs.app.dao;

import java.util.Optional;

public interface CrudDao <T, ID> {

    /**
     * save an entity
     * @param entity - must not be null
     * @return - saved entity
     * @throws IllegalArgumentException - if entity is null
     */
    T save (T entity) throws IllegalArgumentException;
    
    /**
     * retrieve an entity by its id
     * @param id - must not be null
     * @return - Entity with the given id or or empty Optional if not found
     * @throws IllegalArgumentException - if id is null
     */
    Optional<T> findById (ID id) throws IllegalArgumentException;

    /**
     * retrieve all entities
     * @return - all entities
     */
    Iterable<T> findAll();

    /**
     * Delete an entity if it exists
     * @param entity - must not be null
     * @return - true if entity was deleted, false otherwise
     * @throws IllegalArgumentException - if entity is null
     */
    void deleteById (ID id) throws IllegalArgumentException;

    /**
     * Delete all entities
     */
    void deleteAll();

}
