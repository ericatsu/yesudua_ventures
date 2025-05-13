import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'inventory_controller.dart';
import 'add_item_view.dart';
import 'restock_view.dart';
import 'widgets/inventory_card.dart';

class InventoryView extends GetView<InventoryController> {
  const InventoryView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Inventory")),
      body: Row(
        children: [
          Expanded(
            flex: 2,
            child: Obx(
              () => ListView(
                children:
                    controller.items
                        .map(
                          (item) => InventoryCard(
                            item: item,
                            onEdit: () {}, // future: edit logic
                            onRestock:
                                () => Get.dialog(RestockView(item: item)),
                          ),
                        )
                        .toList(),
              ),
            ),
          ),
          const VerticalDivider(),
          Expanded(
            flex: 1,
            child: Center(
              child: ElevatedButton.icon(
                onPressed: () => Get.dialog(AddItemView()),
                icon: const Icon(Icons.add),
                label: const Text("Add Item"),
              ),
            ),
          ),
        ],
      ),
    );
  }
}