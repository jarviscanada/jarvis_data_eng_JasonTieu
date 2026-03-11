package com.jrvs;

import java.util.List;
import java.util.Arrays;

public class Main {
    public static void main(String[] args) {

        // Test BankAccount
        BankAccount account = new BankAccount("12345", "Alice", 100.0);
        account.deposit(50.0);
        account.withdraw(30.0);
        account.deposit(200.0);
        account.withdraw(20.0);
        System.out.println(account.getAccountInfo());

        // Test detectFraud
        List<Integer> transactions = Arrays.asList(7000, 40, 5000, 30, 100, 200);
        System.out.println("Suspicious transactions: " + DetectFraud.detectFraud(transactions, account.getThreshold()));

        // Stream API version
        System.out.println("Suspicious transactions (stream): " + DetectFraud.detectFraudStream(transactions, account.getThreshold()));
        
        // Print transactions Stream API version
        System.out.println("Total deposits: " + account.getTotalDeposits());
        System.out.println("Total withdrawals: " + account.getTotalWithdrawals());
        System.out.println("Largest deposit: " + account.getLargestDeposit());

        // List transactions
        System.out.println("All transactions: " + account.getTransactions());

    }
}