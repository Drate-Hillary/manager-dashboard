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
}
