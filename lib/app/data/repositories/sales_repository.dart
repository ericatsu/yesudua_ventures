import 'package:drift/drift.dart';
import 'package:yesudua_ventures/app/data/local/app_database.dart';
import 'package:yesudua_ventures/app/data/models/sales_model.dart';

class SalesRepository {
  final AppDatabase _database;

  SalesRepository(this._database);

  // Get all sales with optional filtering
  Future<List<SaleModel>> getAllSales({
    bool todayOnly = false,
    DateTime? startDate,
    DateTime? endDate,
    bool paidOnly = false,
    bool unpaidOnly = false,
  }) async {
    var query = _database.select(_database.sales);

    // Apply filters
    if (todayOnly) {
      final today = DateTime.now();
      final startOfDay = DateTime(today.year, today.month, today.day);
      final endOfDay = startOfDay.add(const Duration(days: 1));

      query =
          query..where(
            (tbl) =>
                tbl.saleDate.isBiggerOrEqualValue(startOfDay) &
                tbl.saleDate.isSmallerThanValue(endOfDay),
          );
    } else if (startDate != null && endDate != null) {
      query =
          query..where(
            (tbl) =>
                tbl.saleDate.isBiggerOrEqualValue(startDate) &
                tbl.saleDate.isSmallerOrEqualValue(endDate),
          );
    }

    if (paidOnly) {
      query = query..where((tbl) => tbl.isPaid.equals(true));
    } else if (unpaidOnly) {
      query = query..where((tbl) => tbl.isPaid.equals(false));
    }

    // Order by latest sales first
    query = query..orderBy([(t) => OrderingTerm.desc(t.saleDate)]);

    final results = await query.get();

    // Convert to our domain model
    final salesModels = <SaleModel>[];

    for (final saleRecord in results) {
      // Get sale items for this sale
      final saleItems = await getSaleItems(saleRecord.id);

      salesModels.add(
        SaleModel(
          id: saleRecord.id,
          customerName: saleRecord.customerName,
          customerContact: saleRecord.customerContact,
          totalAmount: saleRecord.totalAmount,
          paidAmount: saleRecord.paidAmount,
          isPaid: saleRecord.isPaid,
          saleDate: saleRecord.saleDate,
          createdAt: saleRecord.createdAt,
          updatedAt: saleRecord.updatedAt,
          items: saleItems,
        ),
      );
    }

    return salesModels;
  }

  // Get sale by ID with items
  Future<SaleModel?> getSaleById(int saleId) async {
    final query = _database.select(_database.sales)
      ..where((tbl) => tbl.id.equals(saleId));

    final result = await query.getSingleOrNull();
    if (result == null) return null;

    final saleItems = await getSaleItems(result.id);

    return SaleModel(
      id: result.id,
      customerName: result.customerName,
      customerContact: result.customerContact,
      totalAmount: result.totalAmount,
      paidAmount: result.paidAmount,
      isPaid: result.isPaid,
      saleDate: result.saleDate,
      createdAt: result.createdAt,
      updatedAt: result.updatedAt,
      items: saleItems,
    );
  }

  // Get sale items for a specific sale
  Future<List<SaleItemModel>> getSaleItems(int saleId) async {
    final query = (_database.select(_database.saleItems)
      ..where((tbl) => tbl.saleId.equals(saleId))).join([
      innerJoin(
        _database.inventoryItems,
        _database.inventoryItems.id.equalsExp(
          _database.saleItems.inventoryItemId,
        ),
      ),
      leftOuterJoin(
        _database.categories,
        _database.categories.id.equalsExp(_database.inventoryItems.categoryId),
      ),
    ]);

    final results = await query.get();

    return results.map((row) {
      final saleItem = row.readTable(_database.saleItems);
      final inventoryItem = row.readTable(_database.inventoryItems);
      final category = row.readTableOrNull(_database.categories);

      return SaleItemModel(
        id: saleItem.id,
        saleId: saleItem.saleId,
        inventoryItemId: saleItem.inventoryItemId,
        quantity: saleItem.quantity,
        sellPrice: saleItem.sellPrice,
        boughtPrice: saleItem.boughtPrice,
        createdAt: saleItem.createdAt,
        itemName: inventoryItem.name,
        categoryName: category?.name,
      );
    }).toList();
  }

  // Create a new sale with items
  Future<int> createSale(SaleModel sale) async {
    return _database.transaction(() async {
      // Insert the sale
      final saleCompanion = SalesCompanion.insert(
        customerName:
            sale.customerName == null
                ? const Value.absent()
                : Value(sale.customerName!),
        customerContact:
            sale.customerContact == null
                ? const Value.absent()
                : Value(sale.customerContact!),
        totalAmount: sale.totalAmount,
        paidAmount: Value(sale.paidAmount),
        isPaid: Value(sale.isPaid),
        saleDate: Value(sale.saleDate),
      );

      final saleId = await _database
          .into(_database.sales)
          .insert(saleCompanion);

      // Insert all sale items
      if (sale.items != null) {
        for (final item in sale.items!) {
          final saleItemCompanion = SaleItemsCompanion.insert(
            saleId: saleId,
            inventoryItemId: item.inventoryItemId,
            quantity: item.quantity,
            sellPrice: item.sellPrice,
            boughtPrice: item.boughtPrice,
          );

          await _database.into(_database.saleItems).insert(saleItemCompanion);

          // Update inventory quantity
          final inventoryItem =
              await (_database.select(_database.inventoryItems)
                ..where((t) => t.id.equals(item.inventoryItemId))).getSingle();

          await (_database.update(_database.inventoryItems)
            ..where((t) => t.id.equals(item.inventoryItemId))).write(
            InventoryItemsCompanion(
              quantity: Value(inventoryItem.quantity - item.quantity),
              updatedAt: Value(DateTime.now()),
            ),
          );
        }
      }

      // If not fully paid, create debtor record
      if (!sale.isPaid &&
          sale.customerName != null &&
          sale.customerContact != null) {
        final outstandingBalance = sale.totalAmount - sale.paidAmount;

        final debtorCompanion = DebtorsCompanion.insert(
          saleId: saleId,
          name: sale.customerName!,
          contact: sale.customerContact!,
          totalDebt: sale.totalAmount,
          paidAmount: Value(sale.paidAmount),
          outstandingBalance: outstandingBalance,
        );

        await _database.into(_database.debtors).insert(debtorCompanion);
      }

      return saleId;
    });
  }

  // Update sale payment status
  Future<bool> updateSalePayment(
    int saleId,
    double paidAmount,
    bool isPaid,
  ) async {
    return _database.transaction(() async {
      // Update the sale record
      await (_database.update(_database.sales)
        ..where((t) => t.id.equals(saleId))).write(
        SalesCompanion(
          paidAmount: Value(paidAmount),
          isPaid: Value(isPaid),
          updatedAt: Value(DateTime.now()),
        ),
      );

      // Check if there's a debtor record to update
      final debtorQuery = _database.select(_database.debtors)
        ..where((t) => t.saleId.equals(saleId));
      final debtor = await debtorQuery.getSingleOrNull();

      if (debtor != null) {
        final outstandingBalance = debtor.totalDebt - paidAmount;

        // Update debtor record
        await (_database.update(_database.debtors)
          ..where((t) => t.id.equals(debtor.id))).write(
          DebtorsCompanion(
            paidAmount: Value(paidAmount),
            outstandingBalance: Value(outstandingBalance),
            updatedAt: Value(DateTime.now()),
          ),
        );

        // Add payment history record if amount paid is greater than previous
        if (paidAmount > debtor.paidAmount) {
          final newPayment = paidAmount - debtor.paidAmount;

          await _database
              .into(_database.debtorPayments)
              .insert(
                DebtorPaymentsCompanion.insert(
                  debtorId: debtor.id,
                  amountPaid: newPayment,
                ),
              );
        }
      }

      return true;
    });
  }

  // Get debtor information for a sale
  Future<DebtorModel?> getDebtorForSale(int saleId) async {
    final query = _database.select(_database.debtors)
      ..where((tbl) => tbl.saleId.equals(saleId));

    final result = await query.getSingleOrNull();
    if (result == null) return null;

    // Get payment history
    final paymentsQuery =
        _database.select(_database.debtorPayments)
          ..where((tbl) => tbl.debtorId.equals(result.id))
          ..orderBy([(t) => OrderingTerm.desc(t.paymentDate)]);

    final payments = await paymentsQuery.get();
    final paymentHistory =
        payments
            .map(
              (payment) => DebtorPaymentModel(
                id: payment.id,
                debtorId: payment.debtorId,
                amountPaid: payment.amountPaid,
                paymentDate: payment.paymentDate,
                createdAt: payment.createdAt,
              ),
            )
            .toList();

    return DebtorModel(
      id: result.id,
      saleId: result.saleId,
      name: result.name,
      contact: result.contact,
      totalDebt: result.totalDebt,
      paidAmount: result.paidAmount,
      outstandingBalance: result.outstandingBalance,
      createdAt: result.createdAt,
      updatedAt: result.updatedAt,
      paymentHistory: paymentHistory,
    );
  }

  // Delete sale (mainly for testing/admin purposes)
  Future<bool> deleteSale(int saleId) async {
    return _database.transaction(() async {
      // Get all sale items first to restore inventory
      final items =
          await (_database.select(_database.saleItems)
            ..where((t) => t.saleId.equals(saleId))).get();

      // Restore inventory quantities
      for (final item in items) {
        final inventoryItem =
            await (_database.select(_database.inventoryItems)
              ..where((t) => t.id.equals(item.inventoryItemId))).getSingle();

        await (_database.update(_database.inventoryItems)
          ..where((t) => t.id.equals(item.inventoryItemId))).write(
          InventoryItemsCompanion(
            quantity: Value(inventoryItem.quantity + item.quantity),
            updatedAt: Value(DateTime.now()),
          ),
        );
      }

      // Delete related records
      await (_database.delete(_database.saleItems)
        ..where((t) => t.saleId.equals(saleId))).go();

      // Check for debtor record
      final debtorQuery = _database.select(_database.debtors)
        ..where((t) => t.saleId.equals(saleId));
      final debtor = await debtorQuery.getSingleOrNull();

      if (debtor != null) {
        // Delete debtor payments
        await (_database.delete(_database.debtorPayments)
          ..where((t) => t.debtorId.equals(debtor.id))).go();

        // Delete debtor
        await (_database.delete(_database.debtors)
          ..where((t) => t.id.equals(debtor.id))).go();
      }

      // Delete the sale
      final deletedRows =
          await (_database.delete(_database.sales)
            ..where((t) => t.id.equals(saleId))).go();

      return deletedRows > 0;
    });
  }
}