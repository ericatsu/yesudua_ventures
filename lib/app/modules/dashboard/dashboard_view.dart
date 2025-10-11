import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:yesudua_ventures/app/data/models/sales_model.dart';
import 'package:yesudua_ventures/app/modules/dashboard/dashboard_controller.dart';

class DashboardView extends GetView<DashboardController> {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(
      locale: 'en_GH',
      symbol: 'GHS ',
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Sales Dashboard'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Analytics Cards Row
              _buildAnalyticsCards(controller, currencyFormat),

              const SizedBox(height: 24),

              // Filters Section
              _buildFiltersSection(controller),

              const SizedBox(height: 24),

              // Sales Table
              _buildSalesTable(controller, currencyFormat),

              const SizedBox(height: 24),

              // Quick Stats Section
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Top Selling Items
                  Expanded(child: _buildTopSellingItemsCard(controller)),
                  const SizedBox(width: 16),
                  // Revenue by Item
                  Expanded(
                    child: _buildRevenueByItemCard(controller, currencyFormat),
                  ),
                ],
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildAnalyticsCards(
    DashboardController controller,
    NumberFormat currencyFormat,
  ) {
    return Obx(
      () => Row(
        children: [
          Expanded(
            child: _buildAnalyticsCard(
              'Today\'s Sales',
              controller.todaysSalesCount.value.toString(),
              currencyFormat.format(controller.todaysSalesAmount.value),
              Colors.green,
              Icons.today,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: _buildAnalyticsCard(
              'This Week',
              controller.weekSalesCount.value.toString(),
              currencyFormat.format(controller.weekSalesAmount.value),
              Colors.blue,
              Icons.calendar_view_week,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: _buildAnalyticsCard(
              'This Month',
              controller.monthSalesCount.value.toString(),
              currencyFormat.format(controller.monthSalesAmount.value),
              Colors.orange,
              Icons.calendar_month,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: _buildAnalyticsCard(
              'Unpaid Sales',
              controller.unpaidSalesCount.value.toString(),
              currencyFormat.format(controller.totalUnpaidAmount.value),
              Colors.red,
              Icons.payment,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnalyticsCard(
    String title,
    String count,
    String amount,
    Color color,
    IconData icon,
  ) {
    return Card(
      elevation: 4,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          gradient: LinearGradient(
            colors: [
              color.withValues(alpha: 0.1),
              color.withValues(alpha: 0.05),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: color, size: 24),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              count,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              amount,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFiltersSection(DashboardController controller) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Filter Sales',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _buildFilterChip(controller, 'All Time', 'all'),
                _buildFilterChip(controller, 'Today', 'today'),
                _buildFilterChip(controller, 'This Week', 'week'),
                _buildFilterChip(controller, 'This Month', 'month'),
                _buildFilterChip(controller, 'Unpaid', 'unpaid'),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Start Date',
                      border: OutlineInputBorder(),
                      suffixIcon: Icon(Icons.calendar_today),
                    ),
                    readOnly: true,
                    controller: TextEditingController(
                      text:
                          controller.selectedStartDate.value != null
                              ? DateFormat(
                                'dd/MM/yyyy',
                              ).format(controller.selectedStartDate.value!)
                              : '',
                    ),
                    onTap: () => _selectStartDate(controller),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'End Date',
                      border: OutlineInputBorder(),
                      suffixIcon: Icon(Icons.calendar_today),
                    ),
                    readOnly: true,
                    controller: TextEditingController(
                      text:
                          controller.selectedEndDate.value != null
                              ? DateFormat(
                                'dd/MM/yyyy',
                              ).format(controller.selectedEndDate.value!)
                              : '',
                    ),
                    onTap: () => _selectEndDate(controller),
                  ),
                ),
                const SizedBox(width: 16),
                ElevatedButton.icon(
                  onPressed: () => _applyDateFilter(controller),
                  icon: const Icon(Icons.filter_list),
                  label: const Text('Apply Filter'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip(
    DashboardController controller,
    String label,
    String filter,
  ) {
    return Obx(
      () => FilterChip(
        label: Text(label),
        selected: controller.currentFilter.value == filter,
        onSelected: (selected) {
          if (selected) {
            controller.changeFilter(filter);
          }
        },
        selectedColor: Colors.blue.withValues(alpha: 0.2),
      ),
    );
  }

  Widget _buildSalesTable(
    DashboardController controller,
    NumberFormat currencyFormat,
  ) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Sales Records (${controller.currentPeriodCount})',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Total: ${currencyFormat.format(controller.currentPeriodAmount)}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey[300]!),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Obx(() {
                final sales = controller.currentSales;
                if (sales.isEmpty) {
                  return Container(
                    padding: const EdgeInsets.all(32),
                    child: const Center(
                      child: Text(
                        'No sales records found for the selected period.',
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    ),
                  );
                }

                return Column(
                  children: [
                    // Table Header
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(8),
                          topRight: Radius.circular(8),
                        ),
                      ),
                      child: Row(
                        children: const [
                          Expanded(
                            flex: 2,
                            child: Text(
                              'Date',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          Expanded(
                            flex: 3,
                            child: Text(
                              'Customer',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Text(
                              'Items',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Text(
                              'Total',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Text(
                              'Paid',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Text(
                              'Status',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Table Rows
                    SizedBox(
                      height: 400, // Fixed height for scrollable table
                      child: ListView.builder(
                        itemCount: sales.length,
                        itemBuilder: (context, index) {
                          final sale = sales[index];
                          return _buildSaleRow(
                            sale,
                            currencyFormat,
                            index.isEven,
                          );
                        },
                      ),
                    ),
                  ],
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSaleRow(
    SaleModel sale,
    NumberFormat currencyFormat,
    bool isEven,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isEven ? Colors.grey[50] : Colors.white,
        border: Border(bottom: BorderSide(color: Colors.grey[200]!)),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              DateFormat('dd/MM/yy HH:mm').format(sale.saleDate),
              style: const TextStyle(fontSize: 12),
            ),
          ),
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  sale.customerName ?? 'Walk-in Customer',
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
                if (sale.customerContact != null)
                  Text(
                    sale.customerContact!,
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              '${sale.items!.length} items',
              style: const TextStyle(fontSize: 12),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              currencyFormat.format(sale.totalAmount),
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              currencyFormat.format(sale.paidAmount),
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: sale.isPaid ? Colors.green : Colors.orange,
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color:
                    sale.isPaid
                        ? Colors.green.withValues(alpha: 0.1)
                        : Colors.red.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                sale.isPaid ? 'Paid' : 'Unpaid',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: sale.isPaid ? Colors.green : Colors.red,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopSellingItemsCard(DashboardController controller) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Top Selling Items',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Obx(() {
              final topItems = controller.getTopSellingItems();
              if (topItems.isEmpty) {
                return const Text(
                  'No data available',
                  style: TextStyle(color: Colors.grey),
                );
              }

              return Column(
                children:
                    topItems.entries
                        .map(
                          (entry) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    entry.key,
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                ),
                                Text(
                                  '${entry.value.toInt()} sold',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                        .toList(),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildRevenueByItemCard(
    DashboardController controller,
    NumberFormat currencyFormat,
  ) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Revenue by Item',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Obx(() {
              final revenueItems = controller.getRevenueByItem();
              if (revenueItems.isEmpty) {
                return const Text(
                  'No data available',
                  style: TextStyle(color: Colors.grey),
                );
              }

              return Column(
                children:
                    revenueItems.entries
                        .map(
                          (entry) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    entry.key,
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                ),
                                Text(
                                  currencyFormat.format(entry.value),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                        .toList(),
              );
            }),
          ],
        ),
      ),
    );
  }

  Future<void> _selectStartDate(DashboardController controller) async {
    final picked = await showDatePicker(
      context: Get.context!,
      initialDate: controller.selectedStartDate.value ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      controller.selectedStartDate.value = picked;
    }
  }

  Future<void> _selectEndDate(DashboardController controller) async {
    final picked = await showDatePicker(
      context: Get.context!,
      initialDate: controller.selectedEndDate.value ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      controller.selectedEndDate.value = picked;
    }
  }

  void _applyDateFilter(DashboardController controller) {
    if (controller.selectedStartDate.value != null &&
        controller.selectedEndDate.value != null) {
      controller.filterSalesByDateRange(
        controller.selectedStartDate.value!,
        controller.selectedEndDate.value!,
      );
    } else {
      Get.snackbar(
        'Error',
        'Please select both start and end dates',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
}
