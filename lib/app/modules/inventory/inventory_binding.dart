import 'package:get/get.dart';
import 'package:yesudua_ventures/app/data/local/app_database.dart';
import 'package:yesudua_ventures/app/data/repositories/inventory_repository.dart';
import 'package:yesudua_ventures/app/modules/inventory/inventory_controller.dart';

class InventoryBinding extends Bindings {
  @override
  void dependencies() {
    // Make sure AppDatabase is available
    if (!Get.isRegistered<AppDatabase>()) {
      Get.put(AppDatabase(), permanent: true);
    }

    // Register repository if not registered
    if (!Get.isRegistered<InventoryRepository>()) {
      Get.lazyPut<InventoryRepository>(
        () => InventoryRepositoryImpl(Get.find<AppDatabase>()),
        fenix: true,
      );
    }

    // Register controller
    Get.lazyPut<InventoryController>(
      () => InventoryController(Get.find<InventoryRepository>()),
    );
  }
}
