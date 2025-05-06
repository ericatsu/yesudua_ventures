import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yesudua_ventures/app/modules/inventory/add_item_view.dart';
import 'package:yesudua_ventures/app/modules/inventory/restock_view.dart';
import 'inventory_controller.dart';

class InventoryView extends GetView<InventoryController> {
  final _formKey = GlobalKey<FormState>();

  InventoryView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Inventory')),
      body: Row(
        children: [
          // Left: Inventory List
          Expanded(
            flex: 2,
            child: Obx(
              () => ListView.builder(
                itemCount: controller.items.length,
                itemBuilder: (context, index) {
                  final item = controller.items[index];
                  return ListTile(
                    title: Text(item.name),
                    subtitle: Text(
                      'Qty: ${item.quantity} | ₵${item.sellPrice.toStringAsFixed(2)}',
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('Bought @ ₵${item.boughtPrice}'),
                        IconButton(
                          icon: const Icon(Icons.add_box),
                          onPressed: () => Get.dialog(RestockView(item: item)),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
          const VerticalDivider(),
          // Right: Add Form
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    const Text(
                      "Add New Item",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextFormField(
                      decoration: const InputDecoration(labelText: 'Name'),
                      onChanged: (val) => controller.name.value = val,
                    ),
                    TextFormField(
                      decoration: const InputDecoration(labelText: 'Category'),
                      onChanged: (val) => controller.category.value = val,
                    ),
                    TextFormField(
                      decoration: const InputDecoration(labelText: 'Quantity'),
                      keyboardType: TextInputType.number,
                      onChanged:
                          (val) =>
                              controller.quantity.value =
                                  int.tryParse(val) ?? 0,
                    ),
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Bought Price',
                      ),
                      keyboardType: TextInputType.number,
                      onChanged:
                          (val) =>
                              controller.boughtPrice.value =
                                  double.tryParse(val) ?? 0.0,
                    ),
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Sell Price',
                      ),
                      keyboardType: TextInputType.number,
                      onChanged:
                          (val) =>
                              controller.sellPrice.value =
                                  double.tryParse(val) ?? 0.0,
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton.icon(
                      onPressed: controller.addItem,
                      icon: const Icon(Icons.add),
                      label: const Text("Add Item"),
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton.icon(
                      onPressed: () => Get.dialog(AddItemView()),
                      icon: const Icon(Icons.add),
                      label: const Text("Add Item"),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
