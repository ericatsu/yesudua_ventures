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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (Get.currentRoute != AppRoutes.login && Get.currentRoute.isNotEmpty) {
        controller.updateCurrentRoute(Get.currentRoute);
      }
    });

    return Scaffold(
      body: Obx(() {
        if (!controller.shouldShowSidebar) {
          return child;
        }
        return Row(children: [const SideBar(), Expanded(child: child)]);
      }),
    );
  }
}
