import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yesudua_ventures/app/core/utils/constants.dart'; // Import for currency formatter
import 'package:yesudua_ventures/app/data/models/inventory_model.dart';
import 'package:yesudua_ventures/app/modules/inventory/inventory_controller.dart';

class InventoryItemCard extends StatelessWidget {
  final InventoryItemModel item;
  final String? imagePath; // Add imagePath parameter
  final VoidCallback? onTap; // Add onTap parameter
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onRestock;

  const InventoryItemCard({
    super.key,
    required this.item,
    this.imagePath, // Make it optional since we can get it from controller
    this.onTap,
    required this.onEdit,
    required this.onDelete,
    required this.onRestock,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<InventoryController>();
    final itemImagePath = imagePath ?? controller.getImagePathForItem(item);

    return InkWell(
      onTap: onTap,
      child: Card(
        elevation: 3,
        margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 2.0),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Item image
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                      image: DecorationImage(
                        image: AssetImage(itemImagePath),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16.0),

                  // Item details
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.name,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18.0,
                          ),
                        ),
                        const SizedBox(height: 4.0),
                        Text(
                          'Category: ${item.categoryName ?? 'Unknown'}',
                          style: TextStyle(
                            color: Colors.grey[700],
                            fontSize: 14.0,
                          ),
                        ),
                        const SizedBox(height: 4.0),
                        Text(
                          'Quantity: ${item.quantity}',
                          style: TextStyle(
                            color:
                                item.quantity <= 5
                                    ? Colors.red
                                    : Colors.grey[700],
                            fontWeight:
                                item.quantity <= 5
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                            fontSize: 14.0,
                          ),
                        ),
                        const SizedBox(height: 4.0),
                        Text(
                          'Price: ${AppConstants.currencyFormatter.format(item.sellPrice)}',
                          style: TextStyle(
                            color: Colors.green[700],
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const Divider(height: 24.0),

              // Action buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit_outlined, color: Colors.blue),
                    onPressed: onEdit,
                    tooltip: 'Edit Item',
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.add_circle_outline,
                      color: Colors.green,
                    ),
                    onPressed: onRestock,
                    tooltip: 'Restock Item',
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete_outline, color: Colors.red),
                    onPressed: onDelete,
                    tooltip: 'Delete Item',
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
