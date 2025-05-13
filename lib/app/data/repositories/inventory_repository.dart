import 'package:get/get.dart';
import '../local/drift_database.dart' as drift;
import '../models/inventory_item.dart';
import '../remote/supabase_service.dart';

class InventoryRepository extends GetxService {
  final drift.AppDatabase _local = Get.find();
  final SupabaseService _remote = Get.find();

  // Fetch all inventory items
  Future<List<InventoryItem>> getAllItems() async {
    final driftItems = await _local.getAllInventoryItems();
    return driftItems
        .map((driftItem) => InventoryItem.fromDriftItem(driftItem))
        .toList();
  }

  // Add a new inventory item
  Future<int> addItem(InventoryItem item) async {
    try {
      // Add to local database
      final id = await _local.insertInventoryItem(item.toCompanion());

      // Get the inserted item with the new ID
      final insertedItem = await _local.getInventoryItemById(id);

      // Upload to Supabase
      if (insertedItem != null) {
        await _remote.uploadInventoryItem(insertedItem);
      }

      return id;
    } catch (e) {
      throw Exception('Failed to add inventory item: $e');
    }
  }

  // Update an existing inventory item
  Future<bool> updateItem(InventoryItem item) async {
    try {
      // Convert to Drift model
      final driftItem = item.toDriftItem();

      // Update local database
      final success = await _local.updateInventoryItem(driftItem);

      // Upload to Supabase
      if (success) {
        await _remote.uploadInventoryItem(driftItem);
      }

      return success;
    } catch (e) {
      throw Exception('Failed to update inventory item: $e');
    }
  }

  // Delete an inventory item
  Future<bool> deleteItem(int id) async {
    try {
      final rowsAffected = await _local.deleteInventoryItem(id);
      return rowsAffected > 0;
    } catch (e) {
      throw Exception('Failed to delete inventory item: $e');
    }
  }

  // Get inventory item by ID
  Future<InventoryItem?> getItemById(int id) async {
    final driftItem = await _local.getInventoryItemById(id);
    if (driftItem == null) return null;
    return InventoryItem.fromDriftItem(driftItem);
  }

  // Get items by category
  Future<List<InventoryItem>> getItemsByCategory(String category) async {
    final query = _local.select(_local.inventoryItems)
      ..where((tbl) => tbl.category.equals(category));

    final driftItems = await query.get();
    return driftItems.map((item) => InventoryItem.fromDriftItem(item)).toList();
  }

  // Get items by supplier
  Future<List<InventoryItem>> getItemsBySupplier(String supplier) async {
    final query = _local.select(_local.inventoryItems)
      ..where((tbl) => tbl.supplier.equals(supplier));

    final driftItems = await query.get();
    return driftItems.map((item) => InventoryItem.fromDriftItem(item)).toList();
  }

  // Get all unique categories
  Future<List<String>> getAllCategories() async {
    final items = await getAllItems();
    return items.map((item) => item.category).toSet().toList();
  }

  // Get all unique suppliers
  Future<List<String>> getAllSuppliers() async {
    final items = await getAllItems();
    return items
        .where((item) => item.supplier != null && item.supplier!.isNotEmpty)
        .map((item) => item.supplier!)
        .toSet()
        .toList();
  }
}