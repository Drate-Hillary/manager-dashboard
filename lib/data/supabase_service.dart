import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class SupabaseService {
  static SupabaseClient? clt;

  static Future<void> initialize() async {
    await dotenv.load(fileName: ".env");
    await Supabase.initialize(
      url: dotenv.env['SUPABASE_URL']!,
      anonKey: dotenv.env['SUPABASE_ANON_KEY']!,
    );
    clt = Supabase.instance.client;
  }

  static SupabaseClient get supabase => clt!;

  static Future<int> getOrderCount() async {
    final count = await supabase.from('order').count();
    return count;
  }

  static Future<void> registerRestaurant(Map<String, dynamic> data) async {
    await supabase.from('restaurants').insert(data);
  }

  static Future<void> saveMenu(
    Map<String, dynamic> menuData,
    List<Map<String, dynamic>> items,
  ) async {
    final menuResponse = await supabase
        .from('menus')
        .insert(menuData)
        .select()
        .single();
    final menuId = menuResponse['id'];

    if (items.isNotEmpty) {
      final itemsWithMenuId = items
          .map((item) => {...item, 'menu_id': menuId})
          .toList();
      await supabase.from('menu_items').insert(itemsWithMenuId);
    }
  }

  static Future<List<Map<String, dynamic>>> getRestaurantMenus(
    String restaurantId,
  ) async {
    final response = await supabase
        .from('menus')
        .select()
        .eq('restaurant_id', restaurantId);
    return List<Map<String, dynamic>>.from(response);
  }

  static Future<void> saveRestaurantTable(
    Map<String, dynamic> tableData,
  ) async {
    await supabase.from('restaurant_tables').insert(tableData);
  }

  Future<List<Map<String, dynamic>>> getRestaurantTables(
    String restaurantId,
  ) async {
    try {
      final response = await supabase
        .from('restaurant_tables')
        .select()
        .eq('restaurant_id', restaurantId)
        .order('table_number');

      return response;
    } catch (e) {
      throw Exception('Error fetching restaurant tables: $e');
    }
  }

  Future<Map<String, dynamic>?> getTableByQRCode(String qrCode) async {
    try {
      final response = await supabase
        .from('restaurant_tables')
        .select()
        .eq('qr_code', qrCode)
        .single();

      return response;
    } catch (e) {
      throw Exception('Error fetching table by QR code: $e');
    }
  }

  Future<void> updateTableStatus(String tableId, String status) async {
    try {
      await supabase
        .from('restaurant_tables')
        .update({
          'table_status': status,
          'updated_at': DateTime.now().toIso8601String(),
        })
        .eq('id', tableId);
    } catch (e) {
      throw Exception('Error updating table status: $e');
    }
  }

  Future<void> deleteRestaurantTable(String tableId) async {
    try {
      await supabase.from('restaurant_tables').delete().eq('id', tableId);
    } catch (e) {
      throw Exception('Error deleting restaurant table: $e');
    }
  }

  // Restaurant Operations
  Future<Map<String, dynamic>?> getRestaurant(String restaurantId) async {
    try {
      final response = await supabase
        .from('restaurants')
        .select()
        .eq('id', restaurantId)
        .single();

      return response;
    } catch (e) {
      throw Exception('Error fetching restaurant: $e');
    }
  }

  // Order Operations
  Future<List<Map<String, dynamic>>> getActiveOrdersByTable(
    String tableId,
  ) async {
    try {
      final response = await supabase
        .from('orders')
        .select()
        .eq('table_id', tableId)
        .inFilter('order_status', ['pending', 'confirmed', 'preparing'])
        .order('created_at', ascending: false);

      return response;
    } catch (e) {
      throw Exception('Error fetching active orders: $e');
    }
  }

  // Menu Operations
  Future<List<Map<String, dynamic>>> getRestaurantMenu(
    String restaurantId,
  ) async {
    try {
      final response = await supabase
        .from('menu_items')
        .select()
        .eq('restaurant_id', restaurantId)
        .eq('is_available', true)
        .order('category')
        .order('name');

      return response;
    } catch (e) {
      throw Exception('Error fetching restaurant menu: $e');
    }
  }

  // Real-time Subscriptions
  Stream<List<Map<String, dynamic>>> watchRestaurantTables(
    String restaurantId,
  ) {
    return supabase
      .from('restaurant_tables')
      .stream(primaryKey: ['id'])
      .eq('restaurant_id', restaurantId)
      .order('table_number');
  }

  Stream<List<Map<String, dynamic>>> watchTableOrders(String tableId) {
    return supabase
      .from('orders')
      .stream(primaryKey: ['id'])
      .eq('table_id', tableId)
      .order('created_at', ascending: false);
  }

  // Batch Operations
  Future<void> createMultipleTables(
    List<Map<String, dynamic>> tablesData,
  ) async {
    try {
      await supabase.from('restaurant_tables').insert(tablesData);
    } catch (e) {
      throw Exception('Error creating multiple tables: $e');
    }
  }

  // Utility Methods
  Future<bool> checkTableNumberExists(
    String restaurantId,
    String tableNumber,
  ) async {
    try {
      final response = await supabase
        .from('restaurant_tables')
        .select()
        .eq('restaurant_id', restaurantId)
        .eq('table_number', tableNumber);

      return response.isNotEmpty;
    } catch (e) {
      throw Exception('Error checking table number: $e');
    }
  }

  Future<int> getNextAvailableTableNumber(String restaurantId) async {
    try {
      final response = await supabase
        .from('restaurant_tables')
        .select('table_number')
        .eq('restaurant_id', restaurantId)
        .order('table_number');

      final tables = response;
      if (tables.isEmpty) return 1;

      final tableNumbers = tables.map((table) {
        final number = table['table_number'].toString().replaceAll(
          RegExp(r'[^0-9]'),
          '',
        );
        return int.tryParse(number) ?? 0;
      }).toList();

      tableNumbers.sort();

      for (int i = 1; i <= tableNumbers.length + 1; i++) {
        if (!tableNumbers.contains(i)) {
          return i;
        }
      }

      return tableNumbers.length + 1;
    } catch (e) {
      throw Exception('Error getting next available table number: $e');
    }
  }
}
