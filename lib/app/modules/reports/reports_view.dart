import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'reports_controller.dart';

class ReportsView extends GetView<ReportsController> {
  const ReportsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Reports")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Obx(
          () => ListView(
            children: [
              const Text(
                "📊 Sales Summary",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              ListTile(
                title: const Text("Total Sales Today"),
                trailing: Text(
                  "₵${controller.dailySalesTotal.value.toStringAsFixed(2)}",
                ),
              ),
              ListTile(
                title: const Text("Total Sales This Month"),
                trailing: Text(
                  "₵${controller.monthlySalesTotal.value.toStringAsFixed(2)}",
                ),
              ),
              const Divider(),
              const Text(
                "💳 Debtors Summary",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              ListTile(
                title: const Text("Total Outstanding Debt"),
                trailing: Text(
                  "₵${controller.totalDebt.value.toStringAsFixed(2)}",
                ),
              ),
              ...controller.topDebtors.map(
                (d) => ListTile(
                  title: Text(d.customerName),
                  subtitle: Text(
                    "Owes ₵${(d.totalAmount - d.amountPaid).toStringAsFixed(2)}",
                  ),
                ),
              ),
              const Divider(),
              const Text(
                "📦 Low Stock Alerts",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              ...controller.lowStockItems.map(
                (i) => ListTile(
                  title: Text(i.name),
                  subtitle: Text("Qty Left: ${i.quantity}"),
                  trailing: const Icon(Icons.warning, color: Colors.red),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}