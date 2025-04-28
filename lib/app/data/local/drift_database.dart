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
  DateTimeColumn get lastUpdated => dateTime().nullable()();
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

  // Similar queries can be added for Sales, Debtors, Suppliers...
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
