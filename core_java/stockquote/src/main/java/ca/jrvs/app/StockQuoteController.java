package ca.jrvs.app;

import ca.jrvs.app.entity.Position;
import ca.jrvs.app.entity.Quote;
import ca.jrvs.app.service.PositionService;
import ca.jrvs.app.service.QuoteService;

import java.util.Optional;
import java.util.Scanner;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class StockQuoteController {
    private QuoteService quoteService;
    private PositionService positionService;
    private Scanner scanner;
    private static final Logger log = LoggerFactory.getLogger(StockQuoteController.class);

    public StockQuoteController(QuoteService quoteService, PositionService positionService) {
        this.quoteService = quoteService;
        this.positionService = positionService;
        this.scanner = new Scanner(System.in);
    }

    public void initClient() {
        boolean running = true;
        log.info("Stock Quote Application started");
        while (running) {
            printMenu();
            String choice = scanner.nextLine().trim();
            
            switch (choice) {
                case "1":
                    viewQuote();
                    break;
                case "2":
                    buyOrSell();
                    break;
                case "3":
                    viewPosition();
                    break;
                case "4":
                    running = false;
                    System.out.println("Goodbye!");
                    log.info("Stock Quote Application exited");
                    break;
                default:
                    System.out.println("Invalid option. Please try again.");
            }
        }
    }

    private void printMenu() {
        log.info("Printing menu options.");
        System.out.println("\n=== Stock Quote Application ===");
        System.out.println("1. View Quote");
        System.out.println("2. Buy or Sell");
        System.out.println("3. View Position");
        System.out.println("4. Exit");
        System.out.print("Enter your choice: ");
        

    }

    private void viewQuote() {
        System.out.print("Enter ticker symbol: ");
        String ticker = scanner.nextLine().trim().toUpperCase();
        log.info("User requested quote for ticker: " + ticker);
        
        if (ticker.isEmpty()) {
            log.error("Error: Ticker cannot be empty.");
            return;
        }
        
        Optional<Quote> quote = quoteService.fetchQuoteDataFromAPI(ticker);
        if (quote.isPresent()) {
            System.out.println("Quote for " + ticker + ": " + quote.get());
            log.info("Displayed quote for " + ticker);
        } else {
            log.error("No quote found for " + ticker);
        }
    }

    private void buyOrSell() {
        System.out.println("1. Buy");
        System.out.println("2. Sell");
        System.out.print("Enter your choice: ");
        String action = scanner.nextLine().trim();
        log.info("User selected action: " + action);
        
        
        if (!action.equals("1") && !action.equals("2")) {
            log.error("Error: Please enter '1' or '2'.");
            return;
        }
        
        System.out.print("Enter ticker symbol: ");
        String ticker = scanner.nextLine().trim().toUpperCase();
        log.info("User entered ticker: " + ticker);
        
        if (ticker.isEmpty()) {
            log.error("Error: Ticker cannot be empty.");
            return;
        }
        
        if (action.equals("1")) {
            System.out.print("Enter number of shares: ");
            int numOfShares;
            try {
                numOfShares = Integer.parseInt(scanner.nextLine().trim());
                log.info("User entered number of shares: " + numOfShares);
            } catch (NumberFormatException e) {
                log.error("Error: Invalid number of shares.");
                return;
            }
            
            System.out.print("Enter value paid: ");
            double valuePaid;
            try {
                valuePaid = Double.parseDouble(scanner.nextLine().trim());
            } catch (NumberFormatException e) {
                log.error("Error: Invalid value.");
                return;
            }
            
            positionService.buy(ticker, numOfShares, valuePaid);
            System.out.println("Bought " + numOfShares + " shares of " + ticker);
            log.info("Bought " + numOfShares + " shares of " + ticker);
        } else if (action.equals("2")) {
            System.out.print("Enter number of shares to sell: ");
            int numOfSharesToSell;
            try {
                numOfSharesToSell = Integer.parseInt(scanner.nextLine().trim());
            } catch (NumberFormatException e) {
                log.error("Error: Invalid number of shares.");
                return;
            }
            positionService.sell(ticker, numOfSharesToSell);
            System.out.println("Sold " + numOfSharesToSell + " shares of " + ticker);
            log.info("Sold " + numOfSharesToSell + " shares of " + ticker);
        }else {
            log.error("Invalid action. Please try again.");
        }
    }

    private void viewPosition() {
        System.out.print("Enter ticker symbol: ");
        String ticker = scanner.nextLine().trim().toUpperCase();
        
        if (ticker.isEmpty()) {
            log.error("Error: Ticker cannot be empty.");
            return;
        }
        
        Optional<Position> position = positionService.findByTicker(ticker);
        if (position.isPresent()) {
            System.out.println("Position for " + ticker + ":");
            System.out.println("  Shares: " + position.get().getNumOfShares());
            System.out.println("  Value Paid: $" + position.get().getValuePaid());
            log.info("Displayed position for " + ticker);
        } else {
            log.error("No position found for " + ticker);
        }
    }
}
