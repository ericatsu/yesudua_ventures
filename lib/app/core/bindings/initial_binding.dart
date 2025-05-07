import 'package:get/get.dart';
import 'package:yesudua_ventures/app/core/services/connectivity_service.dart';
import 'package:yesudua_ventures/app/core/services/sync_service.dart';
import 'package:yesudua_ventures/app/data/local/drift_database.dart';
import 'package:yesudua_ventures/app/data/remote/supabase_service.dart';
import 'package:yesudua_ventures/app/modules/sidebar/sidebar_controller.dart';
import 'package:yesudua_ventures/app/data/repositories/inventory_repository.dart';
import 'package:yesudua_ventures/app/data/repositories/sales_repository.dart';
import 'package:yesudua_ventures/app/data/repositories/debtors_repository.dart';
import 'package:yesudua_ventures/app/data/repositories/suppliers_repository.dart';

class InitialBinding implements Bindings {
  @override
  void dependencies() {
    // Core services - permanent instances
    Get.put(AppDatabase(), permanent: true);
    Get.put(SupabaseService(), permanent: true);
    Get.put(ConnectivityService(), permanent: true);
    Get.put(SyncService(), permanent: true);
    Get.put(SidebarController(), permanent: true);

    // Repositories - lazy loading
    Get.lazyPut(() => InventoryRepository(), fenix: true);
    Get.lazyPut(() => SalesRepository(), fenix: true);
    Get.lazyPut(() => DebtorsRepository(), fenix: true);
    Get.lazyPut(() => SuppliersRepository(), fenix: true);
  }
}