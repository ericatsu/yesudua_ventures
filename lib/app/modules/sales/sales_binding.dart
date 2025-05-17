import 'package:get/get.dart';
import 'package:yesudua_ventures/app/data/local/app_database.dart';
import 'package:yesudua_ventures/app/data/repositories/inventory_repository.dart';
import 'package:yesudua_ventures/app/data/repositories/sales_repository.dart';
import 'package:yesudua_ventures/app/modules/sales/sales_controller.dart';

class SalesBinding implements Bindings {
  @override
  void dependencies() {
    // Get the database instance
    final database = Get.find<AppDatabase>();

    // Register repository
    Get.lazyPut<SalesRepository>(() => SalesRepository(database));

    // Register controller
    Get.lazyPut<SalesController>(
      () => SalesController(
        Get.find<SalesRepository>(),
        Get.find<InventoryRepository>(),
      ),
    );
  }
}