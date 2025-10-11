import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:yesudua_ventures/app/modules/debtors/debtors_controller.dart';

class DebtorDetailView extends GetView<DebtorsController> {
  const DebtorDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    // Get debtor ID from arguments and fetch data
    final debtorId = Get.arguments as int?;

    if (debtorId != null) {
      // Fetch debtor data when the page loads
      WidgetsBinding.instance.addPostFrameCallback((_) {
        controller.getDebtorById(debtorId);
      });
    }

    return Scaffold(
      appBar: AppBar(
        title: Obx(() {
          final debtor = controller.selectedDebtor.value;
          return Text(
            'Debtor Details${debtor?.name != null ? ' of ${debtor!.name}' : ''}',
          );
        }),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.errorMessage.value.isNotEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.error_outline, size: 64, color: Colors.red.shade300),
                const SizedBox(height: 16),
                Text(
                  controller.errorMessage.value,
                  style: const TextStyle(fontSize: 16),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    if (debtorId != null) {
                      controller.getDebtorById(debtorId);
                    }
                  },
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }

        final debtor = controller.selectedDebtor.value;
        if (debtor == null) {
          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.person_off_outlined, size: 64, color: Colors.grey),
                SizedBox(height: 16),
                Text('Debtor not found', style: TextStyle(fontSize: 18)),
              ],
            ),
          );
        }

        final dateFormat = DateFormat('dd/MM/yyyy');

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Debtor Info Card
              Card(
                elevation: 2,
                margin: EdgeInsets.zero,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Column(
                          children: [
                            CircleAvatar(
                              radius: 30,
                              backgroundColor: Colors.blue.shade100,
                              child: Text(
                                debtor.name.isNotEmpty
                                    ? debtor.name[0].toUpperCase()
                                    : '?',
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue,
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              debtor.name,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              debtor.contact,
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey.shade700,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Divider(),
                      const SizedBox(height: 8),

                      Text(
                        'Total Debt: GHS ${debtor.totalDebt.toStringAsFixed(2)}',
                      ),

                      const SizedBox(height: 4),
                      // Display items information
                      if (controller.debtorItems.isNotEmpty) ...[
                        Text('Items Purchased: ${_getItemNames()}'),
                        const SizedBox(height: 4),
                        Text('Categories: ${_getCategoryNames()}'),
                        const SizedBox(height: 4),
                        Text(
                          'Total Items: ${controller.totalItemsQuantity.toStringAsFixed(1)}',
                        ),
                      ] else
                        const Text('Items: Loading...'),

                      const SizedBox(height: 4),
                      Text(
                        'Amount Paid: GHS ${debtor.paidAmount.toStringAsFixed(2)}',
                        style: const TextStyle(color: Colors.green),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Outstanding: GHS ${debtor.outstandingBalance.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Initial Date: ${debtor.createdAt != null ? dateFormat.format(debtor.createdAt!) : 'N/A'}',
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Last Updated: ${debtor.updatedAt != null ? dateFormat.format(debtor.updatedAt!) : 'N/A'}',
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // New Payment Section
              Card(
                elevation: 2,
                margin: EdgeInsets.zero,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Record New Payment',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: controller.paymentController,
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                    decimal: true,
                                  ),
                              decoration: const InputDecoration(
                                labelText: 'Payment Amount (GHS)',
                                border: OutlineInputBorder(),
                                prefixIcon: Icon(Icons.payments_outlined),
                                isDense: true,
                              ),
                              onChanged: (value) {
                                controller.newPaymentAmount.value =
                                    double.tryParse(value) ?? 0.0;
                              },
                            ),
                          ),
                          const SizedBox(width: 12),
                          ElevatedButton.icon(
                            onPressed:
                                debtor.outstandingBalance > 0
                                    ? () async {
                                      if (controller.newPaymentAmount.value <=
                                          0) {
                                        Get.snackbar(
                                          'Invalid Amount',
                                          'Please enter a valid payment amount',
                                          snackPosition: SnackPosition.BOTTOM,
                                          backgroundColor: Colors.red.shade100,
                                        );
                                        return;
                                      }

                                      if (controller.newPaymentAmount.value >
                                          debtor.outstandingBalance) {
                                        Get.snackbar(
                                          'Excess Payment',
                                          'Payment amount exceeds outstanding balance',
                                          snackPosition: SnackPosition.BOTTOM,
                                          backgroundColor:
                                              Colors.orange.shade100,
                                        );
                                        return;
                                      }

                                      final success = await controller
                                          .recordPayment(
                                            debtor.id!,
                                            controller.newPaymentAmount.value,
                                          );

                                      if (success) {
                                        Get.snackbar(
                                          'Success',
                                          'Payment recorded successfully',
                                          snackPosition: SnackPosition.BOTTOM,
                                          backgroundColor:
                                              Colors.green.shade100,
                                        );
                                      } else {
                                        Get.snackbar(
                                          'Error',
                                          controller
                                                  .errorMessage
                                                  .value
                                                  .isNotEmpty
                                              ? controller.errorMessage.value
                                              : 'Failed to record payment',
                                          snackPosition: SnackPosition.BOTTOM,
                                          backgroundColor: Colors.red.shade100,
                                        );
                                      }
                                    }
                                    : null,
                            icon: const Icon(Icons.check, size: 18),
                            label: const Text('Record'),
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                vertical: 12,
                                horizontal: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      LinearProgressIndicator(
                        value:
                            debtor.totalDebt > 0
                                ? debtor.paidAmount / debtor.totalDebt
                                : 0,
                        backgroundColor: Colors.grey.shade200,
                        valueColor: const AlwaysStoppedAnimation<Color>(
                          Colors.green,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        debtor.totalDebt > 0
                            ? '${(debtor.paidAmount / debtor.totalDebt * 100).toStringAsFixed(1)}% paid'
                            : '0.0% paid',
                        style: TextStyle(
                          color: Colors.grey.shade700,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Payment History
              const Text(
                'Payment History',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),

              if (debtor.paymentHistory?.isEmpty ?? true)
                Card(
                  elevation: 1,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Center(
                      child: Text(
                        'No payment records yet',
                        style: TextStyle(color: Colors.grey.shade700),
                      ),
                    ),
                  ),
                )
              else
                Card(
                  elevation: 1,
                  child: ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: debtor.paymentHistory!.length,
                    separatorBuilder:
                        (context, index) => const Divider(height: 1),
                    itemBuilder: (context, index) {
                      final payment = debtor.paymentHistory?[index];
                      if (payment == null) return const SizedBox.shrink();

                      final paymentDate = DateFormat(
                        'dd/MM/yyyy HH:mm',
                      ).format(payment.paymentDate);

                      return ListTile(
                        leading: const Icon(
                          Icons.receipt_long,
                          color: Colors.green,
                          size: 20,
                        ),
                        title: Text(
                          'GHS ${payment.amountPaid.toStringAsFixed(2)}',
                        ),
                        subtitle: Text('Date: $paymentDate'),
                        dense: true,
                      );
                    },
                  ),
                ),
            ],
          ),
        );
      }),
    );
  }

  String _getItemNames() {
    if (controller.debtorItems.isEmpty) return 'None';
    return controller.debtorItems
        .map((item) => item.itemName ?? 'Unknown')
        .toSet()
        .join(', ');
  }

  String _getCategoryNames() {
    if (controller.debtorItems.isEmpty) return 'None';
    return controller.debtorItems
        .where((item) => item.categoryName != null)
        .map((item) => item.categoryName!)
        .toSet()
        .join(', ');
  }
}
