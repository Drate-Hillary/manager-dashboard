import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:dineswift_management/data/supabase_service.dart';
import 'package:uuid/uuid.dart';

class AuthService {
  static String hashPassword(String password) {
    final bytes = utf8.encode(password);
    final hash = sha256.convert(bytes);
    return hash.toString();
  }

  static Future<Map<String, dynamic>?> login({
    required String email,
    required String password,
  }) async {
    try {
      final hashedPassword = hashPassword(password);
      
      final response = await SupabaseService.supabase
          .from('users')
          .select('id, username, email, is_superuser, is_active')
          .eq('email', email)
          .eq('password', hashedPassword)
          .maybeSingle();

      if (response == null) return null;
      
      if (response['is_active'] != true) {
        throw Exception('Account is not active');
      }

      return response;
    } catch (e) {
      throw Exception(e);
    }
  }

  static Future<Map<String, dynamic>?> registerManager({
    required String username,
    required String email,
    required String password,
  }) async {
    try {
      final hashedPassword = hashPassword(password);
      final uuid = const Uuid();
      
      final userData = {
        'id': uuid.v4(),
        'username': username,
        'email': email,
        'password': hashedPassword,
        'is_superuser': true,
        'is_staff': false,
        'is_active': true,
        'created_at': DateTime.now().toIso8601String(),
        'updated_at': DateTime.now().toIso8601String(),
      };

      final response = await SupabaseService.supabase
        .from('users')
        .insert(userData)
        .select('id, username, email, is_superuser, is_active')
        .single();

      return response;
      
    } catch (e) {
      throw Exception(e);
    }
  }
}
