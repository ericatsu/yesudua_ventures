import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yesudua_ventures/app/data/models/sales_model.dart';
import 'package:yesudua_ventures/app/data/repositories/sales_repository.dart';

class DebtorsController extends GetxController {
  final SalesRepository _salesRepository;

  // Observable variables
  final isLoading = false.obs;
  final debtors = <DebtorModel>[].obs;
  final selectedDebtor = Rxn<DebtorModel>();
  final errorMessage = ''.obs;

  // Form controller for updates
  final newPaymentAmount = 0.0.obs;
  final paymentController = TextEditingController();

  DebtorsController(this._salesRepository);

  @override
  void onInit() {
    super.onInit();
    fetchAllDebtors();
  }

  // Add this method to handle page refreshes
  @override
  void onReady() {
    super.onReady();

    // Check if we have arguments (debtor ID) when the controller is ready
    final arguments = Get.arguments;
    if (arguments is int) {
      getDebtorById(arguments);
    }
  }

  @override
  void onClose() {
    paymentController.dispose();
    super.onClose();
  }

  // Fetch all debtors
  Future<void> fetchAllDebtors() async {
    isLoading.value = true;
    errorMessage.value = ''; // Clear previous errors
    try {
      debtors.value = await _salesRepository.getAllDebtors();
    } catch (e) {
      errorMessage.value = 'Failed to load debtors: ${e.toString()}';
    } finally {
      isLoading.value = false;
    }
  }

  // Get debtor details by ID
  Future<void> getDebtorById(int debtorId) async {
    isLoading.value = true;
    errorMessage.value = ''; // Clear previous errors
    try {
      selectedDebtor.value = await _salesRepository.getDebtorById(debtorId);
      if (selectedDebtor.value != null) {
        paymentController.text = '0.0';
        newPaymentAmount.value = 0.0;
      } else {
        errorMessage.value = 'Debtor not found';
      }
    } catch (e) {
      errorMessage.value = 'Failed to load debtor details: ${e.toString()}';
      selectedDebtor.value = null; // Ensure it's null on error
    } finally {
      isLoading.value = false;
    }
  }

  // Record new payment for a debtor
  Future<bool> recordPayment(int debtorId, double amount) async {
    if (amount <= 0) {
      errorMessage.value = 'Payment amount must be greater than zero';
      return false;
    }

    isLoading.value = true;
    try {
      final debtor = selectedDebtor.value;
      if (debtor == null) {
        errorMessage.value = 'No debtor selected';
        return false;
      }

      final totalPaid = debtor.paidAmount + amount;
      final isPaid = totalPaid >= debtor.totalDebt;

      final success = await _salesRepository.updateDebtorPayment(
        debtorId,
        amount,
        totalPaid,
        isPaid,
      );

      if (success) {
        // Refresh debtor details and list
        await getDebtorById(debtorId);
        await fetchAllDebtors();

        paymentController.text = '0.0';
        newPaymentAmount.value = 0.0;
      }

      return success;
    } catch (e) {
      errorMessage.value = 'Failed to record payment: ${e.toString()}';
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  // Method to refresh data when returning to debtors list
  void refreshDebtorsList() {
    fetchAllDebtors();
  }
}
