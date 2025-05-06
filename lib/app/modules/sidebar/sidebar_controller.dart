import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yesudua_ventures/app/routes/app_routes.dart';

class SidebarController extends GetxController {
  // Use a reactive string to track current route
  final RxString currentRoute = ''.obs;
  final RxBool isExpanded = true.obs;
  final RxBool _showSidebar = false.obs;

  // Routes where sidebar should be visible
  final List<String> sidebarRoutes = [
    AppRoutes.SALES,
    AppRoutes.DASHBOARD,
    AppRoutes.INVENTORY,
    AppRoutes.DEBTORS,
    AppRoutes.SUPPLIERS,
    AppRoutes.REPORTS,
  ];

  @override
  void onInit() {
    super.onInit();

    // Set initial route and sidebar visibility
    currentRoute.value = Get.currentRoute;
    _updateSidebarVisibility();

    // Listen for route changes and update sidebar visibility
    ever(currentRoute, (_) => _updateSidebarVisibility());

    // Use GetX's navigation observer to update the current route
    Get.rootController.addListener(() {
      if (Get.currentRoute != currentRoute.value) {
        currentRoute.value = Get.currentRoute;
      }
    });

    // Check screen size for initial sidebar state
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (Get.mediaQuery.size.width < 600) {
        isExpanded.value = false;
      }
      update(); // Ensure UI updates
    });
  }

  void _updateSidebarVisibility() {
    _showSidebar.value = sidebarRoutes.contains(currentRoute.value);
    update();
  }

  // Getter that can be used with Obx
  bool get shouldShowSidebar => _showSidebar.value;

  void toggleSidebar() {
    isExpanded.toggle();
    update(); // Ensure UI updates
  }

  // Navigation helper
  void navigateTo(String route) {
    if (currentRoute.value != route) {
      Get.toNamed(route);
    }
  }
}