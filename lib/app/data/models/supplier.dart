class Supplier {
  final int id;
  final String name;
  final String? contact;
  final String? company;
  final DateTime createdAt;

  Supplier({
    required this.id,
    required this.name,
    this.contact,
    this.company,
    required this.createdAt,
  });
}
