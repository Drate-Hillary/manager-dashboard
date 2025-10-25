import 'package:dineswift_management/features/dashboard/screens/widgets/analytics_report.dart';
import 'package:dineswift_management/features/dashboard/screens/widgets/dashboard_overview.dart';
import 'package:dineswift_management/features/inventory_supplies/screens/inventory_supplies.dart';
import 'package:dineswift_management/features/operations_dispatch/screens/operation_dispatch.dart';
import 'package:dineswift_management/features/dashboard/screens/widgets/loyalty_program.dart';
import 'package:dineswift_management/features/dashboard/screens/widgets/customer_communication.dart';
import 'package:dineswift_management/features/dashboard/screens/widgets/system_configuration.dart';

import 'package:flutter/material.dart';

class DashboardNavigationController extends ChangeNotifier {
  Widget _currentScreen = const DashboardOverview();

  int _selectedIndex = 0;

  Widget get currentScreen => _currentScreen;

  int get selectedIndex => _selectedIndex;

  final Map<int, Widget> _screens = {
    0: const DashboardOverview(),
    1: const InventorySupplies(),
    2: const OperationsDispatch(),
    3: const LoyaltyProgram(),
    4: const CustomerCommunication(),
    5: const AnalyticsReport(),
    6: SystemConfiguration(),
  };

  void selectScreen(int index) {
    _currentScreen = _screens[index] ?? const DashboardOverview(); // Fallback to dashboard
    _selectedIndex = index;
    notifyListeners();
  }
}