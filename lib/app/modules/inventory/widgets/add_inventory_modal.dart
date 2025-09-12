import 'package:flutter/material.dart';
import 'package:yesudua_ventures/app/core/utils/app_utils.dart';
import 'package:yesudua_ventures/app/core/utils/constants.dart';
import 'package:yesudua_ventures/app/data/models/inventory_model.dart';
import 'package:yesudua_ventures/app/modules/inventory/inventory_controller.dart';
import 'package:yesudua_ventures/app/modules/inventory/widgets/inventory_form_widgets.dart';

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

  bool get isEditMode => widget.editItem != null;

  @override
  void initState() {
    super.initState();
    _initializeForm();
    _ensureCategoriesLoaded();
  }

  void _initializeForm() {
    if (isEditMode) {
      _populateEditFields();
      widget.controller.initializeFormForEdit(widget.editItem!);
    } else {
      widget.controller.resetFormState();
    }
  }

  void _populateEditFields() {
    _nameController.text = widget.editItem!.name;
    _quantityController.text = widget.editItem!.quantity.toString();
    _boughtPriceController.text = widget.editItem!.boughtPrice.toString();
    _sellPriceController.text = widget.editItem!.sellPrice.toString();
  }

  void _ensureCategoriesLoaded() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.controller.categories.isEmpty) {
        widget.controller.ensurecategoryItems();
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

  void _onProductVariantChanged(String productName) {
    _nameController.text = productName;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20.0),
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
            _buildHeader(),
            SizedBox(height: 24.0),
            _buildForm(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Text(
      isEditMode ? 'Edit Inventory Item' : 'Add New Inventory Item',
      style: const TextStyle(fontSize: 22.0, fontWeight: FontWeight.w600),
    );
  }

  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          // Category Dropdown
          CategoryDropdownWidget(
            controller: widget.controller,
            validator: AppUtils.categoryValidator,
          ),
          SizedBox(height: 24.0),

          // Product Variant Selector
          ProductVariantSelectorWidget(
            controller: widget.controller,
            onVariantSelected: _onProductVariantChanged,
          ),

          // Product Preview
          ProductPreviewWidget(
            controller: widget.controller,
            productName: _nameController.text,
          ),

          // Item Name Field
          StandardFormFieldWidget(
            controller: _nameController,
            labelText: 'Item Name *',
            prefixIcon: Icons.inventory,
            enabled: _isNameFieldEnabled(),
            validator:
                (value) =>
                    AppUtils.requiredValidator(value, 'item name'),
          ),
          SizedBox(height: 16.0),

          // Quantity Field
          StandardFormFieldWidget(
            controller: _quantityController,
            labelText: 'Quantity *',
            prefixIcon: Icons.numbers,
            keyboardType: AppConstants.numberInputType,
            validator:
                (value) =>
                    AppUtils.numberValidator(value, 'quantity'),
          ),
          SizedBox(height: 16.0),

          // Bought Price Field
          StandardFormFieldWidget(
            controller: _boughtPriceController,
            labelText: 'Bought Price *',
            prefixIcon: Icons.price_change,
            keyboardType: AppConstants.numberInputType,
            validator:
                (value) =>
                    AppUtils.numberValidator(value, 'bought price'),
          ),
          SizedBox(height: 16.0),

          // Sell Price Field
          StandardFormFieldWidget(
            controller: _sellPriceController,
            labelText: 'Sell Price *',
            prefixIcon: Icons.price_check,
            keyboardType: AppConstants.numberInputType,
            validator:
                (value) =>
                    AppUtils.numberValidator(value, 'sell price'),
          ),
          SizedBox(height: 16.0),

          // Supplier Dropdown
          SupplierDropdownWidget(controller: widget.controller),
          SizedBox(height: AppConstants.sectionSpacing),

          // Action Buttons
          FormActionButtonsWidget(
            onCancel: () => Navigator.of(context).pop(),
            onSave: _saveInventoryItem,
            saveButtonText: isEditMode ? 'Update Item' : 'Save Item',
          ),
        ],
      ),
    );
  }

  bool _isNameFieldEnabled() {
    return widget.controller.selectedProductVariant.value.isEmpty ||
        widget.controller.selectedProductVariant.value == 'custom';
  }

  void _saveInventoryItem() async {
    if (_formKey.currentState?.validate() ?? false) {
      final success = await widget.controller.saveInventoryItem(
        name: _nameController.text,
        quantity: double.parse(_quantityController.text),
        boughtPrice: double.parse(_boughtPriceController.text),
        sellPrice: double.parse(_sellPriceController.text),
        editItem: widget.editItem,
      );

      if (success) {
        widget.onItemAdded();
        Navigator.of(context).pop();
      }
    }
  }
}
