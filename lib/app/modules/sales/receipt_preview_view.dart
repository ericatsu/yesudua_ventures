import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'sales_controller.dart';

class ReceiptPreviewView extends GetView<SalesController> {
  const ReceiptPreviewView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Receipt Preview")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text(
              "Edit Bought Prices (Optional)",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: Obx(
                () => ListView(
                  children:
                      controller.cart.map((item) {
                        return ListTile(
                          title: Text(item.item.name),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Qty: ${item.quantity} | Sell Price: ₵${item.sellPrice}",
                              ),
                              Text("Bought Price: ₵${item.item.boughtPrice}"),
                            ],
                          ),
                        );
                      }).toList(),
                ),
              ),
            ),
            const SizedBox(height: 10),
            const Divider(),
            Text(
              "Total: ₵${controller.totalAmount.toStringAsFixed(2)}",
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    controller.submitSale(isPaid: true);
                    Get.back();
                  },
                  child: const Text("Mark as Paid"),
                ),
                OutlinedButton(
                  onPressed: () {
                    controller.submitSale(isPaid: false);
                    Get.back();
                  },
                  child: const Text("Mark as Unpaid (Debtor)"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}