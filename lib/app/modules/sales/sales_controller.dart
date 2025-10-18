import 'package:get/get.dart';
import 'package:yesudua_ventures/app/data/models/inventory_model.dart';
import 'package:yesudua_ventures/app/data/models/sales_model.dart';
import 'package:yesudua_ventures/app/data/repositories/inventory_repository.dart';
import 'package:yesudua_ventures/app/data/repositories/sales_repository.dart';
import 'package:yesudua_ventures/app/modules/dashboard/dashboard_controller.dart';
import 'package:yesudua_ventures/app/modules/inventory/inventory_controller.dart';

class SalesController extends GetxController {
  final SalesRepository _salesRepository;
  final InventoryRepository _inventoryRepository;

  // Observable variables
  final isLoading = false.obs;
  final sales = <SaleModel>[].obs;
  final selectedItems = <SaleItemModel>[].obs;
  final currentSale = Rxn<SaleModel>();
  final currentReceipt = Rxn<ReceiptModel>();
  final customerName = ''.obs;
  final customerContact = ''.obs;
  final totalAmount = 0.0.obs;
  final paidAmount = 0.0.obs;
  final isPaid = false.obs;
  final isPreviewMode = false.obs;
  final isCustomerCopy = true.obs;
  final errorMessage = ''.obs;

  // Store original prices for database operations
  final originalItemPrices = <int, double>{}.obs;

  // Selected sale for viewing details
  final selectedSale = Rxn<SaleModel>();
  final selectedSaleDebtor = Rxn<DebtorModel>();

  // Inventory items for sales page
  final inventoryItems = <InventoryItemModel>[].obs;
  final categories = <CategoryModel>[].obs;
  final selectedCategoryId = Rxn<int>();

  // Computed list of filtered inventory items
  List<InventoryItemModel> get filteredInventoryItems {
    if (selectedCategoryId.value == null) {
      return inventoryItems;
    } else {
      return inventoryItems
          .where((item) => item.categoryId == selectedCategoryId.value)
          .toList();
    }
  }

  SalesController(this._salesRepository, this._inventoryRepository);

  @override
  void onInit() {
    super.onInit();
    fetchAllSales();
    fetchCategories();
    fetchInventoryItems();
  }

  // Fetch all inventory categories
  Future<void> fetchCategories() async {
    try {
      categories.value = await _inventoryRepository.getAllCategories();
    } catch (e) {
      errorMessage.value = 'Failed to load categories: ${e.toString()}';
    }
  }

  // FIXED: Fetch all inventory items with proper refresh
  Future<void> fetchInventoryItems() async {
    isLoading.value = true;
    try {
      // Always get fresh data from repository
      final items = await _inventoryRepository.getAllInventoryItems();
      inventoryItems.value = items;
      inventoryItems.refresh(); // Force UI update
    } catch (e) {
      errorMessage.value = 'Failed to load inventory: ${e.toString()}';
    } finally {
      isLoading.value = false;
    }
  }

  // Search inventory items
  Future<List<InventoryItemModel>> searchInventoryItems(String query) async {
    try {
      return await _inventoryRepository.searchInventoryItems(query);
    } catch (e) {
      errorMessage.value = 'Search failed: ${e.toString()}';
      return [];
    }
  }

  // Fetch all sales
  Future<void> fetchAllSales({
    bool todayOnly = false,
    DateTime? startDate,
    DateTime? endDate,
    bool paidOnly = false,
    bool unpaidOnly = false,
  }) async {
    isLoading.value = true;
    try {
      sales.value = await _salesRepository.getAllSales(
        todayOnly: todayOnly,
        startDate: startDate,
        endDate: endDate,
        paidOnly: paidOnly,
        unpaidOnly: unpaidOnly,
      );
    } catch (e) {
      errorMessage.value = 'Failed to load sales: ${e.toString()}';
    } finally {
      isLoading.value = false;
    }
  }

  // Get sale by ID
  Future<void> getSaleById(int saleId) async {
    isLoading.value = true;
    try {
      selectedSale.value = await _salesRepository.getSaleById(saleId);

      if (selectedSale.value != null && !selectedSale.value!.isPaid) {
        selectedSaleDebtor.value = await _salesRepository.getDebtorForSale(
          saleId,
        );
      } else {
        selectedSaleDebtor.value = null;
      }
    } catch (e) {
      errorMessage.value = 'Failed to load sale details: ${e.toString()}';
    } finally {
      isLoading.value = false;
    }
  }

  // Add item to current sale
  void addItemToSale(SaleItemModel item) {
    final existingItemIndex = selectedItems.indexWhere(
      (i) =>
          i.inventoryItemId == item.inventoryItemId &&
          i.sellPrice == item.sellPrice,
    );

    if (existingItemIndex >= 0) {
      final existingItem = selectedItems[existingItemIndex];
      selectedItems[existingItemIndex] = existingItem.copyWith(
        quantity: existingItem.quantity + item.quantity,
      );
    } else {
      selectedItems.add(item);
      final newIndex = selectedItems.length - 1;
      originalItemPrices[newIndex] = item.sellPrice;
    }

    _updateTotalAmount();
  }

  // Remove item from current sale
  void removeItemFromSale(int index) {
    if (index >= 0 && index < selectedItems.length) {
      selectedItems.removeAt(index);
      originalItemPrices.remove(index);
      _reindexOriginalPrices(index);
      _updateTotalAmount();
    }
  }

  // Reindex original prices after item removal
  void _reindexOriginalPrices(int removedIndex) {
    final newPrices = <int, double>{};
    originalItemPrices.forEach((index, price) {
      if (index > removedIndex) {
        newPrices[index - 1] = price;
      } else if (index < removedIndex) {
        newPrices[index] = price;
      }
    });
    originalItemPrices.value = newPrices;
  }

  // Update item quantity in current sale
  void updateItemQuantity(int index, double newQuantity) {
    if (index >= 0 && index < selectedItems.length && newQuantity > 0) {
      final item = selectedItems[index];
      selectedItems[index] = item.copyWith(quantity: newQuantity);
      _updateTotalAmount();
    }
  }

  // Update item price in current sale (for receipt preview only)
  void updateItemPrice(int index, double newPrice) {
    if (index >= 0 && index < selectedItems.length && newPrice > 0) {
      final item = selectedItems[index];

      if (!originalItemPrices.containsKey(index)) {
        originalItemPrices[index] = item.sellPrice;
      }

      selectedItems[index] = item.copyWith(sellPrice: newPrice);
      _updateTotalAmount();
    }
  }

  // Get original price for database operations
  double getOriginalPrice(int index) {
    return originalItemPrices[index] ?? selectedItems[index].sellPrice;
  }

  // Calculate total amount based on selected items
  void _updateTotalAmount() {
    double total = 0;
    for (var item in selectedItems) {
      total += (item.quantity * item.sellPrice);
    }
    totalAmount.value = total;
  }

  // Clear current sale
  void clearSale() {
    selectedItems.clear();
    originalItemPrices.clear();
    customerName.value = '';
    customerContact.value = '';
    totalAmount.value = 0.0;
    paidAmount.value = 0.0;
    isPaid.value = false;
    isPreviewMode.value = false;
    isCustomerCopy.value = true;
    currentSale.value = null;
    currentReceipt.value = null;
  }

  // Generate receipt for preview
  ReceiptModel generateReceipt({bool isCustomerCopy = true}) {
    final sale = SaleModel(
      customerName: customerName.value.isEmpty ? null : customerName.value,
      customerContact:
          customerContact.value.isEmpty ? null : customerContact.value,
      totalAmount: totalAmount.value,
      paidAmount: paidAmount.value,
      isPaid: isPaid.value,
      saleDate: DateTime.now(),
      items: selectedItems,
    );

    final receipt = ReceiptModel(
      sale: sale,
      items: selectedItems,
      isPreviewMode: true,
      isCustomerCopy: isCustomerCopy,
      editedPaidAmount: paidAmount.value,
    );

    currentReceipt.value = receipt;
    isPreviewMode.value = true;
    this.isCustomerCopy.value = isCustomerCopy;

    return receipt;
  }

  // FIXED: Update inventory quantities after successful sale
  Future<void> _updateInventoryAfterSale() async {
    for (int i = 0; i < selectedItems.length; i++) {
      final item = selectedItems[i];
      if (item.inventoryItemId != null) {
        try {
          // Get fresh inventory item from repository
          final inventoryItem = await _inventoryRepository.getInventoryItemById(
            item.inventoryItemId!,
          );

          if (inventoryItem != null) {
            final newQuantity = inventoryItem.quantity - item.quantity;

            if (newQuantity < 0) {
              print('Warning: Negative stock for ${item.itemName}');
            }

            // Update inventory item quantity
            final updatedItem = inventoryItem.copyWith(quantity: newQuantity);
            await _inventoryRepository.updateInventoryItem(updatedItem);

            // FIXED: Update local inventory list immediately
            final localIndex = inventoryItems.indexWhere(
              (invItem) => invItem.id == item.inventoryItemId,
            );
            if (localIndex != -1) {
              inventoryItems[localIndex] = updatedItem;
            }
          }
        } catch (e) {
          print('Error updating inventory for ${item.itemName}: $e');
        }
      }
    }

    // FIXED: Force refresh of inventory items list
    inventoryItems.refresh();
  }

  // FIXED: Submit sale after receipt approval
  Future<bool> submitSale() async {
    isLoading.value = true;
    try {
      if (selectedItems.isEmpty) {
        errorMessage.value = 'No items added to sale';
        return false;
      }

      // Validate inventory availability before proceeding
      for (int i = 0; i < selectedItems.length; i++) {
        final item = selectedItems[i];
        if (item.inventoryItemId != null) {
          final inventoryItem = await _inventoryRepository.getInventoryItemById(
            item.inventoryItemId!,
          );

          if (inventoryItem == null) {
            errorMessage.value = 'Item ${item.itemName} not found in inventory';
            return false;
          }

          if (inventoryItem.quantity < item.quantity) {
            errorMessage.value =
                'Insufficient stock for ${item.itemName}. Available: ${inventoryItem.quantity}';
            return false;
          }
        }
      }

      // Create sale items with original prices for database
      final saleItemsForDb = <SaleItemModel>[];
      for (int i = 0; i < selectedItems.length; i++) {
        final item = selectedItems[i];
        final originalPrice = getOriginalPrice(i);

        saleItemsForDb.add(item.copyWith(sellPrice: originalPrice));
      }

      // Calculate total with original prices
      final originalTotal = saleItemsForDb.fold(
        0.0,
        (sum, item) => sum + (item.quantity * item.sellPrice),
      );

      // Create sale model with original data
      final sale = SaleModel(
        customerName: customerName.value.isEmpty ? null : customerName.value,
        customerContact:
            customerContact.value.isEmpty ? null : customerContact.value,
        totalAmount: originalTotal,
        paidAmount: paidAmount.value,
        isPaid: isPaid.value,
        saleDate: DateTime.now(),
        items: saleItemsForDb,
      );

      // Save to database
      final saleId = await _salesRepository.createSale(sale);

      // FIXED: Update inventory quantities - this is critical!
      await _updateInventoryAfterSale();

      // Update current sale with ID
      currentSale.value = sale.copyWith(id: saleId);

      // FIXED: Refresh everything in the correct order
      // 1. Refresh sales list
      await fetchAllSales();

      // 2. Force refresh inventory items to show updated quantities
      await fetchInventoryItems();

      // 3. Refresh inventory controller if it exists
      try {
        if (Get.isRegistered<InventoryController>()) {
          final inventoryController = Get.find<InventoryController>();
          await inventoryController.fetchAllInventory();
        }
      } catch (e) {
        print('Inventory controller not found: $e');
      }

      // 4. Refresh dashboard if it exists
      try {
        if (Get.isRegistered<DashboardController>()) {
          final dashboardController = Get.find<DashboardController>();
          await dashboardController.refreshDashboard();
        }
      } catch (e) {
        print('Dashboard controller not found: $e');
      }

      // Clear the cart
      clearSale();

      return true;
    } catch (e) {
      errorMessage.value = 'Failed to save sale: ${e.toString()}';
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  // Update payment status for an existing sale
  Future<bool> updatePayment(
    int saleId,
    double newPaidAmount,
    bool isFullyPaid,
  ) async {
    isLoading.value = true;
    try {
      final success = await _salesRepository.updateSalePayment(
        saleId,
        newPaidAmount,
        isFullyPaid,
      );

      if (success) {
        await fetchAllSales();
        if (selectedSale.value != null && selectedSale.value!.id == saleId) {
          await getSaleById(saleId);
        }
      }

      return success;
    } catch (e) {
      errorMessage.value = 'Failed to update payment: ${e.toString()}';
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  // Delete a sale (for admin purposes)
  Future<bool> deleteSale(int saleId) async {
    isLoading.value = true;
    try {
      final success = await _salesRepository.deleteSale(saleId);

      if (success) {
        await fetchAllSales();

        if (selectedSale.value != null && selectedSale.value!.id == saleId) {
          selectedSale.value = null;
          selectedSaleDebtor.value = null;
        }

        // FIXED: Refresh inventory after sale deletion
        await fetchInventoryItems();

        // Refresh inventory controller if exists
        try {
          if (Get.isRegistered<InventoryController>()) {
            final inventoryController = Get.find<InventoryController>();
            await inventoryController.fetchAllInventory();
          }
        } catch (e) {
          print('Inventory controller not found: $e');
        }
      }

      return success;
    } catch (e) {
      errorMessage.value = 'Failed to delete sale: ${e.toString()}';
      return false;
    } finally {
      isLoading.value = false;
    }
  }
}
