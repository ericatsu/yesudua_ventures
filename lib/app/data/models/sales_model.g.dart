// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sales_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SaleModel _$SaleModelFromJson(Map<String, dynamic> json) => SaleModel(
  id: (json['id'] as num?)?.toInt(),
  customerName: json['customerName'] as String?,
  customerContact: json['customerContact'] as String?,
  totalAmount: (json['totalAmount'] as num).toDouble(),
  paidAmount: (json['paidAmount'] as num?)?.toDouble() ?? 0.0,
  isPaid: json['isPaid'] as bool? ?? false,
  saleDate:
      json['saleDate'] == null
          ? null
          : DateTime.parse(json['saleDate'] as String),
  createdAt:
      json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
  updatedAt:
      json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
  items:
      (json['items'] as List<dynamic>?)
          ?.map((e) => SaleItemModel.fromJson(e as Map<String, dynamic>))
          .toList(),
);

Map<String, dynamic> _$SaleModelToJson(SaleModel instance) => <String, dynamic>{
  'id': instance.id,
  'customerName': instance.customerName,
  'customerContact': instance.customerContact,
  'totalAmount': instance.totalAmount,
  'paidAmount': instance.paidAmount,
  'isPaid': instance.isPaid,
  'saleDate': instance.saleDate.toIso8601String(),
  'createdAt': instance.createdAt?.toIso8601String(),
  'updatedAt': instance.updatedAt?.toIso8601String(),
  'items': instance.items,
};

SaleItemModel _$SaleItemModelFromJson(Map<String, dynamic> json) =>
    SaleItemModel(
      id: (json['id'] as num?)?.toInt(),
      saleId: (json['saleId'] as num?)?.toInt(),
      inventoryItemId: (json['inventoryItemId'] as num).toInt(),
      quantity: (json['quantity'] as num).toDouble(),
      sellPrice: (json['sellPrice'] as num).toDouble(),
      boughtPrice: (json['boughtPrice'] as num).toDouble(),
      createdAt:
          json['createdAt'] == null
              ? null
              : DateTime.parse(json['createdAt'] as String),
      itemName: json['itemName'] as String?,
      categoryName: json['categoryName'] as String?,
    );

Map<String, dynamic> _$SaleItemModelToJson(SaleItemModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'saleId': instance.saleId,
      'inventoryItemId': instance.inventoryItemId,
      'quantity': instance.quantity,
      'sellPrice': instance.sellPrice,
      'boughtPrice': instance.boughtPrice,
      'createdAt': instance.createdAt?.toIso8601String(),
      'itemName': instance.itemName,
      'categoryName': instance.categoryName,
    };

DebtorModel _$DebtorModelFromJson(Map<String, dynamic> json) => DebtorModel(
  id: (json['id'] as num?)?.toInt(),
  saleId: (json['saleId'] as num).toInt(),
  name: json['name'] as String,
  contact: json['contact'] as String,
  totalDebt: (json['totalDebt'] as num).toDouble(),
  paidAmount: (json['paidAmount'] as num?)?.toDouble() ?? 0.0,
  outstandingBalance: (json['outstandingBalance'] as num).toDouble(),
  createdAt:
      json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
  updatedAt:
      json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
  paymentHistory:
      (json['paymentHistory'] as List<dynamic>?)
          ?.map((e) => DebtorPaymentModel.fromJson(e as Map<String, dynamic>))
          .toList(),
);

Map<String, dynamic> _$DebtorModelToJson(DebtorModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'saleId': instance.saleId,
      'name': instance.name,
      'contact': instance.contact,
      'totalDebt': instance.totalDebt,
      'paidAmount': instance.paidAmount,
      'outstandingBalance': instance.outstandingBalance,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
      'paymentHistory': instance.paymentHistory,
    };

DebtorPaymentModel _$DebtorPaymentModelFromJson(Map<String, dynamic> json) =>
    DebtorPaymentModel(
      id: (json['id'] as num?)?.toInt(),
      debtorId: (json['debtorId'] as num).toInt(),
      amountPaid: (json['amountPaid'] as num).toDouble(),
      paymentDate:
          json['paymentDate'] == null
              ? null
              : DateTime.parse(json['paymentDate'] as String),
      createdAt:
          json['createdAt'] == null
              ? null
              : DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$DebtorPaymentModelToJson(DebtorPaymentModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'debtorId': instance.debtorId,
      'amountPaid': instance.amountPaid,
      'paymentDate': instance.paymentDate.toIso8601String(),
      'createdAt': instance.createdAt?.toIso8601String(),
    };
