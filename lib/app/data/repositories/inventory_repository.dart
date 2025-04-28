import 'package:get/get.dart';
import 'package:yesudua_ventures/app/data/local/drift_database.dart';
import 'package:yesudua_ventures/app/data/remote/supabase_service.dart';
import 'package:yesudua_ventures/app/data/models/inventory_item.dart';

class InventoryRepository extends GetxService {
  final AppDatabase _localDb = Get.find();
  final SupabaseService _supabaseService = Get.find();

  // Fetch all inventory from local DB
  Future<List<InventoryItem>> fetchAllInventory() async {
    final records = await _localDb.getAllInventoryItems();
    return records
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

  // Add item locally and sync remotely
  Future<void> addInventoryItem(InventoryItemsCompanion item) async {
    final id = await _localDb.insertInventoryItem(item);
    final fullItem = await _localDb.getInventoryItemById(id);

    if (fullItem != null) {
      await _supabaseService.uploadInventoryItem(fullItem);
    }
  }

  // Update inventory locally
  Future<void> updateInventoryItem(InventoryItem item) async {
    await _localDb.updateInventoryItem(item);
    await _supabaseService.uploadInventoryItem(item);
  }

  // Delete inventory item locally
  Future<void> deleteInventoryItem(int id) async {
    await _localDb.deleteInventoryItem(id);
    // Optionally delete remotely if you implement delete in Supabase
  }
}
