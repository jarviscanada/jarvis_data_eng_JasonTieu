package com.jrvs;

import java.util.ArrayList;
import java.util.List;

public class DetectFraud {
    // Using traditional loop
    public static List<Integer> detectFraud(List<Integer> transactions, int threshold) {
            // Using traditional loop
            List<Integer> suspicious = new ArrayList<>();
            for (int transaction : transactions) {
                if (transaction > threshold) {
                    suspicious.add(transaction);
                }
            }
            return suspicious;
        }

    // Using Stream API
    public static List<Integer> detectFraudStream(List<Integer> transactions, int threshold) {
        return transactions.stream()
                .filter(t -> t > threshold)
                .toList();
    }   
}
