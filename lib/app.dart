import 'package:dineswift_management/features/dashboard/screens/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DineSwiftApp extends StatelessWidget {
  const DineSwiftApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      home: const DineSwiftDashboard(),
    );
  }
}