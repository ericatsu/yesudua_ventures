import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dashboard_controller.dart';
import 'widgets/summary_cards.dart';
import 'widgets/sales_chart.dart';

class DashboardView extends GetView<DashboardController> {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dashboard')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Obx(
              () => SummaryCard(
                title: "Total Sales Today",
                value:
                    "₵${controller.totalSalesToday.value.toStringAsFixed(2)}",
                color: Colors.green,
              ),
            ),
            Obx(
              () => SummaryCard(
                title: "Total Debtors",
                value: controller.totalDebtors.value.toString(),
                color: Colors.red,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              "Top Products",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Obx(
              () => Column(
                children:
                    controller.topProducts
                        .map(
                          (product) => ListTile(
                            leading: const Icon(Icons.star),
                            title: Text(product),
                          ),
                        )
                        .toList(),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              "Sales Chart",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SalesChart(),
          ],
        ),
      ),
    );
  }
}
