import 'package:get/get.dart';
import '../local/drift_database.dart' as drift;
import '../models/inventory_item.dart';
import '../remote/supabase_service.dart';
import '../../core/services/connectivity_service.dart';
import '../../core/utils/logger.dart';

class InventoryRepository extends GetxService {
  final drift.AppDatabase _local = Get.find();
  final SupabaseService _remote = Get.find();
  final ConnectivityService _connectivityService = Get.find();

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
      // Add to local database first
      final id = await _local.insertInventoryItem(item.toCompanion());
      Logger.i('InventoryRepository', 'Added item locally with ID: $id');

      // Get the inserted item with the new ID
      final insertedItem = await _local.getInventoryItemById(id);

      // Try to sync with Supabase if online
      if (insertedItem != null && _connectivityService.isOnline.value) {
        try {
          await _remote.uploadInventoryItem(insertedItem);
          Logger.i('InventoryRepository', 'Item synced with Supabase');
        } catch (e) {
          // Just log the error but don't fail the operation
          // The sync service will handle this later
          Logger.e(
            'InventoryRepository',
            'Failed to sync with Supabase, will try later',
            error: e,
          );
          // Mark item for later sync
          await _markItemForSync(id);
        }
      } else {
        // Mark for future syncing
        await _markItemForSync(id);
        Logger.i(
          'InventoryRepository',
          'Device offline, item marked for future sync',
        );
      }

      return id;
    } catch (e) {
      Logger.e('InventoryRepository', 'Failed to add inventory item', error: e);
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
      Logger.i(
        'InventoryRepository',
        'Updated item locally: ${success ? "success" : "failed"}',
      );

      // Try to sync with Supabase if online
      if (success && _connectivityService.isOnline.value) {
        try {
          await _remote.uploadInventoryItem(driftItem);
          Logger.i('InventoryRepository', 'Item update synced with Supabase');
        } catch (e) {
          // Log the error but don't fail the operation
          Logger.e(
            'InventoryRepository',
            'Failed to sync update with Supabase, will try later',
            error: e,
          );
          // Mark for later sync
          await _markItemForSync(item.id);
        }
      } else if (success) {
        // Mark for future syncing
        await _markItemForSync(item.id);
        Logger.i(
          'InventoryRepository',
          'Device offline, update marked for future sync',
        );
      }

      return success;
    } catch (e) {
      Logger.e(
        'InventoryRepository',
        'Failed to update inventory item',
        error: e,
      );
      throw Exception('Failed to update inventory item: $e');
    }
  }

  // Mark item for sync
  Future<void> _markItemForSync(int itemId) async {
    // Implementation depends on how you track pending sync items
    // This could be a simple flag in the database
    try {
      await _local.markItemForSync(itemId);
    } catch (e) {
      Logger.e('InventoryRepository', 'Failed to mark item for sync', error: e);
    }
  }

  // Delete an inventory item
  Future<bool> deleteItem(int id) async {
    try {
      final rowsAffected = await _local.deleteInventoryItem(id);

      // Try to delete from Supabase if online
      if (rowsAffected > 0 && _connectivityService.isOnline.value) {
        try {
          await _remote.deleteInventoryItem(id);
          Logger.i('InventoryRepository', 'Item deletion synced with Supabase');
        } catch (e) {
          // Just log the error but don't fail the operation
          Logger.e(
            'InventoryRepository',
            'Failed to sync deletion with Supabase',
            error: e,
          );
          // Could track deletions for later sync
        }
      }

      return rowsAffected > 0;
    } catch (e) {
      Logger.e(
        'InventoryRepository',
        'Failed to delete inventory item',
        error: e,
      );
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

  // Get items that need syncing
  Future<List<drift.InventoryItem>> getPendingSyncItems() async {
    return await _local.getPendingSyncItems();
  }
}
