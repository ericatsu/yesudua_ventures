class Sale {
  final int id;
  final int itemId;
  final int quantitySold;
  final double soldPrice;
  final DateTime dateOfSale;
  final bool isPaid;

  Sale({
    required this.id,
    required this.itemId,
    required this.quantitySold,
    required this.soldPrice,
    required this.dateOfSale,
    this.isPaid = true,
  });
}
