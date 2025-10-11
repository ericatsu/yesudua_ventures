import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yesudua_ventures/app/core/utils/constants.dart';
import 'package:yesudua_ventures/app/core/utils/image_helper.dart';
import 'package:yesudua_ventures/app/data/models/inventory_model.dart';
import 'package:yesudua_ventures/app/modules/inventory/inventory_controller.dart';

class AddInventoryModal extends StatefulWidget {
  final InventoryController controller;
  final InventoryItemModel? editItem;
  final VoidCallback? onItemAdded;

  const AddInventoryModal({
    super.key,
    required this.controller,
    this.editItem,
    this.onItemAdded,
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

  bool _isSaving = false;
  bool _isPickingImage = false;

  @override
  void initState() {
    super.initState();

    if (widget.editItem != null) {
      // Initialize form for editing
      _nameController.text = widget.editItem!.name;
      _quantityController.text = widget.editItem!.quantity.toString();
      _boughtPriceController.text = widget.editItem!.boughtPrice.toString();
      _sellPriceController.text = widget.editItem!.sellPrice.toString();
      widget.controller.initializeFormForEdit(widget.editItem!);
    } else {
      widget.controller.resetFormState();
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

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: DraggableScrollableSheet(
        initialChildSize: 0.9,
        maxChildSize: 0.95,
        minChildSize: 0.5,
        expand: false,
        builder: (context, scrollController) {
          return Column(
            children: [
              // Header
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(20),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.editItem != null ? 'Edit Item' : 'Add New Item',
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed:
                          _isSaving ? null : () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),

              // Form content
              Expanded(
                child: SingleChildScrollView(
                  controller: scrollController,
                  padding: const EdgeInsets.all(AppConstants.defaultPadding),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Image Section
                        _buildImageSection(),
                        const SizedBox(height: 24),

                        // Category Dropdown
                        _buildCategoryDropdown(),
                        const SizedBox(height: 16),

                        // Product Name
                        _buildTextField(
                          controller: _nameController,
                          label: 'Product Name',
                          hint: 'Enter product name or variant',
                          enabled: !_isSaving,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter product name';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),

                        // Quantity
                        _buildTextField(
                          controller: _quantityController,
                          label: 'Quantity',
                          hint: 'Enter quantity',
                          keyboardType: AppConstants.numberInputType,
                          enabled: !_isSaving,
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
                        const SizedBox(height: 16),

                        // Bought Price
                        _buildTextField(
                          controller: _boughtPriceController,
                          label: 'Bought Price',
                          hint: 'Enter bought price',
                          keyboardType: AppConstants.numberInputType,
                          prefixText: '₵',
                          enabled: !_isSaving,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter bought price';
                            }
                            if (double.tryParse(value) == null) {
                              return 'Please enter a valid price';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),

                        // Sell Price
                        _buildTextField(
                          controller: _sellPriceController,
                          label: 'Sell Price',
                          hint: 'Enter sell price',
                          keyboardType: AppConstants.numberInputType,
                          prefixText: '₵',
                          enabled: !_isSaving,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter sell price';
                            }
                            if (double.tryParse(value) == null) {
                              return 'Please enter a valid price';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),

                        // Supplier Dropdown
                        _buildSupplierDropdown(),
                        const SizedBox(height: 32),

                        // Save Button
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _isSaving ? null : _saveItem,
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                  AppConstants.defaultBorderRadius,
                                ),
                              ),
                            ),
                            child:
                                _isSaving
                                    ? const SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: Colors.white,
                                      ),
                                    )
                                    : Text(
                                      widget.editItem != null
                                          ? 'Update Item'
                                          : 'Add Item',
                                      style: const TextStyle(fontSize: 16),
                                    ),
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildImageSection() {
    return Obx(() {
      final imagePath = widget.controller.getCurrentImagePath();
      final isCustomImage =
          widget.controller.selectedImagePath.value != null &&
          widget.controller.selectedImagePath.value!.isNotEmpty;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            height: 150,
            width: 150,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey[400]!),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child:
                  isCustomImage && File(imagePath).existsSync()
                      ? Image.file(
                        File(imagePath),
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.error, color: Colors.red[300]),
                                const SizedBox(height: 4),
                                const Text(
                                  'Image error',
                                  style: TextStyle(fontSize: 12),
                                ),
                              ],
                            ),
                          );
                        },
                      )
                      : Image.asset(imagePath, fit: BoxFit.contain),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton.icon(
                onPressed: _isSaving || _isPickingImage ? null : _pickImage,
                icon:
                    _isPickingImage
                        ? const SizedBox(
                          height: 16,
                          width: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                        : const Icon(Icons.add_photo_alternate, size: 20),
                label: Text(isCustomImage ? 'Change Image' : 'Add Image'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                ),
              ),
              if (isCustomImage) ...[
                const SizedBox(width: 8),
                ElevatedButton.icon(
                  onPressed: _isSaving ? null : _removeImage,
                  icon: const Icon(Icons.delete, size: 20),
                  label: const Text('Remove'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                  ),
                ),
              ],
            ],
          ),
          if (!isCustomImage)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                'Using default category image',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
        ],
      );
    });
  }

  Future<void> _pickImage() async {
    setState(() => _isPickingImage = true);

    try {
      final imagePath = await ImageHelper.showImageSourceDialog(context);
      if (imagePath != null && mounted) {
        widget.controller.setImagePath(imagePath);
      }
    } catch (e) {
      if (mounted) {
        Get.snackbar(
          'Error',
          'Failed to pick image: $e',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isPickingImage = false);
      }
    }
  }

  void _removeImage() {
    widget.controller.setImagePath(null);
  }

  Widget _buildCategoryDropdown() {
    return Obx(() {
      if (widget.controller.isLoadingCategories.value) {
        return const Center(child: CircularProgressIndicator());
      }

      return DropdownButtonFormField<int>(
        value:
            widget.controller.selectedCategoryId.value > 0
                ? widget.controller.selectedCategoryId.value
                : null,
        decoration: const InputDecoration(
          labelText: 'Category',
          border: OutlineInputBorder(),
        ),
        items:
            widget.controller.categories.map((category) {
              return DropdownMenuItem<int>(
                value: category.id!,
                child: Text(category.name),
              );
            }).toList(),
        onChanged:
            _isSaving
                ? null
                : (value) => widget.controller.onCategoryChanged(value),
        validator: (value) {
          if (value == null) {
            return 'Please select a category';
          }
          return null;
        },
      );
    });
  }

  Widget _buildSupplierDropdown() {
    return Obx(() {
      if (widget.controller.isLoadingSuppliers.value) {
        return const Center(child: CircularProgressIndicator());
      }

      return DropdownButtonFormField<int>(
        value: widget.controller.selectedSupplierId.value,
        decoration: const InputDecoration(
          labelText: 'Supplier (Optional)',
          border: OutlineInputBorder(),
        ),
        items: [
          const DropdownMenuItem<int>(value: null, child: Text('No Supplier')),
          ...widget.controller.suppliers.map((supplier) {
            return DropdownMenuItem<int>(
              value: supplier.id!,
              child: Text(supplier.name),
            );
          }).toList(),
        ],
        onChanged:
            _isSaving
                ? null
                : (value) => widget.controller.selectedSupplierId.value = value,
      );
    });
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    TextInputType? keyboardType,
    String? prefixText,
    String? Function(String?)? validator,
    bool enabled = true,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      enabled: enabled,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixText: prefixText,
        border: const OutlineInputBorder(),
      ),
      validator: validator,
    );
  }

  Future<void> _saveItem() async {
    // Validate form
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // Check if category is selected
    if (widget.controller.selectedCategoryId.value == 0) {
      Get.snackbar(
        'Error',
        'Please select a category',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    // Set loading state
    setState(() => _isSaving = true);

    try {
      // Save the item
      final success = await widget.controller.saveInventoryItem(
        name: _nameController.text,
        quantity: double.parse(_quantityController.text),
        boughtPrice: double.parse(_boughtPriceController.text),
        sellPrice: double.parse(_sellPriceController.text),
        editItem: widget.editItem,
      );

      if (!mounted) return;

      if (success) {
        // Show success message
        Get.snackbar(
          'Success',
          widget.editItem != null
              ? 'Item updated successfully'
              : 'Item added successfully',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
          duration: const Duration(seconds: 2),
        );

        // Close the modal after a brief delay to show the success message
        await Future.delayed(const Duration(milliseconds: 300));

        if (mounted) {
          Navigator.pop(context);

          // Call the callback if provided
          widget.onItemAdded?.call();
        }
      }
    } catch (e) {
      if (mounted) {
        Get.snackbar(
          'Error',
          'Failed to save item: $e',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }
}
