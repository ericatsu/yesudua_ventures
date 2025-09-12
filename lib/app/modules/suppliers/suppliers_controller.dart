import 'package:get/get.dart';
import 'package:yesudua_ventures/app/core/utils/app_utils.dart';
import 'package:yesudua_ventures/app/data/models/inventory_model.dart';
import 'package:yesudua_ventures/app/data/repositories/inventory_repository.dart';

class SuppliersController extends GetxController {
  final InventoryRepository _repository;

  // Observable list of suppliers
  final RxList<SupplierModel> suppliers = <SupplierModel>[].obs;

  // Loading state
  final RxBool isLoading = false.obs;

  // Search query
  final RxString searchQuery = ''.obs;

  // Selected supplier for editing
  final Rx<SupplierModel?> selectedSupplier = Rx<SupplierModel?>(null);

  // Constructor
  SuppliersController(this._repository);

  @override
  void onInit() {
    super.onInit();
    fetchAllSuppliers();

    // Listen to changes in search query
    debounce(
      searchQuery,
      (_) => searchSuppliers(),
      time: const Duration(milliseconds: 500),
    );
  }

  // Fetch all suppliers
  Future<void> fetchAllSuppliers() async {
    isLoading.value = true;
    try {
      suppliers.value = await _repository.getAllSuppliers();
    } catch (e) {
      Get.snackbar('Error', 'Failed to load suppliers: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // Search suppliers
  void searchSuppliers() {
    if (searchQuery.isEmpty) {
      fetchAllSuppliers();
      return;
    }

    final query = searchQuery.value.toLowerCase();
    suppliers.value =
        suppliers
            .where(
              (supplier) =>
                  supplier.name.toLowerCase().contains(query) ||
                  supplier.contact.toLowerCase().contains(query) ||
                  (supplier.address?.toLowerCase().contains(query) ?? false),
            )
            .toList();
  }

  // Add a new supplier
  Future<bool> addSupplier(SupplierModel supplier) async {
    try {
      final id = await _repository.addSupplier(supplier);
      if (id > 0) {
        final newSupplier = supplier.copyWith(id: id);
        suppliers.add(newSupplier);
        Get.back(); // Close dialog
        AppUtils.showSuccess('Success', '${supplier.name} added successfully');
        return true;
      }
      return false;
    } catch (e) {
      AppUtils.showError('Error', 'Failed to add supplier: $e');
      return false;
    }
  }

  // Update an existing supplier
  Future<bool> updateSupplier(SupplierModel supplier) async {
    try {
      final success = await _repository.updateSupplier(supplier);
      if (success) {
        final index = suppliers.indexWhere((s) => s.id == supplier.id);
        if (index != -1) {
          suppliers[index] = supplier;
          suppliers.refresh();
        }
        Get.back(); // Close dialog
        AppUtils.showSuccess('Success', '${supplier.name} updated successfully');
        return true;
      }
      return false;
    } catch (e) {
      AppUtils.showError('Error', 'Failed to update supplier: $e');
      return false;
    }
  }

  // Delete a supplier
  Future<bool> deleteSupplier(int id) async {
    try {
      final success = await _repository.deleteSupplier(id);
      if (success) {
        suppliers.removeWhere((supplier) => supplier.id == id);
        AppUtils.showSuccess('Success', 'Supplier deleted successfully');
        return true;
      } else {
        AppUtils.showError(
          'Error',
          'Cannot delete supplier that is linked to inventory items',
        );
        return false;
      }
    } catch (e) {
      AppUtils.showError('Error', 'Failed to delete supplier: $e');
      return false;
    }
  }

  // Select a supplier for editing
  void selectSupplier(SupplierModel? supplier) {
    selectedSupplier.value = supplier;
  }

  // Get supply history for a specific supplier
  Future<List<SupplyHistoryModel>> getSupplierHistory(int supplierId) async {
    try {
      return await _repository.getSupplyHistoryBySupplier(supplierId);
    } catch (e) {
      AppUtils.showError('Error', 'Failed to load supplier history: $e');
      return [];
    }
  }
}
