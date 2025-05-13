import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:yesudua_ventures/app/core/utils/constants.dart';
import 'package:yesudua_ventures/app/data/local/drift_database.dart';
import 'package:yesudua_ventures/app/core/utils/logger.dart';

class SupabaseService extends GetxService {
  late final SupabaseClient supabase;
  final RxBool isInitialized = false.obs;

  @override
  void onInit() {
    super.onInit();
    _initSupabase();
  }

  Future<void> _initSupabase() async {
    try {
      supabase = SupabaseClient(
        AppConstants.supabaseUrl,
        AppConstants.supabaseAnonKey,
      );
      isInitialized.value = true;
      Logger.i('SupabaseService', 'Supabase initialized successfully');
    } catch (e) {
      Logger.e('SupabaseService', 'Failed to initialize Supabase', error: e);
    }
  }

  // Upload Inventory Item to Supabase
  Future<void> uploadInventoryItem(InventoryItem item) async {
    if (!isInitialized.value) {
      Logger.e('SupabaseService', 'Supabase not initialized');
      throw Exception('Supabase not initialized');
    }

    try {
      final data = {
        'id': item.id,
        'name': item.name,
        'category': item.category,
        'quantity': item.quantity,
        'bought_price': item.boughtPrice,
        'sell_price': item.sellPrice,
        'supplier': item.supplier,
        'last_updated': item.lastUpdated?.toIso8601String(),
        'image_key': item.imageKey,
      };

      Logger.i('SupabaseService', 'Uploading item to Supabase: ${item.id}');

      // Check if the item exists (for upsert)
      final existing =
          await supabase
              .from('inventory_items')
              .select()
              .eq('id', item.id)
              .maybeSingle();

      if (existing != null) {
        // Update
        await supabase.from('inventory_items').update(data).eq('id', item.id);
        Logger.i('SupabaseService', 'Updated item in Supabase: ${item.id}');
      } else {
        // Insert
        await supabase.from('inventory_items').insert(data);
        Logger.i('SupabaseService', 'Inserted item to Supabase: ${item.id}');
      }
    } catch (e) {
      Logger.e('SupabaseService', 'Failed to upload inventory item', error: e);
      throw Exception('Supabase Upload Error: $e');
    }
  }

  // Delete Inventory Item from Supabase
  Future<void> deleteInventoryItem(int id) async {
    if (!isInitialized.value) {
      Logger.e('SupabaseService', 'Supabase not initialized');
      throw Exception('Supabase not initialized');
    }

    try {
      await supabase.from('inventory_items').delete().eq('id', id);
      Logger.i('SupabaseService', 'Deleted item from Supabase: $id');
    } catch (e) {
      Logger.e('SupabaseService', 'Failed to delete inventory item', error: e);
      throw Exception('Supabase Delete Error: $e');
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
