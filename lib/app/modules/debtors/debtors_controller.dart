import 'package:get/get.dart';
import '../../data/models/debtor.dart';

class DebtorsController extends GetxController {
  var debtors = <Debtor>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadDebtors();
  }

  void loadDebtors() {
    // Simulated list — replace with real DB call
    debtors.value = [
      Debtor(
        id: 1,
        customerName: "John Doe",
        customerContact: "0551234567",
        totalAmount: 300,
        amountPaid: 100,
        createdAt: DateTime.now().subtract(const Duration(days: 3)),
      ),
      Debtor(
        id: 2,
        customerName: "Ama Mensah",
        customerContact: "0249876543",
        totalAmount: 450,
        amountPaid: 450,
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
      ),
    ];
  }

  void recordPayment(int id, double amount) {
    final index = debtors.indexWhere((d) => d.id == id);
    if (index != -1) {
      final d = debtors[index];
      debtors[index] = Debtor(
        id: d.id,
        customerName: d.customerName,
        customerContact: d.customerContact,
        totalAmount: d.totalAmount,
        amountPaid: (d.amountPaid + amount).clamp(0, d.totalAmount),
        createdAt: d.createdAt,
      );
      debtors.refresh();
    }
  }
}