import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'debtors_controller.dart';

class RecordPaymentView extends StatelessWidget {
  final int debtorId;
  final TextEditingController amountController = TextEditingController();

  RecordPaymentView({super.key, required this.debtorId});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<DebtorsController>();

    return AlertDialog(
      title: const Text("Record Payment"),
      content: TextField(
        controller: amountController,
        keyboardType: TextInputType.number,
        decoration: const InputDecoration(labelText: "Enter amount paid"),
      ),
      actions: [
        TextButton(onPressed: () => Get.back(), child: const Text("Cancel")),
        ElevatedButton(
          onPressed: () {
            final amount = double.tryParse(amountController.text) ?? 0;
            controller.recordPayment(debtorId, amount);
            Get.back();
          },
          child: const Text("Submit"),
        ),
      ],
    );
  }
}