import 'package:get/get.dart';
import 'package:yesudua_ventures/app/data/repositories/sales_repository.dart';
import 'package:yesudua_ventures/app/modules/debtors/debtors_controller.dart';

class DebtorsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DebtorsController>(
      () => DebtorsController(Get.find<SalesRepository>()),
      fenix: true,
    );
  }
}
