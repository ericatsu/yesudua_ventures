import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yesudua_ventures/app/modules/suppliers/suppliers_controller.dart';
import 'package:yesudua_ventures/app/modules/suppliers/widgets/supplier_widgets.dart';
import 'package:yesudua_ventures/app/core/utils/dialog_utils.dart';
import 'package:yesudua_ventures/app/core/utils/app_utils.dart';

class SuppliersView extends GetView<SuppliersController> {
  const SuppliersView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Suppliers'),
        actions: [
          IconButton(
            onPressed: () => _showAddSupplierDialog(controller),
            icon: const Icon(Icons.add),
            tooltip: 'Add Supplier',
          ),
        ],
      ),
      body: Column(
        children: [
          SearchBarWidget(
            hintText: 'Search suppliers...',
            onChanged: (value) => controller.searchQuery.value = value,
          ),
          Expanded(child: _buildSuppliersList(controller)),
        ],
      ),
    );
  }

  Widget _buildSuppliersList(SuppliersController controller) {
    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      if (controller.suppliers.isEmpty) {
        return EmptyStateWidget(
          message: 'No suppliers found.\nAdd a new supplier to get started.',
          icon: Icons.business,
          actionText: 'Add Supplier',
          onAction: () => _showAddSupplierDialog(controller),
        );
      }

      return ListView.separated(
        padding: const EdgeInsets.all(16.0),
        itemCount: controller.suppliers.length,
        separatorBuilder: (_, __) => const Divider(),
        itemBuilder: (context, index) {
          final supplier = controller.suppliers[index];
          return SupplierListItem(
            supplier: supplier,
            onEdit: () => _showEditSupplierDialog(controller, supplier),
            onDelete: () => _showDeleteConfirmation(controller, supplier),
            onViewHistory: () => _showSupplierHistory(controller, supplier),
          );
        },
      );
    });
  }

  void _showAddSupplierDialog(SuppliersController controller) {
    DialogUtils.showSupplierFormDialog(
      onSave: (supplier) => controller.addSupplier(supplier),
    );
  }

  void _showEditSupplierDialog(SuppliersController controller, supplier) {
    controller.selectSupplier(supplier);
    DialogUtils.showSupplierFormDialog(
      supplier: supplier,
      onSave: (updatedSupplier) => controller.updateSupplier(updatedSupplier),
    );
  }

  void _showDeleteConfirmation(SuppliersController controller, supplier) {
    DialogUtils.showConfirmationDialog(
      title: 'Delete Supplier',
      content:
          'Are you sure you want to delete ${supplier.name}? This action cannot be undone.',
      onConfirm: () async {
        if (supplier.id != null) {
          final success = await controller.deleteSupplier(supplier.id!);
          if (success) {
            AppUtils.showSuccess('Success', 'Supplier deleted successfully');
          }
        }
      },
      confirmText: 'Delete',
      confirmColor: Colors.red,
    );
  }

  void _showSupplierHistory(SuppliersController controller, supplier) {
    if (supplier.id == null) return;

    DialogUtils.showSupplierHistoryDialog(
      supplierName: supplier.name,
      historyFuture: controller.getSupplierHistory(supplier.id!),
    );
  }
}
