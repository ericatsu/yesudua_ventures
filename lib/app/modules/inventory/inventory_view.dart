import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yesudua_ventures/app/core/utils/constants.dart';
import 'package:yesudua_ventures/app/data/models/inventory_model.dart';
import 'package:yesudua_ventures/app/modules/inventory/inventory_controller.dart';
import 'package:yesudua_ventures/app/modules/inventory/widgets/add_inventory_modal.dart';
import 'package:yesudua_ventures/app/modules/inventory/widgets/inventory_item_card.dart';
import 'package:yesudua_ventures/app/modules/inventory/widgets/restock_inventory_modal.dart';

class InventoryView extends GetView<InventoryController> {
  const InventoryView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inventory Management'),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.sort),
            onPressed: () => _showSortOptions(context),
          ),
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () => _showCategoryFilter(context),
          ),
        ],
      ),
      body: Column(
        children: [
          _buildSearchBar(),
          _buildCategoryChips(),
          Expanded(child: _buildInventoryList()),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddInventoryModal(context),
        tooltip: 'Add Inventory Item',
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(AppConstants.defaultPadding),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Search inventory items...',
          prefixIcon: const Icon(Icons.search),
          suffixIcon: IconButton(
            icon: const Icon(Icons.clear),
            onPressed: () {
              controller.searchQuery.value = '';
              FocusManager.instance.primaryFocus?.unfocus();
            },
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(
              AppConstants.defaultBorderRadius,
            ),
          ),
        ),
        onChanged: (value) => controller.searchQuery.value = value,
      ),
    );
  }

  Widget _buildCategoryChips() {
    return Obx(
      () =>
          controller.selectedCategory.value != null
              ? Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppConstants.defaultPadding,
                ),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      Chip(
                        label: Text(
                          'Category: ${controller.selectedCategory.value!.name}',
                        ),
                        deleteIcon: const Icon(Icons.close),
                        onDeleted: () {
                          controller.selectedCategory.value = null;
                          controller.fetchAllInventory();
                        },
                      ),
                    ],
                  ),
                ),
              )
              : const SizedBox.shrink(),
    );
  }

  Widget _buildInventoryList() {
    return Obx(() {
      if (controller.isLoadingItems.value) {
        return const Center(child: CircularProgressIndicator());
      }

      if (controller.inventoryItems.isEmpty) {
        return Center(
          child: Builder(
            builder: (context) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.inventory_2_outlined,
                    size: 64,
                    color: Colors.grey,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'No inventory items found',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () => _showAddInventoryModal(context),
                    child: const Text('Add Item'),
                  ),
                ],
              );
            }
          ),
        );
      }

      return RefreshIndicator(
        onRefresh: controller.fetchAllInventory,
        child: ListView.builder(
          padding: const EdgeInsets.all(AppConstants.defaultPadding),
          itemCount: controller.inventoryItems.length,
          itemBuilder: (context, index) {
            final item = controller.inventoryItems[index];
            return InventoryItemCard(
              item: item,
              onTap: () => _showItemDetails(context, item),
              onEdit: () => _showEditInventoryModal(context, item),
              onDelete: () => _confirmDelete(context, item),
              onRestock: () => _showRestockModal(context, item),
            );
          },
        ),
      );
    });
  }

  void _showSortOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Obx(
          () => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: const Text('Sort by Name'),
                leading: const Icon(Icons.sort_by_alpha),
                trailing:
                    controller.sortBy.value == 'name'
                        ? Icon(
                          controller.sortAscending.value
                              ? Icons.arrow_upward
                              : Icons.arrow_downward,
                        )
                        : null,
                onTap: () {
                  controller.changeSortOption('name');
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text('Sort by Quantity'),
                leading: const Icon(Icons.numbers),
                trailing:
                    controller.sortBy.value == 'quantity'
                        ? Icon(
                          controller.sortAscending.value
                              ? Icons.arrow_upward
                              : Icons.arrow_downward,
                        )
                        : null,
                onTap: () {
                  controller.changeSortOption('quantity');
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const Text('Sort by Price'),
                leading: const Icon(Icons.attach_money),
                trailing:
                    controller.sortBy.value == 'sellPrice'
                        ? Icon(
                          controller.sortAscending.value
                              ? Icons.arrow_upward
                              : Icons.arrow_downward,
                        )
                        : null,
                onTap: () {
                  controller.changeSortOption('sellPrice');
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showCategoryFilter(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.6,
          maxChildSize: 0.9,
          minChildSize: 0.5,
          expand: false,
          builder: (context, scrollController) {
            return Obx(() {
              if (controller.isLoadingCategories.value) {
                return const Center(child: CircularProgressIndicator());
              }

              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(AppConstants.defaultPadding),
                    child: Row(
                      children: [
                        const Text(
                          'Filter by Category',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Spacer(),
                        TextButton(
                          onPressed: () {
                            controller.selectedCategory.value = null;
                            controller.fetchAllInventory();
                            Navigator.pop(context);
                          },
                          child: const Text('Clear Filter'),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      controller: scrollController,
                      itemCount: controller.categories.length,
                      itemBuilder: (context, index) {
                        final category = controller.categories[index];
                        return ListTile(
                          title: Text(category.name),
                          subtitle:
                              category.description != null
                                  ? Text(category.description!)
                                  : null,
                          onTap: () {
                            controller.selectedCategory.value = category;
                            controller.filterByCategory();
                            Navigator.pop(context);
                          },
                        );
                      },
                    ),
                  ),
                ],
              );
            });
          },
        );
      },
    );
  }

  void _showAddInventoryModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder:
          (context) => AddInventoryModal(
            controller: controller,
            onItemAdded: () {
              Navigator.pop(context);
            },
          ),
    );
  }

  void _showRestockModal(BuildContext context, InventoryItemModel item) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder:
          (context) => RestockInventoryModal(
            controller: controller,
            item: item,
            onRestockComplete: () {
              // Restock complete callback - refresh is handled in the controller
              Navigator.pop(context);
            },
          ),
    );
  }

  void _showItemDetails(BuildContext context, InventoryItemModel item) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.6,
          maxChildSize: 0.9,
          minChildSize: 0.5,
          expand: false,
          builder: (_, scrollController) {
            return SingleChildScrollView(
              controller: scrollController,
              padding: const EdgeInsets.all(AppConstants.defaultPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      height: 100,
                      width: 100,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(
                            controller.getImagePathForItem(item),
                          ),
                          fit: BoxFit.contain,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    item.name,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text('Category: ${item.categoryName ?? 'None'}'),
                  const SizedBox(height: 4),
                  Text('Supplier: ${item.supplierName ?? 'None'}'),
                  const SizedBox(height: 8),
                  Text(
                    'Quantity: ${item.quantity}',
                    style: TextStyle(
                      color: item.quantity < 5 ? Colors.red : null,
                      fontWeight: item.quantity < 5 ? FontWeight.bold : null,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Selling Price: ${AppConstants.currencyFormatter.format(item.sellPrice)}',
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Bought Price: ${AppConstants.currencyFormatter.format(item.boughtPrice)}',
                  ),
                  const SizedBox(height: 4),
                  if (item.lastRestocked != null)
                    Text(
                      'Last Restocked: ${AppConstants.dateFormatter.format(item.lastRestocked!)}',
                    ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton.icon(
                        onPressed: () {
                          Navigator.pop(context);
                          // Navigate to edit screen or show edit modal
                          _showEditInventoryModal(context, item);
                        },
                        icon: const Icon(Icons.edit),
                        label: const Text('Edit'),
                      ),
                      ElevatedButton.icon(
                        onPressed: () {
                          Navigator.pop(context);
                          _showRestockModal(context, item);
                        },
                        icon: const Icon(Icons.add_shopping_cart),
                        label: const Text('Restock'),
                      ),
                      ElevatedButton.icon(
                        onPressed: () {
                          _confirmDelete(context, item);
                        },
                        icon: const Icon(Icons.delete),
                        label: const Text('Delete'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _showEditInventoryModal(BuildContext context, InventoryItemModel item) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder:
          (context) => AddInventoryModal(
            controller: controller,
            editItem: item,
            onItemAdded: () {
              // Item updated callback
              Navigator.pop(context);
            },
          ),
    );
  }

  void _confirmDelete(BuildContext context, InventoryItemModel item) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Confirm Delete'),
            content: Text('Are you sure you want to delete ${item.name}?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () async {
                  Navigator.pop(context); // Close dialog
                  Navigator.pop(context); // Close details modal

                  final success = await controller.deleteInventoryItem(
                    item.id!,
                  );
                  if (success) {
                    Get.snackbar(
                      'Success',
                      'Item deleted successfully',
                      snackPosition: SnackPosition.BOTTOM,
                    );
                  }
                },
                child: const Text(
                  'Delete',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          ),
    );
  }
}
