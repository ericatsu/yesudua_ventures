import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'inventory_controller.dart';
import '../../data/models/inventory_item.dart';
import '../../core/utils/validators.dart';
import '../../core/utils/formatters.dart';

class RestockView extends StatelessWidget {
  final InventoryItem item;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final RxBool _updatePrice = false.obs;

  RestockView({required this.item, super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<InventoryController>();

    // Initialize price controller with current bought price
    _priceController.text = item.boughtPrice.toString();

    return AlertDialog(
      title: Text("Restock: ${item.name}"),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Current stock info
            RichText(
              text: TextSpan(
                style: DefaultTextStyle.of(context).style,
                children: [
                  const TextSpan(
                    text: 'Current Stock: ',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(
                    text: '${item.quantity} units',
                    style: TextStyle(
                      color: Formatters.getStockLevelColor(item.quantity),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Current Bought Price: ${Formatters.formatCurrency(item.boughtPrice)}',
            ),
            Text(
              'Current Sell Price: ${Formatters.formatCurrency(item.sellPrice)}',
            ),
            const SizedBox(height: 16),

            // Add quantity field
            TextFormField(
              controller: _quantityController,
              decoration: const InputDecoration(
                labelText: 'Add Quantity',
                hintText: 'Enter quantity to add',
                prefixIcon: Icon(Icons.add_shopping_cart),
              ),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a quantity';
                }
                final quantity = int.tryParse(value);
                if (quantity == null) {
                  return 'Please enter a valid number';
                }
                if (quantity <= 0) {
                  return 'Quantity must be greater than 0';
                }
                return null;
              },
            ),
            const SizedBox(height: 12),

            // Update price checkbox
            Row(
              children: [
                Obx(
                  () => Checkbox(
                    value: _updatePrice.value,
                    onChanged: (value) => _updatePrice.value = value ?? false,
                  ),
                ),
                const Text('Update bought price'),
              ],
            ),

            // Conditional bought price field
            Obx(
              () =>
                  _updatePrice.value
                      ? TextFormField(
                        controller: _priceController,
                        decoration: const InputDecoration(
                          labelText: 'New Bought Price',
                          hintText: 'Enter new bought price',
                          prefixIcon: Icon(Icons.money),
                          prefixText: '₵',
                        ),
                        keyboardType: TextInputType.number,
                        validator: Validators.validatePrice,
                      )
                      : const SizedBox.shrink(),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(onPressed: () => Get.back(), child: const Text("Cancel")),
        Obx(
          () => ElevatedButton(
            onPressed:
                controller.isLoading.value
                    ? null
                    : () async {
                      if (_formKey.currentState!.validate()) {
                        final addedQty =
                            int.tryParse(_quantityController.text) ?? 0;
                        final newPrice =
                            _updatePrice.value
                                ? double.tryParse(_priceController.text)
                                : null;

                        final success = await controller.restockItem(
                          item,
                          addedQty,
                          newPrice,
                        );

                        if (success) {
                          Get.back();
                        }
                      }
                    },
            child:
                controller.isLoading.value
                    ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                    : const Text("Restock"),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _quantityController.dispose();
    _priceController.dispose();
  }
}
