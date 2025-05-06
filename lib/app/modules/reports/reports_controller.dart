import 'package:get/get.dart';
import '../../data/models/debtor.dart';
import '../../data/models/inventory_item.dart';

class ReportsController extends GetxController {
  var dailySalesTotal = 0.0.obs;
  var monthlySalesTotal = 0.0.obs;
  var totalDebt = 0.0.obs;

  var topDebtors = <Debtor>[].obs;
  var lowStockItems = <InventoryItem>[].obs;

  @override
  void onInit() {
    super.onInit();
    generateReports();
  }

  void generateReports() {
    // Simulated data
    dailySalesTotal.value = 840.0;
    monthlySalesTotal.value = 12840.0;

    topDebtors.value = [
      Debtor(
        id: 1,
        customerName: 'John Doe',
        customerContact: '0551112222',
        totalAmount: 300,
        amountPaid: 100,
        createdAt: DateTime.now(),
      ),
      Debtor(
        id: 2,
        customerName: 'Ama Mensah',
        customerContact: '0244445555',
        totalAmount: 500,
        amountPaid: 250,
        createdAt: DateTime.now(),
      ),
    ];

    totalDebt.value = topDebtors.fold(
      0,
      (sum, d) => sum + (d.totalAmount - d.amountPaid),
    );

    lowStockItems.value = [
      InventoryItem(
        id: 1,
        name: 'Cement',
        category: 'Materials',
        quantity: 4,
        boughtPrice: 30,
        sellPrice: 45,
      ),
      InventoryItem(
        id: 2,
        name: 'Nails Box',
        category: 'Tools',
        quantity: 2,
        boughtPrice: 8,
        sellPrice: 12,
      ),
    ];
  }
}