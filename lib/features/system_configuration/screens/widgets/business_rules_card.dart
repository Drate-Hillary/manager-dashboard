import 'package:dineswift_management/util/common/divider.dart';
import 'package:dineswift_management/util/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class BusinessRulesCard extends StatelessWidget {
  const BusinessRulesCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1.5,
      color: DineSwiftColors.whiteColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ExpansionTile(
        leading: const Icon(
          Iconsax.rulerpen,
          color: DineSwiftColors.iconColor,
          size: 25,
        ),
        title: Text(
          'Business Rules',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        subtitle: const Text('Bookings, loyalty, alerts',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400)),
        childrenPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        expandedCrossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            leading: const Icon(Iconsax.calendar_edit, size: 20),
            title: const Text('Booking Policies',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: DineSwiftColors.blackColor)),
            subtitle: const Text('Deposit rules, advance booking times',
                style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: DineSwiftColors.darkGrey)),
            hoverColor: DineSwiftColors.softGrey.withOpacity(0.2),
            trailing: const Icon(Iconsax.arrow_right_1, size: 16),
            onTap: () {
              /* Navigate to Booking Policy Screen */
            },
          ),
          DineSwiftDivider(height: 1),
          ListTile(
            leading: const Icon(Iconsax.award, size: 20),
            title: const Text('Loyalty Program Rules',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: DineSwiftColors.blackColor)),
            subtitle: const Text('Points per spend, tier requirements',
                style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: DineSwiftColors.darkGrey)),
            hoverColor: DineSwiftColors.softGrey.withOpacity(0.2),
            trailing: const Icon(Iconsax.arrow_right_1, size: 16),
            onTap: () {
              /* Navigate to Loyalty Rules Screen */
            },
          ),
          DineSwiftDivider(height: 1),
          ListTile(
            leading: const Icon(Iconsax.warning_2, size: 20),
            title: const Text('Alert Thresholds',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: DineSwiftColors.blackColor)),
            subtitle: const Text('Low stock levels, wait times',
                style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: DineSwiftColors.darkGrey)),
            trailing: const Icon(Iconsax.arrow_right_3, size: 16),
            hoverColor: DineSwiftColors.softGrey.withOpacity(0.2),
            onTap: () {
              /* Navigate to Alert Thresholds Screen */
            },
          ),
        ],
      ),
    );
  }
}