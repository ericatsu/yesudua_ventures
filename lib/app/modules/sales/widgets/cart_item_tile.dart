import 'package:flutter/material.dart';
import 'package:yesudua_ventures/app/data/models/sales_model.dart';

class CartItemTile extends StatelessWidget {
  final SaleItemModel item;
  final int index;
  final Function(int) onRemove;
  final Function(int, double) onQuantityChanged;

  const CartItemTile({
    super.key,
    required this.item,
    required this.index,
    required this.onRemove,
    required this.onQuantityChanged,
  });

  @override
  Widget build(BuildContext context) {
    final quantityController = TextEditingController(
      text: item.quantity.toString(),
    );

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Item details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.itemName ?? 'Unknown Item',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      if (item.categoryName != null)
                        Text(
                          item.categoryName!,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      const SizedBox(height: 4),
                      Text(
                        'GHS ${item.sellPrice.toStringAsFixed(2)} per unit',
                        style: TextStyle(color: Colors.green.shade700),
                      ),
                    ],
                  ),
                ),

                // Remove button
                IconButton(
                  icon: Icon(Icons.delete_outline, color: Colors.red.shade400),
                  onPressed: () => onRemove(index),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Quantity control and subtotal row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Quantity control
                Row(
                  children: [
                    const Text('Quantity: '),
                    SizedBox(
                      width: 60,
                      height: 36,
                      child: TextFormField(
                        controller: quantityController,
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        textAlign: TextAlign.center,
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
                            final newQuantity =
                                double.tryParse(value) ?? item.quantity;
                            if (newQuantity > 0) {
                              onQuantityChanged(index, newQuantity);
                            }
                          }
                        },
                      ),
                    ),
                  ],
                ),

                // Subtotal
                Text(
                  'Subtotal: GHS ${item.subtotal.toStringAsFixed(2)}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
