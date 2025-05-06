import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'sales_controller.dart';
import 'receipt_preview_view.dart';

class SalesView extends GetView<SalesController> {
  const SalesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("New Sale")),
      body: Row(
        children: [
          // Left: Inventory List
          Expanded(
            flex: 2,
            child: Obx(
              () => ListView.builder(
                itemCount: controller.inventoryItems.length,
                itemBuilder: (context, index) {
                  final item = controller.inventoryItems[index];
                  return ListTile(
                    title: Text(item.name),
                    subtitle: Text(
                      "Stock: ${item.quantity} | ₵${item.sellPrice}",
                    ),
                    trailing: ElevatedButton(
                      onPressed: () => controller.addToCart(item),
                      child: const Text("Add to Cart"),
                    ),
                  );
                },
              ),
            ),
          ),
          const VerticalDivider(),
          // Right: Cart + Summary
          Expanded(
            flex: 2,
            child: Obx(
              () => Column(
                children: [
                  const Text(
                    "Cart",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Expanded(
                    child: ListView(
                      children:
                          controller.cart.map((cartItem) {
                            return ListTile(
                              title: Text(cartItem.item.name),
                              subtitle: Text(
                                "Qty: ${cartItem.quantity} | ₵${cartItem.sellPrice}",
                              ),
                              trailing: IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed:
                                    () => controller.removeFromCart(cartItem),
                              ),
                            );
                          }).toList(),
                    ),
                  ),
                  const Divider(),
                  Text(
                    "Total: ₵${controller.totalAmount.toStringAsFixed(2)}",
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton.icon(
                    onPressed:
                        controller.cart.isEmpty
                            ? null
                            : () => Get.to(() => const ReceiptPreviewView()),
                    icon: const Icon(Icons.receipt),
                    label: const Text("Preview Receipt"),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}