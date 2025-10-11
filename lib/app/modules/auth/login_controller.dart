import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yesudua_ventures/app/modules/sidebar/sidebar_controller.dart';
import 'package:yesudua_ventures/app/routes/app_routes.dart';

class LoginController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final passwordController = TextEditingController();
  final RxBool obscurePassword = true.obs;
  final RxBool isLoading = false.obs;

  // Set password
  static const String _correctPassword = 'shop123';

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
        await Future.delayed(const Duration(seconds: 1));

        // Check if password is correct
        if (passwordController.text.trim() == _correctPassword) {
          // Show sidebar
          _sidebarController.showSidebar();

          // Navigate to dashboard
          Get.offAllNamed(AppRoutes.dashboard);

          // Show success message
          Get.snackbar(
            'Success',
            'Login successful!',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green.withValues(alpha: 0.8),
            colorText: Colors.white,
            duration: const Duration(seconds: 2),
          );
        } else {
          // Show error message for incorrect password
          Get.snackbar(
            'Error',
            'Incorrect password. Please try again.',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red.withValues(alpha: 0.8),
            colorText: Colors.white,
            duration: const Duration(seconds: 3),
          );
        }
      } catch (e) {
        Get.snackbar(
          'Error',
          'Login failed: ${e.toString()}',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.withValues(alpha: 0.8),
          colorText: Colors.white,
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
