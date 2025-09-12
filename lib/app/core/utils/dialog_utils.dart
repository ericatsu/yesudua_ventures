import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yesudua_ventures/app/data/models/inventory_model.dart';
import 'package:yesudua_ventures/app/core/utils/app_utils.dart';

class DialogUtils {
  // Generic confirmation dialog
  static void showConfirmationDialog({
    required String title,
    required String content,
    required VoidCallback onConfirm,
    String confirmText = 'Confirm',
    String cancelText = 'Cancel',
    Color? confirmColor = Colors.red,
  }) {
    Get.dialog(
      AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(onPressed: () => Get.back(), child: Text(cancelText)),
          TextButton(
            onPressed: () {
              Get.back();
              onConfirm();
            },
            child: Text(confirmText, style: TextStyle(color: confirmColor)),
          ),
        ],
      ),
    );
  }

  // Supplier form dialog
  static void showSupplierFormDialog({
    SupplierModel? supplier,
    required Function(SupplierModel) onSave,
  }) {
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
        content: SupplierFormContent(
          formKey: formKey,
          nameController: nameController,
          contactController: contactController,
          addressController: addressController,
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

                Get.back();
                onSave(newSupplier);
              }
            },
            child: Text(supplier == null ? 'Add' : 'Save'),
          ),
        ],
      ),
    );
  }

  // Supplier history dialog
  static void showSupplierHistoryDialog({
    required String supplierName,
    required Future<List<SupplyHistoryModel>> historyFuture,
  }) {
    Get.dialog(
      AlertDialog(
        title: Text('$supplierName - Supply History'),
        content: FutureBuilder<List<SupplyHistoryModel>>(
          future: historyFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const SizedBox(
                height: 100,
                child: Center(child: CircularProgressIndicator()),
              );
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
                  return SupplyHistoryTile(supply: supply);
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

// Supplier Form Content Widget
class SupplierFormContent extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController nameController;
  final TextEditingController contactController;
  final TextEditingController addressController;

  const SupplierFormContent({
    super.key,
    required this.formKey,
    required this.nameController,
    required this.contactController,
    required this.addressController,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Name *',
                prefixIcon: Icon(Icons.person),
              ),
              validator: (value) => AppUtils.requiredValidator(value, 'name'),
            ),
            const SizedBox(height: 16.0),
            TextFormField(
              controller: contactController,
              decoration: const InputDecoration(
                labelText: 'Contact *',
                prefixIcon: Icon(Icons.phone),
              ),
              validator:
                  (value) =>
                      AppUtils.requiredValidator(value, 'contact information'),
            ),
            const SizedBox(height: 16.0),
            TextFormField(
              controller: addressController,
              decoration: const InputDecoration(
                labelText: 'Address (Optional)',
                prefixIcon: Icon(Icons.location_on),
              ),
              maxLines: 2,
            ),
          ],
        ),
      ),
    );
  }
}

// Supply History Tile Widget
class SupplyHistoryTile extends StatelessWidget {
  final SupplyHistoryModel supply;

  const SupplyHistoryTile({super.key, required this.supply});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4.0),
      child: ListTile(
        title: Text(
          supply.itemName ?? 'Unknown Item',
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Quantity: ${supply.quantity}'),
            Text('Price: ${AppUtils.formatCurrency(supply.boughtPrice)}'),
            Text('Date: ${AppUtils.formatDate(supply.supplyDate)}'),
          ],
        ),
        isThreeLine: true,
        leading: const CircleAvatar(child: Icon(Icons.inventory)),
      ),
    );
  }
}
