import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

part 'drift_database.g.dart';

// =============================
// Define Drift Tables
// =============================

class InventoryItems extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  TextColumn get category => text()();
  IntColumn get quantity => integer()();
  RealColumn get boughtPrice => real()();
  RealColumn get sellPrice => real()();
  TextColumn get supplier => text().nullable()();
  TextColumn get imageKey => text().nullable()();
  DateTimeColumn get lastUpdated => dateTime().nullable()();
  BoolColumn get needsSync => boolean().withDefault(const Constant(false))();
}

class Sales extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get itemId => integer()();
  IntColumn get quantitySold => integer()();
  RealColumn get soldPrice => real()();
  DateTimeColumn get dateOfSale => dateTime()();
  BoolColumn get isPaid => boolean().withDefault(const Constant(true))();
}

class Debtors extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get customerName => text()();
  TextColumn get customerContact => text().nullable()();
  RealColumn get totalAmount => real()();
  RealColumn get amountPaid => real().withDefault(const Constant(0.0))();
  DateTimeColumn get createdAt => dateTime()();
}

class Suppliers extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  TextColumn get contact => text().nullable()();
  TextColumn get company => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
}

// =============================
// Create Database
// =============================

@DriftDatabase(tables: [InventoryItems, Sales, Debtors, Suppliers])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  // Inventory Queries
  Future<List<InventoryItem>> getAllInventoryItems() =>
      select(inventoryItems).get();
  Future<int> insertInventoryItem(InventoryItemsCompanion item) =>
      into(inventoryItems).insert(item);
  Future<bool> updateInventoryItem(InventoryItem item) =>
      update(inventoryItems).replace(item);
  Future<int> deleteInventoryItem(int id) =>
      (delete(inventoryItems)..where((tbl) => tbl.id.equals(id))).go();

  Future<InventoryItem?> getInventoryItemById(int id) async {
    return (select(inventoryItems)
      ..where((tbl) => tbl.id.equals(id))).getSingleOrNull();
  }

  // Mark item for syncing
  // Mark item for syncing - Fixed version
  Future<void> markItemForSync(int id) async {
    await (update(inventoryItems)..where(
      (tbl) => tbl.id.equals(id),
    )).write(const InventoryItemsCompanion(needsSync: Value(true)));
  }

  // Mark item as synced - Fixed version
  Future<void> markItemAsSynced(int id) async {
    await (update(inventoryItems)..where(
      (tbl) => tbl.id.equals(id),
    )).write(const InventoryItemsCompanion(needsSync: Value(false)));
  }

  // Get items that need syncing
  Future<List<InventoryItem>> getPendingSyncItems() async {
    return (select(inventoryItems)
      ..where((tbl) => tbl.needsSync.equals(true))).get();
  }

  // Sales Queries
  Future<int> insertSale(SalesCompanion sale) => into(sales).insert(sale);
  Future<Sale?> getSaleById(int id) =>
      (select(sales)..where((s) => s.id.equals(id))).getSingleOrNull();
  Future<List<Sale>> getAllSales() => select(sales).get();
  Future<bool> updateSale(Sale sale) => update(sales).replace(sale);
  Future<int> deleteSale(int id) =>
      (delete(sales)..where((s) => s.id.equals(id))).go();

  Future<int> insertSupplier(SuppliersCompanion supplier) =>
      into(suppliers).insert(supplier);

  Future<Supplier?> getSupplierById(int id) =>
      (select(suppliers)..where((tbl) => tbl.id.equals(id))).getSingleOrNull();

  // Debtors Queries
  Future<Debtor?> getDebtorById(int id) =>
      (select(debtors)..where((d) => d.id.equals(id))).getSingleOrNull();

  Future<int> insertDebtor(DebtorsCompanion debtor) =>
      into(debtors).insert(debtor);

  Future<int> updateDebtorPayment(int id, double amountPaid) {
    return (update(debtors)..where(
      (tbl) => tbl.id.equals(id),
    )).write(DebtorsCompanion(amountPaid: Value(amountPaid)));
  }
}

// =============================
// Open SQLite Connection
// =============================

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'yesudua_inventory.db'));
    return NativeDatabase(file);
  });
}
