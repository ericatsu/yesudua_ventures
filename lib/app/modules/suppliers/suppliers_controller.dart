import 'package:get/get.dart';
import '../../data/models/supplier.dart';

class SuppliersController extends GetxController {
  var suppliers = <Supplier>[].obs;

  final name = ''.obs;
  final contact = ''.obs;
  final company = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadSuppliers();
  }

  void loadSuppliers() {
    suppliers.value = [
      Supplier(
        id: 1,
        name: "GreenWood Supplies",
        contact: "0200000001",
        company: "GreenWood Co.",
        createdAt: DateTime.now().subtract(const Duration(days: 2)),
      ),
    ];
  }

  void addSupplier() {
    final newSupplier = Supplier(
      id: suppliers.length + 1,
      name: name.value,
      contact: contact.value,
      company: company.value,
      createdAt: DateTime.now(),
    );
    suppliers.add(newSupplier);
    resetForm();
  }

  void resetForm() {
    name.value = '';
    contact.value = '';
    company.value = '';
  }
}