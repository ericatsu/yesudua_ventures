import 'package:get/get.dart';
import 'package:yesudua_ventures/app/data/models/inventory_model.dart';
import 'package:yesudua_ventures/app/data/models/sales_model.dart';
import 'package:yesudua_ventures/app/data/repositories/inventory_repository.dart';
import 'package:yesudua_ventures/app/data/repositories/sales_repository.dart';

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
      print('Error fetching categories: $e');
    }
  }

  // Fetch all inventory items
  Future<void> fetchInventoryItems() async {
    isLoading.value = true;
    try {
      inventoryItems.value = await _inventoryRepository.getAllInventoryItems();
    } catch (e) {
      errorMessage.value = 'Failed to load inventory: ${e.toString()}';
      print('Error fetching inventory items: $e');
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
      print('Error searching inventory: $e');
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
      print('Error fetching sales: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // Get sale by ID
  Future<void> getSaleById(int saleId) async {
    isLoading.value = true;
    try {
      selectedSale.value = await _salesRepository.getSaleById(saleId);

      // Also fetch debtor information if available
      if (selectedSale.value != null && !selectedSale.value!.isPaid) {
        selectedSaleDebtor.value = await _salesRepository.getDebtorForSale(
          saleId,
        );
      } else {
        selectedSaleDebtor.value = null;
      }
    } catch (e) {
      errorMessage.value = 'Failed to load sale details: ${e.toString()}';
      print('Error fetching sale details: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // Add item to current sale
  void addItemToSale(SaleItemModel item) {
    // Check if we already have this item in the list
    final existingItemIndex = selectedItems.indexWhere(
      (i) =>
          i.inventoryItemId == item.inventoryItemId &&
          i.sellPrice == item.sellPrice,
    );

    if (existingItemIndex >= 0) {
      // Update existing item quantity
      final existingItem = selectedItems[existingItemIndex];
      selectedItems[existingItemIndex] = existingItem.copyWith(
        quantity: existingItem.quantity + item.quantity,
      );
    } else {
      // Add as new item
      selectedItems.add(item);
    }

    // Update total amount
    _updateTotalAmount();
  }

  // Remove item from current sale
  void removeItemFromSale(int index) {
    if (index >= 0 && index < selectedItems.length) {
      selectedItems.removeAt(index);
      _updateTotalAmount();
    }
  }

  // Update item quantity in current sale
  void updateItemQuantity(int index, double newQuantity) {
    if (index >= 0 && index < selectedItems.length && newQuantity > 0) {
      final item = selectedItems[index];
      selectedItems[index] = item.copyWith(quantity: newQuantity);
      _updateTotalAmount();
    }
  }

  // Update item price in current sale
  void updateItemPrice(int index, double newPrice) {
    if (index >= 0 && index < selectedItems.length && newPrice > 0) {
      final item = selectedItems[index];
      selectedItems[index] = item.copyWith(sellPrice: newPrice);
      _updateTotalAmount();
    }
  }

  // Update item bought price in receipt preview
  void updateItemBoughtPrice(int index, double newBoughtPrice) {
    if (index >= 0 && index < selectedItems.length && newBoughtPrice >= 0) {
      final item = selectedItems[index];
      selectedItems[index] = item.copyWith(boughtPrice: newBoughtPrice);
      // No need to update total amount as bought price doesn't affect it
    }
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
    // Create a sale model with current data
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

    // Create receipt model
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

  // Toggle between customer and internal copy
  void toggleReceiptType() {
    if (currentReceipt.value != null) {
      isCustomerCopy.value = !isCustomerCopy.value;
      // Generate new receipt with updated isCustomerCopy value
      generateReceipt(isCustomerCopy: isCustomerCopy.value);
    }
  }

  // Submit sale after receipt approval
  Future<bool> submitSale() async {
    isLoading.value = true;
    try {
      if (selectedItems.isEmpty) {
        errorMessage.value = 'No items added to sale';
        return false;
      }

      // Create sale model
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

      // Save to database
      final saleId = await _salesRepository.createSale(sale);

      // Update current sale with ID
      currentSale.value = sale.copyWith(id: saleId);

      // Refresh sales list and inventory items
      await fetchAllSales();
      await fetchInventoryItems();

      // Clear the cart
      clearSale();

      return true;
    } catch (e) {
      errorMessage.value = 'Failed to save sale: ${e.toString()}';
      print('Error saving sale: $e');
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
        // Refresh sales list and selected sale
        await fetchAllSales();
        if (selectedSale.value != null && selectedSale.value!.id == saleId) {
          await getSaleById(saleId);
        }
      }

      return success;
    } catch (e) {
      errorMessage.value = 'Failed to update payment: ${e.toString()}';
      print('Error updating payment: $e');
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
        // Refresh sales list
        await fetchAllSales();

        // Clear selected sale if it was deleted
        if (selectedSale.value != null && selectedSale.value!.id == saleId) {
          selectedSale.value = null;
          selectedSaleDebtor.value = null;
        }

        // Refresh inventory items
        await fetchInventoryItems();
      }

      return success;
    } catch (e) {
      errorMessage.value = 'Failed to delete sale: ${e.toString()}';
      print('Error deleting sale: $e');
      return false;
    } finally {
      isLoading.value = false;
    }
  }
}
