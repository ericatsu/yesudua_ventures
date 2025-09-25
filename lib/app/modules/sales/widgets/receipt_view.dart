import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:yesudua_ventures/app/core/services/print_service.dart';
import 'package:yesudua_ventures/app/data/models/sales_model.dart';
import 'package:yesudua_ventures/app/modules/sales/sales_controller.dart';

class ReceiptView extends StatelessWidget {
  final ReceiptModel receipt;
  final bool allowEditing;
  final Function? onPrint;
  final Function? onSave;
  final Function? onToggleReceiptType;

  const ReceiptView({
    super.key,
    required this.receipt,
    this.allowEditing = false,
    this.onPrint,
    this.onSave,
    this.onToggleReceiptType,
  });

  double _calculateTotalAmount(
    List<SaleItemModel> items, [
    bool formatted = true,
  ]) {
    final total = items.fold(
      0.0,
      (sum, item) => sum + (item.quantity * item.sellPrice),
    );
    return formatted ? double.parse(total.toStringAsFixed(2)) : total;
  }

  // Convert your SaleItemModel to ReceiptItem for PDF generation
  List<ReceiptItem> _convertToReceiptItems(List<SaleItemModel> items) {
    return items.map((item) => ReceiptItem(
      name: item.itemName ?? 'Unknown Item',
      quantity: item.quantity.toDouble(),
      price: item.sellPrice,
    )).toList();
  }

  // Method to handle PDF printing
  Future<void> _printReceipt() async {
    try {
      final controller = Get.find<SalesController>();
      
      // Convert items to ReceiptItem format
      final receiptItems = _convertToReceiptItems(receipt.items);
      
      // Get current values (considering edits)
      final totalAmount = receipt.isCustomerCopy 
          ? _calculateTotalAmount(receipt.items, false)
          : receipt.sale.totalAmount;
      
      final paidAmount = controller.paidAmount.value;
      
      // Generate PDF
      final pdfData = await generateReceipt(
        PdfPageFormat.a4,
        receipt.sale.customerName ?? 'Walk-in Customer',
        receipt.sale.customerContact ?? 'N/A',
        receiptItems,
        totalAmount,
        paidAmount,
        receipt.sale.saleDate,
        receipt.isCustomerCopy,
      );

      // Show print dialog
      await Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async => pdfData,
        name: 'Receipt_${DateFormat('yyyyMMdd_HHmmss').format(receipt.sale.saleDate)}',
      );
    } catch (e) {
      // Handle error
      Get.snackbar(
        'Error',
        'Failed to generate receipt: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<SalesController>();
    final dateFormat = DateFormat('dd/MM/yyyy hh:mm a');

    return Card(
      elevation: 4,
      margin: const EdgeInsets.all(16),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Receipt Header
              Center(
                child: Column(
                  children: [
                    const Text(
                      'YESU DEA WOOD VENTURES',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Official Receipt',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      receipt.isCustomerCopy
                          ? 'Customer Copy'
                          : 'Internal Copy',
                      style: TextStyle(
                        fontStyle: FontStyle.italic,
                        color:
                            receipt.isCustomerCopy ? Colors.green : Colors.blue,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text('Date: ${dateFormat.format(receipt.sale.saleDate)}'),
                    if (receipt.sale.customerName != null) ...[
                      const SizedBox(height: 8),
                      Text('Customer: ${receipt.sale.customerName}'),
                    ],
                    if (receipt.sale.customerContact != null) ...[
                      const SizedBox(height: 2),
                      Text('Contact: ${receipt.sale.customerContact}'),
                    ],
                  ],
                ),
              ),

              const SizedBox(height: 20),
              const Divider(),

              // Items Table
              Obx(
                () => Table(
                  border: TableBorder.all(color: Colors.grey.shade300),
                  columnWidths: const {
                    0: FlexColumnWidth(4), // Item
                    1: FlexColumnWidth(1), // Qty
                    2: FlexColumnWidth(2), // Price
                    3: FlexColumnWidth(2), // Total
                  },
                  children: [
                    // Table Header
                    TableRow(
                      decoration: BoxDecoration(color: Colors.grey.shade200),
                      children: [
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            'Item',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            'Qty',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            'Price',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            'Total',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),

                    // Table Rows for Items
                    ...receipt.items.asMap().entries.map((entry) {
                      final index = entry.key;
                      final item = entry.value;

                      return TableRow(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(item.itemName ?? 'Unknown Item'),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(item.quantity.toString()),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: receipt.isPreviewMode &&
                                    allowEditing &&
                                    receipt.isCustomerCopy
                                ? TextFormField(
                                    initialValue: item.sellPrice.toString(),
                                    keyboardType: TextInputType.number,
                                    decoration: const InputDecoration(
                                      isDense: true,
                                      contentPadding: EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 8,
                                      ),
                                      border: OutlineInputBorder(),
                                    ),
                                    onChanged: (value) {
                                      if (value.isNotEmpty) {
                                        final newPrice =
                                            double.tryParse(value) ??
                                                item.sellPrice;
                                        controller.updateItemPrice(
                                          index,
                                          newPrice,
                                        );
                                      }
                                    },
                                  )
                                : Text(
                                    item.sellPrice.toStringAsFixed(2),
                                  ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              (item.quantity * item.sellPrice)
                                  .toStringAsFixed(2),
                            ),
                          ),
                        ],
                      );
                    }),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Summary and Totals
              Align(
                alignment: Alignment.centerRight,
                child: Obx(
                  () => Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'Total Amount: GHS ${receipt.isCustomerCopy ? _calculateTotalAmount(receipt.items) : receipt.sale.totalAmount.toStringAsFixed(2)}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),

                      if (receipt.isPreviewMode && allowEditing) ...[
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text(
                              'Amount Paid: GHS ',
                              style: TextStyle(fontWeight: FontWeight.w500),
                            ),
                            SizedBox(
                              width: 100,
                              child: TextFormField(
                                initialValue:
                                    receipt.editedPaidAmount?.toString() ??
                                        receipt.sale.paidAmount.toString(),
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                  isDense: true,
                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 8,
                                  ),
                                  border: OutlineInputBorder(),
                                ),
                                onChanged: (value) {
                                  if (value.isNotEmpty) {
                                    final newPaidAmount =
                                        double.tryParse(value) ?? 0.0;
                                    controller.paidAmount.value = newPaidAmount;
                                    controller.isPaid.value = newPaidAmount >=
                                        (receipt.isCustomerCopy
                                            ? _calculateTotalAmount(
                                                receipt.items,
                                                false,
                                              )
                                            : receipt.sale.totalAmount);
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                      ] else ...[
                        Text(
                          'Amount Paid: GHS ${receipt.sale.paidAmount.toStringAsFixed(2)}',
                          style: const TextStyle(fontWeight: FontWeight.w500),
                        ),
                      ],

                      const SizedBox(height: 4),
                      Text(
                        'Balance: GHS ${(receipt.isCustomerCopy ? _calculateTotalAmount(receipt.items, false) : receipt.sale.totalAmount - controller.paidAmount.value).toStringAsFixed(2)}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: (receipt.isCustomerCopy
                                      ? _calculateTotalAmount(
                                            receipt.items,
                                            false,
                                          ) -
                                          controller.paidAmount.value
                                      : receipt.sale.totalAmount -
                                          controller.paidAmount.value) >
                                  0
                              ? Colors.red
                              : Colors.green,
                        ),
                      ),

                      if (!receipt.isCustomerCopy) ...[
                        const SizedBox(height: 10),
                        const Divider(),
                      ],
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Action Buttons
              if (receipt.isPreviewMode) ...[
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  alignment: WrapAlignment.spaceEvenly,
                  children: [
                    ElevatedButton.icon(
                      icon: const Icon(Icons.sync),
                      label: const Text('Toggle Copy'),
                      onPressed: () {
                        if (onToggleReceiptType != null) {
                          onToggleReceiptType!();
                        } else {
                          controller.toggleReceiptType();
                        }
                      },
                    ),
                    ElevatedButton.icon(
                      icon: const Icon(Icons.print),
                      label: const Text('Print'),
                      onPressed: _printReceipt,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                      ),
                    ),
                    ElevatedButton.icon(
                      icon: const Icon(Icons.save),
                      label: const Text('Save Sale'),
                      onPressed: onSave as void Function()?,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class ReceiptItem {
  final String name;
  final double quantity;
  final double price;

  ReceiptItem({
    required this.name,
    required this.quantity,
    required this.price,
  });
}