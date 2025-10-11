import 'package:get/get.dart';
import 'package:yesudua_ventures/app/modules/auth/auth_middleware.dart';
import 'package:yesudua_ventures/app/modules/auth/login_binding.dart';
import 'package:yesudua_ventures/app/modules/auth/login_view.dart';
import 'package:yesudua_ventures/app/modules/dashboard/dashboard_binding.dart';
import 'package:yesudua_ventures/app/modules/dashboard/dashboard_view.dart';
import 'package:yesudua_ventures/app/modules/debtors/debtors_binding.dart';
import 'package:yesudua_ventures/app/modules/debtors/debtor_detail_view.dart';
import 'package:yesudua_ventures/app/modules/debtors/debtors_view.dart';
import 'package:yesudua_ventures/app/modules/inventory/inventory_binding.dart';
import 'package:yesudua_ventures/app/modules/inventory/inventory_view.dart';
// import 'package:yesudua_ventures/app/modules/receipts/receipts_binding.dart';
// import 'package:yesudua_ventures/app/modules/receipts/receipts_view.dart';
import 'package:yesudua_ventures/app/modules/sales/sales_binding.dart';
import 'package:yesudua_ventures/app/modules/sales/sales_view.dart';
import 'package:yesudua_ventures/app/modules/suppliers/suppliers_binding.dart';
import 'package:yesudua_ventures/app/modules/suppliers/suppliers_view.dart';

import 'app_routes.dart';

class AppPages {
  static final pages = [
    GetPage(
      name: AppRoutes.login,
      page: () => const LoginView(),
      binding: LoginBinding(),
    ),
    GetPage(
      name: AppRoutes.sales,
      page: () => SalesView(),
      binding: SalesBinding(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: AppRoutes.dashboard,
      page: () => DashboardView(),
      binding: DashboardBinding(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: AppRoutes.inventory,
      page: () => InventoryView(),
      binding: InventoryBinding(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: AppRoutes.debtors,
      page: () => DebtorsView(),
      binding: DebtorsBinding(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: AppRoutes.debtorDetail,
      page: () => DebtorDetailView(),
      binding: DebtorsBinding(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: AppRoutes.suppliers,
      page: () => SuppliersView(),
      binding: SuppliersBinding(),
      middlewares: [AuthMiddleware()],
    ),
    GetPage(
      name: AppRoutes.dashboard,
      page: () => const DashboardView(),
      binding: DashboardBinding(),
    ),
  ];
}
