package com.jrvs;

import java.util.List;
import java.util.Arrays;
import static com.jrvs.DetectFraud.detectFraud;

public class Main {
    public static void main(String[] args) {
        // Test detectFraud
        List<Integer> transactions = Arrays.asList(7000, 40, 5000, 30, 100, 200);
        int threshold = 1000;
        
        System.out.println("Suspicious transactions: " + DetectFraud.detectFraud(transactions, threshold));

        // Stream API version
        System.out.println("Suspicious transactions (stream): " + DetectFraud.detectFraudStream(transactions, threshold));

        // Test BankAccount
        BankAccount account = new BankAccount("12345", "Alice", 100.0);
        account.deposit(50.0);
        account.withdraw(30.0);
        account.deposit(200.0);
        account.withdraw(20.0);
        System.out.println(account.getAccountInfo());
        //BankAccount account2 = new BankAccount("12346", "John", 650.0);
        //System.out.println(account2.getAccountInfo());

        
        // Print transactions Stream API version
        System.out.println("Total deposits: " + account.getTotalDeposits());
        System.out.println("Total withdrawals: " + account.getTotalWithdrawals());
        System.out.println("Largest deposit: " + account.getLargestDeposit());

        // List transactions
        System.out.println("All transactions: " + account.getTransactions());

    }
}