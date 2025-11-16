import 'package:dineswift_management/features/system_configuration/screens/widgets/qr_code.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class FinancialSystemCard extends StatelessWidget {
  const FinancialSystemCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1.5,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ExpansionTile(
        leading: const Icon(Iconsax.setting_4, color: Colors.indigo),
        title: Text('System & Financials',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 18)),
        subtitle: const Text('Payments, records, system health'),
        childrenPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        expandedCrossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            leading: const Icon(Iconsax.card, size: 20),
            title: const Text('Payment Gateway Settings'),
            subtitle: const Text('Configure Momo, Visa Direct, etc.'),
            trailing: const Icon(Iconsax.arrow_right_3, size: 16),
            onTap: () {
              /* Navigate to Payment Settings */
            },
          ),
          const Divider(height: 1),
          ListTile(
            leading: const Icon(Iconsax.receipt_search, size: 20),
            title: const Text('Order & Payment Records'),
            subtitle: const Text('View historical transaction logs'),
            trailing: const Icon(Iconsax.arrow_right_3, size: 16),
            onTap: () {
              /* Navigate to Records Viewer */
            },
          ),
          const Divider(height: 1),
          ListTile(
            leading: const Icon(Iconsax.scan_barcode, size: 20),
            title: const Text('QR Code Management'),
            subtitle: const Text('View and manage table QR codes'),
            trailing: const Icon(Iconsax.arrow_right_3, size: 16),
            onTap: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return const Dialog(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12.0))),
                    child: GenerateQRCode(restaurantId: 'restaurant-001'),
                  );
                },
              );
            },
          ),
          const Divider(height: 1),
          ListTile(
            leading: const Icon(Iconsax.cpu_setting, size: 20),
            title: const Text('System Health & Sync Status'),
            subtitle: const Text('Monitor connectivity and data sync'),
            trailing: const Icon(Iconsax.arrow_right_3, size: 16),
            onTap: () {
              /* Navigate to System Health Dashboard */
            },
          ),
        ],
      ),
    );
  }
}