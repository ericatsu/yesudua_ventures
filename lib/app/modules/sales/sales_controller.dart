import 'package:get/get.dart';
import '../../data/models/inventory_item.dart';
import '../../data/models/sale.dart';

class CartItem {
  final InventoryItem item;
  int quantity;
  double sellPrice;

  CartItem({required this.item, this.quantity = 1, required this.sellPrice});
}

class SalesController extends GetxController {
  var inventoryItems = <InventoryItem>[].obs;
  var cart = <CartItem>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadInventory(); // replace with real repo later
  }

  void loadInventory() {
    inventoryItems.value = [
      InventoryItem(
        id: 1,
        name: "Treated Wood",
        category: "Wood",
        quantity: 50,
        boughtPrice: 40,
        sellPrice: 60,
      ),
      InventoryItem(
        id: 2,
        name: "Cement",
        category: "Materials",
        quantity: 100,
        boughtPrice: 30,
        sellPrice: 45,
      ),
    ];
  }

  void addToCart(InventoryItem item) {
    final existing = cart.firstWhereOrNull((c) => c.item.id == item.id);
    if (existing != null) {
      existing.quantity += 1;
    } else {
      cart.add(CartItem(item: item, sellPrice: item.sellPrice));
    }
    cart.refresh();
  }

  double get totalAmount =>
      cart.fold(0.0, (sum, c) => sum + (c.sellPrice * c.quantity));

  void removeFromCart(CartItem item) {
    cart.remove(item);
  }

  void clearCart() {
    cart.clear();
  }

  void submitSale({required bool isPaid}) {
    // TODO: Persist to Drift and Supabase
    print('Sale submitted: isPaid = $isPaid');
    clearCart();
  }
}