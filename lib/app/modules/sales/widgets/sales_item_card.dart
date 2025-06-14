import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yesudua_ventures/app/data/models/inventory_model.dart';
import 'package:yesudua_ventures/app/modules/inventory/inventory_controller.dart';

class SalesItemCard extends StatelessWidget {
  final InventoryItemModel item;
  final VoidCallback onAddToCart;

  const SalesItemCard({
    super.key,
    required this.item,
    required this.onAddToCart,
  });

  @override
  Widget build(BuildContext context) {
    // Get the inventory controller to access the image path method
    final inventoryController = Get.find<InventoryController>();

    return Card(
      elevation: 1,
      child: InkWell(
        onTap: onAddToCart,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Product Image
              Container(
                height: 80,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset(
                    inventoryController.getImagePathForItem(item),
                    fit: BoxFit.cover,
                    errorBuilder:
                        (context, error, stackTrace) => Container(
                          decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            Icons.inventory_2_outlined,
                            size: 40,
                            color: Colors.grey.shade500,
                          ),
                        ),
                  ),
                ),
              ),

              const SizedBox(height: 12),

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
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  color: Colors.green.shade700,
                ),
              ),

              const Spacer(),

              // Stock and add button
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Stock indicator
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color:
                          item.quantity > 0
                              ? Colors.green.shade100
                              : Colors.red.shade100,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.inventory_2_outlined,
                          size: 14,
                          color:
                              item.quantity > 0
                                  ? Colors.green.shade700
                                  : Colors.red.shade700,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '${item.quantity.toInt()}',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color:
                                item.quantity > 0
                                    ? Colors.green.shade700
                                    : Colors.red.shade700,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Add button
                  Container(
                    decoration: BoxDecoration(
                      color:
                          item.quantity > 0
                              ? Colors.blue.shade600
                              : Colors.grey.shade400,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: item.quantity > 0 ? onAddToCart : null,
                        borderRadius: BorderRadius.circular(20),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Icon(
                            Icons.add_shopping_cart,
                            color: Colors.white,
                            size: 18,
                          ),
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
