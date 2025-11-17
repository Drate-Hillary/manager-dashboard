import 'package:dineswift_management/features/system_configuration/screens/widgets/add_menu.dart';
import 'package:dineswift_management/features/system_configuration/screens/widgets/register_restaurant.dart';
import 'package:dineswift_management/util/common/divider.dart';
import 'package:dineswift_management/util/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class RestaurantSettings extends StatelessWidget {
  const RestaurantSettings({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: DineSwiftColors.whiteColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: ExpansionTile(
        leading: const Icon(
          Iconsax.shop,
          color: DineSwiftColors.infoColor,
          size: 25,
        ),
        title: Text(
          'Restaurant Settings',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        subtitle: const Text(
          'Menu, tables, operating hours',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
        ),
        initiallyExpanded: true,
        childrenPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 8,
        ),
        expandedCrossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            leading: const Icon(Iconsax.document_upload, size: 20),
            title: const Text(
              'Menu Management',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: DineSwiftColors.blackColor,
              ),
            ),
            subtitle: const Text(
              'Edit categories, items, prices, availability',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: DineSwiftColors.darkGrey,
              ),
            ),
            trailing: const Icon(Iconsax.arrow_right_1, size: 16),
            hoverColor: DineSwiftColors.softGrey.withOpacity(0.2),
            onTap: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return const Dialog(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    ),
                    child: AddMenu(),
                  );
                },
              );
            },
          ),
          DineSwiftDivider(height: 1),
          ListTile(
            leading: const Icon(Iconsax.map_1, size: 20),
            title: const Text(
              'Table Layout Setup',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: DineSwiftColors.blackColor,
              ),
            ),
            subtitle: const Text(
              'Configure table map and capacity',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: DineSwiftColors.darkGrey,
              ),
            ),
            trailing: const Icon(Iconsax.arrow_right_1, size: 16),
            hoverColor: DineSwiftColors.softGrey.withOpacity(0.2),
            onTap: () {
              /* Navigate to Table Layout Editor */
            },
          ),
          DineSwiftDivider(height: 1),
          ListTile(
            leading: const Icon(Iconsax.pen_add, size: 20),
            title: const Text(
              'Register a Restaurant',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: DineSwiftColors.blackColor,
              ),
            ),
            subtitle: const Text(
              'Add or modify restaurant details',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: DineSwiftColors.darkGrey,
              ),
            ),
            trailing: const Icon(Iconsax.arrow_right_1, size: 16),
            hoverColor: DineSwiftColors.softGrey.withOpacity(0.2),
            onTap: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return const Dialog(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    ),
                    child: RestaurantRegistrationForm(),
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
