import 'package:get/get.dart';

class DashboardController extends GetxController {
  var totalSalesToday = 0.0.obs;
  var totalDebtors = 0.obs;
  var topProducts = <String>[].obs;

  @override
  void onInit() {
    super.onInit();
    // Simulated load
    loadSummary();
  }

  void loadSummary() {
    totalSalesToday.value = 1250.00;
    totalDebtors.value = 4;
    topProducts.value = ["Treated Wood", "Cement", "Iron Rods"];
  }
}
