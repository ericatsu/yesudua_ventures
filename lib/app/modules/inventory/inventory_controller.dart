import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yesudua_ventures/app/core/utils/assets.dart';
import 'package:yesudua_ventures/app/core/utils/constants.dart';
import 'package:yesudua_ventures/app/data/models/inventory_model.dart';
import 'package:yesudua_ventures/app/data/repositories/inventory_repository.dart';
import 'package:yesudua_ventures/app/modules/dashboard/dashboard_controller.dart';

class InventoryController extends GetxController {
  final InventoryRepository _repository;

  // Observable lists for inventory items, categories, and suppliers
  final RxList<InventoryItemModel> inventoryItems = <InventoryItemModel>[].obs;
  final RxList<CategoryModel> categories = <CategoryModel>[].obs;
  final RxList<SupplierModel> suppliers = <SupplierModel>[].obs;

  // Loading states
  final RxBool isLoadingItems = false.obs;
  final RxBool isLoadingCategories = false.obs;
  final RxBool isLoadingSuppliers = false.obs;

  // Search query
  final RxString searchQuery = ''.obs;

  // Filter by category
  final Rx<CategoryModel?> selectedCategory = Rx<CategoryModel?>(null);

  // Sort options
  final RxString sortBy = 'name'.obs;
  final RxBool sortAscending = true.obs;

  // Add inventory form state management
  final RxInt selectedCategoryId = 0.obs;
  final RxnInt selectedSupplierId = RxnInt();
  final RxString selectedProductVariant = ''.obs;
  final RxString selectedCategoryName = ''.obs;
  final RxString customProductName = ''.obs;

  InventoryController(this._repository);

  @override
  void onInit() {
    super.onInit();
    fetchAllInventory();
    fetchAllCategories();
    fetchAllSuppliers();
    ensurecategoryItems();

    debounce(
      searchQuery,
      (_) => searchInventory(),
      time: const Duration(milliseconds: 500),
    );
  }

  // Helper method to refresh dashboard if it exists
  Future<void> _refreshDashboardIfExists() async {
    try {
      if (Get.isRegistered<DashboardController>()) {
        final dashboardController = Get.find<DashboardController>();
        await dashboardController.refreshDashboard();
      }
    } catch (e) {
      print('Dashboard controller not found: $e');
    }
  }

  Future<void> fetchAllInventory() async {
    isLoadingItems.value = true;
    try {
      if (searchQuery.isEmpty && selectedCategory.value == null) {
        inventoryItems.value = await _repository.getAllInventoryItems();
      } else if (searchQuery.isNotEmpty) {
        searchInventory();
        return;
      } else if (selectedCategory.value != null) {
        filterByCategory();
        return;
      }
      sortInventory();
    } catch (e) {
      Get.snackbar('Error', 'Failed to load inventory items: $e');
    } finally {
      isLoadingItems.value = false;
    }
  }

  Future<void> searchInventory() async {
    if (searchQuery.isEmpty) {
      fetchAllInventory();
      return;
    }

    isLoadingItems.value = true;
    try {
      inventoryItems.value = await _repository.searchInventoryItems(
        searchQuery.value,
      );
      sortInventory();
    } catch (e) {
      Get.snackbar('Error', 'Failed to search inventory items: $e');
    } finally {
      isLoadingItems.value = false;
    }
  }

  Future<void> ensurecategoryItems() async {
    try {
      final existingCategories = await _repository.getAllCategories();
      final existingCategoryNames =
          existingCategories.map((c) => c.name.toLowerCase()).toSet();

      for (final categoryName in AppConstants.categoryItems.keys) {
        if (!existingCategoryNames.contains(categoryName.toLowerCase())) {
          await _repository.addCategory(CategoryModel(name: categoryName));
        }
      }

      await fetchAllCategories();
    } catch (e) {
      Get.snackbar('Error', 'Failed to initialize predefined categories: $e');
    }
  }

  Future<void> filterByCategory() async {
    if (selectedCategory.value == null) {
      fetchAllInventory();
      return;
    }

    isLoadingItems.value = true;
    try {
      inventoryItems.value = await _repository.getInventoryItemsByCategory(
        selectedCategory.value!.id!,
      );
      sortInventory();
    } catch (e) {
      Get.snackbar('Error', 'Failed to filter inventory items: $e');
    } finally {
      isLoadingItems.value = false;
    }
  }

  void sortInventory() {
    switch (sortBy.value) {
      case 'name':
        sortAscending.value
            ? inventoryItems.sort((a, b) => a.name.compareTo(b.name))
            : inventoryItems.sort((a, b) => b.name.compareTo(a.name));
        break;
      case 'quantity':
        sortAscending.value
            ? inventoryItems.sort((a, b) => a.quantity.compareTo(b.quantity))
            : inventoryItems.sort((a, b) => b.quantity.compareTo(a.quantity));
        break;
      case 'sellPrice':
        sortAscending.value
            ? inventoryItems.sort((a, b) => a.sellPrice.compareTo(b.sellPrice))
            : inventoryItems.sort((a, b) => b.sellPrice.compareTo(a.sellPrice));
        break;
    }
  }

  void changeSortOption(String option) {
    if (sortBy.value == option) {
      sortAscending.toggle();
    } else {
      sortBy.value = option;
      sortAscending.value = true;
    }
    sortInventory();
  }

  Future<void> fetchAllCategories() async {
    isLoadingCategories.value = true;
    try {
      categories.value = await _repository.getAllCategories();
    } catch (e) {
      Get.snackbar('Error', 'Failed to load categories: $e');
    } finally {
      isLoadingCategories.value = false;
    }
  }

  Future<void> fetchAllSuppliers() async {
    isLoadingSuppliers.value = true;
    try {
      suppliers.value = await _repository.getAllSuppliers();
    } catch (e) {
      Get.snackbar('Error', 'Failed to load suppliers: $e');
    } finally {
      isLoadingSuppliers.value = false;
    }
  }

  // UPDATED: Add inventory item with dashboard refresh
  Future<bool> addInventoryItem(InventoryItemModel item) async {
    try {
      final id = await _repository.addInventoryItem(item);
      if (id > 0) {
        final newItem = item.copyWith(id: id);
        inventoryItems.add(newItem);
        sortInventory();
        
        // Refresh dashboard after adding inventory
        await _refreshDashboardIfExists();
        
        Get.snackbar('Success', '${item.name} added to inventory');
        return true;
      }
      return false;
    } catch (e) {
      Get.snackbar('Error', 'Failed to add inventory item: $e');
      return false;
    }
  }

  // UPDATED: Update inventory item with dashboard refresh
  Future<bool> updateInventoryItem(InventoryItemModel item) async {
    try {
      final success = await _repository.updateInventoryItem(item);
      if (success) {
        final index = inventoryItems.indexWhere((i) => i.id == item.id);
        if (index != -1) {
          inventoryItems[index] = item;
          inventoryItems.refresh();
          sortInventory();
        }
        
        // Refresh dashboard after updating inventory
        await _refreshDashboardIfExists();
        
        Get.snackbar('Success', '${item.name} updated');
        return true;
      }
      return false;
    } catch (e) {
      Get.snackbar('Error', 'Failed to update inventory item: $e');
      return false;
    }
  }

  // UPDATED: Delete inventory item with dashboard refresh
  Future<bool> deleteInventoryItem(int id) async {
    try {
      final success = await _repository.deleteInventoryItem(id);
      if (success) {
        inventoryItems.removeWhere((item) => item.id == id);
        
        // Refresh dashboard after deleting inventory
        await _refreshDashboardIfExists();
        
        Get.snackbar('Success', 'Item deleted from inventory');
        return true;
      }
      return false;
    } catch (e) {
      Get.snackbar('Error', 'Failed to delete inventory item: $e');
      return false;
    }
  }

  Future<bool> addCategory(CategoryModel category) async {
    try {
      final id = await _repository.addCategory(category);
      if (id > 0) {
        final newCategory = category.copyWith(id: id);
        categories.add(newCategory);
        Get.snackbar('Success', '${category.name} category added');
        return true;
      }
      return false;
    } catch (e) {
      Get.snackbar('Error', 'Failed to add category: $e');
      return false;
    }
  }

  Future<bool> addSupplier(SupplierModel supplier) async {
    try {
      final id = await _repository.addSupplier(supplier);
      if (id > 0) {
        final newSupplier = supplier.copyWith(id: id);
        suppliers.add(newSupplier);
        Get.snackbar('Success', '${supplier.name} supplier added');
        return true;
      }
      return false;
    } catch (e) {
      Get.snackbar('Error', 'Failed to add supplier: $e');
      return false;
    }
  }

  // UPDATED: Restock inventory item with dashboard refresh
  Future<bool> restockInventoryItem(
    int itemId,
    double quantity,
    double boughtPrice,
    int supplierId,
  ) async {
    try {
      final success = await _repository.restockInventoryItem(
        itemId,
        quantity,
        boughtPrice,
        supplierId,
      );

      if (success) {
        final item = await _repository.getInventoryItemById(itemId);
        if (item != null) {
          final index = inventoryItems.indexWhere((i) => i.id == itemId);
          if (index != -1) {
            inventoryItems[index] = item;
            inventoryItems.refresh();
          }
        }
        
        // Refresh dashboard after restocking
        await _refreshDashboardIfExists();
        
        Get.snackbar('Success', 'Item restocked successfully');
        return true;
      }
      return false;
    } catch (e) {
      Get.snackbar('Error', 'Failed to restock item: $e');
      return false;
    }
  }

  String getImagePathForItem(InventoryItemModel item) {
    if (item.categoryName == null) {
      return AppConstants.categoryItems['other']?['image'] ??
          AppAssets.defaultItem;
    }

    final categoryNameLower = item.categoryName!.toLowerCase();
    final itemNameLower = item.name.toLowerCase();

    if (AppConstants.categoryItems.containsKey(categoryNameLower)) {
      final variants = AppConstants.categoryItems[categoryNameLower]!;

      for (String variant in variants.keys) {
        if (itemNameLower.contains(variant.toLowerCase()) ||
            variant.toLowerCase().contains(itemNameLower)) {
          return variants[variant]!;
        }
      }

      if (variants.isNotEmpty) {
        return variants.values.first;
      }
    }

    for (final categoryKey in AppConstants.categoryItems.keys) {
      if (categoryNameLower.contains(categoryKey) ||
          itemNameLower.contains(categoryKey)) {
        final variants = AppConstants.categoryItems[categoryKey]!;

        for (String variant in variants.keys) {
          if (itemNameLower.contains(variant.toLowerCase())) {
            return variants[variant]!;
          }
        }

        if (variants.isNotEmpty) {
          return variants.values.first;
        }
      }
    }

    return AppConstants.categoryItems['other']?['image'] ??
        AppAssets.defaultItem;
  }

  CategoryModel? findCategoryById(int id) {
    try {
      return categories.firstWhere((category) => category.id == id);
    } catch (e) {
      return null;
    }
  }

  SupplierModel? findSupplierById(int? id) {
    if (id == null) return null;
    try {
      return suppliers.firstWhere((supplier) => supplier.id == id);
    } catch (e) {
      return null;
    }
  }

  void resetFormState() {
    selectedCategoryId.value = 0;
    selectedSupplierId.value = null;
    selectedProductVariant.value = '';
    selectedCategoryName.value = '';
    customProductName.value = '';
  }

  void initializeFormForEdit(InventoryItemModel item) {
    selectedCategoryId.value = item.categoryId;
    selectedSupplierId.value = item.supplierId;
    selectedCategoryName.value = item.categoryName?.toLowerCase() ?? '';
    findMatchingVariant(item.name);
  }

  void findMatchingVariant(String itemName) {
    if (selectedCategoryName.value.isNotEmpty &&
        AppConstants.categoryItems.containsKey(selectedCategoryName.value)) {
      final variants = AppConstants.categoryItems[selectedCategoryName.value]!;
      for (String variant in variants.keys) {
        if (itemName.toLowerCase().contains(variant)) {
          selectedProductVariant.value = variant;
          break;
        }
      }
    }
  }

  void onCategoryChanged(int? categoryId) {
    selectedCategoryId.value = categoryId ?? 0;
    selectedProductVariant.value = '';
    customProductName.value = '';

    if (categoryId != null) {
      final category = findCategoryById(categoryId);
      selectedCategoryName.value = category?.name.toLowerCase() ?? '';
    } else {
      selectedCategoryName.value = '';
    }
  }

  String onProductVariantChanged(String? variant) {
    selectedProductVariant.value = variant ?? '';
    if (variant != null && variant != 'custom') {
      customProductName.value = '';
      return variant.replaceAll('_', ' ').toUpperCase();
    } else if (variant == 'custom') {
      return '';
    }
    return '';
  }

  Map<String, String>? getAvailableVariants() {
    if (selectedCategoryName.value.isNotEmpty &&
        AppConstants.categoryItems.containsKey(selectedCategoryName.value)) {
      return AppConstants.categoryItems[selectedCategoryName.value];
    }
    return null;
  }

  String? getProductImagePath() {
    if (selectedCategoryName.value.isNotEmpty &&
        selectedProductVariant.value.isNotEmpty) {
      final variants = AppConstants.categoryItems[selectedCategoryName.value];
      if (variants != null &&
          variants.containsKey(selectedProductVariant.value)) {
        return variants[selectedProductVariant.value];
      }
    }
    return null;
  }

  Future<bool> saveInventoryItem({
    required String name,
    required double quantity,
    required double boughtPrice,
    required double sellPrice,
    InventoryItemModel? editItem,
  }) async {
    final itemData = InventoryItemModel(
      id: editItem?.id,
      name: name.trim(),
      categoryId: selectedCategoryId.value,
      quantity: quantity,
      boughtPrice: boughtPrice,
      sellPrice: sellPrice,
      supplierId: selectedSupplierId.value,
      lastRestocked: editItem?.lastRestocked ?? DateTime.now(),
      categoryName: findCategoryById(selectedCategoryId.value)?.name,
      supplierName: findSupplierById(selectedSupplierId.value)?.name,
    );

    Get.dialog(
      const Center(child: CircularProgressIndicator()),
      barrierDismissible: false,
    );

    final success =
        editItem != null
            ? await updateInventoryItem(itemData)
            : await addInventoryItem(itemData);

    Get.back();

    if (success) {
      resetFormState();
      Get.snackbar(
        'Success',
        editItem != null
            ? 'Item updated successfully'
            : 'Item added successfully',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
      );
      return true;
    }
    return false;
  }
}