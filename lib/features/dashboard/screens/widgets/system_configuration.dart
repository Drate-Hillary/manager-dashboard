import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

// --- Data Models (Simple Examples for Config) ---
class StaffMember {
  final String id;
  final String name;
  final String role; // e.g., 'Manager', 'Waiter', 'Kitchen'
  bool isActive;

  StaffMember({
    required this.id,
    required this.name,
    required this.role,
    this.isActive = true,
  });
}

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
        title: const Text('System Configuration'),
      ),
      body: ListView( // Use ListView for scrolling if content overflows
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildRestaurantSettingsCard(context),
          const SizedBox(height: 16),
          _buildBusinessRulesCard(context),
          const SizedBox(height: 16),
          _buildUserManagementCard(context, staffList),
          const SizedBox(height: 16),
          _buildFinancialSystemCard(context), // Combines Payment/Order Records & System Health
        ],
      ),
    );
  }

  // --- Configuration Section Cards ---

  /// **1. Restaurant Settings Card**
  Widget _buildRestaurantSettingsCard(BuildContext context) {
    return Card(
      elevation: 1.5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ExpansionTile(
        leading: const Icon(Iconsax.shop, color: Colors.blue),
        title: Text('Restaurant Settings', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 18)),
        subtitle: const Text('Menu, tables, operating hours'),
        initiallyExpanded: true, // Start expanded
        childrenPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        expandedCrossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            leading: const Icon(Iconsax.document_upload, size: 20),
            title: const Text('Menu Management'),
            subtitle: const Text('Edit categories, items, prices, availability'),
            trailing: const Icon(Iconsax.arrow_right_3, size: 16),
            onTap: () { /* Navigate to Menu Editor Screen */ },
          ),
          const Divider(height: 1),
           ListTile(
            leading: const Icon(Iconsax.map_1, size: 20),
            title: const Text('Table Layout Setup'),
            subtitle: const Text('Configure table map and capacity'),
             trailing: const Icon(Iconsax.arrow_right_3, size: 16),
            onTap: () { /* Navigate to Table Layout Editor */ },
          ),
           const Divider(height: 1),
           ListTile(
            leading: const Icon(Iconsax.clock, size: 20),
            title: const Text('Operating Hours'),
            subtitle: const Text('Set daily opening and closing times'),
             trailing: const Icon(Iconsax.arrow_right_3, size: 16),
            onTap: () { /* Navigate to Operating Hours Screen */ },
          ),
        ],
      ),
    );
  }

  /// **2. Business Rules Card**
  Widget _buildBusinessRulesCard(BuildContext context) {
     return Card(
      elevation: 1.5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ExpansionTile(
        leading: const Icon(Iconsax.rulerpen, color: Colors.orange),
        title: Text('Business Rules', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 18)),
        subtitle: const Text('Bookings, loyalty, alerts'),
        childrenPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        expandedCrossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            leading: const Icon(Iconsax.calendar_edit, size: 20),
            title: const Text('Booking Policies'),
            subtitle: const Text('Deposit rules, advance booking times'),
            trailing: const Icon(Iconsax.arrow_right_3, size: 16),
            onTap: () { /* Navigate to Booking Policy Screen */ },
          ),
           const Divider(height: 1),
           ListTile(
            leading: const Icon(Iconsax.award, size: 20),
            title: const Text('Loyalty Program Rules'),
            subtitle: const Text('Points per spend, tier requirements'),
             trailing: const Icon(Iconsax.arrow_right_3, size: 16),
            onTap: () { /* Navigate to Loyalty Rules Screen */ },
          ),
           const Divider(height: 1),
           ListTile(
            leading: const Icon(Iconsax.warning_2, size: 20),
            title: const Text('Alert Thresholds'),
            subtitle: const Text('Low stock levels, wait times'),
             trailing: const Icon(Iconsax.arrow_right_3, size: 16),
            onTap: () { /* Navigate to Alert Thresholds Screen */ },
          ),
        ],
      ),
    );
  }

  /// **3. User Management Card**
  Widget _buildUserManagementCard(BuildContext context, List<StaffMember> staff) {
     return Card(
      elevation: 1.5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ExpansionTile(
        leading: const Icon(Iconsax.profile_2user, color: Colors.green),
        title: Text('User Management', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 18)),
        subtitle: Text('${staff.length} staff accounts'),
        childrenPadding: const EdgeInsets.symmetric(horizontal: 0, vertical: 8), // No horizontal padding for full-width list
        expandedCrossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
             padding: const EdgeInsets.symmetric(horizontal: 16.0),
             child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                 Text('Staff Accounts', style: Theme.of(context).textTheme.titleMedium),
                 TextButton.icon(
                   icon: const Icon(Iconsax.add, size: 16),
                   label: const Text('Add Staff'),
                   onPressed: () { /* Show Add Staff Dialog/Screen */},
                   style: TextButton.styleFrom(visualDensity: VisualDensity.compact),
                 ),
              ],
            ),
          ),
          const Divider(height: 1),
          // Staff List
          ListView.separated(
             shrinkWrap: true,
             physics: const NeverScrollableScrollPhysics(), // Disable nested scrolling
             itemCount: staff.length,
             itemBuilder: (context, index) {
               final member = staff[index];
               return ListTile(
                 dense: true,
                 leading: CircleAvatar(
                   radius: 16,
                   child: Text(member.name.substring(0,1)), // Initial
                 ),
                 title: Text(member.name),
                 subtitle: Text(member.role),
                 trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                   children: [
                     Chip(
                        label: Text(member.isActive ? 'Active' : 'Inactive', style: TextStyle(fontSize: 10, color: member.isActive ? Colors.green.shade800 : Colors.red.shade800)),
                        backgroundColor: member.isActive ? Colors.green.withOpacity(0.1) : Colors.red.withOpacity(0.1),
                        side: BorderSide.none,
                        visualDensity: VisualDensity.compact,
                        padding: const EdgeInsets.symmetric(horizontal: 6)
                      ),
                      IconButton(
                        icon: const Icon(Iconsax.edit, size: 16),
                        onPressed: () {/* Edit Staff */},
                         visualDensity: VisualDensity.compact,
                      ),
                   ],
                 ),
                 onTap: () {/* View Staff Details */},
               );
             },
             separatorBuilder: (context, index) => const Divider(height: 1, indent: 16, endIndent: 16),
           ),
           const Divider(height: 1),
           // Link to Role Permissions
           ListTile(
              leading: const Icon(Iconsax.key_square, size: 20),
              title: const Text('Role Permissions'),
              subtitle: const Text('Manage what each role can access'),
              trailing: const Icon(Iconsax.arrow_right_3, size: 16),
              onTap: () { /* Navigate to Role Permissions Screen */ },
            ),

        ],
      ),
    );
  }

   /// **4. Financial & System Card**
  Widget _buildFinancialSystemCard(BuildContext context) {
      return Card(
      elevation: 1.5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ExpansionTile(
        leading: const Icon(Iconsax.setting_4, color: Colors.indigo),
        title: Text('System & Financials', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 18)),
        subtitle: const Text('Payments, records, system health'),
         childrenPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        expandedCrossAxisAlignment: CrossAxisAlignment.start,
        children: [
           ListTile(
            leading: const Icon(Iconsax.card, size: 20),
            title: const Text('Payment Gateway Settings'),
            subtitle: const Text('Configure Momo, Visa Direct, etc.'),
             trailing: const Icon(Iconsax.arrow_right_3, size: 16),
            onTap: () { /* Navigate to Payment Settings */ },
          ),
          const Divider(height: 1),
            ListTile(
            leading: const Icon(Iconsax.receipt_search, size: 20),
            title: const Text('Order & Payment Records'),
            subtitle: const Text('View historical transaction logs'),
             trailing: const Icon(Iconsax.arrow_right_3, size: 16),
            onTap: () { /* Navigate to Records Viewer */ },
          ),
           const Divider(height: 1),
           ListTile(
            leading: const Icon(Iconsax.scan_barcode, size: 20),
            title: const Text('QR Code Management'),
            subtitle: const Text('View and manage table QR codes'),
             trailing: const Icon(Iconsax.arrow_right_3, size: 16),
            onTap: () { /* Navigate to QR Management Screen */ },
          ),
          const Divider(height: 1),
           ListTile(
            leading: const Icon(Iconsax.cpu_setting, size: 20),
            title: const Text('System Health & Sync Status'),
            subtitle: const Text('Monitor connectivity and data sync'),
             trailing: const Icon(Iconsax.arrow_right_3, size: 16),
            onTap: () { /* Navigate to System Health Dashboard */ },
          ),
        ],
      ),
    );
  }
}