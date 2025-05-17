import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yesudua_ventures/app/data/models/inventory_model.dart';
import 'package:yesudua_ventures/app/modules/inventory/inventory_controller.dart';

class RestockInventoryModal extends StatefulWidget {
  final InventoryItemModel item;
  final InventoryController controller; // Added missing parameter
  final VoidCallback onRestockComplete; // Added missing parameter

  const RestockInventoryModal({
    super.key,
    required this.item,
    required this.controller,
    required this.onRestockComplete,
  });

  @override
  State<RestockInventoryModal> createState() => _RestockInventoryModalState();
}

class _RestockInventoryModalState extends State<RestockInventoryModal> {
  final _formKey = GlobalKey<FormState>();
  final _quantityController = TextEditingController();
  final _boughtPriceController = TextEditingController();

  int? _selectedSupplierId;

  @override
  void initState() {
    super.initState();
    _selectedSupplierId = widget.item.supplierId;
    _boughtPriceController.text = widget.item.boughtPrice.toString();
  }

  @override
  void dispose() {
    _quantityController.dispose();
    _boughtPriceController.dispose();
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
              'Restock ${widget.item.name}',
              style: const TextStyle(
                fontSize: 22.0,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8.0),
            Text(
              'Current Quantity: ${widget.item.quantity}',
              style: const TextStyle(fontSize: 16.0, color: Colors.grey),
            ),
            const SizedBox(height: 24.0),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  // Quantity Field
                  TextFormField(
                    controller: _quantityController,
                    decoration: const InputDecoration(
                      labelText: 'Quantity to Add *',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.add_circle_outline),
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
                      if (double.parse(value) <= 0) {
                        return 'Quantity must be greater than 0';
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
                      if (double.parse(value) <= 0) {
                        return 'Price must be greater than 0';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16.0),

                  // Supplier Dropdown
                  Obx(
                    () => DropdownButtonFormField<int>(
                      decoration: const InputDecoration(
                        labelText: 'Supplier *',
                        border: OutlineInputBorder(),
                        prefixIcon: Icon(Icons.business),
                      ),
                      value: _selectedSupplierId,
                      items:
                          widget.controller.suppliers.map((supplier) {
                            return DropdownMenuItem<int>(
                              value: supplier.id,
                              child: Text(supplier.name),
                            );
                          }).toList(),
                      onChanged: (value) {
                        setState(() {
                          _selectedSupplierId = value;
                        });
                      },
                      validator: (value) {
                        if (value == null) {
                          return 'Please select a supplier';
                        }
                        return null;
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
                            padding: const EdgeInsets.symmetric(vertical: 12.0),
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
                            padding: const EdgeInsets.symmetric(vertical: 12.0),
                          ),
                          onPressed: _restockItem,
                          child: const Text('Restock'),
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

  void _restockItem() async {
    if (_formKey.currentState?.validate() ?? false) {
      if (_selectedSupplierId == null) {
        Get.snackbar('Error', 'Please select a supplier');
        return;
      }

      // Show loading indicator
      Get.dialog(
        const Center(child: CircularProgressIndicator()),
        barrierDismissible: false,
      );

      // Restock the item
      final success = await widget.controller.restockInventoryItem(
        widget.item.id!,
        double.parse(_quantityController.text),
        double.parse(_boughtPriceController.text),
        _selectedSupplierId!,
      );

      // Close loading indicator
      Get.back();

      if (success) {
        widget.onRestockComplete(); // Call the callback
      }
    }
  }
}
