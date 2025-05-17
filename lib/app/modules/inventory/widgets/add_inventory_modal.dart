import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yesudua_ventures/app/data/models/inventory_model.dart';
import 'package:yesudua_ventures/app/modules/inventory/inventory_controller.dart';

class AddInventoryModal extends StatefulWidget {
  final InventoryController controller;
  final InventoryItemModel? editItem; // Optional for edit mode
  final VoidCallback onItemAdded; // Callback when item is added or updated

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
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.controller.categories.isEmpty) {
        widget.controller.ensurePredefinedCategories();
      }
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _quantityController.dispose();
    _boughtPriceController.dispose();
    _sellPriceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
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
                  // Item Name Field
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: 'Item Name *',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.inventory),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter item name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16.0),

                  // Category Dropdown
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
                      onChanged: (value) {
                        setState(() {
                          _selectedCategoryId = value;
                        });
                      },
                      validator: (value) {
                        if (value == null) {
                          return 'Please select a category';
                        }
                        return null;
                      },
                    );
                  }),
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
        // The following fields will be automatically populated by the repository
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
