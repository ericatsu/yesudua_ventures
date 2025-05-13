// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'drift_database.dart';

// ignore_for_file: type=lint
class $InventoryItemsTable extends InventoryItems
    with TableInfo<$InventoryItemsTable, InventoryItem> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $InventoryItemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _categoryMeta = const VerificationMeta(
    'category',
  );
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
    'category',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _quantityMeta = const VerificationMeta(
    'quantity',
  );
  @override
  late final GeneratedColumn<int> quantity = GeneratedColumn<int>(
    'quantity',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _boughtPriceMeta = const VerificationMeta(
    'boughtPrice',
  );
  @override
  late final GeneratedColumn<double> boughtPrice = GeneratedColumn<double>(
    'bought_price',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sellPriceMeta = const VerificationMeta(
    'sellPrice',
  );
  @override
  late final GeneratedColumn<double> sellPrice = GeneratedColumn<double>(
    'sell_price',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _supplierMeta = const VerificationMeta(
    'supplier',
  );
  @override
  late final GeneratedColumn<String> supplier = GeneratedColumn<String>(
    'supplier',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _imageKeyMeta = const VerificationMeta(
    'imageKey',
  );
  @override
  late final GeneratedColumn<String> imageKey = GeneratedColumn<String>(
    'image_key',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _lastUpdatedMeta = const VerificationMeta(
    'lastUpdated',
  );
  @override
  late final GeneratedColumn<DateTime> lastUpdated = GeneratedColumn<DateTime>(
    'last_updated',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _needsSyncMeta = const VerificationMeta(
    'needsSync',
  );
  @override
  late final GeneratedColumn<bool> needsSync = GeneratedColumn<bool>(
    'needs_sync',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("needs_sync" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    category,
    quantity,
    boughtPrice,
    sellPrice,
    supplier,
    imageKey,
    lastUpdated,
    needsSync,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'inventory_items';
  @override
  VerificationContext validateIntegrity(
    Insertable<InventoryItem> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('category')) {
      context.handle(
        _categoryMeta,
        category.isAcceptableOrUnknown(data['category']!, _categoryMeta),
      );
    } else if (isInserting) {
      context.missing(_categoryMeta);
    }
    if (data.containsKey('quantity')) {
      context.handle(
        _quantityMeta,
        quantity.isAcceptableOrUnknown(data['quantity']!, _quantityMeta),
      );
    } else if (isInserting) {
      context.missing(_quantityMeta);
    }
    if (data.containsKey('bought_price')) {
      context.handle(
        _boughtPriceMeta,
        boughtPrice.isAcceptableOrUnknown(
          data['bought_price']!,
          _boughtPriceMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_boughtPriceMeta);
    }
    if (data.containsKey('sell_price')) {
      context.handle(
        _sellPriceMeta,
        sellPrice.isAcceptableOrUnknown(data['sell_price']!, _sellPriceMeta),
      );
    } else if (isInserting) {
      context.missing(_sellPriceMeta);
    }
    if (data.containsKey('supplier')) {
      context.handle(
        _supplierMeta,
        supplier.isAcceptableOrUnknown(data['supplier']!, _supplierMeta),
      );
    }
    if (data.containsKey('image_key')) {
      context.handle(
        _imageKeyMeta,
        imageKey.isAcceptableOrUnknown(data['image_key']!, _imageKeyMeta),
      );
    }
    if (data.containsKey('last_updated')) {
      context.handle(
        _lastUpdatedMeta,
        lastUpdated.isAcceptableOrUnknown(
          data['last_updated']!,
          _lastUpdatedMeta,
        ),
      );
    }
    if (data.containsKey('needs_sync')) {
      context.handle(
        _needsSyncMeta,
        needsSync.isAcceptableOrUnknown(data['needs_sync']!, _needsSyncMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  InventoryItem map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return InventoryItem(
      id:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}id'],
          )!,
      name:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}name'],
          )!,
      category:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}category'],
          )!,
      quantity:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}quantity'],
          )!,
      boughtPrice:
          attachedDatabase.typeMapping.read(
            DriftSqlType.double,
            data['${effectivePrefix}bought_price'],
          )!,
      sellPrice:
          attachedDatabase.typeMapping.read(
            DriftSqlType.double,
            data['${effectivePrefix}sell_price'],
          )!,
      supplier: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}supplier'],
      ),
      imageKey: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}image_key'],
      ),
      lastUpdated: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_updated'],
      ),
      needsSync:
          attachedDatabase.typeMapping.read(
            DriftSqlType.bool,
            data['${effectivePrefix}needs_sync'],
          )!,
    );
  }

  @override
  $InventoryItemsTable createAlias(String alias) {
    return $InventoryItemsTable(attachedDatabase, alias);
  }
}

class InventoryItem extends DataClass implements Insertable<InventoryItem> {
  final int id;
  final String name;
  final String category;
  final int quantity;
  final double boughtPrice;
  final double sellPrice;
  final String? supplier;
  final String? imageKey;
  final DateTime? lastUpdated;
  final bool needsSync;
  const InventoryItem({
    required this.id,
    required this.name,
    required this.category,
    required this.quantity,
    required this.boughtPrice,
    required this.sellPrice,
    this.supplier,
    this.imageKey,
    this.lastUpdated,
    required this.needsSync,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['category'] = Variable<String>(category);
    map['quantity'] = Variable<int>(quantity);
    map['bought_price'] = Variable<double>(boughtPrice);
    map['sell_price'] = Variable<double>(sellPrice);
    if (!nullToAbsent || supplier != null) {
      map['supplier'] = Variable<String>(supplier);
    }
    if (!nullToAbsent || imageKey != null) {
      map['image_key'] = Variable<String>(imageKey);
    }
    if (!nullToAbsent || lastUpdated != null) {
      map['last_updated'] = Variable<DateTime>(lastUpdated);
    }
    map['needs_sync'] = Variable<bool>(needsSync);
    return map;
  }

  InventoryItemsCompanion toCompanion(bool nullToAbsent) {
    return InventoryItemsCompanion(
      id: Value(id),
      name: Value(name),
      category: Value(category),
      quantity: Value(quantity),
      boughtPrice: Value(boughtPrice),
      sellPrice: Value(sellPrice),
      supplier:
          supplier == null && nullToAbsent
              ? const Value.absent()
              : Value(supplier),
      imageKey:
          imageKey == null && nullToAbsent
              ? const Value.absent()
              : Value(imageKey),
      lastUpdated:
          lastUpdated == null && nullToAbsent
              ? const Value.absent()
              : Value(lastUpdated),
      needsSync: Value(needsSync),
    );
  }

  factory InventoryItem.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return InventoryItem(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      category: serializer.fromJson<String>(json['category']),
      quantity: serializer.fromJson<int>(json['quantity']),
      boughtPrice: serializer.fromJson<double>(json['boughtPrice']),
      sellPrice: serializer.fromJson<double>(json['sellPrice']),
      supplier: serializer.fromJson<String?>(json['supplier']),
      imageKey: serializer.fromJson<String?>(json['imageKey']),
      lastUpdated: serializer.fromJson<DateTime?>(json['lastUpdated']),
      needsSync: serializer.fromJson<bool>(json['needsSync']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'category': serializer.toJson<String>(category),
      'quantity': serializer.toJson<int>(quantity),
      'boughtPrice': serializer.toJson<double>(boughtPrice),
      'sellPrice': serializer.toJson<double>(sellPrice),
      'supplier': serializer.toJson<String?>(supplier),
      'imageKey': serializer.toJson<String?>(imageKey),
      'lastUpdated': serializer.toJson<DateTime?>(lastUpdated),
      'needsSync': serializer.toJson<bool>(needsSync),
    };
  }

  InventoryItem copyWith({
    int? id,
    String? name,
    String? category,
    int? quantity,
    double? boughtPrice,
    double? sellPrice,
    Value<String?> supplier = const Value.absent(),
    Value<String?> imageKey = const Value.absent(),
    Value<DateTime?> lastUpdated = const Value.absent(),
    bool? needsSync,
  }) => InventoryItem(
    id: id ?? this.id,
    name: name ?? this.name,
    category: category ?? this.category,
    quantity: quantity ?? this.quantity,
    boughtPrice: boughtPrice ?? this.boughtPrice,
    sellPrice: sellPrice ?? this.sellPrice,
    supplier: supplier.present ? supplier.value : this.supplier,
    imageKey: imageKey.present ? imageKey.value : this.imageKey,
    lastUpdated: lastUpdated.present ? lastUpdated.value : this.lastUpdated,
    needsSync: needsSync ?? this.needsSync,
  );
  InventoryItem copyWithCompanion(InventoryItemsCompanion data) {
    return InventoryItem(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      category: data.category.present ? data.category.value : this.category,
      quantity: data.quantity.present ? data.quantity.value : this.quantity,
      boughtPrice:
          data.boughtPrice.present ? data.boughtPrice.value : this.boughtPrice,
      sellPrice: data.sellPrice.present ? data.sellPrice.value : this.sellPrice,
      supplier: data.supplier.present ? data.supplier.value : this.supplier,
      imageKey: data.imageKey.present ? data.imageKey.value : this.imageKey,
      lastUpdated:
          data.lastUpdated.present ? data.lastUpdated.value : this.lastUpdated,
      needsSync: data.needsSync.present ? data.needsSync.value : this.needsSync,
    );
  }

  @override
  String toString() {
    return (StringBuffer('InventoryItem(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('category: $category, ')
          ..write('quantity: $quantity, ')
          ..write('boughtPrice: $boughtPrice, ')
          ..write('sellPrice: $sellPrice, ')
          ..write('supplier: $supplier, ')
          ..write('imageKey: $imageKey, ')
          ..write('lastUpdated: $lastUpdated, ')
          ..write('needsSync: $needsSync')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    category,
    quantity,
    boughtPrice,
    sellPrice,
    supplier,
    imageKey,
    lastUpdated,
    needsSync,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is InventoryItem &&
          other.id == this.id &&
          other.name == this.name &&
          other.category == this.category &&
          other.quantity == this.quantity &&
          other.boughtPrice == this.boughtPrice &&
          other.sellPrice == this.sellPrice &&
          other.supplier == this.supplier &&
          other.imageKey == this.imageKey &&
          other.lastUpdated == this.lastUpdated &&
          other.needsSync == this.needsSync);
}

class InventoryItemsCompanion extends UpdateCompanion<InventoryItem> {
  final Value<int> id;
  final Value<String> name;
  final Value<String> category;
  final Value<int> quantity;
  final Value<double> boughtPrice;
  final Value<double> sellPrice;
  final Value<String?> supplier;
  final Value<String?> imageKey;
  final Value<DateTime?> lastUpdated;
  final Value<bool> needsSync;
  const InventoryItemsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.category = const Value.absent(),
    this.quantity = const Value.absent(),
    this.boughtPrice = const Value.absent(),
    this.sellPrice = const Value.absent(),
    this.supplier = const Value.absent(),
    this.imageKey = const Value.absent(),
    this.lastUpdated = const Value.absent(),
    this.needsSync = const Value.absent(),
  });
  InventoryItemsCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required String category,
    required int quantity,
    required double boughtPrice,
    required double sellPrice,
    this.supplier = const Value.absent(),
    this.imageKey = const Value.absent(),
    this.lastUpdated = const Value.absent(),
    this.needsSync = const Value.absent(),
  }) : name = Value(name),
       category = Value(category),
       quantity = Value(quantity),
       boughtPrice = Value(boughtPrice),
       sellPrice = Value(sellPrice);
  static Insertable<InventoryItem> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? category,
    Expression<int>? quantity,
    Expression<double>? boughtPrice,
    Expression<double>? sellPrice,
    Expression<String>? supplier,
    Expression<String>? imageKey,
    Expression<DateTime>? lastUpdated,
    Expression<bool>? needsSync,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (category != null) 'category': category,
      if (quantity != null) 'quantity': quantity,
      if (boughtPrice != null) 'bought_price': boughtPrice,
      if (sellPrice != null) 'sell_price': sellPrice,
      if (supplier != null) 'supplier': supplier,
      if (imageKey != null) 'image_key': imageKey,
      if (lastUpdated != null) 'last_updated': lastUpdated,
      if (needsSync != null) 'needs_sync': needsSync,
    });
  }

  InventoryItemsCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<String>? category,
    Value<int>? quantity,
    Value<double>? boughtPrice,
    Value<double>? sellPrice,
    Value<String?>? supplier,
    Value<String?>? imageKey,
    Value<DateTime?>? lastUpdated,
    Value<bool>? needsSync,
  }) {
    return InventoryItemsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      category: category ?? this.category,
      quantity: quantity ?? this.quantity,
      boughtPrice: boughtPrice ?? this.boughtPrice,
      sellPrice: sellPrice ?? this.sellPrice,
      supplier: supplier ?? this.supplier,
      imageKey: imageKey ?? this.imageKey,
      lastUpdated: lastUpdated ?? this.lastUpdated,
      needsSync: needsSync ?? this.needsSync,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (quantity.present) {
      map['quantity'] = Variable<int>(quantity.value);
    }
    if (boughtPrice.present) {
      map['bought_price'] = Variable<double>(boughtPrice.value);
    }
    if (sellPrice.present) {
      map['sell_price'] = Variable<double>(sellPrice.value);
    }
    if (supplier.present) {
      map['supplier'] = Variable<String>(supplier.value);
    }
    if (imageKey.present) {
      map['image_key'] = Variable<String>(imageKey.value);
    }
    if (lastUpdated.present) {
      map['last_updated'] = Variable<DateTime>(lastUpdated.value);
    }
    if (needsSync.present) {
      map['needs_sync'] = Variable<bool>(needsSync.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('InventoryItemsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('category: $category, ')
          ..write('quantity: $quantity, ')
          ..write('boughtPrice: $boughtPrice, ')
          ..write('sellPrice: $sellPrice, ')
          ..write('supplier: $supplier, ')
          ..write('imageKey: $imageKey, ')
          ..write('lastUpdated: $lastUpdated, ')
          ..write('needsSync: $needsSync')
          ..write(')'))
        .toString();
  }
}

class $SalesTable extends Sales with TableInfo<$SalesTable, Sale> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SalesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _itemIdMeta = const VerificationMeta('itemId');
  @override
  late final GeneratedColumn<int> itemId = GeneratedColumn<int>(
    'item_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _quantitySoldMeta = const VerificationMeta(
    'quantitySold',
  );
  @override
  late final GeneratedColumn<int> quantitySold = GeneratedColumn<int>(
    'quantity_sold',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _soldPriceMeta = const VerificationMeta(
    'soldPrice',
  );
  @override
  late final GeneratedColumn<double> soldPrice = GeneratedColumn<double>(
    'sold_price',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dateOfSaleMeta = const VerificationMeta(
    'dateOfSale',
  );
  @override
  late final GeneratedColumn<DateTime> dateOfSale = GeneratedColumn<DateTime>(
    'date_of_sale',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isPaidMeta = const VerificationMeta('isPaid');
  @override
  late final GeneratedColumn<bool> isPaid = GeneratedColumn<bool>(
    'is_paid',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_paid" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    itemId,
    quantitySold,
    soldPrice,
    dateOfSale,
    isPaid,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'sales';
  @override
  VerificationContext validateIntegrity(
    Insertable<Sale> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('item_id')) {
      context.handle(
        _itemIdMeta,
        itemId.isAcceptableOrUnknown(data['item_id']!, _itemIdMeta),
      );
    } else if (isInserting) {
      context.missing(_itemIdMeta);
    }
    if (data.containsKey('quantity_sold')) {
      context.handle(
        _quantitySoldMeta,
        quantitySold.isAcceptableOrUnknown(
          data['quantity_sold']!,
          _quantitySoldMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_quantitySoldMeta);
    }
    if (data.containsKey('sold_price')) {
      context.handle(
        _soldPriceMeta,
        soldPrice.isAcceptableOrUnknown(data['sold_price']!, _soldPriceMeta),
      );
    } else if (isInserting) {
      context.missing(_soldPriceMeta);
    }
    if (data.containsKey('date_of_sale')) {
      context.handle(
        _dateOfSaleMeta,
        dateOfSale.isAcceptableOrUnknown(
          data['date_of_sale']!,
          _dateOfSaleMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_dateOfSaleMeta);
    }
    if (data.containsKey('is_paid')) {
      context.handle(
        _isPaidMeta,
        isPaid.isAcceptableOrUnknown(data['is_paid']!, _isPaidMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Sale map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Sale(
      id:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}id'],
          )!,
      itemId:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}item_id'],
          )!,
      quantitySold:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}quantity_sold'],
          )!,
      soldPrice:
          attachedDatabase.typeMapping.read(
            DriftSqlType.double,
            data['${effectivePrefix}sold_price'],
          )!,
      dateOfSale:
          attachedDatabase.typeMapping.read(
            DriftSqlType.dateTime,
            data['${effectivePrefix}date_of_sale'],
          )!,
      isPaid:
          attachedDatabase.typeMapping.read(
            DriftSqlType.bool,
            data['${effectivePrefix}is_paid'],
          )!,
    );
  }

  @override
  $SalesTable createAlias(String alias) {
    return $SalesTable(attachedDatabase, alias);
  }
}

class Sale extends DataClass implements Insertable<Sale> {
  final int id;
  final int itemId;
  final int quantitySold;
  final double soldPrice;
  final DateTime dateOfSale;
  final bool isPaid;
  const Sale({
    required this.id,
    required this.itemId,
    required this.quantitySold,
    required this.soldPrice,
    required this.dateOfSale,
    required this.isPaid,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['item_id'] = Variable<int>(itemId);
    map['quantity_sold'] = Variable<int>(quantitySold);
    map['sold_price'] = Variable<double>(soldPrice);
    map['date_of_sale'] = Variable<DateTime>(dateOfSale);
    map['is_paid'] = Variable<bool>(isPaid);
    return map;
  }

  SalesCompanion toCompanion(bool nullToAbsent) {
    return SalesCompanion(
      id: Value(id),
      itemId: Value(itemId),
      quantitySold: Value(quantitySold),
      soldPrice: Value(soldPrice),
      dateOfSale: Value(dateOfSale),
      isPaid: Value(isPaid),
    );
  }

  factory Sale.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Sale(
      id: serializer.fromJson<int>(json['id']),
      itemId: serializer.fromJson<int>(json['itemId']),
      quantitySold: serializer.fromJson<int>(json['quantitySold']),
      soldPrice: serializer.fromJson<double>(json['soldPrice']),
      dateOfSale: serializer.fromJson<DateTime>(json['dateOfSale']),
      isPaid: serializer.fromJson<bool>(json['isPaid']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'itemId': serializer.toJson<int>(itemId),
      'quantitySold': serializer.toJson<int>(quantitySold),
      'soldPrice': serializer.toJson<double>(soldPrice),
      'dateOfSale': serializer.toJson<DateTime>(dateOfSale),
      'isPaid': serializer.toJson<bool>(isPaid),
    };
  }

  Sale copyWith({
    int? id,
    int? itemId,
    int? quantitySold,
    double? soldPrice,
    DateTime? dateOfSale,
    bool? isPaid,
  }) => Sale(
    id: id ?? this.id,
    itemId: itemId ?? this.itemId,
    quantitySold: quantitySold ?? this.quantitySold,
    soldPrice: soldPrice ?? this.soldPrice,
    dateOfSale: dateOfSale ?? this.dateOfSale,
    isPaid: isPaid ?? this.isPaid,
  );
  Sale copyWithCompanion(SalesCompanion data) {
    return Sale(
      id: data.id.present ? data.id.value : this.id,
      itemId: data.itemId.present ? data.itemId.value : this.itemId,
      quantitySold:
          data.quantitySold.present
              ? data.quantitySold.value
              : this.quantitySold,
      soldPrice: data.soldPrice.present ? data.soldPrice.value : this.soldPrice,
      dateOfSale:
          data.dateOfSale.present ? data.dateOfSale.value : this.dateOfSale,
      isPaid: data.isPaid.present ? data.isPaid.value : this.isPaid,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Sale(')
          ..write('id: $id, ')
          ..write('itemId: $itemId, ')
          ..write('quantitySold: $quantitySold, ')
          ..write('soldPrice: $soldPrice, ')
          ..write('dateOfSale: $dateOfSale, ')
          ..write('isPaid: $isPaid')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, itemId, quantitySold, soldPrice, dateOfSale, isPaid);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Sale &&
          other.id == this.id &&
          other.itemId == this.itemId &&
          other.quantitySold == this.quantitySold &&
          other.soldPrice == this.soldPrice &&
          other.dateOfSale == this.dateOfSale &&
          other.isPaid == this.isPaid);
}

class SalesCompanion extends UpdateCompanion<Sale> {
  final Value<int> id;
  final Value<int> itemId;
  final Value<int> quantitySold;
  final Value<double> soldPrice;
  final Value<DateTime> dateOfSale;
  final Value<bool> isPaid;
  const SalesCompanion({
    this.id = const Value.absent(),
    this.itemId = const Value.absent(),
    this.quantitySold = const Value.absent(),
    this.soldPrice = const Value.absent(),
    this.dateOfSale = const Value.absent(),
    this.isPaid = const Value.absent(),
  });
  SalesCompanion.insert({
    this.id = const Value.absent(),
    required int itemId,
    required int quantitySold,
    required double soldPrice,
    required DateTime dateOfSale,
    this.isPaid = const Value.absent(),
  }) : itemId = Value(itemId),
       quantitySold = Value(quantitySold),
       soldPrice = Value(soldPrice),
       dateOfSale = Value(dateOfSale);
  static Insertable<Sale> custom({
    Expression<int>? id,
    Expression<int>? itemId,
    Expression<int>? quantitySold,
    Expression<double>? soldPrice,
    Expression<DateTime>? dateOfSale,
    Expression<bool>? isPaid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (itemId != null) 'item_id': itemId,
      if (quantitySold != null) 'quantity_sold': quantitySold,
      if (soldPrice != null) 'sold_price': soldPrice,
      if (dateOfSale != null) 'date_of_sale': dateOfSale,
      if (isPaid != null) 'is_paid': isPaid,
    });
  }

  SalesCompanion copyWith({
    Value<int>? id,
    Value<int>? itemId,
    Value<int>? quantitySold,
    Value<double>? soldPrice,
    Value<DateTime>? dateOfSale,
    Value<bool>? isPaid,
  }) {
    return SalesCompanion(
      id: id ?? this.id,
      itemId: itemId ?? this.itemId,
      quantitySold: quantitySold ?? this.quantitySold,
      soldPrice: soldPrice ?? this.soldPrice,
      dateOfSale: dateOfSale ?? this.dateOfSale,
      isPaid: isPaid ?? this.isPaid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (itemId.present) {
      map['item_id'] = Variable<int>(itemId.value);
    }
    if (quantitySold.present) {
      map['quantity_sold'] = Variable<int>(quantitySold.value);
    }
    if (soldPrice.present) {
      map['sold_price'] = Variable<double>(soldPrice.value);
    }
    if (dateOfSale.present) {
      map['date_of_sale'] = Variable<DateTime>(dateOfSale.value);
    }
    if (isPaid.present) {
      map['is_paid'] = Variable<bool>(isPaid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SalesCompanion(')
          ..write('id: $id, ')
          ..write('itemId: $itemId, ')
          ..write('quantitySold: $quantitySold, ')
          ..write('soldPrice: $soldPrice, ')
          ..write('dateOfSale: $dateOfSale, ')
          ..write('isPaid: $isPaid')
          ..write(')'))
        .toString();
  }
}

class $DebtorsTable extends Debtors with TableInfo<$DebtorsTable, Debtor> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DebtorsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _customerNameMeta = const VerificationMeta(
    'customerName',
  );
  @override
  late final GeneratedColumn<String> customerName = GeneratedColumn<String>(
    'customer_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _customerContactMeta = const VerificationMeta(
    'customerContact',
  );
  @override
  late final GeneratedColumn<String> customerContact = GeneratedColumn<String>(
    'customer_contact',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _totalAmountMeta = const VerificationMeta(
    'totalAmount',
  );
  @override
  late final GeneratedColumn<double> totalAmount = GeneratedColumn<double>(
    'total_amount',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _amountPaidMeta = const VerificationMeta(
    'amountPaid',
  );
  @override
  late final GeneratedColumn<double> amountPaid = GeneratedColumn<double>(
    'amount_paid',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(0.0),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    customerName,
    customerContact,
    totalAmount,
    amountPaid,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'debtors';
  @override
  VerificationContext validateIntegrity(
    Insertable<Debtor> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('customer_name')) {
      context.handle(
        _customerNameMeta,
        customerName.isAcceptableOrUnknown(
          data['customer_name']!,
          _customerNameMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_customerNameMeta);
    }
    if (data.containsKey('customer_contact')) {
      context.handle(
        _customerContactMeta,
        customerContact.isAcceptableOrUnknown(
          data['customer_contact']!,
          _customerContactMeta,
        ),
      );
    }
    if (data.containsKey('total_amount')) {
      context.handle(
        _totalAmountMeta,
        totalAmount.isAcceptableOrUnknown(
          data['total_amount']!,
          _totalAmountMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_totalAmountMeta);
    }
    if (data.containsKey('amount_paid')) {
      context.handle(
        _amountPaidMeta,
        amountPaid.isAcceptableOrUnknown(data['amount_paid']!, _amountPaidMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Debtor map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Debtor(
      id:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}id'],
          )!,
      customerName:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}customer_name'],
          )!,
      customerContact: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}customer_contact'],
      ),
      totalAmount:
          attachedDatabase.typeMapping.read(
            DriftSqlType.double,
            data['${effectivePrefix}total_amount'],
          )!,
      amountPaid:
          attachedDatabase.typeMapping.read(
            DriftSqlType.double,
            data['${effectivePrefix}amount_paid'],
          )!,
      createdAt:
          attachedDatabase.typeMapping.read(
            DriftSqlType.dateTime,
            data['${effectivePrefix}created_at'],
          )!,
    );
  }

  @override
  $DebtorsTable createAlias(String alias) {
    return $DebtorsTable(attachedDatabase, alias);
  }
}

class Debtor extends DataClass implements Insertable<Debtor> {
  final int id;
  final String customerName;
  final String? customerContact;
  final double totalAmount;
  final double amountPaid;
  final DateTime createdAt;
  const Debtor({
    required this.id,
    required this.customerName,
    this.customerContact,
    required this.totalAmount,
    required this.amountPaid,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['customer_name'] = Variable<String>(customerName);
    if (!nullToAbsent || customerContact != null) {
      map['customer_contact'] = Variable<String>(customerContact);
    }
    map['total_amount'] = Variable<double>(totalAmount);
    map['amount_paid'] = Variable<double>(amountPaid);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  DebtorsCompanion toCompanion(bool nullToAbsent) {
    return DebtorsCompanion(
      id: Value(id),
      customerName: Value(customerName),
      customerContact:
          customerContact == null && nullToAbsent
              ? const Value.absent()
              : Value(customerContact),
      totalAmount: Value(totalAmount),
      amountPaid: Value(amountPaid),
      createdAt: Value(createdAt),
    );
  }

  factory Debtor.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Debtor(
      id: serializer.fromJson<int>(json['id']),
      customerName: serializer.fromJson<String>(json['customerName']),
      customerContact: serializer.fromJson<String?>(json['customerContact']),
      totalAmount: serializer.fromJson<double>(json['totalAmount']),
      amountPaid: serializer.fromJson<double>(json['amountPaid']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'customerName': serializer.toJson<String>(customerName),
      'customerContact': serializer.toJson<String?>(customerContact),
      'totalAmount': serializer.toJson<double>(totalAmount),
      'amountPaid': serializer.toJson<double>(amountPaid),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  Debtor copyWith({
    int? id,
    String? customerName,
    Value<String?> customerContact = const Value.absent(),
    double? totalAmount,
    double? amountPaid,
    DateTime? createdAt,
  }) => Debtor(
    id: id ?? this.id,
    customerName: customerName ?? this.customerName,
    customerContact:
        customerContact.present ? customerContact.value : this.customerContact,
    totalAmount: totalAmount ?? this.totalAmount,
    amountPaid: amountPaid ?? this.amountPaid,
    createdAt: createdAt ?? this.createdAt,
  );
  Debtor copyWithCompanion(DebtorsCompanion data) {
    return Debtor(
      id: data.id.present ? data.id.value : this.id,
      customerName:
          data.customerName.present
              ? data.customerName.value
              : this.customerName,
      customerContact:
          data.customerContact.present
              ? data.customerContact.value
              : this.customerContact,
      totalAmount:
          data.totalAmount.present ? data.totalAmount.value : this.totalAmount,
      amountPaid:
          data.amountPaid.present ? data.amountPaid.value : this.amountPaid,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Debtor(')
          ..write('id: $id, ')
          ..write('customerName: $customerName, ')
          ..write('customerContact: $customerContact, ')
          ..write('totalAmount: $totalAmount, ')
          ..write('amountPaid: $amountPaid, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    customerName,
    customerContact,
    totalAmount,
    amountPaid,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Debtor &&
          other.id == this.id &&
          other.customerName == this.customerName &&
          other.customerContact == this.customerContact &&
          other.totalAmount == this.totalAmount &&
          other.amountPaid == this.amountPaid &&
          other.createdAt == this.createdAt);
}

class DebtorsCompanion extends UpdateCompanion<Debtor> {
  final Value<int> id;
  final Value<String> customerName;
  final Value<String?> customerContact;
  final Value<double> totalAmount;
  final Value<double> amountPaid;
  final Value<DateTime> createdAt;
  const DebtorsCompanion({
    this.id = const Value.absent(),
    this.customerName = const Value.absent(),
    this.customerContact = const Value.absent(),
    this.totalAmount = const Value.absent(),
    this.amountPaid = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  DebtorsCompanion.insert({
    this.id = const Value.absent(),
    required String customerName,
    this.customerContact = const Value.absent(),
    required double totalAmount,
    this.amountPaid = const Value.absent(),
    required DateTime createdAt,
  }) : customerName = Value(customerName),
       totalAmount = Value(totalAmount),
       createdAt = Value(createdAt);
  static Insertable<Debtor> custom({
    Expression<int>? id,
    Expression<String>? customerName,
    Expression<String>? customerContact,
    Expression<double>? totalAmount,
    Expression<double>? amountPaid,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (customerName != null) 'customer_name': customerName,
      if (customerContact != null) 'customer_contact': customerContact,
      if (totalAmount != null) 'total_amount': totalAmount,
      if (amountPaid != null) 'amount_paid': amountPaid,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  DebtorsCompanion copyWith({
    Value<int>? id,
    Value<String>? customerName,
    Value<String?>? customerContact,
    Value<double>? totalAmount,
    Value<double>? amountPaid,
    Value<DateTime>? createdAt,
  }) {
    return DebtorsCompanion(
      id: id ?? this.id,
      customerName: customerName ?? this.customerName,
      customerContact: customerContact ?? this.customerContact,
      totalAmount: totalAmount ?? this.totalAmount,
      amountPaid: amountPaid ?? this.amountPaid,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (customerName.present) {
      map['customer_name'] = Variable<String>(customerName.value);
    }
    if (customerContact.present) {
      map['customer_contact'] = Variable<String>(customerContact.value);
    }
    if (totalAmount.present) {
      map['total_amount'] = Variable<double>(totalAmount.value);
    }
    if (amountPaid.present) {
      map['amount_paid'] = Variable<double>(amountPaid.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DebtorsCompanion(')
          ..write('id: $id, ')
          ..write('customerName: $customerName, ')
          ..write('customerContact: $customerContact, ')
          ..write('totalAmount: $totalAmount, ')
          ..write('amountPaid: $amountPaid, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $SuppliersTable extends Suppliers
    with TableInfo<$SuppliersTable, Supplier> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SuppliersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _contactMeta = const VerificationMeta(
    'contact',
  );
  @override
  late final GeneratedColumn<String> contact = GeneratedColumn<String>(
    'contact',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _companyMeta = const VerificationMeta(
    'company',
  );
  @override
  late final GeneratedColumn<String> company = GeneratedColumn<String>(
    'company',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, name, contact, company, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'suppliers';
  @override
  VerificationContext validateIntegrity(
    Insertable<Supplier> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('contact')) {
      context.handle(
        _contactMeta,
        contact.isAcceptableOrUnknown(data['contact']!, _contactMeta),
      );
    }
    if (data.containsKey('company')) {
      context.handle(
        _companyMeta,
        company.isAcceptableOrUnknown(data['company']!, _companyMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Supplier map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Supplier(
      id:
          attachedDatabase.typeMapping.read(
            DriftSqlType.int,
            data['${effectivePrefix}id'],
          )!,
      name:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}name'],
          )!,
      contact: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}contact'],
      ),
      company: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}company'],
      ),
      createdAt:
          attachedDatabase.typeMapping.read(
            DriftSqlType.dateTime,
            data['${effectivePrefix}created_at'],
          )!,
    );
  }

  @override
  $SuppliersTable createAlias(String alias) {
    return $SuppliersTable(attachedDatabase, alias);
  }
}

class Supplier extends DataClass implements Insertable<Supplier> {
  final int id;
  final String name;
  final String? contact;
  final String? company;
  final DateTime createdAt;
  const Supplier({
    required this.id,
    required this.name,
    this.contact,
    this.company,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || contact != null) {
      map['contact'] = Variable<String>(contact);
    }
    if (!nullToAbsent || company != null) {
      map['company'] = Variable<String>(company);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  SuppliersCompanion toCompanion(bool nullToAbsent) {
    return SuppliersCompanion(
      id: Value(id),
      name: Value(name),
      contact:
          contact == null && nullToAbsent
              ? const Value.absent()
              : Value(contact),
      company:
          company == null && nullToAbsent
              ? const Value.absent()
              : Value(company),
      createdAt: Value(createdAt),
    );
  }

  factory Supplier.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Supplier(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      contact: serializer.fromJson<String?>(json['contact']),
      company: serializer.fromJson<String?>(json['company']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'contact': serializer.toJson<String?>(contact),
      'company': serializer.toJson<String?>(company),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  Supplier copyWith({
    int? id,
    String? name,
    Value<String?> contact = const Value.absent(),
    Value<String?> company = const Value.absent(),
    DateTime? createdAt,
  }) => Supplier(
    id: id ?? this.id,
    name: name ?? this.name,
    contact: contact.present ? contact.value : this.contact,
    company: company.present ? company.value : this.company,
    createdAt: createdAt ?? this.createdAt,
  );
  Supplier copyWithCompanion(SuppliersCompanion data) {
    return Supplier(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      contact: data.contact.present ? data.contact.value : this.contact,
      company: data.company.present ? data.company.value : this.company,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Supplier(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('contact: $contact, ')
          ..write('company: $company, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, contact, company, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Supplier &&
          other.id == this.id &&
          other.name == this.name &&
          other.contact == this.contact &&
          other.company == this.company &&
          other.createdAt == this.createdAt);
}

class SuppliersCompanion extends UpdateCompanion<Supplier> {
  final Value<int> id;
  final Value<String> name;
  final Value<String?> contact;
  final Value<String?> company;
  final Value<DateTime> createdAt;
  const SuppliersCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.contact = const Value.absent(),
    this.company = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  SuppliersCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.contact = const Value.absent(),
    this.company = const Value.absent(),
    required DateTime createdAt,
  }) : name = Value(name),
       createdAt = Value(createdAt);
  static Insertable<Supplier> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? contact,
    Expression<String>? company,
    Expression<DateTime>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (contact != null) 'contact': contact,
      if (company != null) 'company': company,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  SuppliersCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<String?>? contact,
    Value<String?>? company,
    Value<DateTime>? createdAt,
  }) {
    return SuppliersCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      contact: contact ?? this.contact,
      company: company ?? this.company,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (contact.present) {
      map['contact'] = Variable<String>(contact.value);
    }
    if (company.present) {
      map['company'] = Variable<String>(company.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SuppliersCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('contact: $contact, ')
          ..write('company: $company, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $InventoryItemsTable inventoryItems = $InventoryItemsTable(this);
  late final $SalesTable sales = $SalesTable(this);
  late final $DebtorsTable debtors = $DebtorsTable(this);
  late final $SuppliersTable suppliers = $SuppliersTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    inventoryItems,
    sales,
    debtors,
    suppliers,
  ];
}

typedef $$InventoryItemsTableCreateCompanionBuilder =
    InventoryItemsCompanion Function({
      Value<int> id,
      required String name,
      required String category,
      required int quantity,
      required double boughtPrice,
      required double sellPrice,
      Value<String?> supplier,
      Value<String?> imageKey,
      Value<DateTime?> lastUpdated,
      Value<bool> needsSync,
    });
typedef $$InventoryItemsTableUpdateCompanionBuilder =
    InventoryItemsCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<String> category,
      Value<int> quantity,
      Value<double> boughtPrice,
      Value<double> sellPrice,
      Value<String?> supplier,
      Value<String?> imageKey,
      Value<DateTime?> lastUpdated,
      Value<bool> needsSync,
    });

class $$InventoryItemsTableFilterComposer
    extends Composer<_$AppDatabase, $InventoryItemsTable> {
  $$InventoryItemsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get quantity => $composableBuilder(
    column: $table.quantity,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get boughtPrice => $composableBuilder(
    column: $table.boughtPrice,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get sellPrice => $composableBuilder(
    column: $table.sellPrice,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get supplier => $composableBuilder(
    column: $table.supplier,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get imageKey => $composableBuilder(
    column: $table.imageKey,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastUpdated => $composableBuilder(
    column: $table.lastUpdated,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get needsSync => $composableBuilder(
    column: $table.needsSync,
    builder: (column) => ColumnFilters(column),
  );
}

class $$InventoryItemsTableOrderingComposer
    extends Composer<_$AppDatabase, $InventoryItemsTable> {
  $$InventoryItemsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get quantity => $composableBuilder(
    column: $table.quantity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get boughtPrice => $composableBuilder(
    column: $table.boughtPrice,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get sellPrice => $composableBuilder(
    column: $table.sellPrice,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get supplier => $composableBuilder(
    column: $table.supplier,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get imageKey => $composableBuilder(
    column: $table.imageKey,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastUpdated => $composableBuilder(
    column: $table.lastUpdated,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get needsSync => $composableBuilder(
    column: $table.needsSync,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$InventoryItemsTableAnnotationComposer
    extends Composer<_$AppDatabase, $InventoryItemsTable> {
  $$InventoryItemsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<int> get quantity =>
      $composableBuilder(column: $table.quantity, builder: (column) => column);

  GeneratedColumn<double> get boughtPrice => $composableBuilder(
    column: $table.boughtPrice,
    builder: (column) => column,
  );

  GeneratedColumn<double> get sellPrice =>
      $composableBuilder(column: $table.sellPrice, builder: (column) => column);

  GeneratedColumn<String> get supplier =>
      $composableBuilder(column: $table.supplier, builder: (column) => column);

  GeneratedColumn<String> get imageKey =>
      $composableBuilder(column: $table.imageKey, builder: (column) => column);

  GeneratedColumn<DateTime> get lastUpdated => $composableBuilder(
    column: $table.lastUpdated,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get needsSync =>
      $composableBuilder(column: $table.needsSync, builder: (column) => column);
}

class $$InventoryItemsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $InventoryItemsTable,
          InventoryItem,
          $$InventoryItemsTableFilterComposer,
          $$InventoryItemsTableOrderingComposer,
          $$InventoryItemsTableAnnotationComposer,
          $$InventoryItemsTableCreateCompanionBuilder,
          $$InventoryItemsTableUpdateCompanionBuilder,
          (
            InventoryItem,
            BaseReferences<_$AppDatabase, $InventoryItemsTable, InventoryItem>,
          ),
          InventoryItem,
          PrefetchHooks Function()
        > {
  $$InventoryItemsTableTableManager(
    _$AppDatabase db,
    $InventoryItemsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () => $$InventoryItemsTableFilterComposer($db: db, $table: table),
          createOrderingComposer:
              () =>
                  $$InventoryItemsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer:
              () => $$InventoryItemsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> category = const Value.absent(),
                Value<int> quantity = const Value.absent(),
                Value<double> boughtPrice = const Value.absent(),
                Value<double> sellPrice = const Value.absent(),
                Value<String?> supplier = const Value.absent(),
                Value<String?> imageKey = const Value.absent(),
                Value<DateTime?> lastUpdated = const Value.absent(),
                Value<bool> needsSync = const Value.absent(),
              }) => InventoryItemsCompanion(
                id: id,
                name: name,
                category: category,
                quantity: quantity,
                boughtPrice: boughtPrice,
                sellPrice: sellPrice,
                supplier: supplier,
                imageKey: imageKey,
                lastUpdated: lastUpdated,
                needsSync: needsSync,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                required String category,
                required int quantity,
                required double boughtPrice,
                required double sellPrice,
                Value<String?> supplier = const Value.absent(),
                Value<String?> imageKey = const Value.absent(),
                Value<DateTime?> lastUpdated = const Value.absent(),
                Value<bool> needsSync = const Value.absent(),
              }) => InventoryItemsCompanion.insert(
                id: id,
                name: name,
                category: category,
                quantity: quantity,
                boughtPrice: boughtPrice,
                sellPrice: sellPrice,
                supplier: supplier,
                imageKey: imageKey,
                lastUpdated: lastUpdated,
                needsSync: needsSync,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable(table),
                          BaseReferences(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$InventoryItemsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $InventoryItemsTable,
      InventoryItem,
      $$InventoryItemsTableFilterComposer,
      $$InventoryItemsTableOrderingComposer,
      $$InventoryItemsTableAnnotationComposer,
      $$InventoryItemsTableCreateCompanionBuilder,
      $$InventoryItemsTableUpdateCompanionBuilder,
      (
        InventoryItem,
        BaseReferences<_$AppDatabase, $InventoryItemsTable, InventoryItem>,
      ),
      InventoryItem,
      PrefetchHooks Function()
    >;
typedef $$SalesTableCreateCompanionBuilder =
    SalesCompanion Function({
      Value<int> id,
      required int itemId,
      required int quantitySold,
      required double soldPrice,
      required DateTime dateOfSale,
      Value<bool> isPaid,
    });
typedef $$SalesTableUpdateCompanionBuilder =
    SalesCompanion Function({
      Value<int> id,
      Value<int> itemId,
      Value<int> quantitySold,
      Value<double> soldPrice,
      Value<DateTime> dateOfSale,
      Value<bool> isPaid,
    });

class $$SalesTableFilterComposer extends Composer<_$AppDatabase, $SalesTable> {
  $$SalesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get itemId => $composableBuilder(
    column: $table.itemId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get quantitySold => $composableBuilder(
    column: $table.quantitySold,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get soldPrice => $composableBuilder(
    column: $table.soldPrice,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get dateOfSale => $composableBuilder(
    column: $table.dateOfSale,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isPaid => $composableBuilder(
    column: $table.isPaid,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SalesTableOrderingComposer
    extends Composer<_$AppDatabase, $SalesTable> {
  $$SalesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get itemId => $composableBuilder(
    column: $table.itemId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get quantitySold => $composableBuilder(
    column: $table.quantitySold,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get soldPrice => $composableBuilder(
    column: $table.soldPrice,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get dateOfSale => $composableBuilder(
    column: $table.dateOfSale,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isPaid => $composableBuilder(
    column: $table.isPaid,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SalesTableAnnotationComposer
    extends Composer<_$AppDatabase, $SalesTable> {
  $$SalesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get itemId =>
      $composableBuilder(column: $table.itemId, builder: (column) => column);

  GeneratedColumn<int> get quantitySold => $composableBuilder(
    column: $table.quantitySold,
    builder: (column) => column,
  );

  GeneratedColumn<double> get soldPrice =>
      $composableBuilder(column: $table.soldPrice, builder: (column) => column);

  GeneratedColumn<DateTime> get dateOfSale => $composableBuilder(
    column: $table.dateOfSale,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isPaid =>
      $composableBuilder(column: $table.isPaid, builder: (column) => column);
}

class $$SalesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SalesTable,
          Sale,
          $$SalesTableFilterComposer,
          $$SalesTableOrderingComposer,
          $$SalesTableAnnotationComposer,
          $$SalesTableCreateCompanionBuilder,
          $$SalesTableUpdateCompanionBuilder,
          (Sale, BaseReferences<_$AppDatabase, $SalesTable, Sale>),
          Sale,
          PrefetchHooks Function()
        > {
  $$SalesTableTableManager(_$AppDatabase db, $SalesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () => $$SalesTableFilterComposer($db: db, $table: table),
          createOrderingComposer:
              () => $$SalesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer:
              () => $$SalesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> itemId = const Value.absent(),
                Value<int> quantitySold = const Value.absent(),
                Value<double> soldPrice = const Value.absent(),
                Value<DateTime> dateOfSale = const Value.absent(),
                Value<bool> isPaid = const Value.absent(),
              }) => SalesCompanion(
                id: id,
                itemId: itemId,
                quantitySold: quantitySold,
                soldPrice: soldPrice,
                dateOfSale: dateOfSale,
                isPaid: isPaid,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int itemId,
                required int quantitySold,
                required double soldPrice,
                required DateTime dateOfSale,
                Value<bool> isPaid = const Value.absent(),
              }) => SalesCompanion.insert(
                id: id,
                itemId: itemId,
                quantitySold: quantitySold,
                soldPrice: soldPrice,
                dateOfSale: dateOfSale,
                isPaid: isPaid,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable(table),
                          BaseReferences(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SalesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SalesTable,
      Sale,
      $$SalesTableFilterComposer,
      $$SalesTableOrderingComposer,
      $$SalesTableAnnotationComposer,
      $$SalesTableCreateCompanionBuilder,
      $$SalesTableUpdateCompanionBuilder,
      (Sale, BaseReferences<_$AppDatabase, $SalesTable, Sale>),
      Sale,
      PrefetchHooks Function()
    >;
typedef $$DebtorsTableCreateCompanionBuilder =
    DebtorsCompanion Function({
      Value<int> id,
      required String customerName,
      Value<String?> customerContact,
      required double totalAmount,
      Value<double> amountPaid,
      required DateTime createdAt,
    });
typedef $$DebtorsTableUpdateCompanionBuilder =
    DebtorsCompanion Function({
      Value<int> id,
      Value<String> customerName,
      Value<String?> customerContact,
      Value<double> totalAmount,
      Value<double> amountPaid,
      Value<DateTime> createdAt,
    });

class $$DebtorsTableFilterComposer
    extends Composer<_$AppDatabase, $DebtorsTable> {
  $$DebtorsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get customerName => $composableBuilder(
    column: $table.customerName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get customerContact => $composableBuilder(
    column: $table.customerContact,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get totalAmount => $composableBuilder(
    column: $table.totalAmount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get amountPaid => $composableBuilder(
    column: $table.amountPaid,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$DebtorsTableOrderingComposer
    extends Composer<_$AppDatabase, $DebtorsTable> {
  $$DebtorsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get customerName => $composableBuilder(
    column: $table.customerName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get customerContact => $composableBuilder(
    column: $table.customerContact,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get totalAmount => $composableBuilder(
    column: $table.totalAmount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get amountPaid => $composableBuilder(
    column: $table.amountPaid,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$DebtorsTableAnnotationComposer
    extends Composer<_$AppDatabase, $DebtorsTable> {
  $$DebtorsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get customerName => $composableBuilder(
    column: $table.customerName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get customerContact => $composableBuilder(
    column: $table.customerContact,
    builder: (column) => column,
  );

  GeneratedColumn<double> get totalAmount => $composableBuilder(
    column: $table.totalAmount,
    builder: (column) => column,
  );

  GeneratedColumn<double> get amountPaid => $composableBuilder(
    column: $table.amountPaid,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$DebtorsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DebtorsTable,
          Debtor,
          $$DebtorsTableFilterComposer,
          $$DebtorsTableOrderingComposer,
          $$DebtorsTableAnnotationComposer,
          $$DebtorsTableCreateCompanionBuilder,
          $$DebtorsTableUpdateCompanionBuilder,
          (Debtor, BaseReferences<_$AppDatabase, $DebtorsTable, Debtor>),
          Debtor,
          PrefetchHooks Function()
        > {
  $$DebtorsTableTableManager(_$AppDatabase db, $DebtorsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () => $$DebtorsTableFilterComposer($db: db, $table: table),
          createOrderingComposer:
              () => $$DebtorsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer:
              () => $$DebtorsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> customerName = const Value.absent(),
                Value<String?> customerContact = const Value.absent(),
                Value<double> totalAmount = const Value.absent(),
                Value<double> amountPaid = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => DebtorsCompanion(
                id: id,
                customerName: customerName,
                customerContact: customerContact,
                totalAmount: totalAmount,
                amountPaid: amountPaid,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String customerName,
                Value<String?> customerContact = const Value.absent(),
                required double totalAmount,
                Value<double> amountPaid = const Value.absent(),
                required DateTime createdAt,
              }) => DebtorsCompanion.insert(
                id: id,
                customerName: customerName,
                customerContact: customerContact,
                totalAmount: totalAmount,
                amountPaid: amountPaid,
                createdAt: createdAt,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable(table),
                          BaseReferences(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$DebtorsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DebtorsTable,
      Debtor,
      $$DebtorsTableFilterComposer,
      $$DebtorsTableOrderingComposer,
      $$DebtorsTableAnnotationComposer,
      $$DebtorsTableCreateCompanionBuilder,
      $$DebtorsTableUpdateCompanionBuilder,
      (Debtor, BaseReferences<_$AppDatabase, $DebtorsTable, Debtor>),
      Debtor,
      PrefetchHooks Function()
    >;
typedef $$SuppliersTableCreateCompanionBuilder =
    SuppliersCompanion Function({
      Value<int> id,
      required String name,
      Value<String?> contact,
      Value<String?> company,
      required DateTime createdAt,
    });
typedef $$SuppliersTableUpdateCompanionBuilder =
    SuppliersCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<String?> contact,
      Value<String?> company,
      Value<DateTime> createdAt,
    });

class $$SuppliersTableFilterComposer
    extends Composer<_$AppDatabase, $SuppliersTable> {
  $$SuppliersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get contact => $composableBuilder(
    column: $table.contact,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get company => $composableBuilder(
    column: $table.company,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SuppliersTableOrderingComposer
    extends Composer<_$AppDatabase, $SuppliersTable> {
  $$SuppliersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get contact => $composableBuilder(
    column: $table.contact,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get company => $composableBuilder(
    column: $table.company,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SuppliersTableAnnotationComposer
    extends Composer<_$AppDatabase, $SuppliersTable> {
  $$SuppliersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get contact =>
      $composableBuilder(column: $table.contact, builder: (column) => column);

  GeneratedColumn<String> get company =>
      $composableBuilder(column: $table.company, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$SuppliersTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SuppliersTable,
          Supplier,
          $$SuppliersTableFilterComposer,
          $$SuppliersTableOrderingComposer,
          $$SuppliersTableAnnotationComposer,
          $$SuppliersTableCreateCompanionBuilder,
          $$SuppliersTableUpdateCompanionBuilder,
          (Supplier, BaseReferences<_$AppDatabase, $SuppliersTable, Supplier>),
          Supplier,
          PrefetchHooks Function()
        > {
  $$SuppliersTableTableManager(_$AppDatabase db, $SuppliersTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () => $$SuppliersTableFilterComposer($db: db, $table: table),
          createOrderingComposer:
              () => $$SuppliersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer:
              () => $$SuppliersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> contact = const Value.absent(),
                Value<String?> company = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
              }) => SuppliersCompanion(
                id: id,
                name: name,
                contact: contact,
                company: company,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                Value<String?> contact = const Value.absent(),
                Value<String?> company = const Value.absent(),
                required DateTime createdAt,
              }) => SuppliersCompanion.insert(
                id: id,
                name: name,
                contact: contact,
                company: company,
                createdAt: createdAt,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable(table),
                          BaseReferences(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SuppliersTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SuppliersTable,
      Supplier,
      $$SuppliersTableFilterComposer,
      $$SuppliersTableOrderingComposer,
      $$SuppliersTableAnnotationComposer,
      $$SuppliersTableCreateCompanionBuilder,
      $$SuppliersTableUpdateCompanionBuilder,
      (Supplier, BaseReferences<_$AppDatabase, $SuppliersTable, Supplier>),
      Supplier,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$InventoryItemsTableTableManager get inventoryItems =>
      $$InventoryItemsTableTableManager(_db, _db.inventoryItems);
  $$SalesTableTableManager get sales =>
      $$SalesTableTableManager(_db, _db.sales);
  $$DebtorsTableTableManager get debtors =>
      $$DebtorsTableTableManager(_db, _db.debtors);
  $$SuppliersTableTableManager get suppliers =>
      $$SuppliersTableTableManager(_db, _db.suppliers);
}
