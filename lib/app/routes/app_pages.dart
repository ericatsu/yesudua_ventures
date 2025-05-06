import 'package:get/get.dart';
import 'package:yesudua_ventures/app/modules/auth/login_binding.dart';
import 'package:yesudua_ventures/app/modules/auth/login_view.dart';
import 'package:yesudua_ventures/app/modules/dashboard/dashboard_binding.dart';
import 'package:yesudua_ventures/app/modules/dashboard/dashboard_view.dart';
import 'package:yesudua_ventures/app/modules/debtors/debtors_binding.dart';
import 'package:yesudua_ventures/app/modules/debtors/debtors_view.dart';
import 'package:yesudua_ventures/app/modules/inventory/inventory_binding.dart';
import 'package:yesudua_ventures/app/modules/inventory/inventory_view.dart';
import 'package:yesudua_ventures/app/modules/reports/reports_binding.dart';
import 'package:yesudua_ventures/app/modules/reports/reports_view.dart';
import 'package:yesudua_ventures/app/modules/sales/sales_binding.dart';
import 'package:yesudua_ventures/app/modules/sales/sales_view.dart';
import 'package:yesudua_ventures/app/modules/suppliers/suppliers_binding.dart';
import 'package:yesudua_ventures/app/modules/suppliers/suppliers_view.dart';

import 'app_routes.dart';

class AppPages {
  static final pages = [
    GetPage(
      name: AppRoutes.LOGIN,
      page: () => const LoginView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: AppRoutes.SALES,
      page: () => SalesView(),
      binding: SalesBinding(),
    ),
    GetPage(
      name: AppRoutes.DASHBOARD,
      page: () => DashboardView(),
      binding: DashboardBinding(),
    ),
    GetPage(
      name: AppRoutes.INVENTORY,
      page: () => InventoryView(),
      binding: InventoryBinding(),
    ),
    GetPage(
      name: AppRoutes.DEBTORS,
      page: () => DebtorsView(),
      binding: DebtorsBinding(),
    ),
    GetPage(
      name: AppRoutes.SUPPLIERS,
      page: () => SuppliersView(),
      binding: SuppliersBinding(),
    ),
    GetPage(
      name: AppRoutes.REPORTS,
      page: () => ReportsView(),
      binding: ReportsBinding(),
    ),
  ];
}
