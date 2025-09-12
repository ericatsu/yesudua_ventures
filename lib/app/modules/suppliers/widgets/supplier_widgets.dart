import 'package:flutter/material.dart';
import 'package:yesudua_ventures/app/data/models/inventory_model.dart';
import 'package:yesudua_ventures/app/core/utils/app_utils.dart';

class SupplierListItem extends StatelessWidget {
  final SupplierModel supplier;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onViewHistory;

  const SupplierListItem({
    super.key,
    required this.supplier,
    required this.onEdit,
    required this.onDelete,
    required this.onViewHistory,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: ListTile(
        title: Text(
          supplier.name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.phone, size: 16),
                const SizedBox(width: 4),
                Text(supplier.contact),
              ],
            ),
            if (supplier.address != null) ...[
              const SizedBox(height: 4),
              Row(
                children: [
                  const Icon(Icons.location_on, size: 16),
                  const SizedBox(width: 4),
                  Expanded(child: Text(supplier.address!)),
                ],
              ),
            ],
          ],
        ),
        trailing: SupplierMenuButton(
          onEdit: onEdit,
          onHistory: onViewHistory,
          onDelete: onDelete,
        ),
      ),
    );
  }
}

class SupplierMenuButton extends StatelessWidget {
  final VoidCallback onEdit;
  final VoidCallback onHistory;
  final VoidCallback onDelete;

  const SupplierMenuButton({
    super.key,
    required this.onEdit,
    required this.onHistory,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      itemBuilder:
          (context) => [
            const PopupMenuItem(
              value: 'edit',
              child: Row(
                children: [Icon(Icons.edit), SizedBox(width: 8), Text('Edit')],
              ),
            ),
            const PopupMenuItem(
              value: 'history',
              child: Row(
                children: [
                  Icon(Icons.history),
                  SizedBox(width: 8),
                  Text('View History'),
                ],
              ),
            ),
            const PopupMenuItem(
              value: 'delete',
              child: Row(
                children: [
                  Icon(Icons.delete, color: Colors.red),
                  SizedBox(width: 8),
                  Text('Delete', style: TextStyle(color: Colors.red)),
                ],
              ),
            ),
          ],
      onSelected: (value) {
        switch (value) {
          case 'edit':
            onEdit();
            break;
          case 'history':
            onHistory();
            break;
          case 'delete':
            onDelete();
            break;
        }
      },
    );
  }
}

class SearchBarWidget extends StatelessWidget {
  final String hintText;
  final Function(String) onChanged;
  final IconData prefixIcon;

  const SearchBarWidget({
    super.key,
    required this.hintText,
    required this.onChanged,
    this.prefixIcon = Icons.search,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: TextField(
        onChanged: onChanged,
        decoration: InputDecoration(
          hintText: hintText,
          prefixIcon: Icon(prefixIcon),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          contentPadding: const EdgeInsets.symmetric(vertical: 8.0),
        ),
      ),
    );
  }
}

// Supply History List Widget
class SupplyHistoryList extends StatelessWidget {
  final List<SupplyHistoryModel> history;

  const SupplyHistoryList({super.key, required this.history});

  @override
  Widget build(BuildContext context) {
    if (history.isEmpty) {
      return const Text('No supply history found for this supplier');
    }

    return SizedBox(
      width: double.maxFinite,
      height: 300,
      child: ListView.builder(
        itemCount: history.length,
        itemBuilder: (context, index) {
          final supply = history[index];
          return ListTile(
            title: Text(supply.itemName ?? 'Unknown Item'),
            subtitle: Text(
              'Qty: ${supply.quantity}, Price: ${AppUtils.formatCurrency(supply.boughtPrice)}\n'
              'Date: ${AppUtils.formatDate(supply.supplyDate)}',
            ),
            isThreeLine: true,
          );
        },
      ),
    );
  }
}

class EmptyStateWidget extends StatelessWidget {
  final String message;
  final IconData icon;
  final String? actionText;
  final VoidCallback? onAction;

  const EmptyStateWidget({
    super.key,
    required this.message,
    this.icon = Icons.inbox,
    this.actionText,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 64, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            message,
            style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            textAlign: TextAlign.center,
          ),
          if (actionText != null && onAction != null) ...[
            const SizedBox(height: 16),
            ElevatedButton(onPressed: onAction, child: Text(actionText!)),
          ],
        ],
      ),
    );
  }
}
