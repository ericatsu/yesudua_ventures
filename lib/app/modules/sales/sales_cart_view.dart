import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yesudua_ventures/app/modules/sales/sales_controller.dart';
import 'package:yesudua_ventures/app/modules/sales/widgets/cart_item_tile.dart';
import 'package:yesudua_ventures/app/modules/sales/widgets/receipt_view.dart';

class SalesCartView extends StatelessWidget {
  const SalesCartView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<SalesController>();
    final formKey = GlobalKey<FormState>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cart'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: () {
              if (controller.selectedItems.isEmpty) return;

              showDialog(
                context: context,
                builder:
                    (context) => AlertDialog(
                      title: const Text('Clear Cart'),
                      content: const Text(
                        'Are you sure you want to clear all items from the cart?',
                      ),
                      actions: [
                        TextButton(
                          child: const Text('Cancel'),
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                        TextButton(
                          child: const Text('Clear'),
                          onPressed: () {
                            controller.clearSale();
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    ),
              );
            },
          ),
        ],
      ),
      body: Obx(() {
        if (controller.selectedItems.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.shopping_cart_outlined,
                  size: 80,
                  color: Colors.grey.shade400,
                ),
                const SizedBox(height: 16),
                const Text(
                  'Your cart is empty',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () => Get.back(),
                  child: const Text('Add items'),
                ),
              ],
            ),
          );
        }

        if (controller.isPreviewMode.value) {
          return SingleChildScrollView(
            child: Column(
              children: [
                ReceiptView(
                  receipt: controller.currentReceipt.value!,
                  allowEditing: true,
                  onPrint: () {
                    // Implement printing functionality
                    Get.snackbar(
                      'Printing',
                      'Sending to printer...',
                      snackPosition: SnackPosition.BOTTOM,
                    );
                  },
                  onSave: () async {
                    final success = await controller.submitSale();
                    if (success) {
                      Get.snackbar(
                        'Success',
                        'Sale has been saved successfully',
                        snackPosition: SnackPosition.BOTTOM,
                      );
                      Get.back(); // Return to sales screen
                    } else {
                      Get.snackbar(
                        'Error',
                        controller.errorMessage.value.isEmpty
                            ? 'Failed to save sale'
                            : controller.errorMessage.value,
                        snackPosition: SnackPosition.BOTTOM,
                        backgroundColor: Colors.red.shade100,
                      );
                    }
                  },
                  onToggleReceiptType: () {
                    controller.toggleReceiptType();
                  },
                ),
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ElevatedButton(
                    onPressed: () {
                      controller.isPreviewMode.value = false;
                    },
                    child: const Text('Back to Cart'),
                  ),
                ),
              ],
            ),
          );
        }

        return Form(
          key: formKey,
          child: Column(
            children: [
              // Cart items list
              Expanded(
                child: ListView.builder(
                  itemCount: controller.selectedItems.length,
                  itemBuilder: (context, index) {
                    return CartItemTile(
                      item: controller.selectedItems[index],
                      index: index,
                      onRemove: controller.removeItemFromSale,
                      onQuantityChanged: controller.updateItemQuantity,
                    );
                  },
                ),
              ),

              // Cart summary and checkout section
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.shade300,
                      blurRadius: 4,
                      offset: const Offset(0, -2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Customer details
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Customer Name (Optional)',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.person_outline),
                      ),
                      onChanged: (value) {
                        controller.customerName.value = value;
                      },
                      validator: (value) {
                        // Make customer name required if not paid in full
                        if (!controller.isPaid.value &&
                            (value == null || value.isEmpty)) {
                          return 'Customer name is required for partial payments';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Customer Contact (Optional)',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.phone_outlined),
                      ),
                      onChanged: (value) {
                        controller.customerContact.value = value;
                      },
                      validator: (value) {
                        // Make customer contact required if not paid in full
                        if (!controller.isPaid.value &&
                            (value == null || value.isEmpty)) {
                          return 'Customer contact is required for partial payments';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 8),

                    // Payment details
                    Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: TextFormField(
                            decoration: const InputDecoration(
                              labelText: 'Amount Paid',
                              border: OutlineInputBorder(),
                              prefixIcon: Icon(Icons.payment),
                            ),
                            keyboardType: const TextInputType.numberWithOptions(
                              decimal: true,
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter amount';
                              }
                              return null;
                            },
                            onChanged: (value) {
                              if (value.isNotEmpty) {
                                final paid = double.tryParse(value) ?? 0;
                                controller.paidAmount.value = paid;
                                controller.isPaid.value =
                                    paid >= controller.totalAmount.value;
                              }
                            },
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: CheckboxListTile(
                            title: const Text('Paid in full'),
                            value: controller.isPaid.value,
                            dense: true,
                            contentPadding: EdgeInsets.zero,
                            controlAffinity: ListTileControlAffinity.leading,
                            onChanged: (value) {
                              if (value == true) {
                                controller.isPaid.value = true;
                                controller.paidAmount.value =
                                    controller.totalAmount.value;
                              } else {
                                controller.isPaid.value = false;
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Total and checkout
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Total Amount:',
                              style: TextStyle(fontSize: 16),
                            ),
                            Text(
                              'GHS ${controller.totalAmount.toStringAsFixed(2)}',
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        ElevatedButton.icon(
                          onPressed: () {
                            if (formKey.currentState?.validate() ?? false) {
                              final receipt = controller.generateReceipt();
                              if (receipt != null) {
                                controller.isPreviewMode.value = true;
                              }
                            }
                          },
                          icon: const Icon(Icons.receipt_long),
                          label: const Text('Checkout'),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
