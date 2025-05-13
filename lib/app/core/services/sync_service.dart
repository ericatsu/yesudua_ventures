import 'package:get/get.dart';
import 'package:yesudua_ventures/app/core/utils/logger.dart';
import 'package:yesudua_ventures/app/data/local/drift_database.dart';
import 'package:yesudua_ventures/app/data/remote/supabase_service.dart';
import 'package:yesudua_ventures/app/data/repositories/inventory_repository.dart';
import 'connectivity_service.dart';

class SyncService extends GetxService {
  final ConnectivityService _connectivityService = Get.find();
  final AppDatabase _localDb = Get.find();
  final SupabaseService _remote = Get.find();
  final InventoryRepository _inventoryRepository =
      Get.find<InventoryRepository>();

  final RxBool isSyncing = false.obs;
  final RxInt pendingSyncItems = 0.obs;

  @override
  void onInit() {
    super.onInit();
    // Check for pending sync items on startup
    _checkPendingSyncItems();

    // Listen for connectivity changes
    ever(_connectivityService.isOnline, (online) {
      if (online == true) {
        Logger.i('SyncService', 'Device is online, starting sync');
        syncData();
      } else {
        Logger.i('SyncService', 'Device went offline');
      }
    });

    // Schedule periodic sync checks (every 30 minutes)
    _scheduleSyncChecks();
  }

  void _scheduleSyncChecks() {
    Future.delayed(const Duration(minutes: 30), () {
      if (_connectivityService.isOnline.value) {
        syncData();
      }
      _scheduleSyncChecks(); // Reschedule next check
    });
  }

  Future<void> _checkPendingSyncItems() async {
    try {
      final pendingItems = await _localDb.getPendingSyncItems();
      pendingSyncItems.value = pendingItems.length;
      Logger.i('SyncService', 'Pending sync items: ${pendingItems.length}');
    } catch (e) {
      Logger.e('SyncService', 'Failed to check pending sync items', error: e);
    }
  }

  Future<void> syncData() async {
    // Check if already syncing
    if (isSyncing.value) {
      Logger.i('SyncService', 'Sync already in progress, skipping');
      return;
    }

    // Check if online
    if (!_connectivityService.isOnline.value) {
      Logger.i('SyncService', 'Device offline, syncing canceled');
      return;
    }

    if (!_remote.isInitialized.value) {
      Logger.e('SyncService', 'Supabase not initialized, sync canceled');
      return;
    }

    isSyncing.value = true;
    Logger.i('SyncService', 'Starting data sync...');

    try {
      // Sync inventory items
      await _syncPendingInventoryItems();

      // Add other sync operations here
      // await _syncPendingSales();
      // await _syncPendingDebtors();
      // await _syncPendingSuppliers();

      Logger.i('SyncService', 'Sync completed successfully');

      // Update pending items count
      await _checkPendingSyncItems();
    } catch (e) {
      Logger.e('SyncService', 'Sync failed', error: e);
    } finally {
      isSyncing.value = false;
    }
  }

  Future<void> _syncPendingInventoryItems() async {
    try {
      Logger.i('SyncService', 'Syncing pending inventory items...');

      // Get all items marked for sync
      final pendingItems = await _localDb.getPendingSyncItems();
      Logger.i(
        'SyncService',
        'Found ${pendingItems.length} pending inventory items',
      );

      if (pendingItems.isEmpty) return;

      int successCount = 0;
      for (var item in pendingItems) {
        try {
          await _remote.uploadInventoryItem(item);

          // Mark as synced
          await _localDb.markItemAsSynced(item.id);
          successCount++;
        } catch (e) {
          Logger.e('SyncService', 'Failed to sync item ${item.id}', error: e);
          // Keep as pending for next sync attempt
        }
      }

      Logger.i(
        'SyncService',
        'Successfully synced $successCount/${pendingItems.length} inventory items',
      );
    } catch (e) {
      Logger.e(
        'SyncService',
        'Error syncing pending inventory items',
        error: e,
      );
      throw e;
    }
  }
}
