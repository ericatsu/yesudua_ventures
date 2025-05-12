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

    ever(isLoading, _handleLoadingState);

     WidgetsBinding.instance.addPostFrameCallback((_) {
      loadSummary();
    });
  }

  void _handleLoadingState(bool loading) {
    if (loading) {
      Get.dialog(
        const Center(child: CircularProgressIndicator()),
        barrierDismissible: false,
      );
    } else {
      if (Get.isDialogOpen ?? false) Get.back();
    }
  }

  void loadSummary() async {
    try {
      isLoading.value = true;

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