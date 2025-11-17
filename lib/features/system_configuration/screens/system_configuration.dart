import 'package:dineswift_management/features/system_configuration/models/staff_member_model.dart';
import 'package:dineswift_management/features/system_configuration/screens/widgets/business_rules_card.dart';
import 'package:dineswift_management/features/system_configuration/screens/widgets/financial_system_card.dart';
import 'package:dineswift_management/features/system_configuration/screens/widgets/restaurant_settings.dart';
import 'package:dineswift_management/features/system_configuration/screens/widgets/user_management_card.dart';
import 'package:dineswift_management/util/constants/colors.dart';
import 'package:flutter/material.dart';

// --- Main System Configuration Screen Widget ---
class SystemConfiguration extends StatefulWidget {
  const SystemConfiguration({super.key});

  @override
  State<SystemConfiguration> createState() => SystemConfigurationScreen();
}

class SystemConfigurationScreen extends State<SystemConfiguration> {

  // --- Mock Data ---
  // (You would fetch this data in a StatefulWidget or using a state management solution)
  final List<StaffMember> staffList = [
    StaffMember(id: 'S01', name: 'Alice M.', role: 'Manager'),
    StaffMember(id: 'S02', name: 'Bob K.', role: 'Waiter'),
    StaffMember(id: 'S03', name: 'Charlie P.', role: 'Kitchen'),
    StaffMember(id: 'S04', name: 'Diana L.', role: 'Waiter', isActive: false),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: DineSwiftColors.backgroundColor,
        leading: Icon(
          Icons.settings_outlined,
          color: DineSwiftColors.blackColor,
          size: 30,
        ),
        title: Row(
          children: const [
            SizedBox(width: 2),
            Text('System Configuration'),
          ],
        ),
        titleSpacing: 0, // To remove default title spacing
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final crossAxisCount = constraints.maxWidth < 600 ? 1 : 2;
          return GridView.count(
            padding: const EdgeInsets.all(16.0),
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 1.2,
            children: [
              const RestaurantSettings(),
              const BusinessRulesCard(),
              UserManagementCard(staff: staffList),
              const FinancialSystemCard(),
            ],
          );
        },
      ),
    );
  }
}