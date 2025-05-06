import 'package:get/get.dart';
import 'debtors_controller.dart';

class DebtorsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => DebtorsController());
  }
}