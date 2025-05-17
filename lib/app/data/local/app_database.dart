import 'package:drift/drift.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:drift/native.dart';
import 'dart:io';

part 'app_database.g.dart';

// Table definitions
class Suppliers extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withLength(min: 1, max: 100)();
  TextColumn get contact => text().withLength(min: 1, max: 20)();
  TextColumn get address => text().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}

class Categories extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withLength(min: 1, max: 50).unique()();
  TextColumn get description => text().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}

class InventoryItems extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withLength(min: 1, max: 100)();
  IntColumn get categoryId => integer().references(Categories, #id)();
  RealColumn get quantity => real().withDefault(const Constant(0))();
  RealColumn get boughtPrice => real()();
  RealColumn get sellPrice => real()();
  IntColumn get supplierId => integer().references(Suppliers, #id).nullable()();
  DateTimeColumn get lastRestocked => dateTime().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}

class Sales extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get customerName =>
      text().withLength(min: 1, max: 100).nullable()();
  TextColumn get customerContact => text().withLength(max: 20).nullable()();
  RealColumn get totalAmount => real()();
  RealColumn get paidAmount => real().withDefault(const Constant(0))();
  BoolColumn get isPaid => boolean().withDefault(const Constant(false))();
  DateTimeColumn get saleDate => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}

class SaleItems extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get saleId => integer().references(Sales, #id)();
  IntColumn get inventoryItemId => integer().references(InventoryItems, #id)();
  RealColumn get quantity => real()();
  RealColumn get sellPrice => real()();
  RealColumn get boughtPrice => real()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

class Debtors extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get saleId => integer().references(Sales, #id).unique()();
  TextColumn get name => text().withLength(min: 1, max: 100)();
  TextColumn get contact => text().withLength(min: 1, max: 20)();
  RealColumn get totalDebt => real()();
  RealColumn get paidAmount => real().withDefault(const Constant(0))();
  RealColumn get outstandingBalance => real()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}

class DebtorPayments extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get debtorId => integer().references(Debtors, #id)();
  RealColumn get amountPaid => real()();
  DateTimeColumn get paymentDate =>
      dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

class SupplyHistory extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get supplierId => integer().references(Suppliers, #id)();
  IntColumn get inventoryItemId => integer().references(InventoryItems, #id)();
  RealColumn get quantity => real()();
  RealColumn get boughtPrice => real()();
  DateTimeColumn get supplyDate => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

// Database class
@DriftDatabase(
  tables: [
    Suppliers,
    Categories,
    InventoryItems,
    Sales,
    SaleItems,
    Debtors,
    DebtorPayments,
    SupplyHistory,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (Migrator m) {
        return m.createAll();
      },
      onUpgrade: (Migrator m, int from, int to) async {
        // Handle future database migrations here
      },
    );
  }

  // Helper methods for complex queries or transactions
  Future<void> insertSaleWithItems(
    SalesCompanion sale,
    List<SaleItemsCompanion> items,
  ) {
    return transaction(() async {
      final saleId = await into(sales).insert(sale);

      for (final item in items) {
        await into(saleItems).insert(item.copyWith(saleId: Value(saleId)));

        // Update inventory quantity
        final inventoryItem =
            await (select(inventoryItems)..where(
              (t) => t.id.equals(item.inventoryItemId.value),
            )).getSingle();

        await (update(inventoryItems)
          ..where((t) => t.id.equals(item.inventoryItemId.value))).write(
          InventoryItemsCompanion(
            quantity: Value(inventoryItem.quantity - item.quantity.value),
            updatedAt: Value(DateTime.now()),
          ),
        );
      }
    });
  }

  // Helper method to record a debtor
  Future<int> recordDebtor(DebtorsCompanion debtor) {
    return into(debtors).insert(debtor);
  }

  // Helper method to record a payment for a debtor
  Future<void> recordDebtorPayment(int debtorId, double amountPaid) {
    return transaction(() async {
      // Insert payment record
      await into(debtorPayments).insert(
        DebtorPaymentsCompanion.insert(
          debtorId: debtorId,
          amountPaid: amountPaid,
        ),
      );

      // Update debtor record
      final debtor =
          await (select(debtors)
            ..where((t) => t.id.equals(debtorId))).getSingle();

      final newPaidAmount = debtor.paidAmount + amountPaid;
      final newOutstandingBalance = debtor.totalDebt - newPaidAmount;

      await (update(debtors)..where((t) => t.id.equals(debtorId))).write(
        DebtorsCompanion(
          paidAmount: Value(newPaidAmount),
          outstandingBalance: Value(newOutstandingBalance),
          updatedAt: Value(DateTime.now()),
        ),
      );
    });
  }

  // Helper method for inventory queries with category and supplier info
  Stream<List<InventoryItemWithRelations>> watchInventoryWithRelations() {
    return (select(inventoryItems).join([
      leftOuterJoin(
        categories,
        categories.id.equalsExp(inventoryItems.categoryId),
      ),
      leftOuterJoin(
        suppliers,
        suppliers.id.equalsExp(inventoryItems.supplierId),
      ),
    ])).watch().map((rows) {
      return rows.map((row) {
        return InventoryItemWithRelations(
          item: row.readTable(inventoryItems),
          category: row.readTable(categories),
          supplier: row.readTableOrNull(suppliers),
        );
      }).toList();
    });
  }

  // Additional helper method to get a single inventory item with relations
  Future<InventoryItemWithRelations> getInventoryItemWithRelations(int id) {
    return (select(inventoryItems).join([
      leftOuterJoin(
        categories,
        categories.id.equalsExp(inventoryItems.categoryId),
      ),
      leftOuterJoin(
        suppliers,
        suppliers.id.equalsExp(inventoryItems.supplierId),
      ),
    ])..where(inventoryItems.id.equals(id))).getSingle().then((row) {
      return InventoryItemWithRelations(
        item: row.readTable(inventoryItems),
        category: row.readTable(categories),
        supplier: row.readTableOrNull(suppliers),
      );
    });
  }
}

// Custom data class for inventory items with related entities
class InventoryItemWithRelations {
  final InventoryItem item;
  final Category category;
  final Supplier? supplier;

  InventoryItemWithRelations({
    required this.item,
    required this.category,
    this.supplier,
  });
}

// Database connection
LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'yesu_dea_wood_ventures.sqlite'));
    return NativeDatabase(file);
  });
}