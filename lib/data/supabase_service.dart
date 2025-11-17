import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class SupabaseService {
  static SupabaseClient? _client;

  static Future<void> initialize() async {
    await dotenv.load(fileName: ".env");
    await Supabase.initialize(
      url: dotenv.env['SUPABASE_URL']!,
      anonKey: dotenv.env['SUPABASE_ANON_KEY']!,
    );
    _client = Supabase.instance.client;
  }

  static SupabaseClient get client => _client!;

  static Future<int> getOrderCount() async {
    final count = await client.from('order').count();
    return count;
  }

  static Future<void> registerRestaurant(Map<String, dynamic> data) async {
    await client.from('restaurants').insert(data);
  }

  static Future<void> saveMenu(Map<String, dynamic> menuData, List<Map<String, dynamic>> items) async {
    final menuResponse = await client.from('menus').insert(menuData).select().single();
    final menuId = menuResponse['id'];
    
    if (items.isNotEmpty) {
      final itemsWithMenuId = items.map((item) => {...item, 'menu_id': menuId}).toList();
      await client.from('menu_items').insert(itemsWithMenuId);
    }
  }

  static Future<List<Map<String, dynamic>>> getRestaurantMenus(String restaurantId) async {
    final response = await client.from('menus').select().eq('restaurant_id', restaurantId);
    return List<Map<String, dynamic>>.from(response);
  }

  static Future<void> saveRestaurantTable(Map<String, dynamic> tableData) async {
    await client.from('restaurant_tables').insert(tableData);
  }
}
