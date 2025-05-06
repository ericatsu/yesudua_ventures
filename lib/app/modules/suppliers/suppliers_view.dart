import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'suppliers_controller.dart';

class SuppliersView extends GetView<SuppliersController> {
  final _formKey = GlobalKey<FormState>();

 SuppliersView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Suppliers")),
      body: Row(
        children: [
          // Left: List
          Expanded(
            flex: 2,
            child: Obx(
              () => ListView.builder(
                itemCount: controller.suppliers.length,
                itemBuilder: (context, index) {
                  final s = controller.suppliers[index];
                  return ListTile(
                    title: Text(s.name),
                    subtitle: Text(
                      "Contact: ${s.contact ?? '-'}\nCompany: ${s.company ?? '-'}",
                    ),
                  );
                },
              ),
            ),
          ),
          const VerticalDivider(),
          // Right: Form
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    const Text(
                      "Add Supplier",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextFormField(
                      decoration: const InputDecoration(labelText: 'Name'),
                      onChanged: (val) => controller.name.value = val,
                    ),
                    TextFormField(
                      decoration: const InputDecoration(labelText: 'Contact'),
                      onChanged: (val) => controller.contact.value = val,
                    ),
                    TextFormField(
                      decoration: const InputDecoration(labelText: 'Company'),
                      onChanged: (val) => controller.company.value = val,
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton.icon(
                      onPressed: controller.addSupplier,
                      icon: const Icon(Icons.person_add),
                      label: const Text("Save"),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}