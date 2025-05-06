import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'inventory_controller.dart';
import '../../data/models/inventory_item.dart';

class RestockView extends StatelessWidget {
  final InventoryItem item;
  final _quantityController = TextEditingController();
  final _priceController = TextEditingController();

  RestockView({required this.item, super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<InventoryController>();

    return AlertDialog(
      title: Text("Restock: ${item.name}"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text("Current Quantity: ${item.quantity}"),
          const SizedBox(height: 8),
          TextField(
            controller: _quantityController,
            decoration: const InputDecoration(labelText: 'Add Quantity'),
            keyboardType: TextInputType.number,
          ),
          TextField(
            controller: _priceController,
            decoration: const InputDecoration(
              labelText: 'Update Bought Price (optional)',
            ),
            keyboardType: TextInputType.number,
          ),
        ],
      ),
      actions: [
        TextButton(onPressed: () => Get.back(), child: const Text("Cancel")),
        ElevatedButton(
          onPressed: () {
            final addedQty = int.tryParse(_quantityController.text) ?? 0;
            final newPrice = double.tryParse(_priceController.text);

            controller.restockItem(item, addedQty, newPrice);
            Get.back();
          },
          child: const Text("Restock"),
        ),
      ],
    );
  }
}
