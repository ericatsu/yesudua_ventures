import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yesudua_ventures/app/data/models/product.dart';

class DashboardController extends GetxController {
  var totalSalesToday = 0.0.obs;
  var totalDebtors = 0.obs;
  var topProducts = <Product>[].obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();

    // Adding worker to react to loading state changes
    ever(isLoading, _handleLoadingState);

    // Simulated load
    loadSummary();
  }

  // Handler for loading state changes
  void _handleLoadingState(bool loading) {
    if (loading) {
      // Show loading indicator or disable UI
      Get.dialog(
        const Center(child: CircularProgressIndicator()),
        barrierDismissible: false,
      );
    } else {
      // Hide loading indicator
      if (Get.isDialogOpen ?? false) Get.back();
    }
  }

  void loadSummary() async {
    try {
      isLoading.value = true;

      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));

      totalSalesToday.value = 1250.00;
      totalDebtors.value = 4;
      topProducts.value = [
        Product(id: 1, name: "Treated Wood", price: 150.0, stock: 25),
        Product(id: 2, name: "Cement", price: 65.0, stock: 100),
        Product(id: 3, name: "Iron Rods", price: 45.0, stock: 75),
      ];
    } catch (e) {
      Get.snackbar('Error', 'Failed to load dashboard data');
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    // Clean up any resources
    super.onClose();
  }
}