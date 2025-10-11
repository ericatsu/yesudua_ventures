import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yesudua_ventures/app/core/utils/constants.dart';
import 'package:yesudua_ventures/app/data/models/inventory_model.dart';
import 'package:yesudua_ventures/app/data/repositories/inventory_repository.dart';
import 'package:yesudua_ventures/app/modules/sales/sales_controller.dart';

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
  final RxString selectedCategoryName = ''.obs;
  final RxnString selectedImagePath = RxnString();

  // Constructor
  InventoryController(this._repository);

  @override
  void onInit() {
    super.onInit();
    fetchAllInventory();
    fetchAllCategories();
    fetchAllSuppliers();
    ensurePredefinedCategories();

    // Listen to changes in search query
    debounce(
      searchQuery,
      (_) => searchInventory(),
      time: const Duration(milliseconds: 500),
    );
  }

  // Fetch all inventory items
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

  // Search inventory items
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

  Future<void> ensurePredefinedCategories() async {
    try {
      final existingCategories = await _repository.getAllCategories();

      final existingCategoryNames =
          existingCategories.map((c) => c.name.toLowerCase()).toSet();

      for (final categoryName in AppConstants.categoryNames) {
        if (!existingCategoryNames.contains(categoryName.toLowerCase())) {
          await _repository.addCategory(CategoryModel(name: categoryName));
        }
      }

      await fetchAllCategories();
    } catch (e) {
      Get.snackbar('Error', 'Failed to initialize predefined categories: $e');
    }
  }

  // Filter by category
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

  // Sort inventory items
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

  // Change sort option
  void changeSortOption(String option) {
    if (sortBy.value == option) {
      sortAscending.toggle();
    } else {
      sortBy.value = option;
      sortAscending.value = true;
    }
    sortInventory();
  }

  // Fetch all categories
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

  // Fetch all suppliers
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

  // FIXED: Add inventory item with sales controller refresh
  Future<bool> addInventoryItem(InventoryItemModel item) async {
    try {
      final id = await _repository.addInventoryItem(item);
      if (id > 0) {
        final newItem = item.copyWith(id: id);
        inventoryItems.add(newItem);
        sortInventory();

        // FIXED: Refresh sales controller if it exists
        _refreshSalesController();

        Get.snackbar('Success', '${item.name} added to inventory');
        return true;
      }
      return false;
    } catch (e) {
      Get.snackbar('Error', 'Failed to add inventory item: $e');
      return false;
    }
  }

  // FIXED: Update inventory item with sales controller refresh
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

        // FIXED: Refresh sales controller if it exists
        _refreshSalesController();

        Get.snackbar('Success', '${item.name} updated');
        return true;
      }
      return false;
    } catch (e) {
      Get.snackbar('Error', 'Failed to update inventory item: $e');
      return false;
    }
  }

  // FIXED: Delete inventory item with sales controller refresh
  Future<bool> deleteInventoryItem(int id) async {
    try {
      final success = await _repository.deleteInventoryItem(id);
      if (success) {
        inventoryItems.removeWhere((item) => item.id == id);

        // FIXED: Refresh sales controller if it exists
        _refreshSalesController();

        Get.snackbar('Success', 'Item deleted from inventory');
        return true;
      }
      return false;
    } catch (e) {
      Get.snackbar('Error', 'Failed to delete inventory item: $e');
      return false;
    }
  }

  // Add category
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

  // Add supplier
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

  // FIXED: Restock inventory item with sales controller refresh
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

        // FIXED: Refresh sales controller if it exists
        _refreshSalesController();

        Get.snackbar('Success', 'Item restocked successfully');
        return true;
      }
      return false;
    } catch (e) {
      Get.snackbar('Error', 'Failed to restock item: $e');
      return false;
    }
  }

  // Get image path for inventory item
  String getImagePathForItem(InventoryItemModel item) {
    if (item.imagePath != null && item.imagePath!.isNotEmpty) {
      return item.imagePath!;
    }

    if (item.categoryName != null) {
      return AppConstants.getDefaultImageForCategory(item.categoryName!);
    }

    return AppConstants.getDefaultImageForCategory('other');
  }

  // Find category by ID
  CategoryModel? findCategoryById(int id) {
    try {
      return categories.firstWhere((category) => category.id == id);
    } catch (e) {
      return null;
    }
  }

  // Find supplier by ID
  SupplierModel? findSupplierById(int? id) {
    if (id == null) return null;
    try {
      return suppliers.firstWhere((supplier) => supplier.id == id);
    } catch (e) {
      return null;
    }
  }

  // Reset form state
  void resetFormState() {
    selectedCategoryId.value = 0;
    selectedSupplierId.value = null;
    selectedCategoryName.value = '';
    selectedImagePath.value = null;
  }

  // Initialize form for editing
  void initializeFormForEdit(InventoryItemModel item) {
    selectedCategoryId.value = item.categoryId;
    selectedSupplierId.value = item.supplierId;
    selectedCategoryName.value = item.categoryName?.toLowerCase() ?? '';
    selectedImagePath.value = item.imagePath;
  }

  // Handle category change
  void onCategoryChanged(int? categoryId) {
    selectedCategoryId.value = categoryId ?? 0;

    if (categoryId != null) {
      final category = findCategoryById(categoryId);
      selectedCategoryName.value = category?.name.toLowerCase() ?? '';
    } else {
      selectedCategoryName.value = '';
    }
  }

  // Set custom image path
  void setImagePath(String? path) {
    selectedImagePath.value = path;
  }

  // Get current image path (custom or default)
  String getCurrentImagePath() {
    if (selectedImagePath.value != null &&
        selectedImagePath.value!.isNotEmpty) {
      return selectedImagePath.value!;
    }

    if (selectedCategoryName.value.isNotEmpty) {
      return AppConstants.getDefaultImageForCategory(
        selectedCategoryName.value,
      );
    }

    return AppConstants.getDefaultImageForCategory('other');
  }

  // FIXED: Save inventory item (handles both add and update) with refresh
  Future<bool> saveInventoryItem({
    required String name,
    required double quantity,
    required double boughtPrice,
    required double sellPrice,
    InventoryItemModel? editItem,
  }) async {
    try {
      final itemData = InventoryItemModel(
        id: editItem?.id,
        name: name.trim(),
        categoryId: selectedCategoryId.value,
        quantity: quantity,
        boughtPrice: boughtPrice,
        sellPrice: sellPrice,
        supplierId: selectedSupplierId.value,
        imagePath: selectedImagePath.value,
        lastRestocked: editItem?.lastRestocked ?? DateTime.now(),
        categoryName: findCategoryById(selectedCategoryId.value)?.name,
        supplierName: findSupplierById(selectedSupplierId.value)?.name,
      );

      bool success;

      if (editItem != null) {
        // Update existing item
        success = await updateInventoryItem(itemData);
      } else {
        // Add new item
        final id = await _repository.addInventoryItem(itemData);
        success = id > 0;

        if (success) {
          // Fetch the newly created item with all relations
          final newItem = await _repository.getInventoryItemById(id);
          if (newItem != null) {
            inventoryItems.add(newItem);
            sortInventory();
          }
        }
      }

      if (success) {
        // Reset form state
        resetFormState();

        // FIXED: Refresh sales controller
        _refreshSalesController();

        return true;
      }
      return false;
    } catch (e) {
      debugPrint('Error saving inventory item: $e');
      return false;
    }
  }

  // FIXED: Helper method to refresh sales controller
  void _refreshSalesController() {
    try {
      if (Get.isRegistered<SalesController>()) {
        final salesController = Get.find<SalesController>();
        // Trigger refresh of inventory items in sales controller
        salesController.fetchInventoryItems();
      }
    } catch (e) {
      print('Sales controller not found or refresh failed: $e');
    }
  }
}
