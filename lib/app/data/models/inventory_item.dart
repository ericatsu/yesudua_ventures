import 'package:drift/drift.dart';
import 'package:yesudua_ventures/app/data/local/drift_database.dart' as drift;

/// The InventoryItem class serves as both the domain model and the database entity
class InventoryItem {
  final int id;
  final String name;
  final String category;
  final int quantity;
  final double boughtPrice;
  final double sellPrice;
  final String? supplier;
  final String? imageKey;
  final DateTime? lastUpdated;

  InventoryItem({
    required this.id,
    required this.name,
    required this.category,
    required this.quantity,
    required this.boughtPrice,
    required this.sellPrice,
    this.supplier,
    this.imageKey,
    this.lastUpdated,
  });

  // Create a copy of the current InventoryItem with potentially modified fields
  InventoryItem copyWith({
    int? id,
    String? name,
    String? category,
    int? quantity,
    double? boughtPrice,
    double? sellPrice,
    String? supplier,
    String? imageKey,
    DateTime? lastUpdated,
  }) {
    return InventoryItem(
      id: id ?? this.id,
      name: name ?? this.name,
      category: category ?? this.category,
      quantity: quantity ?? this.quantity,
      boughtPrice: boughtPrice ?? this.boughtPrice,
      sellPrice: sellPrice ?? this.sellPrice,
      supplier: supplier ?? this.supplier,
      imageKey: imageKey ?? this.imageKey,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }

  // Convert to a companion object for Drift database inserts/updates
  drift.InventoryItemsCompanion toCompanion() {
    return drift.InventoryItemsCompanion(
      name: Value(name),
      category: Value(category),
      quantity: Value(quantity),
      boughtPrice: Value(boughtPrice),
      sellPrice: Value(sellPrice),
      supplier: supplier != null ? Value(supplier!) : const Value.absent(),
      imageKey: imageKey != null ? Value(imageKey!) : const Value.absent(),
      lastUpdated: Value(DateTime.now()),
    );
  }

  // Create from a Drift database row
  factory InventoryItem.fromDriftItem(drift.InventoryItem item) {
    return InventoryItem(
      id: item.id,
      name: item.name,
      category: item.category,
      quantity: item.quantity,
      boughtPrice: item.boughtPrice,
      sellPrice: item.sellPrice,
      supplier: item.supplier,
      imageKey: item.imageKey,
      lastUpdated: item.lastUpdated,
    );
  }

  // Create a Drift database entity from this model
  drift.InventoryItem toDriftItem() {
    return drift.InventoryItem(
      id: id,
      name: name,
      category: category,
      quantity: quantity,
      boughtPrice: boughtPrice,
      sellPrice: sellPrice,
      supplier: supplier,
      imageKey: imageKey,
      lastUpdated: lastUpdated ?? DateTime.now(),
    );
  }

  // Convert to JSON for API requests
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'quantity': quantity,
      'bought_price': boughtPrice,
      'sell_price': sellPrice,
      'supplier': supplier,
      'image_key': imageKey,
      'last_updated': lastUpdated?.toIso8601String(),
    };
  }

  // Create from JSON for API responses
  factory InventoryItem.fromJson(Map<String, dynamic> json) {
    return InventoryItem(
      id: json['id'],
      name: json['name'],
      category: json['category'],
      quantity: json['quantity'],
      boughtPrice: json['bought_price'] ?? json['boughtPrice'],
      sellPrice: json['sell_price'] ?? json['sellPrice'],
      supplier: json['supplier'],
      imageKey: json['image_key'] ?? json['imageKey'],
      lastUpdated: json['last_updated'] != null ? 
          DateTime.parse(json['last_updated']) : null,
    );
  }
}
