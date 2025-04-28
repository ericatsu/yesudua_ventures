import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yesudua_ventures/app.dart';
import 'package:yesudua_ventures/app/data/remote/supabase_service.dart';
import 'package:yesudua_ventures/app/data/repositories/debtors_repository.dart';
import 'package:yesudua_ventures/app/data/repositories/inventory_repository.dart';
import 'package:yesudua_ventures/app/data/repositories/sales_repository.dart';
import 'package:yesudua_ventures/app/data/repositories/suppliers_repository.dart';

import 'app/data/local/drift_database.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Get.put(AppDatabase());
  Get.put(SupabaseService());
  Get.put(InventoryRepository());
  Get.put(SalesRepository());
  Get.put(DebtorsRepository());
  Get.put(SuppliersRepository());
  runApp(InventoryManagementApp());
}
