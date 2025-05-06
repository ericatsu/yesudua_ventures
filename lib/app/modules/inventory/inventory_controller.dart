import 'package:get/get.dart';
import '../../data/models/inventory_item.dart';

class InventoryController extends GetxController {
  var items = <InventoryItem>[].obs;

  final name = ''.obs;
  final category = ''.obs;
  final quantity = 0.obs;
  final boughtPrice = 0.0.obs;
  final sellPrice = 0.0.obs;

  @override
  void onInit() {
    super.onInit();
    loadInventory();
  }

  void loadInventory() {
    // Mocked for now. Replace with repository call.
    items.value = [
      InventoryItem(
        id: 1,
        name: "Treated Wood",
        category: "Wood",
        quantity: 50,
        boughtPrice: 40.0,
        sellPrice: 60.0,
      ),
      InventoryItem(
        id: 2,
        name: "Cement",
        category: "Materials",
        quantity: 100,
        boughtPrice: 30.0,
        sellPrice: 45.0,
      ),
    ];
  }

  void addItem() {
    final newItem = InventoryItem(
      id: items.length + 1,
      name: name.value,
      category: category.value,
      quantity: quantity.value,
      boughtPrice: boughtPrice.value,
      sellPrice: sellPrice.value,
    );
    items.add(newItem);
    resetForm();
  }

  void resetForm() {
    name.value = '';
    category.value = '';
    quantity.value = 0;
    boughtPrice.value = 0.0;
    sellPrice.value = 0.0;
  }

  void restockItem(InventoryItem item, int addedQty, double? newBoughtPrice) {
    final updatedItem = InventoryItem(
      id: item.id,
      name: item.name,
      category: item.category,
      quantity: item.quantity + addedQty,
      boughtPrice: newBoughtPrice ?? item.boughtPrice,
      sellPrice: item.sellPrice,
      supplier: item.supplier,
      lastUpdated: DateTime.now(),
    );

    final index = items.indexWhere((e) => e.id == item.id);
    if (index != -1) {
      items[index] = updatedItem;
      items.refresh();
    }
  }

}
