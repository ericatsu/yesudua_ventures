class Debtor {
  final int id;
  final String customerName;
  final String? customerContact;
  final double totalAmount;
  final double amountPaid;
  final DateTime createdAt;

  Debtor({
    required this.id,
    required this.customerName,
    this.customerContact,
    required this.totalAmount,
    this.amountPaid = 0.0,
    required this.createdAt,
  });
}
