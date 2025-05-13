import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'inventory_controller.dart';
import 'add_item_view.dart';
import 'restock_view.dart';
import 'widgets/inventory_card.dart';
import '../../core/utils/formatters.dart';

class InventoryView extends GetView<InventoryController> {
  const InventoryView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Inventory")),
      body: Row(
        children: [
          Expanded(
            flex: 3,
            child: Column(
              children: [
                // Search and filter bar
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: TextField(
                          decoration: const InputDecoration(
                            hintText: 'Search items...',
                            prefixIcon: Icon(Icons.search),
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.symmetric(vertical: 8.0),
                          ),
                          onChanged: controller.setSearchQuery,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        flex: 2,
                        child: Obx(
                          () => DropdownButtonFormField<String>(
                            decoration: const InputDecoration(
                              labelText: 'Category',
                              border: OutlineInputBorder(),
                              contentPadding: EdgeInsets.symmetric(
                                horizontal: 8.0,
                              ),
                            ),
                            value:
                                controller.selectedCategory.value.isEmpty
                                    ? null
                                    : controller.selectedCategory.value,
                            items: [
                              const DropdownMenuItem<String>(
                                value: '',
                                child: Text('All Categories'),
                              ),
                              ...controller.categories.map(
                                (category) => DropdownMenuItem<String>(
                                  value: category,
                                  child: Text(category),
                                ),
                              ),
                            ],
                            onChanged:
                                (value) =>
                                    controller.setSelectedCategory(value ?? ''),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      TextButton.icon(
                        onPressed: controller.resetFilters,
                        icon: const Icon(Icons.clear),
                        label: const Text('Clear'),
                      ),
                    ],
                  ),
                ),

                // Item list with loading state
                Expanded(
                  child: Obx(() {
                    if (controller.isLoading.value) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (controller.hasError.value) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Error loading inventory',
                              style: TextStyle(color: Colors.red[700]),
                            ),
                            const SizedBox(height: 8),
                            ElevatedButton(
                              onPressed: controller.loadInventory,
                              child: const Text('Retry'),
                            ),
                          ],
                        ),
                      );
                    }

                    final items =
                        controller.filteredItems.isEmpty &&
                                controller.searchQuery.isEmpty &&
                                controller.selectedCategory.isEmpty
                            ? controller.items
                            : controller.filteredItems;

                    if (items.isEmpty) {
                      return const Center(child: Text('No items found'));
                    }

                    return ListView.builder(
                      itemCount: items.length,
                      itemBuilder: (context, index) {
                        final item = items[index];
                        return InventoryCard(
                          item: item,
                          onEdit: () {
                            controller.loadItemToForm(item);
                            Get.dialog(
                              AddItemView(isEditing: true, itemId: item.id),
                            );
                          },
                          onRestock: () => Get.dialog(RestockView(item: item)),
                        );
                      },
                    );
                  }),
                ),

                // Summary info
                Obx(
                  () => Container(
                    padding: const EdgeInsets.all(8.0),
                    color: Colors.grey[200],
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text('Total Items: ${controller.items.length}'),
                        Text(
                          'Total Value: ${Formatters.formatCurrency(controller.items.fold(0.0, (sum, item) => sum + (item.quantity * item.boughtPrice)))}',
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const VerticalDivider(),
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  ElevatedButton.icon(
                    onPressed: () => Get.dialog(AddItemView(isEditing: false)),
                    icon: const Icon(Icons.add),
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(50),
                    ),
                    label: const Text("Add New Item"),
                  ),
                  const SizedBox(height: 20),
                  const Divider(),
                  const SizedBox(height: 10),
                  // Low stock items alert
                  Obx(() {
                    final lowStockItems =
                        controller.items.where((i) => i.quantity <= 5).toList();

                    if (lowStockItems.isEmpty) {
                      return const Text(
                        "No low stock items",
                        style: TextStyle(color: Colors.green),
                      );
                    }

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${lowStockItems.length} Low Stock Items",
                          style: const TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 8),
                        ...lowStockItems
                            .take(5)
                            .map(
                              (item) => ListTile(
                                dense: true,
                                contentPadding: EdgeInsets.zero,
                                title: Text(item.name),
                                subtitle: Text("Qty: ${item.quantity}"),
                                trailing: IconButton(
                                  icon: const Icon(Icons.add_circle_outline),
                                  onPressed:
                                      () => Get.dialog(RestockView(item: item)),
                                ),
                              ),
                            ),
                        if (lowStockItems.length > 5)
                          Center(
                            child: TextButton(
                              child: const Text("View All"),
                              onPressed: () {
                                controller.setSelectedCategory('');
                                controller.setSearchQuery('');
                                // Show only low stock
                                // This would need custom filtering in the controller
                              },
                            ),
                          ),
                      ],
                    );
                  }),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
