import 'package:dineswift_management/features/dashboard/controller/dashboard_navigation_controller.dart';
import 'package:dineswift_management/util/constants/image_string.dart';
import 'package:dineswift_management/util/constants/text_strings.dart';
import 'package:flutter/material.dart';
import 'package:dineswift_management/util/constants/size.dart';
import 'package:dineswift_management/util/constants/colors.dart';
import 'package:iconsax/iconsax.dart';

class AppSidebar extends StatefulWidget {
  final DashboardNavigationController controller;
  const AppSidebar({super.key, required this.controller});

  @override
  State<AppSidebar> createState() => _AppSidebarState();
}

class _AppSidebarState extends State<AppSidebar> {
  static const int alphaHover = 13;
  static const int alphaSelected = 26;
  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: 250,
      backgroundColor: DineSwiftColors.whiteColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.zero,
      ),
      child: Container(
        decoration: BoxDecoration(
          border: Border(right: BorderSide(color: DineSwiftColors.primaryColor, width: 1.0)),
        ),
        child: Column(
          children: [
            Container(
              height: 80,
              decoration: const BoxDecoration(
                color: DineSwiftColors.primaryColor,
              ),
              padding: const EdgeInsets.all(16),
              child: const Row(
                children: [
                  Icon(
                    Icons.restaurant_menu,
                    size: DineSwiftSize.xl,
                    color: DineSwiftColors.backgroundColor,
                  ),
                  SizedBox(width: 12),
                  Text(
                    DineSwiftTextStrings.appName,
                    style: TextStyle(
                      color: DineSwiftColors.backgroundColor,
                      fontSize: DineSwiftSize.xl,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(vertical: DineSwiftSize.spaceBtwSections),
                children: [
                  ListTile(
                    leading: const Icon(Iconsax.home),
                    title: const Text(
                      DineSwiftTextStrings.dashboard,
                      style: TextStyle(
                        fontSize: DineSwiftSize.md,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    selected: widget.controller.selectedIndex == 0,
                    selectedTileColor: DineSwiftColors.secondaryColor.withAlpha(alphaSelected),
                    selectedColor: DineSwiftColors.textColor,
                    hoverColor: DineSwiftColors.secondaryColor.withAlpha(alphaHover),
                    onTap: () {
                      widget.controller.selectScreen(0);
                    },
                  ),

                  ListTile(
                    leading: const Icon(Iconsax.box),
                    title: const Text(
                      DineSwiftTextStrings.inventoryAndSupplies,
                      style: TextStyle(
                        fontSize: DineSwiftSize.md,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    selected: widget.controller.selectedIndex == 1,
                    selectedTileColor: DineSwiftColors.secondaryColor.withAlpha(alphaSelected),
                    selectedColor: DineSwiftColors.textColor,
                    hoverColor: DineSwiftColors.secondaryColor.withAlpha(alphaHover),
                    onTap: () {
                      widget.controller.selectScreen(1);
                    },
                  ),

                  ListTile(
                    leading: const Icon(Iconsax.activity),
                    title: const Text(
                      DineSwiftTextStrings.operationsAndDispatch,
                      style: TextStyle(
                        fontSize: DineSwiftSize.md,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    selected: widget.controller.selectedIndex == 2,
                    selectedTileColor: DineSwiftColors.secondaryColor.withAlpha(alphaSelected),
                    selectedColor: DineSwiftColors.textColor,
                    hoverColor: DineSwiftColors.secondaryColor.withAlpha(alphaHover),
                    onTap: () {
                      widget.controller.selectScreen(2);
                    },
                  ),

                  ListTile(
                    leading: const Icon(Iconsax.star),
                    title: const Text(
                      DineSwiftTextStrings.loyaltyProgram,
                      style: TextStyle(
                        fontSize: DineSwiftSize.md,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    selected: widget.controller.selectedIndex == 3,
                    selectedTileColor: DineSwiftColors.secondaryColor.withAlpha(alphaSelected),
                    selectedColor: DineSwiftColors.textColor,
                    hoverColor: DineSwiftColors.secondaryColor.withAlpha(alphaHover),
                    onTap: () {
                      widget.controller.selectScreen(3);
                    },
                  ),
                  
                  ListTile(
                    leading: const Icon(Iconsax.message_question),
                    title: const Text(
                      DineSwiftTextStrings.customerCommunication,
                      style: TextStyle(
                        fontSize: DineSwiftSize.md,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    selected: widget.controller.selectedIndex == 4,
                    selectedTileColor: DineSwiftColors.secondaryColor.withAlpha(alphaSelected),
                    selectedColor: DineSwiftColors.textColor,
                    hoverColor: DineSwiftColors.secondaryColor.withAlpha(alphaHover),
                    onTap: () {
                      widget.controller.selectScreen(4);
                    },
                  ),

                  ListTile(
                    leading: const Icon(Iconsax.graph),
                    title: const Text(
                      DineSwiftTextStrings.analyticsAndReports,
                      style: TextStyle(
                        fontSize: DineSwiftSize.md,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    selected: widget.controller.selectedIndex == 5,
                    selectedTileColor: DineSwiftColors.secondaryColor.withAlpha(alphaSelected),
                    selectedColor: DineSwiftColors.textColor,
                    hoverColor: DineSwiftColors.secondaryColor.withAlpha(alphaHover),
                    onTap: () {
                      widget.controller.selectScreen(5);
                    },
                  ),
                  
                  ListTile(
                    leading: const Icon(Iconsax.setting),
                    title: const Text(
                      DineSwiftTextStrings.systemConfiguration,
                      style: TextStyle(
                        fontSize: DineSwiftSize.md,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    selected: widget.controller.selectedIndex == 6,
                    selectedTileColor: DineSwiftColors.secondaryColor.withAlpha(alphaSelected),
                    selectedColor: DineSwiftColors.textColor,
                    hoverColor: DineSwiftColors.secondaryColor.withAlpha(alphaHover),
                    onTap: () {
                      widget.controller.selectScreen(6);
                    },
                  ),
                ],
              ),
            ),

            const Divider(color: DineSwiftColors.primaryColor),

            ListTile(
              leading: CircleAvatar(
                backgroundImage: AssetImage(DineSwiftImages.managerAvatar),
              ),
              title: const Text(
                'John Doe', 
                style: TextStyle(
                  fontSize: DineSwiftSize.md,
                  color: DineSwiftColors.blackColor,
                  fontWeight: FontWeight.w600
                ),
              ),
              subtitle: const Text(
                'johndoe@gmail.com', 
                style: TextStyle(
                  fontSize: DineSwiftSize.smd,
                  color: DineSwiftColors.blackColor,
                  fontWeight: FontWeight.w500,
                  fontStyle: FontStyle.italic
                ),
              ),

              onTap: () {
                // Handle logout
              },
            ),
          ],
        ),
      ),
    );
  }
}