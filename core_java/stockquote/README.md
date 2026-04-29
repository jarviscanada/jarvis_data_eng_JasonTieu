# Introduction
This Stock Quote application is a command-line tool that fetches real-time stock market data from an external API and stores it in a PostgreSQL database. Users can search for stock quotes by ticker symbol and manage their investment positions by buying and selling stocks. The application provides a menu-driven interface for easy interaction and maintains a record of all stock positions with their current values.

**Technologies Used:**
- **Java 8** - Core programming language
- **PostgreSQL** - Relational database for storing quotes and positions
- **JDBC** - Database connectivity and query execution
- **Maven** - Build automation and dependency management
- **Jackson** - JSON serialization/deserialization for API data
- **OkHttp3** - HTTP client for fetching stock data from API
- **SLF4J + Logback** - Logging framework
- **JUnit 4 & Mockito** - Unit and integration testing
- **Docker & Docker Compose** - Containerization for easy deployment

# Implementation

## ER Diagram

```
┌─────────────┐           ┌──────────────┐
│    Quote    │           │   Position   │
├─────────────┤           ├──────────────┤
│ symbol (PK) │◄──────────│ symbol (PK)  │
│ open        │  1    *   │ number_shares│
│ high        │           │ value_paid   │
│ low         │           └──────────────┘
│ price       │
│ volume      │
│ change      │
│ change_pct  │
│ timestamp   │
└─────────────┘
```

The application uses two main tables:
- **Quote**: Stores real-time stock market data with symbol as the primary key
- **Position**: Tracks user investment positions with a foreign key constraint to the Quote table

## Design Patterns

### DAO (Data Access Object) Pattern
The application implements the DAO design pattern to abstract database operations. The `CrudDao<T, ID>` interface defines standard CRUD operations (Create, Read, Update, Delete), while `QuoteDao` and `PositionDao` concrete implementations handle specific entity persistence logic. This separation provides several benefits: database independence (easy to switch databases), centralized data access logic, simplified testing through mock objects, and improved code maintainability.

### Service Layer Pattern
The `QuoteService` and `PositionService` classes implement business logic that sits between the controller and DAO layer. Services orchestrate interactions between multiple DAOs, handle API calls, and manage transactions. For example, `QuoteService.fetchQuoteDataFromAPI()` fetches data from an external API and persists it to the database in a single logical unit.

### MVC (Model-View-Controller) Architecture
The application follows MVC architecture with clear separation of concerns:
- **Model**: `Quote` and `Position` entities represent data objects
- **View**: Console interface through the controller's menu system
- **Controller**: `StockQuoteController` handles user input and coordinates service calls

This architecture enhances testability, maintainability, and allows for future UI improvements without modifying business logic.

# Test

## Database Setup
The application uses Docker Compose to simplify database setup. The `docker-compose.yml` file orchestrates:
- **PostgreSQL 15 container** with initialized schema via `ddl.sql`
- **Application container** that depends on PostgreSQL being healthy
- **Environment variables** for database credentials and connection parameters

To set up the test environment:
```bash
docker-compose up
```

## Test Strategy

The application employs multiple testing approaches:

### Unit Tests
- **QuoteService_UnitTest**: Tests business logic with mocked dependencies (DAO and HTTP helper)
- **QuoteHttpHelper_UnitTest**: Tests API data parsing with mocked HTTP responses
- Uses Mockito framework to isolate units under test and verify correct method calls

### Integration Tests
- **QuoteService_IntTest**: Tests full workflow from API fetch to database persistence
- **PositionService_IntTest**: Tests position management against actual database
- Uses real database connections to validate end-to-end functionality

### DAO Tests
- **QuoteDaoTest**: Tests JDBC operations (save, find, update, delete)
- **PositionDaoTest**: Tests position persistence and foreign key constraints
- Verifies correct SQL execution and data integrity

## Test Data Setup
Each test class sets up necessary test data:
- Creates temporary test entities with known values
- Verifies database state before and after operations
- Uses separate test configurations to avoid affecting production data

## Execution
Run all tests with Maven:
```bash
mvn test
```

Test results are generated in `target/surefire-reports/` with detailed XML and text reports.

