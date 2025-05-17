import 'package:json_annotation/json_annotation.dart';

part 'inventory_model.g.dart';

@JsonSerializable()
class InventoryItemModel {
  final int? id;
  final String name;
  final int categoryId;
  final double quantity;
  final double boughtPrice;
  final double sellPrice;
  final int? supplierId;
  final DateTime? lastRestocked;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  // Additional fields for joined data (not stored in database directly)
  final String? categoryName;
  final String? supplierName;

  InventoryItemModel({
    this.id,
    required this.name,
    required this.categoryId,
    required this.quantity,
    required this.boughtPrice,
    required this.sellPrice,
    this.supplierId,
    this.lastRestocked,
    this.createdAt,
    this.updatedAt,
    this.categoryName,
    this.supplierName,
  });

  // Copy constructor with optional parameters
  InventoryItemModel copyWith({
    int? id,
    String? name,
    int? categoryId,
    double? quantity,
    double? boughtPrice,
    double? sellPrice,
    int? supplierId,
    DateTime? lastRestocked,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? categoryName,
    String? supplierName,
    bool clearSupplierId = false,
  }) {
    return InventoryItemModel(
      id: id ?? this.id,
      name: name ?? this.name,
      categoryId: categoryId ?? this.categoryId,
      quantity: quantity ?? this.quantity,
      boughtPrice: boughtPrice ?? this.boughtPrice,
      sellPrice: sellPrice ?? this.sellPrice,
      supplierId: clearSupplierId ? null : (supplierId ?? this.supplierId),
      lastRestocked: lastRestocked ?? this.lastRestocked,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
      categoryName: categoryName ?? this.categoryName,
      supplierName: supplierName ?? this.supplierName,
    );
  }

  // Factory constructor for creating a model from JSON
  factory InventoryItemModel.fromJson(Map<String, dynamic> json) =>
      _$InventoryItemModelFromJson(json);

  // Convert model to JSON
  Map<String, dynamic> toJson() => _$InventoryItemModelToJson(this);
}

@JsonSerializable()
class CategoryModel {
  final int? id;
  final String name;
  final String? description;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  CategoryModel({
    this.id,
    required this.name,
    this.description,
    this.createdAt,
    this.updatedAt,
  });

  // Copy constructor with optional parameters
  CategoryModel copyWith({
    int? id,
    String? name,
    String? description,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return CategoryModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
    );
  }

  // Factory constructor for creating a model from JSON
  factory CategoryModel.fromJson(Map<String, dynamic> json) =>
      _$CategoryModelFromJson(json);

  // Convert model to JSON
  Map<String, dynamic> toJson() => _$CategoryModelToJson(this);
}

@JsonSerializable()
class SupplierModel {
  final int? id;
  final String name;
  final String contact;
  final String? address;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  SupplierModel({
    this.id,
    required this.name,
    required this.contact,
    this.address,
    this.createdAt,
    this.updatedAt,
  });

  // Copy constructor with optional parameters
  SupplierModel copyWith({
    int? id,
    String? name,
    String? contact,
    String? address,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return SupplierModel(
      id: id ?? this.id,
      name: name ?? this.name,
      contact: contact ?? this.contact,
      address: address ?? this.address,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
    );
  }

  // Factory constructor for creating a model from JSON
  factory SupplierModel.fromJson(Map<String, dynamic> json) =>
      _$SupplierModelFromJson(json);

  // Convert model to JSON
  Map<String, dynamic> toJson() => _$SupplierModelToJson(this);
}

@JsonSerializable()
class SupplyHistoryModel {
  final int? id;
  final int supplierId;
  final int inventoryItemId;
  final double quantity;
  final double boughtPrice;
  final DateTime supplyDate;
  final DateTime? createdAt;

  // Additional fields for joined data
  final String? itemName;
  final String? supplierName;

  SupplyHistoryModel({
    this.id,
    required this.supplierId,
    required this.inventoryItemId,
    required this.quantity,
    required this.boughtPrice,
    required this.supplyDate,
    this.createdAt,
    this.itemName,
    this.supplierName,
  });

  // Factory constructor for creating a model from JSON
  factory SupplyHistoryModel.fromJson(Map<String, dynamic> json) =>
      _$SupplyHistoryModelFromJson(json);

  // Convert model to JSON
  Map<String, dynamic> toJson() => _$SupplyHistoryModelToJson(this);
}