import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sidebarx/sidebarx.dart';
import 'package:yesudua_ventures/app/routes/app_routes.dart';

class SidebarController extends GetxController {
  late SidebarXController sidebarXController;
  final RxBool _showSidebar = false.obs;

  // Routes where sidebar should be visible
  final List<String> sidebarRoutes = [
    AppRoutes.sales,
    AppRoutes.dashboard,
    AppRoutes.inventory,
    AppRoutes.debtors,
    AppRoutes.suppliers,
    AppRoutes.receipts,
  ];

  // Routes where sidebar should not be visible
  final List<String> noSidebarRoutes = [AppRoutes.login];

  // Map routes to sidebar indices
  final Map<String, int> routeToIndex = {
    AppRoutes.sales: 0,
    AppRoutes.dashboard: 1,
    AppRoutes.inventory: 2,
    AppRoutes.debtors: 3,
    AppRoutes.suppliers: 4,
    AppRoutes.receipts: 5,
  };

  final Map<int, String> indexToRoute = {
    0: AppRoutes.sales,
    1: AppRoutes.dashboard,
    2: AppRoutes.inventory,
    3: AppRoutes.debtors,
    4: AppRoutes.suppliers,
    5: AppRoutes.receipts,
  };

  @override
  void onInit() {
    super.onInit();

    // Initialize SidebarX controller with Sales (index 0) as default
    sidebarXController = SidebarXController(selectedIndex: 0, extended: true);

    // Set initial sidebar visibility
    _updateSidebarVisibility();

    // Listen to sidebar selection changes
    sidebarXController.addListener(() {
      final selectedRoute = indexToRoute[sidebarXController.selectedIndex];
      if (selectedRoute != null) {
        _navigateToRoute(selectedRoute);
      }
    });

    // Check screen size for initial sidebar state
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (Get.mediaQuery.size.width < 600) {
        sidebarXController.setExtended(false);
      }
    });
  }

  void _updateSidebarVisibility() {
    final currentRoute = Get.currentRoute;
    _showSidebar.value =
        sidebarRoutes.contains(currentRoute) ||
        (!noSidebarRoutes.contains(currentRoute) && currentRoute.isNotEmpty);
  }

  void _navigateToRoute(String route) {
    if (Get.currentRoute != route) {
      Get.toNamed(route);
    }
  }

  // Getter that can be used with Obx
  bool get shouldShowSidebar => _showSidebar.value;

  // Method to explicitly show sidebar - useful after authentication
  void showSidebar() {
    _showSidebar.value = true;
    // Set Sales as the default active item when sidebar is first shown after login
    sidebarXController.selectIndex(0); // Sales index
  }

  // Method to handle logout
  void logout() {
    Get.offAllNamed(AppRoutes.login);
    _showSidebar.value = false;
  }

  // Navigation helper
  void navigateTo(String route) {
    final index = routeToIndex[route];
    if (index != null) {
      sidebarXController.selectIndex(index);
    }
  }

  // Update sidebar selection when route changes externally
  void updateCurrentRoute(String route) {
    final index = routeToIndex[route];
    if (index != null && sidebarXController.selectedIndex != index) {
      sidebarXController.selectIndex(index);
    }
    _updateSidebarVisibility();
  }

  @override
  void onClose() {
    sidebarXController.dispose();
    super.onClose();
  }
}
