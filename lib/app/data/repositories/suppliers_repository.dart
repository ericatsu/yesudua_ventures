import 'package:get/get.dart';
import '../local/drift_database.dart';
import '../remote/supabase_service.dart';
import '../models/supplier.dart';

class SuppliersRepository extends GetxService {
  final AppDatabase _localDb = Get.find();
  final SupabaseService _supabaseService = Get.find();

  Future<void> addSupplier(SuppliersCompanion supplier) async {
    final id = await _localDb.insertSupplier(supplier);
    final fullSupplier = await _localDb.getSupplierById(id);

    if (fullSupplier != null) {
      await _supabaseService.uploadSupplier(fullSupplier);
    }
  }
}
