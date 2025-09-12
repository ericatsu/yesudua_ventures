import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yesudua_ventures/app/core/utils/constants.dart';

class AppUtils {
  static String formatCurrency(double amount) {
    return AppConstants.currencyFormatter.format(amount);
  }

  static String formatDate(DateTime date) {
    return AppConstants.dateFormatter.format(date);
  }

  static String formatDateTime(DateTime dateTime) {
    return AppConstants.dateTimeFormatter.format(dateTime);
  }

  static String formatQuantity(int quantity, [String unit = 'pcs']) {
    return '$quantity $unit';
  }

  static String formatSupplier(String? supplier) {
    return supplier?.isNotEmpty == true ? supplier! : 'Not specified';
  }

  static String calculateProfitMargin(double boughtPrice, double sellPrice) {
    if (boughtPrice <= 0) return '0%';
    final margin = ((sellPrice - boughtPrice) / boughtPrice) * 100;
    return '${margin.toStringAsFixed(1)}%';
  }

  static double calculateProfit(double boughtPrice, double sellPrice) {
    return sellPrice - boughtPrice;
  }

  static double calculateInventoryValue(int quantity, double boughtPrice) {
    return quantity * boughtPrice;
  }

  static double calculatePotentialRevenue(int quantity, double sellPrice) {
    return quantity * sellPrice;
  }

  static double calculatePotentialProfit(
    int quantity,
    double boughtPrice,
    double sellPrice,
  ) {
    return quantity * (sellPrice - boughtPrice);
  }

  // ===== STOCK LEVEL UTILITIES =====
  static Color getStockLevelColor(int quantity) {
    if (quantity <= 0) return Colors.red;
    if (quantity <= 5) return Colors.orange;
    if (quantity <= 10) return Colors.yellow;
    return Colors.green;
  }

  static String getStockLevelDescription(int quantity) {
    if (quantity <= 0) return 'Out of Stock';
    if (quantity <= 5) return 'Low Stock';
    if (quantity <= 10) return 'Medium Stock';
    return 'Good Stock';
  }

  // ===== VALIDATION UTILITIES =====
  static String? requiredValidator(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter $fieldName';
    }
    return null;
  }

  static String? numberValidator(
    String? value,
    String fieldName, {
    bool isDecimal = true,
    bool required = true,
  }) {
    if (required && (value == null || value.trim().isEmpty)) {
      return 'Please enter $fieldName';
    }
    if (value == null || value.trim().isEmpty)
      return null; // Not required, skip

    final num? parsed =
        isDecimal ? double.tryParse(value) : int.tryParse(value);
    if (parsed == null) {
      return 'Please enter a valid ${isDecimal ? 'decimal' : 'number'}';
    }
    if (parsed < 0) {
      return '$fieldName cannot be negative';
    }
    return null;
  }

  static String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) return null; // Optional
    final emailRegExp = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegExp.hasMatch(value)) {
      return 'Invalid email address';
    }
    return null;
  }

  static String? validatePhone(String? value) {
    if (value == null || value.trim().isEmpty) return null; // Optional
    final phoneRegExp = RegExp(r'^\+?[0-9]{10,15}$');
    if (!phoneRegExp.hasMatch(value)) {
      return 'Invalid phone number';
    }
    return null;
  }

  static String? categoryValidator(int? value) {
    if (value == null) {
      return 'Please select a category';
    }
    return null;
  }

  static String? customProductNameValidator(
    String? value,
    bool isCustomSelected,
  ) {
    if (isCustomSelected && (value == null || value.trim().isEmpty)) {
      return 'Please enter custom product name';
    }
    return null;
  }

  // ===== SNACKBAR UTILITIES =====
  static void showSuccess(String title, String message) {
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green,
      colorText: Colors.white,
      margin: const EdgeInsets.all(16),
      borderRadius: 8,
      icon: const Icon(Icons.check_circle, color: Colors.white),
      duration: const Duration(seconds: 3),
    );
  }

  static void showError(String title, String message) {
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red,
      colorText: Colors.white,
      margin: const EdgeInsets.all(16),
      borderRadius: 8,
      icon: const Icon(Icons.error, color: Colors.white),
      duration: const Duration(seconds: 3),
    );
  }

  static void showInfo(String title, String message) {
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.blue,
      colorText: Colors.white,
      margin: const EdgeInsets.all(16),
      borderRadius: 8,
      icon: const Icon(Icons.info, color: Colors.white),
      duration: const Duration(seconds: 3),
    );
  }

  static void showWarning(String title, String message) {
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.orange,
      colorText: Colors.white,
      margin: const EdgeInsets.all(16),
      borderRadius: 8,
      icon: const Icon(Icons.warning, color: Colors.white),
      duration: const Duration(seconds: 3),
    );
  }

  static void showLoadingDialog([String? message]) {
    Get.dialog(
      AlertDialog(
        content: Row(
          children: [
            const CircularProgressIndicator(),
            const SizedBox(width: 20),
            Text(message ?? 'Loading...'),
          ],
        ),
      ),
      barrierDismissible: false,
    );
  }

  static void hideLoadingDialog() {
    if (Get.isDialogOpen == true) {
      Get.back();
    }
  }
}
