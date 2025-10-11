import 'package:get/get.dart';
import 'package:yesudua_ventures/app/data/models/sales_model.dart';
import 'package:yesudua_ventures/app/data/repositories/sales_repository.dart';
import 'package:yesudua_ventures/app/data/repositories/inventory_repository.dart';

class DashboardController extends GetxController {
  final SalesRepository _salesRepository;
  final InventoryRepository _inventoryRepository;

  // Observable variables
  final isLoading = false.obs;
  final allSales = <SaleModel>[].obs;
  final todaySales = <SaleModel>[].obs;
  final weekSales = <SaleModel>[].obs;
  final monthSales = <SaleModel>[].obs;
  final unpaidSales = <SaleModel>[].obs;

  // Analytics data
  final totalSalesAmount = 0.0.obs;
  final todaysSalesAmount = 0.0.obs;
  final weekSalesAmount = 0.0.obs;
  final monthSalesAmount = 0.0.obs;
  final totalUnpaidAmount = 0.0.obs;

  final totalSalesCount = 0.obs;
  final todaysSalesCount = 0.obs;
  final weekSalesCount = 0.obs;
  final monthSalesCount = 0.obs;
  final unpaidSalesCount = 0.obs;

  // Date filters
  final selectedStartDate = Rxn<DateTime>();
  final selectedEndDate = Rxn<DateTime>();
  final currentFilter = 'all'.obs; // all, today, week, month, custom, unpaid

  DashboardController(this._salesRepository, this._inventoryRepository);

  @override
  void onInit() {
    super.onInit();
    loadDashboardData();
  }

  @override
  void onReady() {
    super.onReady();
    loadDashboardData();
  }

  // Load all dashboard data
  Future<void> loadDashboardData() async {
    isLoading.value = true;
    try {
      await Future.wait([
        _loadAllSales(),
        _loadTodaySales(),
        _loadWeekSales(),
        _loadMonthSales(),
        _loadUnpaidSales(),
      ]);
      _calculateAnalytics();
    } catch (e) {
      Get.snackbar('Error', 'Failed to load dashboard data: ${e.toString()}');
    } finally {
      isLoading.value = false;
    }
  }

  // Load all sales
  Future<void> _loadAllSales() async {
    allSales.value = await _salesRepository.getAllSales();
  }

  // Load today's sales
  Future<void> _loadTodaySales() async {
    todaySales.value = await _salesRepository.getAllSales(todayOnly: true);
  }

  // Load this week's sales
  Future<void> _loadWeekSales() async {
    final now = DateTime.now();
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    final startDate = DateTime(
      startOfWeek.year,
      startOfWeek.month,
      startOfWeek.day,
    );
    final endDate = DateTime(now.year, now.month, now.day, 23, 59, 59);

    weekSales.value = await _salesRepository.getAllSales(
      startDate: startDate,
      endDate: endDate,
    );
  }

  // Load this month's sales
  Future<void> _loadMonthSales() async {
    final now = DateTime.now();
    final startDate = DateTime(now.year, now.month, 1);
    final endDate = DateTime(now.year, now.month + 1, 0, 23, 59, 59);

    monthSales.value = await _salesRepository.getAllSales(
      startDate: startDate,
      endDate: endDate,
    );
  }

  // Load unpaid sales
  Future<void> _loadUnpaidSales() async {
    unpaidSales.value = await _salesRepository.getAllSales(unpaidOnly: true);
  }

  // Calculate analytics from loaded data
  void _calculateAnalytics() {
    // All sales analytics
    totalSalesCount.value = allSales.length;
    totalSalesAmount.value = allSales.fold(
      0.0,
      (sum, sale) => sum + sale.totalAmount,
    );

    // Today's sales analytics
    todaysSalesCount.value = todaySales.length;
    todaysSalesAmount.value = todaySales.fold(
      0.0,
      (sum, sale) => sum + sale.totalAmount,
    );

    // Week sales analytics
    weekSalesCount.value = weekSales.length;
    weekSalesAmount.value = weekSales.fold(
      0.0,
      (sum, sale) => sum + sale.totalAmount,
    );

    // Month sales analytics
    monthSalesCount.value = monthSales.length;
    monthSalesAmount.value = monthSales.fold(
      0.0,
      (sum, sale) => sum + sale.totalAmount,
    );

    // Unpaid sales analytics
    unpaidSalesCount.value = unpaidSales.length;
    totalUnpaidAmount.value = unpaidSales.fold(
      0.0,
      (sum, sale) => sum + (sale.totalAmount - sale.paidAmount),
    );
  }

  // Filter sales by date range
  Future<void> filterSalesByDateRange(
    DateTime startDate,
    DateTime endDate,
  ) async {
    isLoading.value = true;
    try {
      selectedStartDate.value = startDate;
      selectedEndDate.value = endDate;
      currentFilter.value = 'custom';

      allSales.value = await _salesRepository.getAllSales(
        startDate: startDate,
        endDate: endDate,
      );

      totalSalesCount.value = allSales.length;
      totalSalesAmount.value = allSales.fold(
        0.0,
        (sum, sale) => sum + sale.totalAmount,
      );
    } catch (e) {
      Get.snackbar('Error', 'Failed to filter sales: ${e.toString()}');
    } finally {
      isLoading.value = false;
    }
  }

  // Change filter type
  Future<void> changeFilter(String filter) async {
    currentFilter.value = filter;
    isLoading.value = true;

    try {
      switch (filter) {
        case 'all':
          await _loadAllSales();
          break;
        case 'today':
          allSales.value = todaySales;
          totalSalesCount.value = todaysSalesCount.value;
          totalSalesAmount.value = todaysSalesAmount.value;
          break;
        case 'week':
          allSales.value = weekSales;
          totalSalesCount.value = weekSalesCount.value;
          totalSalesAmount.value = weekSalesAmount.value;
          break;
        case 'month':
          allSales.value = monthSales;
          totalSalesCount.value = monthSalesCount.value;
          totalSalesAmount.value = monthSalesAmount.value;
          break;
        case 'unpaid':
          allSales.value = unpaidSales;
          totalSalesCount.value = unpaidSalesCount.value;
          totalSalesAmount.value = totalUnpaidAmount.value;
          break;
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to change filter: ${e.toString()}');
    } finally {
      isLoading.value = false;
    }
  }

  // Get sales for current period
  List<SaleModel> get currentSales {
    switch (currentFilter.value) {
      case 'today':
        return todaySales;
      case 'week':
        return weekSales;
      case 'month':
        return monthSales;
      case 'unpaid':
        return unpaidSales;
      default:
        return allSales;
    }
  }

  // Get current period analytics
  double get currentPeriodAmount {
    switch (currentFilter.value) {
      case 'today':
        return todaysSalesAmount.value;
      case 'week':
        return weekSalesAmount.value;
      case 'month':
        return monthSalesAmount.value;
      case 'unpaid':
        return totalUnpaidAmount.value;
      default:
        return totalSalesAmount.value;
    }
  }

  int get currentPeriodCount {
    switch (currentFilter.value) {
      case 'today':
        return todaysSalesCount.value;
      case 'week':
        return weekSalesCount.value;
      case 'month':
        return monthSalesCount.value;
      case 'unpaid':
        return unpaidSalesCount.value;
      default:
        return totalSalesCount.value;
    }
  }

  // Refresh dashboard data
  Future<void> refreshDashboard() async {
    await loadDashboardData();
  }

  // Get top selling items (from all sales)
  Map<String, double> getTopSellingItems({int limit = 10}) {
    final itemSales = <String, double>{};

    for (final sale in allSales) {
      for (final item in sale.items!) {
        final itemName = item.itemName ?? 'Unknown Item';
        itemSales[itemName] = (itemSales[itemName] ?? 0) + item.quantity;
      }
    }

    final sortedItems =
        itemSales.entries.toList()..sort((a, b) => b.value.compareTo(a.value));

    return Map.fromEntries(sortedItems.take(limit));
  }

  // Get revenue by item (from all sales)
  Map<String, double> getRevenueByItem({int limit = 10}) {
    final itemRevenue = <String, double>{};

    for (final sale in allSales) {
      for (final item in sale.items!) {
        final itemName = item.itemName ?? 'Unknown Item';
        final revenue = item.quantity * item.sellPrice;
        itemRevenue[itemName] = (itemRevenue[itemName] ?? 0) + revenue;
      }
    }

    final sortedItems =
        itemRevenue.entries.toList()
          ..sort((a, b) => b.value.compareTo(a.value));

    return Map.fromEntries(sortedItems.take(limit));
  }

  // Get daily sales for the current month (for charts)
  Map<int, double> getDailySalesForMonth() {
    final now = DateTime.now();
    final daysInMonth = DateTime(now.year, now.month + 1, 0).day;
    final dailySales = <int, double>{};

    // Initialize all days with 0
    for (int i = 1; i <= daysInMonth; i++) {
      dailySales[i] = 0.0;
    }

    // Add sales data
    for (final sale in monthSales) {
      final day = sale.saleDate.day;
      dailySales[day] = (dailySales[day] ?? 0) + sale.totalAmount;
    }

    return dailySales;
  }
}
