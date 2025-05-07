class Product {
  final int id;
  final String name;
  final double price;
  final int stock;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.stock,
  });

  // Factory method for JSON parsing
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] as int,
      name: json['name'] as String,
      price: (json['price'] as num).toDouble(),
      stock: json['stock'] as int,
    );
  }

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'price': price, 'stock': stock};
  }
}
