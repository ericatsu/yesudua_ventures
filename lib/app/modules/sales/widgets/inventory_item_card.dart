import 'package:flutter/material.dart';
import 'package:yesudua_ventures/app/data/models/inventory_model.dart';

class InventoryItemCard extends StatelessWidget {
  final InventoryItemModel item;
  final VoidCallback onAddToCart;

  const InventoryItemCard({
    super.key,
    required this.item,
    required this.onAddToCart,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      child: InkWell(
        onTap: onAddToCart,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Category label
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.blue.shade100,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  item.categoryName ?? 'Uncategorized',
                  style: TextStyle(fontSize: 11, color: Colors.blue.shade800),
                ),
              ),

              const SizedBox(height: 8),

              // Item name
              Text(
                item.name,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),

              const SizedBox(height: 8),

              // Price
              Text(
                'GHS ${item.sellPrice.toStringAsFixed(2)}',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: Colors.green.shade700,
                ),
              ),

              const Spacer(),

              // Stock and add button
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Stock indicator
                  Row(
                    children: [
                      Icon(
                        Icons.inventory_2_outlined,
                        size: 16,
                        color:
                            item.quantity > 0
                                ? Colors.grey.shade700
                                : Colors.red,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Stock: ${item.quantity}',
                        style: TextStyle(
                          fontSize: 12,
                          color:
                              item.quantity > 0
                                  ? Colors.grey.shade700
                                  : Colors.red,
                        ),
                      ),
                    ],
                  ),

                  // Add button
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: item.quantity > 0 ? onAddToCart : null,
                      borderRadius: BorderRadius.circular(20),
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Icon(
                          Icons.add_shopping_cart,
                          color: item.quantity > 0 ? Colors.blue : Colors.grey,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
