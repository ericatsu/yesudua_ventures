import 'package:flutter/material.dart';
import 'package:yesudua_ventures/app/core/utils/constants.dart';

class Formatters {
  // Format currency
  static String formatCurrency(double amount) {
    return AppConstants.currencyFormatter.format(amount);
  }
  
  // Format date
  static String formatDate(DateTime date) {
    return AppConstants.dateFormatter.format(date);
  }
  
  // Format date and time
  static String formatDateTime(DateTime dateTime) {
    return AppConstants.dateTimeFormatter.format(dateTime);
  }
  
  // Format quantity with unit
  static String formatQuantity(int quantity, [String unit = 'pcs']) {
    return '$quantity $unit';
  }
  
  // Get profit margin as percentage
  static String calculateProfitMargin(double boughtPrice, double sellPrice) {
    if (boughtPrice <= 0) return '0%';
    
    final margin = ((sellPrice - boughtPrice) / boughtPrice) * 100;
    return '${margin.toStringAsFixed(1)}%';
  }
  
  // Get profit amount
  static double calculateProfit(double boughtPrice, double sellPrice) {
    return sellPrice - boughtPrice;
  }
  
  // Get inventory value (quantity * bought price)
  static double calculateInventoryValue(int quantity, double boughtPrice) {
    return quantity * boughtPrice;
  }
  
  // Get potential revenue (quantity * sell price)
  static double calculatePotentialRevenue(int quantity, double sellPrice) {
    return quantity * sellPrice;
  }
  
  // Get potential profit (quantity * (sell price - bought price))
  static double calculatePotentialProfit(
    int quantity,
    double boughtPrice,
    double sellPrice,
  ) {
    return quantity * (sellPrice - boughtPrice);
  }
  
  // Get appropriate color for stock level
  static Color getStockLevelColor(int quantity) {
    if (quantity <= 0) {
      return Colors.red;
    } else if (quantity <= 5) {
      return Colors.orange;
    } else if (quantity <= 10) {
      return Colors.yellow;
    } else {
      return Colors.green;
    }
  }
  
  // Get stock level description
  static String getStockLevelDescription(int quantity) {
    if (quantity <= 0) {
      return 'Out of Stock';
    } else if (quantity <= 5) {
      return 'Low Stock';
    } else if (quantity <= 10) {
      return 'Medium Stock';
    } else {
      return 'Good Stock';
    }
  }
  
  // Format supplier name (handle null/empty cases)
  static String formatSupplier(String? supplier) {
    return supplier?.isNotEmpty == true ? supplier! : 'Not specified';
  }
}