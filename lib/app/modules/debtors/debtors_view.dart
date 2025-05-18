import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:yesudua_ventures/app/modules/debtors/debtors_controller.dart';
import 'package:yesudua_ventures/app/routes/app_routes.dart';

class DebtorsView extends GetView<DebtorsController> {
  const DebtorsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Debtors List'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => controller.fetchAllDebtors(),
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.debtors.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.check_circle_outline, size: 64, color: Colors.green),
                const SizedBox(height: 16),
                const Text(
                  'No outstanding debtors',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          );
        }

        return ListView.separated(
          itemCount: controller.debtors.length,
          separatorBuilder: (context, index) => const Divider(),
          itemBuilder: (context, index) {
            final debtor = controller.debtors[index];
            final dateFormat = DateFormat('dd/MM/yyyy');

            return ListTile(
              title: Text(
                debtor.name,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Contact: ${debtor.contact}'),
                  Text(
                    'Date: ${debtor.createdAt != null ? dateFormat.format(debtor.createdAt!) : 'N/A'}',
                  ),
                ],
              ),
              trailing: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'Debt: GHS ${debtor.outstandingBalance.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),
                  ),
                  Text(
                    'Paid: GHS ${debtor.paidAmount.toStringAsFixed(2)}',
                    style: TextStyle(color: Colors.green),
                  ),
                ],
              ),
              onTap: () {
                Get.toNamed(AppRoutes.debtorDetail, arguments: debtor.id);
              },
            );
          },
        );
      }),
    );
  }
}
