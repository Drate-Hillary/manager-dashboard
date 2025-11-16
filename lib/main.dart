import 'package:dineswift_management/app.dart';
import 'package:dineswift_management/data/supabase_service.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SupabaseService.initialize();
  runApp(const DineSwiftApp());
}