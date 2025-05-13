import 'package:flutter/material.dart';
import 'package:yesudua_ventures/app/data/models/inventory_item.dart';

class InventoryCard extends StatelessWidget {
  final InventoryItem item;
  final VoidCallback onEdit;
  final VoidCallback onRestock;

  const InventoryCard({
    super.key,
    required this.item,
    required this.onEdit,
    required this.onRestock,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(item.name),
        subtitle: Text("Qty: ${item.quantity}, ₵${item.sellPrice}"),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(icon: const Icon(Icons.edit), onPressed: onEdit),
            IconButton(icon: const Icon(Icons.add), onPressed: onRestock),
          ],
        ),
      ),
    );
  }
}
