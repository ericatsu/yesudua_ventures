class InventoryItem {
  final int id;
  final String name;
  final String category;
  final int quantity;
  final double boughtPrice;
  final double sellPrice;
  final String? supplier;
  final DateTime? lastUpdated;

  InventoryItem({
    required this.id,
    required this.name,
    required this.category,
    required this.quantity,
    required this.boughtPrice,
    required this.sellPrice,
    this.supplier,
    this.lastUpdated,
  });
}