import 'package:get/get.dart';
import '../local/drift_database.dart';
import '../remote/supabase_service.dart';
import '../models/sale.dart';

class SalesRepository extends GetxService {
  final AppDatabase _localDb = Get.find();
  final SupabaseService _supabaseService = Get.find();

  Future<void> recordSale(SalesCompanion sale) async {
    final id = await _localDb.insertSale(sale);
    final fullSale = await _localDb.getSaleById(id);

    if (fullSale != null) {
      await _supabaseService.uploadSale(fullSale);
    }
  }
}
