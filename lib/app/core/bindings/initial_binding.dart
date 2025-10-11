import 'package:get/get.dart';
import 'package:yesudua_ventures/app/data/local/app_database.dart';
import 'package:yesudua_ventures/app/data/repositories/inventory_repository.dart';
import 'package:yesudua_ventures/app/data/repositories/sales_repository.dart';
import 'package:yesudua_ventures/app/modules/inventory/inventory_controller.dart';
import 'package:yesudua_ventures/app/modules/sidebar/sidebar_controller.dart';

class InitialBinding implements Bindings {
  @override
  void dependencies() {
    Get.put(AppDatabase(), permanent: true);
    
    Get.put(SidebarController(), permanent: true);

    Get.lazyPut<InventoryRepository>(
      () => InventoryRepositoryImpl(Get.find<AppDatabase>()),
      fenix: true,
    );
    Get.lazyPut<SalesRepository>(
      () => SalesRepository(Get.find<AppDatabase>()),
      fenix: true,
    );
    Get.put(
      InventoryController(Get.find<InventoryRepository>()),
      permanent: true,
    );
  }
}