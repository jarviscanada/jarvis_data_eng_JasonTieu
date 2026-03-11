package com.jrvs;

import java.util.List;

public class BankAccount {
    private String accountNumber;
    private String ownerName;
    private double balance;
    private final int threashold = 1000;
    //Stream API version
    private List<Double> transactions;

    public BankAccount(String accountNumber, String ownerName, double startingBalance) {
        if (startingBalance < 0) {
            throw new IllegalArgumentException("Starting balance cannot be negative");
        }
        else if (accountNumber == null || accountNumber.isEmpty()) {
            throw new IllegalArgumentException("Account number cannot be null or empty");
        }
        this.accountNumber = accountNumber;
        this.ownerName = ownerName;
        this.balance = startingBalance;
        this.transactions = new java.util.ArrayList<>();
    }

    public void deposit(double amount) {
        if (amount <= 0) {
            throw new IllegalArgumentException("Deposit amount must be greater than 0");
        }
        this.balance += amount;
        addTransaction(amount);
    }

    public void withdraw(double amount) {
        if (amount <= 0) {
            throw new IllegalArgumentException("Withdrawal amount must be greater than 0");
        }
        if (amount > this.balance) {
            throw new IllegalArgumentException("Cannot withdraw more than current balance");
        }
        this.balance -= amount;
        addTransaction(-amount);
    }

    public double getBalance() {
        return this.balance;
    }

    public String getAccountInfo() {
        return String.format("Account: %s\nOwner: %s\nBalance: %.2f",
                             this.accountNumber, this.ownerName, this.balance);
    }

    public int getThreshold() {
        return this.threashold;
    }

    public List<Double> getTransactions() {
        return this.transactions;
    }

    public void addTransaction(double amount) {
        this.transactions.add(amount);
    }


    //Stream API methods
    public List<Double> getDeposits() {
        return this.transactions.stream()
                .filter(t -> t > 0)
                .toList();
    }

    public List<Double> getWithdrawals() {
        return this.transactions.stream()
                .filter(t -> t < 0)
                .toList();
    }

    public double getTotalDeposits() {
        return this.transactions.stream()
                .filter(t -> t > 0)
                .mapToDouble(Double::doubleValue)
                .sum();
    }

    public double getTotalWithdrawals() {
        return this.transactions.stream()
                .filter(t -> t < 0)
                .mapToDouble(Double::doubleValue)
                .sum();
    }

    public double getLargestDeposit() {
        return this.transactions.stream()
                .filter(t -> t > 0)
                .max(Double::compare)
                .orElse(0.0);
    }
}