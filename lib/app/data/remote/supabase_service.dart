import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:yesudua_ventures/app/core/utils/constants.dart';
import 'package:yesudua_ventures/app/data/local/drift_database.dart';

class SupabaseService extends GetxService {
  late final SupabaseClient supabase;

  @override
  void onInit() {
    super.onInit();
    supabase = SupabaseClient(
      AppConstants.supabaseUrl,
      AppConstants.supabaseAnonKey,
    );
  }

  // Upload Inventory Item to Supabase
  Future<void> uploadInventoryItem(InventoryItem item) async {
    final response = await supabase.from('inventory_items').insert({
      'id': item.id,
      'name': item.name,
      'category': item.category,
      'quantity': item.quantity,
      'bought_price': item.boughtPrice,
      'sell_price': item.sellPrice,
      'supplier': item.supplier,
      'last_updated': item.lastUpdated?.toIso8601String(),
      'image_key': item.imageKey,
    });

    if (response.error != null) {
      throw Exception('Supabase Upload Error: ${response.error!.message}');
    }
  }

  // Upload Sale Record to Supabase
  Future<void> uploadSale(Sale sale) async {
    final response = await supabase.from('sales').insert({
      'id': sale.id,
      'item_id': sale.itemId,
      'quantity_sold': sale.quantitySold,
      'sold_price': sale.soldPrice,
      'date_of_sale': sale.dateOfSale.toIso8601String(),
      'is_paid': sale.isPaid,
    });

    if (response.error != null) {
      throw Exception('Supabase Upload Error: ${response.error!.message}');
    }
  }

  // Upload Debtor Record to Supabase
  Future<void> uploadDebtor(Debtor debtor) async {
    final response = await supabase.from('debtors').insert({
      'id': debtor.id,
      'customer_name': debtor.customerName,
      'customer_contact': debtor.customerContact,
      'total_amount': debtor.totalAmount,
      'amount_paid': debtor.amountPaid,
      'created_at': debtor.createdAt.toIso8601String(),
    });

    if (response.error != null) {
      throw Exception('Supabase Upload Error: ${response.error!.message}');
    }
  }

  // Upload Supplier Record to Supabase
  Future<void> uploadSupplier(Supplier supplier) async {
    final response = await supabase.from('suppliers').insert({
      'id': supplier.id,
      'name': supplier.name,
      'contact': supplier.contact,
      'company': supplier.company,
      'created_at': supplier.createdAt.toIso8601String(),
    });

    if (response.error != null) {
      throw Exception('Supabase Upload Error: ${response.error!.message}');
    }
  }
}
