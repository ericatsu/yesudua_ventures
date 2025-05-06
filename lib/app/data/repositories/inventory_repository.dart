import 'package:get/get.dart';
import '../local/drift_database.dart';
import '../remote/supabase_service.dart';

class InventoryRepository extends GetxService {
  final AppDatabase _localDb = Get.find();
  final SupabaseService _remote = Get.find();

  Future<List<InventoryItem>> fetchInventory() async {
    final rows = await _localDb.getAllInventoryItems();
    return rows
        .map(
          (e) => InventoryItem(
            id: e.id,
            name: e.name,
            category: e.category,
            quantity: e.quantity,
            boughtPrice: e.boughtPrice,
            sellPrice: e.sellPrice,
            supplier: e.supplier,
            lastUpdated: e.lastUpdated,
          ),
        )
        .toList();
  }

  Future<void> addInventoryItem(InventoryItemsCompanion item) async {
    final id = await _localDb.insertInventoryItem(item);
    final full = await _localDb.getInventoryItemById(id);
    if (full != null) await _remote.uploadInventoryItem(full);
  }

  Future<void> updateInventoryItem(InventoryItem item) async {
    await _localDb.updateInventoryItem(item);
    await _remote.uploadInventoryItem(item);
  }

  Future<void> deleteInventoryItem(int id) async {
    await _localDb.deleteInventoryItem(id);
  }
}
