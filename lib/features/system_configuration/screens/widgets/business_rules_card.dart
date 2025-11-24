import 'package:dineswift_management/features/system_configuration/screens/widgets/loyalty_reward.dart';
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
      child: Column(
        children: [
          const ListTile(
            leading: const Icon(
              Iconsax.rulerpen,
              color: DineSwiftColors.iconColor,
              size: 25,
            ),
            title: Text(
              'Business Rules',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            subtitle: Text(
              'Bookings, loyalty, alerts',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: DineSwiftDivider(height: 1),
          ),
          const SizedBox(height: 10),
          ListTile(
            leading: const Icon(Iconsax.calendar_edit, size: 20),
            title: const Text(
              'Booking Policies',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: DineSwiftColors.blackColor,
              ),
            ),
            subtitle: const Text(
              'Deposit rules, advance booking times',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: DineSwiftColors.darkGrey,
              ),
            ),
            hoverColor: DineSwiftColors.softGrey.withOpacity(0.2),
            trailing: const Icon(Iconsax.arrow_right_1, size: 16),
            onTap: () {
              /* Navigate to Booking Policy Screen */
            },
          ),
          DineSwiftDivider(height: 1),
          ListTile(
            leading: const Icon(Iconsax.award, size: 20),
            title: const Text(
              'Loyalty Program Rules',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: DineSwiftColors.blackColor,
              ),
            ),
            subtitle: const Text(
              'Points per spend, tier requirements',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: DineSwiftColors.darkGrey,
              ),
            ),
            hoverColor: DineSwiftColors.softGrey.withOpacity(0.2),
            trailing: const Icon(Iconsax.arrow_right_1, size: 16),
            onTap: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return const Dialog(
                    backgroundColor: DineSwiftColors.whiteColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    ),
                    child: LoyaltyReward(),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
