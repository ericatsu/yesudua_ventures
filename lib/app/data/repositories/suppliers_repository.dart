import 'package:get/get.dart';
import '../local/drift_database.dart';
import '../remote/supabase_service.dart';
import '../models/supplier.dart';

class SuppliersRepository extends GetxService {
  final AppDatabase _localDb = Get.find();
  final SupabaseService _remote = Get.find();

  Future<void> addSupplier(SuppliersCompanion supplier) async {
    final id = await _localDb.insertSupplier(supplier);
    final full = await _localDb.getSupplierById(id);
    if (full != null) await _remote.uploadSupplier(full);
  }
}