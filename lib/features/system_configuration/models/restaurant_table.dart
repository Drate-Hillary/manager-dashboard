import 'package:dineswift_management/util/constants/colors.dart';
import 'package:flutter/material.dart';

enum TableStatus { available, occupied, reserved, cleaning, maintenance }

class RestaurantTable {
  final String tableId;
  final String restaurantId;
  final String tableNumber;
  final int capacity;
  final TableStatus tableStatus;
  final String qrCode;
  final DateTime createdAt;

  RestaurantTable({
    required this.tableId,
    required this.restaurantId,
    required this.tableNumber,
    required this.capacity,
    required this.tableStatus,
    required this.qrCode,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': tableId,
      'restaurant_id': restaurantId,
      'table_number': tableNumber,
      'capacity': capacity,
      'table_status': tableStatus.toString().split('.').last,
      'qr_code': qrCode,
      'created_at': createdAt.toIso8601String(),
      'updated_at': DateTime.now().toIso8601String(),
    };
  }
}

Color getStatusColor(TableStatus status) {
  switch (status) {
    case TableStatus.available:
      return DineSwiftColors.successColor;
    case TableStatus.occupied:
      return DineSwiftColors.errorColor;
    case TableStatus.reserved:
      return DineSwiftColors.warningColor;
    case TableStatus.cleaning:
      return DineSwiftColors.infoColor;
    case TableStatus.maintenance:
      return DineSwiftColors.darkGrey;
  }
}