// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'inventory_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

InventoryItemModel _$InventoryItemModelFromJson(Map<String, dynamic> json) =>
    InventoryItemModel(
      id: (json['id'] as num?)?.toInt(),
      name: json['name'] as String,
      categoryId: (json['categoryId'] as num).toInt(),
      quantity: (json['quantity'] as num).toDouble(),
      boughtPrice: (json['boughtPrice'] as num).toDouble(),
      sellPrice: (json['sellPrice'] as num).toDouble(),
      supplierId: (json['supplierId'] as num?)?.toInt(),
      lastRestocked:
          json['lastRestocked'] == null
              ? null
              : DateTime.parse(json['lastRestocked'] as String),
      createdAt:
          json['createdAt'] == null
              ? null
              : DateTime.parse(json['createdAt'] as String),
      updatedAt:
          json['updatedAt'] == null
              ? null
              : DateTime.parse(json['updatedAt'] as String),
      categoryName: json['categoryName'] as String?,
      supplierName: json['supplierName'] as String?,
    );

Map<String, dynamic> _$InventoryItemModelToJson(InventoryItemModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'categoryId': instance.categoryId,
      'quantity': instance.quantity,
      'boughtPrice': instance.boughtPrice,
      'sellPrice': instance.sellPrice,
      'supplierId': instance.supplierId,
      'lastRestocked': instance.lastRestocked?.toIso8601String(),
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
      'categoryName': instance.categoryName,
      'supplierName': instance.supplierName,
    };

CategoryModel _$CategoryModelFromJson(Map<String, dynamic> json) =>
    CategoryModel(
      id: (json['id'] as num?)?.toInt(),
      name: json['name'] as String,
      description: json['description'] as String?,
      createdAt:
          json['createdAt'] == null
              ? null
              : DateTime.parse(json['createdAt'] as String),
      updatedAt:
          json['updatedAt'] == null
              ? null
              : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$CategoryModelToJson(CategoryModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };

SupplierModel _$SupplierModelFromJson(Map<String, dynamic> json) =>
    SupplierModel(
      id: (json['id'] as num?)?.toInt(),
      name: json['name'] as String,
      contact: json['contact'] as String,
      address: json['address'] as String?,
      createdAt:
          json['createdAt'] == null
              ? null
              : DateTime.parse(json['createdAt'] as String),
      updatedAt:
          json['updatedAt'] == null
              ? null
              : DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$SupplierModelToJson(SupplierModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'contact': instance.contact,
      'address': instance.address,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };

SupplyHistoryModel _$SupplyHistoryModelFromJson(Map<String, dynamic> json) =>
    SupplyHistoryModel(
      id: (json['id'] as num?)?.toInt(),
      supplierId: (json['supplierId'] as num).toInt(),
      inventoryItemId: (json['inventoryItemId'] as num).toInt(),
      quantity: (json['quantity'] as num).toDouble(),
      boughtPrice: (json['boughtPrice'] as num).toDouble(),
      supplyDate: DateTime.parse(json['supplyDate'] as String),
      createdAt:
          json['createdAt'] == null
              ? null
              : DateTime.parse(json['createdAt'] as String),
      itemName: json['itemName'] as String?,
      supplierName: json['supplierName'] as String?,
    );

Map<String, dynamic> _$SupplyHistoryModelToJson(SupplyHistoryModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'supplierId': instance.supplierId,
      'inventoryItemId': instance.inventoryItemId,
      'quantity': instance.quantity,
      'boughtPrice': instance.boughtPrice,
      'supplyDate': instance.supplyDate.toIso8601String(),
      'createdAt': instance.createdAt?.toIso8601String(),
      'itemName': instance.itemName,
      'supplierName': instance.supplierName,
    };
