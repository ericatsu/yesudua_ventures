import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yesudua_ventures/app/modules/sidebar/app_layout.dart';
import 'package:yesudua_ventures/app/modules/sidebar/sidebar_controller.dart';
import 'app/routes/app_pages.dart';
import 'app/routes/app_routes.dart';

import 'app/core/services/connectivity_service.dart';
import 'app/core/services/sync_service.dart';
import 'app/data/local/drift_database.dart';
import 'app/data/remote/supabase_service.dart';

import 'app/data/repositories/inventory_repository.dart';
import 'app/data/repositories/sales_repository.dart';
import 'app/data/repositories/debtors_repository.dart';
import 'app/data/repositories/suppliers_repository.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inject core services
  Get.put(AppDatabase()); // Drift
  Get.put(SupabaseService()); // Supabase client
  Get.put(ConnectivityService()); // Online status
  Get.put(SyncService()); // Sync triggers on internet

  Get.put(SidebarController());
  // Inject repositories
  Get.put(InventoryRepository());
  Get.put(SalesRepository());
  Get.put(DebtorsRepository());
  Get.put(SuppliersRepository());

  runApp(const YesuDeaVenturesApp());
}

class YesuDeaVenturesApp extends StatelessWidget {
  const YesuDeaVenturesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Yesu Dea Ventures IMS',
      debugShowCheckedModeBanner: false,
      initialRoute: AppRoutes.SALES,
      defaultTransition: Transition.fadeIn,
      getPages: AppPages.pages,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.brown),
        useMaterial3: true,
      ),
      builder: (context, child) {
        return AppLayout(child: child!);
      },
    );
  }
}
