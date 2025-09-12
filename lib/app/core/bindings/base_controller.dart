import 'package:get/get.dart';
import 'package:yesudua_ventures/app/core/utils/app_utils.dart';

abstract class BaseController<T> extends GetxController {
  final dynamic repository;
  final RxList<T> items = <T>[].obs;
  final RxBool isLoading = false.obs;
  final RxString searchQuery = ''.obs;
  final Rx<T?> selectedItem = Rx<T?>(null);
  final RxString errorMessage = ''.obs;

  BaseController(this.repository) {
    debounce(searchQuery, (_) => searchItems(), time: const Duration(milliseconds: 500));
  }

  // Abstract methods to be implemented by subclasses
  Future<List<T>> fetchAllItems();
  Future<List<T>> searchItemsFromRepo(String query);
  Future<bool> addItem(T item);
  Future<bool> updateItem(T item);
  Future<bool> deleteItem(dynamic id);
  void selectItem(T? item) => selectedItem.value = item;

  // Common fetch logic
  Future<void> fetchItems({bool refresh = false}) async {
    if (refresh) items.clear();
    isLoading.value = true;
    try {
      items.value = await fetchAllItems();
    } catch (e) {
      errorMessage.value = 'Failed to load items: $e';
      AppUtils.showError('Error', errorMessage.value);
    } finally {
      isLoading.value = false;
    }
  }

  // Common search logic
  Future<void> searchItems() async {
    if (searchQuery.isEmpty) {
      fetchItems();
      return;
    }
    isLoading.value = true;
    final query = searchQuery.value.toLowerCase();
    try {
      items.value = await searchItemsFromRepo(query);
    } catch (e) {
      errorMessage.value = 'Search failed: $e';
      AppUtils.showError('Error', errorMessage.value);
    } finally {
      isLoading.value = false;
    }
  }

  // Common add logic
  Future<void> handleAdd(T item) async {
    try {
      final success = await addItem(item);
      if (success) {
        await fetchItems(refresh: true);
        AppUtils.showSuccess('Success', 'Item added successfully');
      }
    } catch (e) {
      AppUtils.showError('Error', 'Failed to add item: $e');
    }
  }

  // Common update logic
  Future<void> handleUpdate(T item) async {
    try {
      final success = await updateItem(item);
      if (success) {
        await fetchItems(refresh: true);
        AppUtils.showSuccess('Success', 'Item updated successfully');
      }
    } catch (e) {
      AppUtils.showError('Error', 'Failed to update item: $e');
    }
  }

  // Common delete logic
  Future<void> handleDelete(dynamic id) async {
    try {
      final success = await deleteItem(id);
      if (success) {
        await fetchItems(refresh: true);
        AppUtils.showSuccess('Success', 'Item deleted successfully');
      }
    } catch (e) {
      AppUtils.showError('Error', 'Failed to delete item: $e');
    }
  }

  @override
  void onInit() {
    super.onInit();
    fetchItems();
  }
}