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
    
    int alpha = (0.2 * 255).round();
    return Card(
      shadowColor: DineSwiftColors.softGrey.withAlpha(70),
      elevation: 8,
      color: DineSwiftColors.whiteColor,
      shape: RoundedRectangleBorder(
        side: const BorderSide(color: DineSwiftColors.softGrey, width: 1),
        borderRadius: BorderRadius.circular(8)
      ),
      child: Column(
        children: [
          const ListTile(
            leading: Icon(
              Iconsax.shop,
              color: DineSwiftColors.infoColor,
              size: 25,
            ),
            title: Text(
              'Restaurant Settings',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            subtitle: Text(
              'Menu, tables, operating hours',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: DineSwiftDivider(height: 1),
          ),
          const SizedBox(height: 8),
          ListTile(
            leading: const Icon(Iconsax.document_upload, size: 20),
            focusColor: DineSwiftColors.softGrey.withAlpha(alpha),
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
            hoverColor: DineSwiftColors.softGrey.withAlpha(alpha),
            onTap: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return const Dialog(
                    backgroundColor: DineSwiftColors.whiteColor,
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
            hoverColor: DineSwiftColors.softGrey.withAlpha(alpha),
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
            hoverColor: DineSwiftColors.softGrey.withAlpha(alpha),
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
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}
