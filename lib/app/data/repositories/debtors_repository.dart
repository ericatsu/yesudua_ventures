import 'package:get/get.dart';
import '../local/drift_database.dart';
import '../remote/supabase_service.dart';
import '../models/debtor.dart';

class DebtorsRepository extends GetxService {
  final AppDatabase _localDb = Get.find();
  final SupabaseService _supabaseService = Get.find();

  Future<void> addDebtor(DebtorsCompanion debtor) async {
    final id = await _localDb.insertDebtor(debtor);
    final fullDebtor = await _localDb.getDebtorById(id);

    if (fullDebtor != null) {
      await _supabaseService.uploadDebtor(fullDebtor);
    }
  }

  Future<void> recordPartialPayment(int debtorId, double amountPaid) async {
    await _localDb.updateDebtorPayment(debtorId, amountPaid);
    final updatedDebtor = await _localDb.getDebtorById(debtorId);

    if (updatedDebtor != null) {
      await _supabaseService.uploadDebtor(updatedDebtor);
    }
  }
}
