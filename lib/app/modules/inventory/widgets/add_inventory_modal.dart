import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yesudua_ventures/app/data/models/inventory_model.dart';
import 'package:yesudua_ventures/app/modules/inventory/inventory_controller.dart';
import 'package:yesudua_ventures/app/core/utils/constants.dart';

class AddInventoryModal extends StatefulWidget {
  final InventoryController controller;
  final InventoryItemModel? editItem;
  final VoidCallback onItemAdded;

  const AddInventoryModal({
    super.key,
    required this.controller,
    this.editItem,
    required this.onItemAdded,
  });

  @override
  State<AddInventoryModal> createState() => _AddInventoryModalState();
}

class _AddInventoryModalState extends State<AddInventoryModal> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _quantityController = TextEditingController();
  final _boughtPriceController = TextEditingController();
  final _sellPriceController = TextEditingController();

  int? _selectedCategoryId;
  int? _selectedSupplierId;
  String? _selectedProductVariant;
  String? _selectedCategoryName;
  String? _customProductName;

  bool get isEditMode => widget.editItem != null;

  @override
  void initState() {
    super.initState();
    // Initialize fields if in edit mode
    if (isEditMode) {
      _nameController.text = widget.editItem!.name;
      _quantityController.text = widget.editItem!.quantity.toString();
      _boughtPriceController.text = widget.editItem!.boughtPrice.toString();
      _sellPriceController.text = widget.editItem!.sellPrice.toString();
      _selectedCategoryId = widget.editItem!.categoryId;
      _selectedSupplierId = widget.editItem!.supplierId;
      _selectedCategoryName = widget.editItem!.categoryName?.toLowerCase();

      // Try to find matching product variant from existing name
      _findMatchingVariant();
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.controller.categories.isEmpty) {
        widget.controller.ensurecategoryItems();
      }
    });
  }

  void _findMatchingVariant() {
    if (_selectedCategoryName != null &&
        AppConstants.categoryItems.containsKey(_selectedCategoryName)) {
      final variants = AppConstants.categoryItems[_selectedCategoryName!]!;
      for (String variant in variants.keys) {
        if (_nameController.text.toLowerCase().contains(variant)) {
          _selectedProductVariant = variant;
          break;
        }
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _quantityController.dispose();
    _boughtPriceController.dispose();
    _sellPriceController.dispose();
    super.dispose();
  }

  void _onCategoryChanged(int? categoryId) {
    setState(() {
      _selectedCategoryId = categoryId;
      _selectedProductVariant = null;
      _customProductName = null;

      if (categoryId != null) {
        final category = widget.controller.findCategoryById(categoryId);
        _selectedCategoryName = category?.name.toLowerCase();

        // Auto-fill name if a product variant is available
        if (_selectedCategoryName != null &&
            AppConstants.categoryItems.containsKey(_selectedCategoryName!)) {
          _nameController.clear();
        }
      } else {
        _selectedCategoryName = null;
      }
    });
  }

  void _onProductVariantChanged(String? variant) {
    setState(() {
      _selectedProductVariant = variant;
      if (variant != null && variant != 'custom') {
        _nameController.text = variant.replaceAll('_', ' ').toUpperCase();
        _customProductName = null;
      } else if (variant == 'custom') {
        _nameController.clear();
      }
    });
  }

  Widget _buildProductVariantSelector() {
    if (_selectedCategoryName == null ||
        !AppConstants.categoryItems.containsKey(_selectedCategoryName!)) {
      return const SizedBox.shrink();
    }

    final variants = AppConstants.categoryItems[_selectedCategoryName!]!;

    return Column(
      children: [
        DropdownButtonFormField<String>(
          decoration: const InputDecoration(
            labelText: 'Product Variant',
            border: OutlineInputBorder(),
            prefixIcon: Icon(Icons.inventory_2),
          ),
          value: _selectedProductVariant,
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
          onChanged: _onProductVariantChanged,
        ),
        const SizedBox(height: 16.0),

        // Show custom name field if 'custom' is selected
        if (_selectedProductVariant == 'custom')
          TextFormField(
            decoration: const InputDecoration(
              labelText: 'Custom Product Name *',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.edit),
            ),
            onChanged: (value) {
              _customProductName = value;
              _nameController.text = value;
            },
            validator: (value) {
              if (_selectedProductVariant == 'custom' &&
                  (value == null || value.isEmpty)) {
                return 'Please enter custom product name';
              }
              return null;
            },
          ),
      ],
    );
  }

  Widget _buildProductPreview() {
    String? imagePath;

    if (_selectedCategoryName != null && _selectedProductVariant != null) {
      final variants = AppConstants.categoryItems[_selectedCategoryName!];
      if (variants != null && variants.containsKey(_selectedProductVariant!)) {
        imagePath = variants[_selectedProductVariant!];
      }
    }

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
            _nameController.text.isNotEmpty
                ? _nameController.text
                : 'Product Name',
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20.0),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.0),
          topRight: Radius.circular(20.0),
        ),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              isEditMode ? 'Edit Inventory Item' : 'Add New Inventory Item',
              style: const TextStyle(
                fontSize: 22.0,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 24.0),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  // Category Dropdown
                  Obx(() {
                    if (widget.controller.isLoadingCategories.value ||
                        widget.controller.categories.isEmpty) {
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
                      value: _selectedCategoryId,
                      items:
                          widget.controller.categories.map((category) {
                            return DropdownMenuItem<int>(
                              value: category.id,
                              child: Text(category.name),
                            );
                          }).toList(),
                      onChanged: _onCategoryChanged,
                      validator: (value) {
                        if (value == null) {
                          return 'Please select a category';
                        }
                        return null;
                      },
                    );
                  }),
                  const SizedBox(height: 16.0),

                  // Product Variant Selector
                  _buildProductVariantSelector(),

                  // Product Preview
                  _buildProductPreview(),

                  // Item Name Field (read-only if variant selected)
                  TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: 'Item Name *',
                      border: const OutlineInputBorder(),
                      prefixIcon: const Icon(Icons.inventory),
                      enabled:
                          _selectedProductVariant == null ||
                          _selectedProductVariant == 'custom',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter item name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16.0),

                  // Quantity Field
                  TextFormField(
                    controller: _quantityController,
                    decoration: const InputDecoration(
                      labelText: 'Quantity *',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.numbers),
                    ),
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter quantity';
                      }
                      if (double.tryParse(value) == null) {
                        return 'Please enter a valid number';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16.0),

                  // Bought Price Field
                  TextFormField(
                    controller: _boughtPriceController,
                    decoration: const InputDecoration(
                      labelText: 'Bought Price *',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.price_change),
                    ),
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter bought price';
                      }
                      if (double.tryParse(value) == null) {
                        return 'Please enter a valid number';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16.0),

                  // Sell Price Field
                  TextFormField(
                    controller: _sellPriceController,
                    decoration: const InputDecoration(
                      labelText: 'Sell Price *',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.price_check),
                    ),
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter sell price';
                      }
                      if (double.tryParse(value) == null) {
                        return 'Please enter a valid number';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16.0),

                  // Supplier Dropdown (Optional)
                  Obx(
                    () => DropdownButtonFormField<int?>(
                      decoration: const InputDecoration(
                        labelText: 'Supplier (Optional)',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.business),
                      ),
                      value: _selectedSupplierId,
                      items: [
                        const DropdownMenuItem<int?>(
                          value: null,
                          child: Text('-- No Supplier --'),
                        ),
                        ...widget.controller.suppliers.map((supplier) {
                          return DropdownMenuItem<int?>(
                            value: supplier.id,
                            child: Text(supplier.name),
                          );
                        }).toList(),
                      ],
                      onChanged: (value) {
                        setState(() {
                          _selectedSupplierId = value;
                        });
                      },
                    ),
                  ),
                  const SizedBox(height: 24.0),

                  // Submit and Cancel Buttons
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red[400],
                            padding: const EdgeInsets.symmetric(vertical: 16.0),
                          ),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
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
                          onPressed: _saveInventoryItem,
                          child: Text(isEditMode ? 'Update Item' : 'Save Item'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _saveInventoryItem() async {
    if (_formKey.currentState?.validate() ?? false) {
      // Create or update inventory item
      final itemData = InventoryItemModel(
        id: isEditMode ? widget.editItem!.id : null,
        name: _nameController.text.trim(),
        categoryId: _selectedCategoryId!,
        quantity: double.parse(_quantityController.text),
        boughtPrice: double.parse(_boughtPriceController.text),
        sellPrice: double.parse(_sellPriceController.text),
        supplierId: _selectedSupplierId,
        lastRestocked:
            isEditMode ? widget.editItem!.lastRestocked : DateTime.now(),
        categoryName:
            widget.controller.findCategoryById(_selectedCategoryId!)?.name,
        supplierName:
            widget.controller.findSupplierById(_selectedSupplierId)?.name,
      );

      // Show loading indicator
      Get.dialog(
        const Center(child: CircularProgressIndicator()),
        barrierDismissible: false,
      );

      // Save or update item
      final success =
          isEditMode
              ? await widget.controller.updateInventoryItem(itemData)
              : await widget.controller.addInventoryItem(itemData);

      // Close loading indicator
      Get.back();

      if (success) {
        // Call the callback
        widget.onItemAdded();

        // Close the modal
        Navigator.of(context).pop();

        // Show success message
        Get.snackbar(
          'Success',
          isEditMode ? 'Item updated successfully' : 'Item added successfully',
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 2),
        );
      }
    }
  }
}
