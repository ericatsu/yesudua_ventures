import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yesudua_ventures/app/modules/sidebar/sidebar_controller.dart';
import 'package:yesudua_ventures/app/routes/app_routes.dart';

class AuthMiddleware extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    // Check if user is logged in (simplified example)
    final bool isLoggedIn = Get.find<SidebarController>().shouldShowSidebar;

    if (!isLoggedIn && route != AppRoutes.login) {
      return const RouteSettings(name: AppRoutes.login);
    }
    return null;
  }
}