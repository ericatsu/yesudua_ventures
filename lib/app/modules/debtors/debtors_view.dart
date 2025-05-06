import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'debtors_controller.dart';
import 'record_payment_view.dart';

class DebtorsView extends GetView<DebtorsController> {
  const DebtorsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Debtors")),
      body: Obx(
        () => ListView.builder(
          itemCount: controller.debtors.length,
          itemBuilder: (context, index) {
            final d = controller.debtors[index];
            final balance = d.totalAmount - d.amountPaid;

            return Card(
              child: ListTile(
                title: Text(d.customerName),
                subtitle: Text("Owes: ₵$balance | Paid: ₵${d.amountPaid}"),
                trailing: ElevatedButton(
                  onPressed:
                      balance <= 0
                          ? null
                          : () => Get.dialog(RecordPaymentView(debtorId: d.id)),
                  child: const Text("Pay"),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}