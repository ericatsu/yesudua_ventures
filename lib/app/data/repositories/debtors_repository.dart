import 'package:get/get.dart';
import '../local/drift_database.dart';
import '../remote/supabase_service.dart';
import '../models/debtor.dart';

class DebtorsRepository extends GetxService {
  final AppDatabase _localDb = Get.find();
  final SupabaseService _remote = Get.find();

  Future<void> addDebtor(DebtorsCompanion debtor) async {
    final id = await _localDb.insertDebtor(debtor);
    final full = await _localDb.getDebtorById(id);
    if (full != null) await _remote.uploadDebtor(full);
  }

  Future<void> updatePayment(int id, double amountPaid) async {
    await _localDb.updateDebtorPayment(id, amountPaid);
    final full = await _localDb.getDebtorById(id);
    if (full != null) await _remote.uploadDebtor(full);
  }
}
