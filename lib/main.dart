import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yesudua_ventures/app/modules/sidebar/app_layout.dart';
import 'app/routes/app_pages.dart';
import 'app/routes/app_routes.dart';
import 'app/core/bindings/initial_binding.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const YesuDeaVenturesApp());
}

class YesuDeaVenturesApp extends StatelessWidget {
  const YesuDeaVenturesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Yesu Dea Ventures IMS',
      debugShowCheckedModeBanner: false,
      initialRoute: AppRoutes.LOGIN,
      initialBinding: InitialBinding(),
      defaultTransition: Transition.fadeIn,
      getPages: AppPages.pages,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.brown),
        useMaterial3: true,
      ),
      builder: (context, child) {
        return AppLayout(child: child!);
      },
    );
  }
}