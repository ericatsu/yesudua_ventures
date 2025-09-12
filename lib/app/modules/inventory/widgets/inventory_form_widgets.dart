import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yesudua_ventures/app/modules/inventory/inventory_controller.dart';

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

// Product Variant Selector Widget
class ProductVariantSelectorWidget extends StatelessWidget {
  final InventoryController controller;
  final Function(String) onVariantSelected;

  const ProductVariantSelectorWidget({
    super.key,
    required this.controller,
    required this.onVariantSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final variants = controller.getAvailableVariants();
      if (variants == null) return const SizedBox.shrink();

      return Column(
        children: [
          DropdownButtonFormField<String>(
            decoration: const InputDecoration(
              labelText: 'Product Variant',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.inventory_2),
            ),
            value:
                controller.selectedProductVariant.value.isEmpty
                    ? null
                    : controller.selectedProductVariant.value,
            items: [
              ...variants.keys.map((variant) {
                return DropdownMenuItem<String>(
                  value: variant,
                  child: Row(
                    children: [
                      Image.asset(
                        variants[variant]!,
                        width: 24,
                        height: 24,
                        errorBuilder:
                            (context, error, stackTrace) =>
                                const Icon(Icons.image_not_supported, size: 24),
                      ),
                      const SizedBox(width: 8),
                      Text(variant.replaceAll('_', ' ').toUpperCase()),
                    ],
                  ),
                );
              }).toList(),
              const DropdownMenuItem<String>(
                value: 'custom',
                child: Row(
                  children: [
                    Icon(Icons.edit, size: 24),
                    SizedBox(width: 8),
                    Text('Custom Product Name'),
                  ],
                ),
              ),
            ],
            onChanged: (value) {
              final result = controller.onProductVariantChanged(value);
              onVariantSelected(result);
            },
          ),
          const SizedBox(height: 16.0),
          if (controller.selectedProductVariant.value == 'custom')
            CustomProductNameWidget(
              controller: controller,
              onNameChanged: onVariantSelected,
            ),
        ],
      );
    });
  }
}

// Custom Product Name Widget
class CustomProductNameWidget extends StatelessWidget {
  final InventoryController controller;
  final Function(String) onNameChanged;

  const CustomProductNameWidget({
    super.key,
    required this.controller,
    required this.onNameChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: const InputDecoration(
        labelText: 'Custom Product Name *',
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.edit),
      ),
      onChanged: (value) {
        controller.customProductName.value = value;
        onNameChanged(value);
      },
      validator: (value) {
        if (controller.selectedProductVariant.value == 'custom' &&
            (value == null || value.isEmpty)) {
          return 'Please enter custom product name';
        }
        return null;
      },
    );
  }
}

// Product Preview Widget
class ProductPreviewWidget extends StatelessWidget {
  final InventoryController controller;
  final String productName;

  const ProductPreviewWidget({
    super.key,
    required this.controller,
    required this.productName,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final imagePath = controller.getProductImagePath();
      if (imagePath == null) return const SizedBox.shrink();

      return Container(
        margin: const EdgeInsets.only(bottom: 16.0),
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Column(
          children: [
            const Text(
              'Product Preview',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8.0),
            Image.asset(
              imagePath,
              width: 80,
              height: 80,
              errorBuilder:
                  (context, error, stackTrace) =>
                      const Icon(Icons.image_not_supported, size: 80),
            ),
            const SizedBox(height: 8.0),
            Text(
              productName.isNotEmpty ? productName : 'Product Name',
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ],
        ),
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
