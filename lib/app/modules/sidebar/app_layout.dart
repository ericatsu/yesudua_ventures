import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yesudua_ventures/app/modules/sidebar/side_bar.dart';
import 'package:yesudua_ventures/app/modules/sidebar/sidebar_controller.dart';

class AppLayoutWrapper extends StatelessWidget {
  final Widget child;

  const AppLayoutWrapper({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder<SidebarController>(
        builder: (controller) {
          return Row(
            children: [
              const SidebarWidget(),

              Expanded(child: child),
            ],
          );
        },
      ),
    );
  }
}