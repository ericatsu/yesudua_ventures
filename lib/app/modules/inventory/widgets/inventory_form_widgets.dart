import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yesudua_ventures/app/modules/inventory/inventory_controller.dart';

// Category Dropdown Widget
class CategoryDropdownWidget extends StatelessWidget {
  final InventoryController controller;
  final String? Function(int?)? validator;

  const CategoryDropdownWidget({
    super.key,
    required this.controller,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoadingCategories.value ||
          controller.categories.isEmpty) {
        return const Padding(
          padding: EdgeInsets.symmetric(vertical: 16.0),
          child: Center(child: CircularProgressIndicator()),
        );
      }

      return DropdownButtonFormField<int>(
        decoration: const InputDecoration(
          labelText: 'Category *',
          border: OutlineInputBorder(),
          prefixIcon: Icon(Icons.category),
        ),
        value:
            controller.selectedCategoryId.value == 0
                ? null
                : controller.selectedCategoryId.value,
        items:
            controller.categories.map((category) {
              return DropdownMenuItem<int>(
                value: category.id,
                child: Text(category.name),
              );
            }).toList(),
        onChanged: controller.onCategoryChanged,
        validator: validator,
      );
    });
  }
}

// Supplier Dropdown Widget
class SupplierDropdownWidget extends StatelessWidget {
  final InventoryController controller;

  const SupplierDropdownWidget({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => DropdownButtonFormField<int?>(
        decoration: const InputDecoration(
          labelText: 'Supplier (Optional)',
          border: OutlineInputBorder(),
          prefixIcon: Icon(Icons.business),
        ),
        value: controller.selectedSupplierId.value,
        items: [
          const DropdownMenuItem<int?>(
            value: null,
            child: Text('-- No Supplier --'),
          ),
          ...controller.suppliers.map((supplier) {
            return DropdownMenuItem<int?>(
              value: supplier.id,
              child: Text(supplier.name),
            );
          }).toList(),
        ],
        onChanged: (value) {
          controller.selectedSupplierId.value = value;
        },
      ),
    );
  }
}

// Form Action Buttons Widget
class FormActionButtonsWidget extends StatelessWidget {
  final VoidCallback onCancel;
  final VoidCallback onSave;
  final String saveButtonText;

  const FormActionButtonsWidget({
    super.key,
    required this.onCancel,
    required this.onSave,
    required this.saveButtonText,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red[400],
              padding: const EdgeInsets.symmetric(vertical: 16.0),
            ),
            onPressed: onCancel,
            child: const Text('Cancel'),
          ),
        ),
        const SizedBox(width: 16.0),
        Expanded(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              padding: const EdgeInsets.symmetric(vertical: 16.0),
            ),
            onPressed: onSave,
            child: Text(saveButtonText),
          ),
        ),
      ],
    );
  }
}

// Standard Form Field Widget
class StandardFormFieldWidget extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final IconData prefixIcon;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final bool enabled;

  const StandardFormFieldWidget({
    super.key,
    required this.controller,
    required this.labelText,
    required this.prefixIcon,
    this.keyboardType,
    this.validator,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        border: const OutlineInputBorder(),
        prefixIcon: Icon(prefixIcon),
        enabled: enabled,
      ),
      keyboardType: keyboardType,
      validator: validator,
    );
  }
}
