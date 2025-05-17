import 'package:get/get.dart';
import 'package:yesudua_ventures/app/data/repositories/inventory_repository.dart';
import 'package:yesudua_ventures/app/modules/suppliers/suppliers_controller.dart';

class SuppliersBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SuppliersController>(
      () => SuppliersController(Get.find<InventoryRepository>()),
    );
  }
}
