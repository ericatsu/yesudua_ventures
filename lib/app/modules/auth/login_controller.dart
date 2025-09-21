import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yesudua_ventures/app/modules/sidebar/sidebar_controller.dart';
import 'package:yesudua_ventures/app/routes/app_routes.dart';

class LoginController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final passwordController = TextEditingController();
  final RxBool obscurePassword = true.obs;
  final RxBool isLoading = false.obs;

  // Get sidebar controller
  final SidebarController _sidebarController = Get.find<SidebarController>();

  void togglePasswordVisibility() {
    obscurePassword.value = !obscurePassword.value;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    return null;
  }

  void login() async {
    if (formKey.currentState!.validate()) {
      try {
        isLoading.value = true;

        // Simulate login delay
        await Future.delayed(const Duration(seconds: 2));
        _sidebarController.showSidebar();

        // 2. Navigate to dashboard or sales page
        Get.offAllNamed(AppRoutes.dashboard);
      } catch (e) {
        Get.snackbar(
          'Error',
          'Login failed: ${e.toString()}',
          snackPosition: SnackPosition.BOTTOM,
        );
      } finally {
        isLoading.value = false;
      }
    }
  }

  @override
  void onClose() {
    passwordController.dispose();
    super.onClose();
  }
}
