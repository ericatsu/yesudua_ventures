import 'package:json_annotation/json_annotation.dart';

part 'sales_model.g.dart';

@JsonSerializable()
class SaleModel {
  final int? id;
  final String? customerName;
  final String? customerContact;
  final double totalAmount;
  final double paidAmount;
  final bool isPaid;
  final DateTime saleDate;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  // Not stored in database directly - for presentation
  final List<SaleItemModel>? items;

  SaleModel({
    this.id,
    this.customerName,
    this.customerContact,
    required this.totalAmount,
    this.paidAmount = 0.0,
    this.isPaid = false,
    DateTime? saleDate,
    this.createdAt,
    this.updatedAt,
    this.items,
  }) : saleDate = saleDate ?? DateTime.now();

  // Copy constructor
  SaleModel copyWith({
    int? id,
    String? customerName,
    String? customerContact,
    double? totalAmount,
    double? paidAmount,
    bool? isPaid,
    DateTime? saleDate,
    DateTime? createdAt,
    DateTime? updatedAt,
    List<SaleItemModel>? items,
  }) {
    return SaleModel(
      id: id ?? this.id,
      customerName: customerName ?? this.customerName,
      customerContact: customerContact ?? this.customerContact,
      totalAmount: totalAmount ?? this.totalAmount,
      paidAmount: paidAmount ?? this.paidAmount,
      isPaid: isPaid ?? this.isPaid,
      saleDate: saleDate ?? this.saleDate,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
      items: items ?? this.items,
    );
  }

  // Factory constructor for creating a model from JSON
  factory SaleModel.fromJson(Map<String, dynamic> json) =>
      _$SaleModelFromJson(json);

  // Convert model to JSON
  Map<String, dynamic> toJson() => _$SaleModelToJson(this);
}

@JsonSerializable()
class SaleItemModel {
  final int? id;
  final int? saleId;
  final int inventoryItemId;
  final double quantity;
  final double sellPrice;
  final double boughtPrice;
  final DateTime? createdAt;

  // Additional fields for presentation
  final String? itemName;
  final String? categoryName;

  SaleItemModel({
    this.id,
    this.saleId,
    required this.inventoryItemId,
    required this.quantity,
    required this.sellPrice,
    required this.boughtPrice,
    this.createdAt,
    this.itemName,
    this.categoryName,
  });

  // Calculate subtotal amount
  double get subtotal => quantity * sellPrice;

  // Calculate profit for this item
  double get profit => quantity * (sellPrice - boughtPrice);

  // Copy constructor
  SaleItemModel copyWith({
    int? id,
    int? saleId,
    int? inventoryItemId,
    double? quantity,
    double? sellPrice,
    double? boughtPrice,
    DateTime? createdAt,
    String? itemName,
    String? categoryName,
  }) {
    return SaleItemModel(
      id: id ?? this.id,
      saleId: saleId ?? this.saleId,
      inventoryItemId: inventoryItemId ?? this.inventoryItemId,
      quantity: quantity ?? this.quantity,
      sellPrice: sellPrice ?? this.sellPrice,
      boughtPrice: boughtPrice ?? this.boughtPrice,
      createdAt: createdAt ?? this.createdAt,
      itemName: itemName ?? this.itemName,
      categoryName: categoryName ?? this.categoryName,
    );
  }

  // Factory constructor for creating a model from JSON
  factory SaleItemModel.fromJson(Map<String, dynamic> json) =>
      _$SaleItemModelFromJson(json);

  // Convert model to JSON
  Map<String, dynamic> toJson() => _$SaleItemModelToJson(this);
}

@JsonSerializable()
class DebtorModel {
  final int? id;
  final int saleId;
  final String name;
  final String contact;
  final double totalDebt;
  final double paidAmount;
  final double outstandingBalance;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  // Additional field for presentation
  final List<DebtorPaymentModel>? paymentHistory;

  DebtorModel({
    this.id,
    required this.saleId,
    required this.name,
    required this.contact,
    required this.totalDebt,
    this.paidAmount = 0.0,
    required this.outstandingBalance,
    this.createdAt,
    this.updatedAt,
    this.paymentHistory,
  });

  // Copy constructor
  DebtorModel copyWith({
    int? id,
    int? saleId,
    String? name,
    String? contact,
    double? totalDebt,
    double? paidAmount,
    double? outstandingBalance,
    DateTime? createdAt,
    DateTime? updatedAt,
    List<DebtorPaymentModel>? paymentHistory,
  }) {
    return DebtorModel(
      id: id ?? this.id,
      saleId: saleId ?? this.saleId,
      name: name ?? this.name,
      contact: contact ?? this.contact,
      totalDebt: totalDebt ?? this.totalDebt,
      paidAmount: paidAmount ?? this.paidAmount,
      outstandingBalance: outstandingBalance ?? this.outstandingBalance,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
      paymentHistory: paymentHistory ?? this.paymentHistory,
    );
  }

  // Factory constructor for creating a model from JSON
  factory DebtorModel.fromJson(Map<String, dynamic> json) =>
      _$DebtorModelFromJson(json);

  // Convert model to JSON
  Map<String, dynamic> toJson() => _$DebtorModelToJson(this);
}

@JsonSerializable()
class DebtorPaymentModel {
  final int? id;
  final int debtorId;
  final double amountPaid;
  final DateTime paymentDate;
  final DateTime? createdAt;

  DebtorPaymentModel({
    this.id,
    required this.debtorId,
    required this.amountPaid,
    DateTime? paymentDate,
    this.createdAt,
  }) : paymentDate = paymentDate ?? DateTime.now();

  // Factory constructor for creating a model from JSON
  factory DebtorPaymentModel.fromJson(Map<String, dynamic> json) =>
      _$DebtorPaymentModelFromJson(json);

  // Convert model to JSON
  Map<String, dynamic> toJson() => _$DebtorPaymentModelToJson(this);
}

// Receipt model - NOT stored in database but used for receipt generation
class ReceiptModel {
  final SaleModel sale;
  final List<SaleItemModel> items;
  final bool isPreviewMode;
  final bool isCustomerCopy;
  final double? editedPaidAmount;


  // Customer copy doesn't show bought prices
  ReceiptModel({
    required this.sale,
    required this.items,
    this.isPreviewMode = false,
    this.isCustomerCopy = true,
    this.editedPaidAmount,
  });

  // Total profit (only shown on internal copies)
  double get totalProfit {
    return items.fold(0, (sum, item) => sum + item.profit);
  }
}
