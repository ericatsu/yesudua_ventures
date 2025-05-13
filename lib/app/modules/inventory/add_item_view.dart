import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'inventory_controller.dart';
import 'widgets/image_selector.dart';
import '../../core/utils/validators.dart';
import '../../core/utils/constants.dart';
import '../../core/utils/snackbar_utils.dart';

class AddItemView extends StatelessWidget {
  final bool isEditing;
  final int? itemId;
  final _formKey = GlobalKey<FormState>();

  AddItemView({this.isEditing = false, this.itemId, super.key}) {
    // If we're not editing, reset the form values
    if (!isEditing) {
      final controller = Get.find<InventoryController>();
      controller.resetForm();
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<InventoryController>();

    return AlertDialog(
      title: Text(isEditing ? "Edit Item" : "Add New Item"),
      content: Form(
        key: _formKey,
        child: SizedBox(
          width: 400,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Item name field
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Name',
                    hintText: 'Enter item name',
                    prefixIcon: Icon(Icons.label),
                  ),
                  initialValue: controller.name.value,
                  validator: Validators.validateName,
                  onChanged: (val) => controller.name.value = val,
                ),
                const SizedBox(height: 10),

                // Category field with dropdown
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    labelText: 'Category',
                    hintText: 'Select or type a category',
                    prefixIcon: Icon(Icons.category),
                  ),
                  value:
                      controller.category.value.isNotEmpty
                          ? controller.category.value
                          : null,
                  items: [
                    ...AppConstants.predefinedCategories.map(
                      (category) => DropdownMenuItem<String>(
                        value: category,
                        child: Text(category),
                      ),
                    ),
                    if (!AppConstants.predefinedCategories.contains(
                          controller.category.value,
                        ) &&
                        controller.category.value.isNotEmpty)
                      DropdownMenuItem<String>(
                        value: controller.category.value,
                        child: Text(controller.category.value),
                      ),
                  ],
                  onChanged: (String? value) {
                    if (value != null) {
                      controller.category.value = value;
                    }
                  },
                  validator: Validators.validateCategory,
                  isExpanded: true,
                ),
                const SizedBox(height: 10),

                // Quantity field
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Quantity',
                    hintText: 'Enter item quantity',
                    prefixIcon: Icon(Icons.shopping_cart),
                  ),
                  initialValue:
                      controller.quantity.value > 0
                          ? controller.quantity.value.toString()
                          : '',
                  keyboardType: TextInputType.number,
                  validator: Validators.validateQuantity,
                  onChanged:
                      (val) =>
                          controller.quantity.value = int.tryParse(val) ?? 0,
                ),
                const SizedBox(height: 10),

                // Price fields in a row
                Row(
                  children: [
                    // Bought price field
                    Expanded(
                      child: TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'Bought Price',
                          hintText: 'Cost price',
                          prefixIcon: Icon(Icons.attach_money),
                          prefixText: '₵',
                        ),
                        initialValue:
                            controller.boughtPrice.value > 0
                                ? controller.boughtPrice.value.toString()
                                : '',
                        keyboardType: TextInputType.number,
                        validator: Validators.validatePrice,
                        onChanged:
                            (val) =>
                                controller.boughtPrice.value =
                                    double.tryParse(val) ?? 0.0,
                      ),
                    ),
                    const SizedBox(width: 10),
                    // Sell price field
                    Expanded(
                      child: TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'Sell Price',
                          hintText: 'Selling price',
                          prefixIcon: Icon(Icons.sell),
                          prefixText: '₵',
                        ),
                        initialValue:
                            controller.sellPrice.value > 0
                                ? controller.sellPrice.value.toString()
                                : '',
                        keyboardType: TextInputType.number,
                        validator: Validators.validatePrice,
                        onChanged:
                            (val) =>
                                controller.sellPrice.value =
                                    double.tryParse(val) ?? 0.0,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                // Supplier field
                TextFormField(
                  decoration: const InputDecoration(
                    labelText: 'Supplier (Optional)',
                    hintText: 'Enter supplier name',
                    prefixIcon: Icon(Icons.business),
                  ),
                  initialValue: controller.supplier.value,
                  onChanged: (val) => controller.supplier.value = val,
                ),
                const SizedBox(height: 16),

                // Image selector
                const Text('Select an image (Optional):'),
                const SizedBox(height: 8),
                SizedBox(
                  height: 120,
                  child: Obx(
                    () => ImageSelector(
                      selected: controller.selectedImage.value,
                      onSelected: (key) => controller.selectedImage.value = key,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(onPressed: () => Get.back(), child: const Text("Cancel")),
        Obx(
          () => ElevatedButton(
            onPressed:
                controller.isLoading.value
                    ? null
                    : () async {
                      if (_formKey.currentState!.validate()) {
                        bool success;

                        if (isEditing && itemId != null) {
                          // Get item by ID and update it
                          final item = await controller.getItemById(itemId!);
                          if (item != null) {
                            success = await controller.updateItem(item);
                          } else {
                            SnackbarUtils.showError('Error', 'Item not found');
                            return;
                          }
                        } else {
                          success = await controller.addItem();
                        }

                        if (success) {
                          Get.back();
                        }
                      }
                    },
            child:
                controller.isLoading.value
                    ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                    : Text(isEditing ? "Update" : "Add"),
          ),
        ),
      ],
    );
  }
}
