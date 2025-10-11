import 'package:drift/drift.dart';
import 'package:yesudua_ventures/app/data/local/app_database.dart';
import 'package:yesudua_ventures/app/data/models/inventory_model.dart';

// Abstract repository interface following SOLID principles
abstract class InventoryRepository {
  // Inventory Items
  Future<List<InventoryItemModel>> getAllInventoryItems();
  Stream<List<InventoryItemModel>> watchAllInventoryItems();
  Future<InventoryItemModel?> getInventoryItemById(int id);
  Future<int> addInventoryItem(InventoryItemModel item);
  Future<bool> updateInventoryItem(InventoryItemModel item);
  Future<bool> deleteInventoryItem(int id);
  Future<List<InventoryItemModel>> searchInventoryItems(String query);
  Future<List<InventoryItemModel>> getInventoryItemsByCategory(int categoryId);

  // Categories
  Future<List<CategoryModel>> getAllCategories();
  Stream<List<CategoryModel>> watchAllCategories();
  Future<CategoryModel?> getCategoryById(int id);
  Future<int> addCategory(CategoryModel category);
  Future<bool> updateCategory(CategoryModel category);
  Future<bool> deleteCategory(int id);

  // Suppliers
  Future<List<SupplierModel>> getAllSuppliers();
  Stream<List<SupplierModel>> watchAllSuppliers();
  Future<SupplierModel?> getSupplierById(int id);
  Future<int> addSupplier(SupplierModel supplier);
  Future<bool> updateSupplier(SupplierModel supplier);
  Future<bool> deleteSupplier(int id);

  // Supply History
  Future<List<SupplyHistoryModel>> getSupplyHistoryBySupplier(int supplierId);
  Future<List<SupplyHistoryModel>> getSupplyHistoryByItem(int itemId);
  Future<int> addSupplyHistory(SupplyHistoryModel supplyHistory);

  // Stock Management
  Future<bool> updateInventoryQuantity(int itemId, double newQuantity);
  Future<bool> restockInventoryItem(
    int itemId,
    double quantity,
    double boughtPrice,
    int supplierId,
  );
}

class InventoryRepositoryImpl implements InventoryRepository {
  final AppDatabase _db;

  InventoryRepositoryImpl(this._db);

  // Convert database entities to model objects
  InventoryItemModel _inventoryItemToModel(
    InventoryItem item,
    Category? category,
    Supplier? supplier,
  ) {
    return InventoryItemModel(
      id: item.id,
      name: item.name,
      categoryId: item.categoryId,
      quantity: item.quantity,
      boughtPrice: item.boughtPrice,
      sellPrice: item.sellPrice,
      supplierId: item.supplierId,
      imagePath: item.imagePath,
      lastRestocked: item.lastRestocked,
      createdAt: item.createdAt,
      updatedAt: item.updatedAt,
      categoryName: category?.name,
      supplierName: supplier?.name,
    );
  }

  CategoryModel _categoryToModel(Category category) {
    return CategoryModel(
      id: category.id,
      name: category.name,
      description: category.description,
      createdAt: category.createdAt,
      updatedAt: category.updatedAt,
    );
  }

  SupplierModel _supplierToModel(Supplier supplier) {
    return SupplierModel(
      id: supplier.id,
      name: supplier.name,
      contact: supplier.contact,
      address: supplier.address,
      createdAt: supplier.createdAt,
      updatedAt: supplier.updatedAt,
    );
  }

  SupplyHistoryModel _supplyHistoryToModel(
    SupplyHistoryData history, {
    String? itemName,
    String? supplierName,
  }) {
    return SupplyHistoryModel(
      id: history.id,
      supplierId: history.supplierId,
      inventoryItemId: history.inventoryItemId,
      quantity: history.quantity,
      boughtPrice: history.boughtPrice,
      supplyDate: history.supplyDate,
      createdAt: history.createdAt,
      itemName: itemName,
      supplierName: supplierName,
    );
  }

  // Inventory Items Implementation
  @override
  Future<List<InventoryItemModel>> getAllInventoryItems() async {
    final items = await _db.watchInventoryWithRelations().first;
    return items
        .map(
          (relation) => _inventoryItemToModel(
            relation.item,
            relation.category,
            relation.supplier,
          ),
        )
        .toList();
  }

  @override
  Stream<List<InventoryItemModel>> watchAllInventoryItems() {
    return _db.watchInventoryWithRelations().map(
      (items) =>
          items
              .map(
                (relation) => _inventoryItemToModel(
                  relation.item,
                  relation.category,
                  relation.supplier,
                ),
              )
              .toList(),
    );
  }

  @override
  Future<InventoryItemModel?> getInventoryItemById(int id) async {
    try {
      final relation = await _db.getInventoryItemWithRelations(id);
      return _inventoryItemToModel(
        relation.item,
        relation.category,
        relation.supplier,
      );
    } catch (e) {
      return null;
    }
  }

  @override
  Future<int> addInventoryItem(InventoryItemModel item) async {
    return await _db
        .into(_db.inventoryItems)
        .insert(
          InventoryItemsCompanion.insert(
            name: item.name,
            categoryId: item.categoryId,
            quantity: Value(item.quantity),
            boughtPrice: item.boughtPrice,
            sellPrice: item.sellPrice,
            supplierId:
                item.supplierId != null
                    ? Value(item.supplierId!)
                    : const Value.absent(),
            imagePath:
                item.imagePath != null
                    ? Value(item.imagePath!)
                    : const Value.absent(),
            lastRestocked:
                item.lastRestocked != null
                    ? Value(item.lastRestocked!)
                    : const Value.absent(),
          ),
        );
  }

  @override
  Future<bool> updateInventoryItem(InventoryItemModel item) async {
    if (item.id == null) return false;

    final rowsAffected = await (_db.update(_db.inventoryItems)
      ..where((tbl) => tbl.id.equals(item.id!))).write(
      InventoryItemsCompanion(
        name: Value(item.name),
        categoryId: Value(item.categoryId),
        quantity: Value(item.quantity),
        boughtPrice: Value(item.boughtPrice),
        sellPrice: Value(item.sellPrice),
        supplierId:
            item.supplierId != null
                ? Value(item.supplierId!)
                : const Value.absent(),
        imagePath:
            item.imagePath != null
                ? Value(item.imagePath!)
                : const Value.absent(),
        lastRestocked:
            item.lastRestocked != null
                ? Value(item.lastRestocked!)
                : const Value.absent(),
        updatedAt: Value(DateTime.now()),
      ),
    );

    return rowsAffected > 0;
  }

  @override
  Future<bool> deleteInventoryItem(int id) async {
    final rowsAffected =
        await (_db.delete(_db.inventoryItems)
          ..where((tbl) => tbl.id.equals(id))).go();

    return rowsAffected > 0;
  }

  @override
  Future<List<InventoryItemModel>> searchInventoryItems(String query) async {
    final searchTerm = '%$query%';

    final results =
        await (_db.select(_db.inventoryItems).join([
          leftOuterJoin(
            _db.categories,
            _db.categories.id.equalsExp(_db.inventoryItems.categoryId),
          ),
          leftOuterJoin(
            _db.suppliers,
            _db.suppliers.id.equalsExp(_db.inventoryItems.supplierId),
          ),
        ])..where(_db.inventoryItems.name.like(searchTerm))).get();

    return results.map((row) {
      final item = row.readTable(_db.inventoryItems);
      final category = row.readTable(_db.categories);
      final supplier = row.readTableOrNull(_db.suppliers);

      return _inventoryItemToModel(item, category, supplier);
    }).toList();
  }

  @override
  Future<List<InventoryItemModel>> getInventoryItemsByCategory(
    int categoryId,
  ) async {
    final results =
        await (_db.select(_db.inventoryItems).join([
          leftOuterJoin(
            _db.categories,
            _db.categories.id.equalsExp(_db.inventoryItems.categoryId),
          ),
          leftOuterJoin(
            _db.suppliers,
            _db.suppliers.id.equalsExp(_db.inventoryItems.supplierId),
          ),
        ])..where(_db.inventoryItems.categoryId.equals(categoryId))).get();

    return results.map((row) {
      final item = row.readTable(_db.inventoryItems);
      final category = row.readTable(_db.categories);
      final supplier = row.readTableOrNull(_db.suppliers);

      return _inventoryItemToModel(item, category, supplier);
    }).toList();
  }

  // Categories Implementation
  @override
  Future<List<CategoryModel>> getAllCategories() async {
    final categories = await _db.select(_db.categories).get();
    return categories.map(_categoryToModel).toList();
  }

  @override
  Stream<List<CategoryModel>> watchAllCategories() {
    return _db
        .select(_db.categories)
        .watch()
        .map((categories) => categories.map(_categoryToModel).toList());
  }

  @override
  Future<CategoryModel?> getCategoryById(int id) async {
    try {
      final category =
          await (_db.select(_db.categories)
            ..where((tbl) => tbl.id.equals(id))).getSingle();
      return _categoryToModel(category);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<int> addCategory(CategoryModel category) async {
    return await _db
        .into(_db.categories)
        .insert(
          CategoriesCompanion.insert(
            name: category.name,
            description:
                category.description != null
                    ? Value(category.description!)
                    : const Value.absent(),
          ),
        );
  }

  @override
  Future<bool> updateCategory(CategoryModel category) async {
    if (category.id == null) return false;

    final rowsAffected = await (_db.update(_db.categories)
      ..where((tbl) => tbl.id.equals(category.id!))).write(
      CategoriesCompanion(
        name: Value(category.name),
        description:
            category.description != null
                ? Value(category.description!)
                : const Value.absent(),
        updatedAt: Value(DateTime.now()),
      ),
    );

    return rowsAffected > 0;
  }

  @override
  Future<bool> deleteCategory(int id) async {
    // Check if category is in use
    final itemsUsingCategory =
        await (_db.select(_db.inventoryItems)
          ..where((tbl) => tbl.categoryId.equals(id))).get();

    if (itemsUsingCategory.isNotEmpty) {
      return false; // Cannot delete category in use
    }

    final rowsAffected =
        await (_db.delete(_db.categories)
          ..where((tbl) => tbl.id.equals(id))).go();

    return rowsAffected > 0;
  }

  // Suppliers Implementation
  @override
  Future<List<SupplierModel>> getAllSuppliers() async {
    final suppliers = await _db.select(_db.suppliers).get();
    return suppliers.map(_supplierToModel).toList();
  }

  @override
  Stream<List<SupplierModel>> watchAllSuppliers() {
    return _db
        .select(_db.suppliers)
        .watch()
        .map((suppliers) => suppliers.map(_supplierToModel).toList());
  }

  @override
  Future<SupplierModel?> getSupplierById(int id) async {
    try {
      final supplier =
          await (_db.select(_db.suppliers)
            ..where((tbl) => tbl.id.equals(id))).getSingle();
      return _supplierToModel(supplier);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<int> addSupplier(SupplierModel supplier) async {
    return await _db
        .into(_db.suppliers)
        .insert(
          SuppliersCompanion.insert(
            name: supplier.name,
            contact: supplier.contact,
            address:
                supplier.address != null
                    ? Value(supplier.address!)
                    : const Value.absent(),
          ),
        );
  }

  @override
  Future<bool> updateSupplier(SupplierModel supplier) async {
    if (supplier.id == null) return false;

    final rowsAffected = await (_db.update(_db.suppliers)
      ..where((tbl) => tbl.id.equals(supplier.id!))).write(
      SuppliersCompanion(
        name: Value(supplier.name),
        contact: Value(supplier.contact),
        address:
            supplier.address != null
                ? Value(supplier.address!)
                : const Value.absent(),
        updatedAt: Value(DateTime.now()),
      ),
    );

    return rowsAffected > 0;
  }

  @override
  Future<bool> deleteSupplier(int id) async {
    // Check if supplier is in use
    final itemsUsingSupplier =
        await (_db.select(_db.inventoryItems)
          ..where((tbl) => tbl.supplierId.equals(id))).get();

    if (itemsUsingSupplier.isNotEmpty) {
      return false; // Cannot delete supplier in use
    }

    final rowsAffected =
        await (_db.delete(_db.suppliers)
          ..where((tbl) => tbl.id.equals(id))).go();

    return rowsAffected > 0;
  }

  // Supply History Implementation
  @override
  Future<List<SupplyHistoryModel>> getSupplyHistoryBySupplier(
    int supplierId,
  ) async {
    final results =
        await (_db.select(_db.supplyHistory).join([
          innerJoin(
            _db.suppliers,
            _db.suppliers.id.equalsExp(_db.supplyHistory.supplierId),
          ),
          innerJoin(
            _db.inventoryItems,
            _db.inventoryItems.id.equalsExp(_db.supplyHistory.inventoryItemId),
          ),
        ])..where(_db.supplyHistory.supplierId.equals(supplierId))).get();

    return results.map((row) {
      final history = row.readTable(_db.supplyHistory);
      final supplier = row.readTable(_db.suppliers);
      final item = row.readTable(_db.inventoryItems);

      return _supplyHistoryToModel(
        history,
        itemName: item.name,
        supplierName: supplier.name,
      );
    }).toList();
  }

  @override
  Future<List<SupplyHistoryModel>> getSupplyHistoryByItem(int itemId) async {
    final results =
        await (_db.select(_db.supplyHistory).join([
          innerJoin(
            _db.suppliers,
            _db.suppliers.id.equalsExp(_db.supplyHistory.supplierId),
          ),
          innerJoin(
            _db.inventoryItems,
            _db.inventoryItems.id.equalsExp(_db.supplyHistory.inventoryItemId),
          ),
        ])..where(_db.supplyHistory.inventoryItemId.equals(itemId))).get();

    return results.map((row) {
      final history = row.readTable(_db.supplyHistory);
      final supplier = row.readTable(_db.suppliers);
      final item = row.readTable(_db.inventoryItems);

      return _supplyHistoryToModel(
        history,
        itemName: item.name,
        supplierName: supplier.name,
      );
    }).toList();
  }

  @override
  Future<int> addSupplyHistory(SupplyHistoryModel supplyHistory) async {
    return await _db
        .into(_db.supplyHistory)
        .insert(
          SupplyHistoryCompanion.insert(
            supplierId: supplyHistory.supplierId,
            inventoryItemId: supplyHistory.inventoryItemId,
            quantity: supplyHistory.quantity,
            boughtPrice: supplyHistory.boughtPrice,
            supplyDate: Value(supplyHistory.supplyDate),
          ),
        );
  }

  // Stock Management Implementation
  @override
  Future<bool> updateInventoryQuantity(int itemId, double newQuantity) async {
    final rowsAffected = await (_db.update(_db.inventoryItems)
      ..where((tbl) => tbl.id.equals(itemId))).write(
      InventoryItemsCompanion(
        quantity: Value(newQuantity),
        updatedAt: Value(DateTime.now()),
      ),
    );

    return rowsAffected > 0;
  }

  @override
  Future<bool> restockInventoryItem(
    int itemId,
    double quantity,
    double boughtPrice,
    int supplierId,
  ) async {
    return await _db.transaction(() async {
      try {
        // Get current item
        final item =
            await (_db.select(_db.inventoryItems)
              ..where((tbl) => tbl.id.equals(itemId))).getSingle();

        // Update inventory quantity
        final newQuantity = item.quantity + quantity;
        await (_db.update(_db.inventoryItems)
          ..where((tbl) => tbl.id.equals(itemId))).write(
          InventoryItemsCompanion(
            quantity: Value(newQuantity),
            boughtPrice: Value(boughtPrice),
            supplierId: Value(supplierId),
            lastRestocked: Value(DateTime.now()),
            updatedAt: Value(DateTime.now()),
          ),
        );

        // Record in supply history
        await _db
            .into(_db.supplyHistory)
            .insert(
              SupplyHistoryCompanion.insert(
                supplierId: supplierId,
                inventoryItemId: itemId,
                quantity: quantity,
                boughtPrice: boughtPrice,
                supplyDate: Value(DateTime.now()),
              ),
            );

        return true;
      } catch (e) {
        return false;
      }
    });
  }
}
