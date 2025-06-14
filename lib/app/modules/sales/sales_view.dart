import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yesudua_ventures/app/data/models/inventory_model.dart';
import 'package:yesudua_ventures/app/data/models/sales_model.dart';
import 'package:yesudua_ventures/app/modules/sales/sales_controller.dart';
import 'package:yesudua_ventures/app/modules/sales/widgets/sales_item_card.dart';
import 'package:yesudua_ventures/app/modules/sales/sales_cart_view.dart';

class SalesView extends StatelessWidget {
  const SalesView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<SalesController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Sales'),
        automaticallyImplyLeading: false,
        actions: [
          // Search action
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                delegate: InventorySearchDelegate(
                  controller,
                  (context, item) =>
                      _showAddToCartDialog(context, controller, item),
                ),
              );
            },
          ),
          // Cart button with badge
          Obx(
            () => Badge(
              isLabelVisible: controller.selectedItems.isNotEmpty,
              label: Text('${controller.selectedItems.length}'),
              child: IconButton(
                icon: const Icon(Icons.shopping_cart),
                onPressed: () {
                  if (controller.selectedItems.isEmpty) {
                    Get.snackbar(
                      'Cart Empty',
                      'Please add items to cart first',
                      snackPosition: SnackPosition.BOTTOM,
                    );
                  } else {
                    Get.to(() => const SalesCartView());
                  }
                },
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Category filter section
            Container(
              height: 50,
              margin: const EdgeInsets.only(bottom: 8),
              child: Obx(
                () => ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: FilterChip(
                        selected: controller.selectedCategoryId.value == null,
                        label: const Text('All Items'),
                        onSelected: (_) {
                          controller.selectedCategoryId.value = null;
                        },
                      ),
                    ),
                    ...controller.categories.map((category) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4.0),
                        child: FilterChip(
                          selected:
                              controller.selectedCategoryId.value ==
                              category.id,
                          label: Text(category.name),
                          onSelected: (_) {
                            controller.selectedCategoryId.value = category.id;
                          },
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ),

            // Inventory items grid
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                } else if (controller.filteredInventoryItems.isEmpty) {
                  return const Center(child: Text('No items found'));
                } else {
                  return GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 1,
                          mainAxisSpacing: 8,
                          crossAxisSpacing: 8,
                        ),
                    itemCount: controller.filteredInventoryItems.length,
                    itemBuilder: (context, index) {
                      final item = controller.filteredInventoryItems[index];
                      return SalesItemCard(
                        item: item,
                        onAddToCart:
                            () =>
                                _showAddToCartDialog(context, controller, item),
                      );
                    },
                  );
                }
              }),
            ),
          ],
        ),
      ),
      floatingActionButton: Obx(
        () => Visibility(
          visible: controller.selectedItems.isNotEmpty,
          child: FloatingActionButton.extended(
            onPressed: () => Get.to(() => const SalesCartView()),
            label: Text('View Cart (${controller.selectedItems.length})'),
            icon: const Icon(Icons.shopping_cart_checkout),
          ),
        ),
      ),
    );
  }

  // Change from private to public method so it can be accessed from delegate
  void _showAddToCartDialog(
    BuildContext context,
    SalesController controller,
    InventoryItemModel item,
  ) {
    final quantityController = TextEditingController(text: '1');
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Add to Cart'),
            content: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Item: ${item.name}'),
                  Text('Available: ${item.quantity}'),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: quantityController,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    decoration: const InputDecoration(
                      labelText: 'Quantity',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a quantity';
                      }

                      final quantity = double.tryParse(value);
                      if (quantity == null || quantity <= 0) {
                        return 'Please enter a valid quantity';
                      }

                      if (quantity > item.quantity) {
                        return 'Not enough stock';
                      }

                      return null;
                    },
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    final quantity = double.parse(quantityController.text);

                    final saleItem = SaleItemModel(
                      inventoryItemId: item.id!,
                      quantity: quantity,
                      sellPrice: item.sellPrice,
                      boughtPrice: item.boughtPrice,
                      itemName: item.name,
                      categoryName: item.categoryName,
                    );

                    controller.addItemToSale(saleItem);
                    Navigator.of(context).pop();

                    Get.snackbar(
                      'Item Added',
                      '${item.name} added to cart',
                      snackPosition: SnackPosition.BOTTOM,
                      duration: const Duration(seconds: 2),
                    );
                  }
                },
                child: const Text('Add to Cart'),
              ),
            ],
          ),
    );
  }
}

class InventorySearchDelegate extends SearchDelegate<InventoryItemModel?> {
  final SalesController controller;
  final Function(BuildContext, InventoryItemModel) showAddToCartDialog;

  InventorySearchDelegate(this.controller, this.showAddToCartDialog);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    if (query.isEmpty) {
      return const Center(child: Text('Enter item name to search'));
    }

    return FutureBuilder<List<InventoryItemModel>>(
      future: controller.searchInventoryItems(query),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No matching items found'));
        } else {
          final items = snapshot.data!;
          return ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              return ListTile(
                title: Text(item.name),
                subtitle: Text(
                  '${item.categoryName ?? "Uncategorized"} - GHS ${item.sellPrice.toStringAsFixed(2)}',
                ),
                trailing: Text('Stock: ${item.quantity}'),
                onTap: () {
                  close(context, item);
                  showAddToCartDialog(context, item);
                },
              );
            },
          );
        }
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.isEmpty) {
      return const Center(child: Text('Enter item name to search'));
    }

    return FutureBuilder<List<InventoryItemModel>>(
      future: controller.searchInventoryItems(query),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No matching items found'));
        } else {
          final items = snapshot.data!;
          return ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              return ListTile(
                title: Text(item.name),
                subtitle: Text(
                  '${item.categoryName ?? "Uncategorized"} - GHS ${item.sellPrice.toStringAsFixed(2)}',
                ),
                trailing: Text('Stock: ${item.quantity}'),
                onTap: () {
                  close(context, item);
                  showAddToCartDialog(context, item);
                },
              );
            },
          );
        }
      },
    );
  }
}
