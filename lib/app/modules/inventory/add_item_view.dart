import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'inventory_controller.dart';
import 'widgets/image_selector.dart';

class AddItemView extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();

  AddItemView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<InventoryController>();

    return AlertDialog(
      title: const Text("Add New Item"),
      content: Form(
        key: _formKey,
        child: SizedBox(
          width: 300,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'Name'),
                onChanged: (val) => controller.name.value = val,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Category'),
                onChanged: (val) => controller.category.value = val,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Quantity'),
                keyboardType: TextInputType.number,
                onChanged:
                    (val) => controller.quantity.value = int.tryParse(val) ?? 0,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Bought Price'),
                keyboardType: TextInputType.number,
                onChanged:
                    (val) =>
                        controller.boughtPrice.value =
                            double.tryParse(val) ?? 0.0,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Sell Price'),
                keyboardType: TextInputType.number,
                onChanged:
                    (val) =>
                        controller.sellPrice.value =
                            double.tryParse(val) ?? 0.0,
              ),
              const SizedBox(height: 10),
              ImageSelector(
                selected: controller.selectedImage.value,
                onSelected: (key) => controller.selectedImage.value = key,
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(onPressed: () => Get.back(), child: const Text("Cancel")),
        ElevatedButton(
          onPressed: () {
            controller.addItem();
            Get.back();
          },
          child: const Text("Add"),
        ),
      ],
    );
  }
}