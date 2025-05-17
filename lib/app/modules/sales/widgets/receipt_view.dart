import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
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
                    //4: FlexColumnWidth(2),
                  },
                  children: [
                    // Table Header
                    TableRow(
                      decoration: BoxDecoration(color: Colors.grey.shade200),
                      children:
                          [
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
                            // if (!receipt.isCustomerCopy)
                            //   const Padding(
                            //     padding: EdgeInsets.all(8.0),
                            //     child: Text(
                            //       'Bought',
                            //       style: TextStyle(fontWeight: FontWeight.bold),
                            //     ),
                            //   ),
                          ].where((widget) => widget != null).toList(),
                    ),

                    // Table Rows for Items
                    ...receipt.items.asMap().entries.map((entry) {
                      final index = entry.key;
                      final item = entry.value;

                      return TableRow(
                        children:
                            [
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
                                child:
                                    // Only allow editing if in preview mode, allowing editing, and is customer copy
                                    receipt.isPreviewMode &&
                                            allowEditing &&
                                            receipt.isCustomerCopy
                                        ? TextFormField(
                                          initialValue:
                                              item.sellPrice.toString(),
                                          keyboardType: TextInputType.number,
                                          decoration: const InputDecoration(
                                            isDense: true,
                                            contentPadding:
                                                EdgeInsets.symmetric(
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
                              // if (!receipt.isCustomerCopy)
                              //   Padding(
                              //     padding: const EdgeInsets.all(8.0),
                              //     child:
                              //         receipt.isPreviewMode && allowEditing
                              //             ? TextFormField(
                              //               initialValue:
                              //                   item.boughtPrice.toString(),
                              //               keyboardType: TextInputType.number,
                              //               decoration: const InputDecoration(
                              //                 isDense: true,
                              //                 contentPadding:
                              //                     EdgeInsets.symmetric(
                              //                       horizontal: 8,
                              //                       vertical: 8,
                              //                     ),
                              //                 border: OutlineInputBorder(),
                              //               ),
                              //               onChanged: (value) {
                              //                 if (value.isNotEmpty) {
                              //                   final newBoughtPrice =
                              //                       double.tryParse(value) ??
                              //                       item.boughtPrice;
                              //                   controller
                              //                       .updateItemBoughtPrice(
                              //                         index,
                              //                         newBoughtPrice,
                              //                       );
                              //                 }
                              //               },
                              //             )
                              //             : Text(
                              //               item.boughtPrice.toStringAsFixed(2),
                              //             ),
                              //   ),
                            ]
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
                                    controller.isPaid.value =
                                        newPaidAmount >=
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
                          color:
                              (receipt.isCustomerCopy
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

                      // Show profit only in internal copy
                      if (!receipt.isCustomerCopy) ...[
                        const SizedBox(height: 10),
                        const Divider(),
                        // Text(
                        //   'Total Profit: GHS ${receipt.totalProfit.toStringAsFixed(2)}',
                        //   style: const TextStyle(
                        //     fontWeight: FontWeight.bold,
                        //     color: Colors.blue,
                        //   ),
                        // ),
                      ],
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Action Buttons
              if (receipt.isPreviewMode) ...[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                      onPressed: onPrint as void Function()?,
                    ),
                    ElevatedButton.icon(
                      icon: const Icon(Icons.save),
                      label: const Text('Save Sale'),
                      onPressed: onSave as void Function()?,
                    ),
                  ],
                ),
              ],

              const SizedBox(height: 20),

              // Footer
              const Center(
                child: Text(
                  'Thank you for your business!',
                  style: TextStyle(fontStyle: FontStyle.italic),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
