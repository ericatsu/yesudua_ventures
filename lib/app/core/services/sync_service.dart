import 'package:get/get.dart';
import 'package:yesudua_ventures/app/core/utils/logger.dart';
import 'connectivity_service.dart';

class SyncService extends GetxService {
  final ConnectivityService _connectivityService = Get.find();

  @override
  void onInit() {
    super.onInit();
    ever(_connectivityService.isOnline, (online) {
      if (online == true) {
        syncData();
      }
    });
  }

  Future<void> syncData() async {
    //Logger.i('Syncing data with cloud...');

    try {
      await _syncPendingInventoryItems();
      // Add other sync operations here (sales, debtors, etc.)

      //Logger.s('Sync completed successfully');
    } catch (e) {
     // Logger.e('Sync failed: $e');
    }
  }

  Future<void> _syncPendingInventoryItems() async {
    // Implementation will depend on how you track pending items
    // This is just a placeholder for now
    //Logger.i('Syncing pending inventory items...');
  }
}