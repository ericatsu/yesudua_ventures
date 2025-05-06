import 'package:get/get.dart';
import 'suppliers_controller.dart';

class SuppliersBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SuppliersController());
  }
}