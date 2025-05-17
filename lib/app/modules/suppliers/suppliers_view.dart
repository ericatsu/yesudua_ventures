import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yesudua_ventures/app/data/models/inventory_model.dart';
import 'package:yesudua_ventures/app/modules/suppliers/suppliers_controller.dart';

class SuppliersView extends StatelessWidget {
  const SuppliersView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<SuppliersController>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Suppliers'),
        actions: [
          IconButton(
            onPressed: () => _showSupplierFormDialog(context),
            icon: const Icon(Icons.add),
            tooltip: 'Add Supplier',
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              onChanged: (value) => controller.searchQuery.value = value,
              decoration: InputDecoration(
                hintText: 'Search suppliers...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 8.0),
              ),
            ),
          ),
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              if (controller.suppliers.isEmpty) {
                return const Center(
                  child: Text('No suppliers found. Add a new supplier.'),
                );
              }

              return ListView.separated(
                padding: const EdgeInsets.all(16.0),
                itemCount: controller.suppliers.length,
                separatorBuilder: (_, __) => const Divider(),
                itemBuilder: (context, index) {
                  final supplier = controller.suppliers[index];
                  return SupplierListItem(
                    supplier: supplier,
                    onEdit: () => _showSupplierFormDialog(context, supplier),
                    onDelete: () => _confirmDeleteSupplier(context, supplier),
                    onViewHistory:
                        () => _showSupplierHistory(context, supplier),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  // Dialog to add or edit a supplier
  void _showSupplierFormDialog(
    BuildContext context, [
    SupplierModel? supplier,
  ]) {
    final controller = Get.find<SuppliersController>();
    controller.selectSupplier(supplier);

    final formKey = GlobalKey<FormState>();
    final nameController = TextEditingController(text: supplier?.name ?? '');
    final contactController = TextEditingController(
      text: supplier?.contact ?? '',
    );
    final addressController = TextEditingController(
      text: supplier?.address ?? '',
    );

    Get.dialog(
      AlertDialog(
        title: Text(supplier == null ? 'Add New Supplier' : 'Edit Supplier'),
        content: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: 'Name'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  controller: contactController,
                  decoration: const InputDecoration(labelText: 'Contact'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter contact information';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  controller: addressController,
                  decoration: const InputDecoration(
                    labelText: 'Address (Optional)',
                  ),
                  maxLines: 2,
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          TextButton(
            onPressed: () async {
              if (formKey.currentState!.validate()) {
                final newSupplier = SupplierModel(
                  id: supplier?.id,
                  name: nameController.text,
                  contact: contactController.text,
                  address:
                      addressController.text.isNotEmpty
                          ? addressController.text
                          : null,
                );

                if (supplier == null) {
                  await controller.addSupplier(newSupplier);
                } else {
                  await controller.updateSupplier(newSupplier);
                }
              }
            },
            child: Text(supplier == null ? 'Add' : 'Save'),
          ),
        ],
      ),
    );
  }

  // Confirmation dialog to delete a supplier
  void _confirmDeleteSupplier(BuildContext context, SupplierModel supplier) {
    final controller = Get.find<SuppliersController>();

    Get.dialog(
      AlertDialog(
        title: const Text('Delete Supplier'),
        content: Text(
          'Are you sure you want to delete ${supplier.name}? This action cannot be undone.',
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          TextButton(
            onPressed: () async {
              if (supplier.id != null) {
                final success = await controller.deleteSupplier(supplier.id!);
                if (success) Get.back();
              }
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  // Show supplier history dialog with supply details
  void _showSupplierHistory(BuildContext context, SupplierModel supplier) {
    if (supplier.id == null) return;

    final controller = Get.find<SuppliersController>();

    Get.dialog(
      AlertDialog(
        title: Text('${supplier.name} - Supply History'),
        content: FutureBuilder<List<SupplyHistoryModel>>(
          future: controller.getSupplierHistory(supplier.id!),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return const Text('Failed to load supply history');
            }

            final history = snapshot.data ?? [];
            if (history.isEmpty) {
              return const Text('No supply history found for this supplier');
            }

            return SizedBox(
              width: double.maxFinite,
              height: 300,
              child: ListView.builder(
                itemCount: history.length,
                itemBuilder: (context, index) {
                  final supply = history[index];
                  return ListTile(
                    title: Text(supply.itemName ?? 'Unknown Item'),
                    subtitle: Text(
                      'Qty: ${supply.quantity}, Price: ${formatCurrency(supply.boughtPrice)}\n'
                      'Date: ${formatDate(supply.supplyDate)}',
                    ),
                    isThreeLine: true,
                  );
                },
              ),
            );
          },
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Close')),
        ],
      ),
    );
  }
}

// Custom widget for supplier list item
class SupplierListItem extends StatelessWidget {
  final SupplierModel supplier;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onViewHistory;

  const SupplierListItem({
    Key? key,
    required this.supplier,
    required this.onEdit,
    required this.onDelete,
    required this.onViewHistory,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: ListTile(
        title: Text(
          supplier.name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.phone, size: 16),
                const SizedBox(width: 4),
                Text(supplier.contact),
              ],
            ),
            if (supplier.address != null) ...[
              const SizedBox(height: 4),
              Row(
                children: [
                  const Icon(Icons.location_on, size: 16),
                  const SizedBox(width: 4),
                  Expanded(child: Text(supplier.address!)),
                ],
              ),
            ],
          ],
        ),
        trailing: PopupMenuButton(
          itemBuilder:
              (context) => [
                const PopupMenuItem(
                  value: 'edit',
                  child: Row(
                    children: [
                      Icon(Icons.edit),
                      SizedBox(width: 8),
                      Text('Edit'),
                    ],
                  ),
                ),
                const PopupMenuItem(
                  value: 'history',
                  child: Row(
                    children: [
                      Icon(Icons.history),
                      SizedBox(width: 8),
                      Text('View History'),
                    ],
                  ),
                ),
                const PopupMenuItem(
                  value: 'delete',
                  child: Row(
                    children: [
                      Icon(Icons.delete, color: Colors.red),
                      SizedBox(width: 8),
                      Text('Delete', style: TextStyle(color: Colors.red)),
                    ],
                  ),
                ),
              ],
          onSelected: (value) {
            switch (value) {
              case 'edit':
                onEdit();
                break;
              case 'history':
                onViewHistory();
                break;
              case 'delete':
                onDelete();
                break;
            }
          },
        ),
      ),
    );
  }
}

// Helper functions for formatting
String formatCurrency(double amount) {
  return 'GH₵ ${amount.toStringAsFixed(2)}';
}

String formatDate(DateTime date) {
  return '${date.day}/${date.month}/${date.year}';
}
