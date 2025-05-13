import 'package:get/get.dart';
import '../../data/models/inventory_item.dart';
import '../../data/repositories/inventory_repository.dart';
import '../../core/utils/snackbar_utils.dart';

class InventoryController extends GetxController {
  final InventoryRepository _repository = Get.find<InventoryRepository>();

  // Observable variables
  final items = <InventoryItem>[].obs;
  final filteredItems = <InventoryItem>[].obs;
  final categories = <String>[].obs;
  final suppliers = <String>[].obs;
  final isLoading = false.obs;
  final hasError = false.obs;
  final errorMessage = ''.obs;

  // Form variables for add/edit
  final name = ''.obs;
  final category = ''.obs;
  final quantity = 0.obs;
  final boughtPrice = 0.0.obs;
  final sellPrice = 0.0.obs;
  final supplier = ''.obs;
  final selectedImage = ''.obs;

  // Current selected filters
  final selectedCategory = RxString('');
  final selectedSupplier = RxString('');
  final searchQuery = RxString('');

  @override
  void onInit() {
    super.onInit();
    loadInventory();
    loadCategories();
    loadSuppliers();
  }

  // Load all inventory items
  Future<void> loadInventory() async {
    isLoading.value = true;
    hasError.value = false;

    try {
      items.value = await _repository.getAllItems();
      applyFilters(); // Apply any existing filters to the loaded items
    } catch (e) {
      hasError.value = true;
      errorMessage.value = e.toString();
      SnackbarUtils.showError('Failed to load inventory', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  // Load all categories
  Future<void> loadCategories() async {
    try {
      categories.value = await _repository.getAllCategories();
    } catch (e) {
      SnackbarUtils.showError('Failed to load categories', e.toString());
    }
  }

  // Load all suppliers
  Future<void> loadSuppliers() async {
    try {
      suppliers.value = await _repository.getAllSuppliers();
    } catch (e) {
      SnackbarUtils.showError('Failed to load suppliers', e.toString());
    }
  }

  // Add a new inventory item
  Future<bool> addItem() async {
    if (!validateItemForm()) return false;

    isLoading.value = true;
    try {
      final newItem = InventoryItem(
        id: 0, // ID will be assigned by the database
        name: name.value,
        category: category.value,
        quantity: quantity.value,
        boughtPrice: boughtPrice.value,
        sellPrice: sellPrice.value,
        supplier: supplier.value.isEmpty ? null : supplier.value,
        imageKey: selectedImage.value.isEmpty ? null : selectedImage.value,
        lastUpdated: DateTime.now(),
      );

      final id = await _repository.addItem(newItem);

      if (id > 0) {
        // Refresh the inventory list
        await loadInventory();

        // Update categories and suppliers if new ones were added
        if (!categories.contains(category.value)) {
          categories.add(category.value);
        }

        if (supplier.value.isNotEmpty && !suppliers.contains(supplier.value)) {
          suppliers.add(supplier.value);
        }

        resetForm();
        SnackbarUtils.showSuccess('Success', 'Item added successfully');
        return true;
      } else {
        SnackbarUtils.showError('Error', 'Failed to add item');
        return false;
      }
    } catch (e) {
      SnackbarUtils.showError('Error', 'Failed to add item: ${e.toString()}');
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  // Update an existing inventory item
  Future<bool> updateItem(InventoryItem item) async {
    if (!validateItemForm()) return false;

    isLoading.value = true;
    try {
      final updatedItem = item.copyWith(
        name: name.value,
        category: category.value,
        quantity: quantity.value,
        boughtPrice: boughtPrice.value,
        sellPrice: sellPrice.value,
        supplier: supplier.value.isEmpty ? null : supplier.value,
        imageKey: selectedImage.value.isEmpty ? null : selectedImage.value,
        lastUpdated: DateTime.now(),
      );

      final success = await _repository.updateItem(updatedItem);

      if (success) {
        // Refresh the inventory list
        await loadInventory();

        // Update categories and suppliers if new ones were added
        if (!categories.contains(category.value)) {
          categories.add(category.value);
        }

        if (supplier.value.isNotEmpty && !suppliers.contains(supplier.value)) {
          suppliers.add(supplier.value);
        }

        resetForm();
        SnackbarUtils.showSuccess('Success', 'Item updated successfully');
        return true;
      } else {
        SnackbarUtils.showError('Error', 'Failed to update item');
        return false;
      }
    } catch (e) {
      SnackbarUtils.showError(
        'Error',
        'Failed to update item: ${e.toString()}',
      );
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  // Delete an inventory item
  Future<bool> deleteItem(int id) async {
    isLoading.value = true;
    try {
      final success = await _repository.deleteItem(id);

      if (success) {
        // Remove the item from the list
        items.removeWhere((item) => item.id == id);

        // Also remove from filtered items if present
        filteredItems.removeWhere((item) => item.id == id);

        SnackbarUtils.showSuccess('Success', 'Item deleted successfully');
        return true;
      } else {
        SnackbarUtils.showError('Error', 'Failed to delete item');
        return false;
      }
    } catch (e) {
      SnackbarUtils.showError(
        'Error',
        'Failed to delete item: ${e.toString()}',
      );
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  // Restock an inventory item
  Future<bool> restockItem(
    InventoryItem item,
    int addedQty,
    double? newBoughtPrice,
  ) async {
    if (addedQty <= 0) {
      SnackbarUtils.showError(
        'Invalid Quantity',
        'Quantity must be greater than 0',
      );
      return false;
    }

    isLoading.value = true;
    try {
      final updatedItem = item.copyWith(
        quantity: item.quantity + addedQty,
        boughtPrice: newBoughtPrice ?? item.boughtPrice,
        lastUpdated: DateTime.now(),
      );

      final success = await _repository.updateItem(updatedItem);

      if (success) {
        // Update the item in the lists
        final index = items.indexWhere((e) => e.id == item.id);
        if (index != -1) {
          items[index] = updatedItem;
        }

        final filteredIndex = filteredItems.indexWhere((e) => e.id == item.id);
        if (filteredIndex != -1) {
          filteredItems[filteredIndex] = updatedItem;
        }

        SnackbarUtils.showSuccess('Success', 'Item restocked successfully');
        return true;
      } else {
        SnackbarUtils.showError('Error', 'Failed to restock item');
        return false;
      }
    } catch (e) {
      SnackbarUtils.showError(
        'Error',
        'Failed to restock item: ${e.toString()}',
      );
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  // Load form with item data for editing
  void loadItemToForm(InventoryItem item) {
    name.value = item.name;
    category.value = item.category;
    quantity.value = item.quantity;
    boughtPrice.value = item.boughtPrice;
    sellPrice.value = item.sellPrice;
    supplier.value = item.supplier ?? '';
    selectedImage.value = item.imageKey ?? '';
  }

  // Reset form values
  void resetForm() {
    name.value = '';
    category.value = '';
    quantity.value = 0;
    boughtPrice.value = 0.0;
    sellPrice.value = 0.0;
    supplier.value = '';
    selectedImage.value = '';
  }

  // Validate form values
  bool validateItemForm() {
    if (name.value.isEmpty) {
      SnackbarUtils.showError('Validation Error', 'Name is required');
      return false;
    }

    if (category.value.isEmpty) {
      SnackbarUtils.showError('Validation Error', 'Category is required');
      return false;
    }

    if (quantity.value < 0) {
      SnackbarUtils.showError(
        'Validation Error',
        'Quantity cannot be negative',
      );
      return false;
    }

    if (boughtPrice.value < 0) {
      SnackbarUtils.showError(
        'Validation Error',
        'Bought price cannot be negative',
      );
      return false;
    }

    if (sellPrice.value < 0) {
      SnackbarUtils.showError(
        'Validation Error',
        'Sell price cannot be negative',
      );
      return false;
    }

    return true;
  }

  // Filter items by category and search query
  void applyFilters() {
    var result = List<InventoryItem>.from(items);

    // Filter by category if selected
    if (selectedCategory.value.isNotEmpty) {
      result =
          result
              .where((item) => item.category == selectedCategory.value)
              .toList();
    }

    // Filter by supplier if selected
    if (selectedSupplier.value.isNotEmpty) {
      result =
          result
              .where(
                (item) =>
                    item.supplier != null &&
                    item.supplier == selectedSupplier.value,
              )
              .toList();
    }

    // Filter by search query if provided
    if (searchQuery.value.isNotEmpty) {
      final query = searchQuery.value.toLowerCase();
      result =
          result
              .where(
                (item) =>
                    item.name.toLowerCase().contains(query) ||
                    item.category.toLowerCase().contains(query) ||
                    (item.supplier != null &&
                        item.supplier!.toLowerCase().contains(query)),
              )
              .toList();
    }

    filteredItems.value = result;
  }

  // Set category filter
  void setSelectedCategory(String categoryValue) {
    selectedCategory.value = categoryValue;
    applyFilters();
  }

  // Set supplier filter
  void setSelectedSupplier(String supplierValue) {
    selectedSupplier.value = supplierValue;
    applyFilters();
  }

  // Set search query
  void setSearchQuery(String query) {
    searchQuery.value = query;
    applyFilters();
  }

  // Reset all filters
  void resetFilters() {
    selectedCategory.value = '';
    selectedSupplier.value = '';
    searchQuery.value = '';
    filteredItems.value = items;
  }
}