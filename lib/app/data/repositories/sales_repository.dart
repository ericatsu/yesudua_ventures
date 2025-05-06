import 'package:get/get.dart';
import '../local/drift_database.dart' as db;
import '../remote/supabase_service.dart';
import '../models/sale.dart' as model;

class SalesRepository extends GetxService {
  final db.AppDatabase _localDb = Get.find();
  final SupabaseService _remote = Get.find();

  /// Insert new sale into local DB, and sync to Supabase
  Future<void> recordSale(db.SalesCompanion sale) async {
    final id = await _localDb.insertSale(sale);
    final full = await _localDb.getSaleById(id);
    if (full != null) {
      await _remote.uploadSale(_mapToModel(full) as db.Sale);
    }
  }

  /// Get all sales from local DB and return as model list
  Future<List<model.Sale>> fetchAllSales() async {
    final rows = await _localDb.getAllSales();
    return rows.map(_mapToModel).toList();
  }

  /// Update a sale in local DB and sync
  Future<void> updateSale(model.Sale sale) async {
    await _localDb.updateSale(_mapToDrift(sale));
    await _remote.uploadSale(sale as db.Sale);
  }

  /// Delete a sale from local DB (does not delete remotely)
  Future<void> deleteSale(int id) async {
    await _localDb.deleteSale(id);
  }

  /// Convert Drift Sale to Model Sale
  model.Sale _mapToModel(db.Sale s) {
    return model.Sale(
      id: s.id,
      itemId: s.itemId,
      quantitySold: s.quantitySold,
      soldPrice: s.soldPrice,
      dateOfSale: s.dateOfSale,
      isPaid: s.isPaid,
    );
  }

  /// Convert Model Sale to Drift Sale
  db.Sale _mapToDrift(model.Sale s) {
    return db.Sale(
      id: s.id,
      itemId: s.itemId,
      quantitySold: s.quantitySold,
      soldPrice: s.soldPrice,
      dateOfSale: s.dateOfSale,
      isPaid: s.isPaid,
    );
  }
}
