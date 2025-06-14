import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yesudua_ventures/app/modules/sidebar/side_bar.dart';
import 'package:yesudua_ventures/app/modules/sidebar/sidebar_controller.dart';
import 'package:yesudua_ventures/app/routes/app_routes.dart';

class AppLayout extends StatelessWidget {
  final Widget child;
  final SidebarController controller = Get.find<SidebarController>();

  AppLayout({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    // Force update current route when layout is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Setting the currentRoute when layout is built helps ensure
      // the sidebar is properly highlighting the active item
      if (Get.currentRoute != AppRoutes.login && Get.currentRoute.isNotEmpty) {
        controller.updateCurrentRoute(Get.currentRoute);
      }
    });

    return Scaffold(
      body: Obx(() {
        if (!controller.shouldShowSidebar) {
          return child;
        }
        // Show sidebar for all other pages
        return Row(children: [const SideBar(), Expanded(child: child)]);
      }),
    );
  }
}
