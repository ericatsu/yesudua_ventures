import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yesudua_ventures/app/modules/sidebar/side_bar.dart';
import 'package:yesudua_ventures/app/modules/sidebar/sidebar_controller.dart';

class AppLayout extends StatelessWidget {
  final Widget child;
  final SidebarController controller = Get.find<SidebarController>();

  AppLayout({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
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