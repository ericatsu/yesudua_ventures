import 'package:get/get.dart';
import 'package:yesudua_ventures/app/data/models/inventory_model.dart';
import 'package:yesudua_ventures/app/data/repositories/inventory_repository.dart';
import 'package:yesudua_ventures/app/core/utils/constants.dart';

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
  final RxString sortBy =
      'name'.obs; // Options: 'name', 'quantity', 'sellPrice'
  final RxBool sortAscending = true.obs;

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

      // Create a set of existing category names (case-insensitive)
      final existingCategoryNames =
          existingCategories.map((c) => c.name.toLowerCase()).toSet();

      // Add any predefined categories that don't exist yet
      for (final categoryName in AppConstants.predefinedCategories) {
        if (!existingCategoryNames.contains(categoryName.toLowerCase())) {
          await _repository.addCategory(CategoryModel(name: categoryName));
        }
      }

      // Refresh categories list
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

  // Add inventory item
  Future<bool> addInventoryItem(InventoryItemModel item) async {
    try {
      final id = await _repository.addInventoryItem(item);
      if (id > 0) {
        // Add ID to the item
        final newItem = item.copyWith(id: id);
        inventoryItems.add(newItem);
        sortInventory();
        Get.snackbar('Success', '${item.name} added to inventory');
        return true;
      }
      return false;
    } catch (e) {
      Get.snackbar('Error', 'Failed to add inventory item: $e');
      return false;
    }
  }

  // Update inventory item
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
        Get.snackbar('Success', '${item.name} updated');
        return true;
      }
      return false;
    } catch (e) {
      Get.snackbar('Error', 'Failed to update inventory item: $e');
      return false;
    }
  }

  // Delete inventory item
  Future<bool> deleteInventoryItem(int id) async {
    try {
      final success = await _repository.deleteInventoryItem(id);
      if (success) {
        inventoryItems.removeWhere((item) => item.id == id);
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

  // Restock inventory item
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
        // Refresh the item after restock
        final item = await _repository.getInventoryItemById(itemId);
        if (item != null) {
          final index = inventoryItems.indexWhere((i) => i.id == itemId);
          if (index != -1) {
            inventoryItems[index] = item;
            inventoryItems.refresh();
          }
        }
        Get.snackbar('Success', 'Item restocked successfully');
        return true;
      }
      return false;
    } catch (e) {
      Get.snackbar('Error', 'Failed to restock item: $e');
      return false;
    }
  }

  // Get image path for inventory item based on category
  String getImagePathForItem(InventoryItemModel item) {
    if (item.categoryName == null) return AppConstants.itemImages['default']!;

    final categoryNameLower = item.categoryName!.toLowerCase();

    for (final key in AppConstants.itemImages.keys) {
      if (categoryNameLower.contains(key)) {
        return AppConstants.itemImages[key]!;
      }
    }

    return AppConstants.itemImages['default']!;
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
}