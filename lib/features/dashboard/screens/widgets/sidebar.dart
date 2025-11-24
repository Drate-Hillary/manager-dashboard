import 'package:dineswift_management/features/authentication/controller/profile_controller.dart';
import 'package:dineswift_management/features/authentication/screen/login.dart';
import 'package:dineswift_management/features/dashboard/controller/dashboard_navigation_controller.dart';
import 'package:dineswift_management/features/dashboard/screens/widgets/profile_setting.dart';
import 'package:dineswift_management/util/constants/image_string.dart';
import 'package:dineswift_management/util/constants/text_strings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:dineswift_management/util/constants/size.dart';
import 'package:dineswift_management/util/constants/colors.dart';
import 'package:iconsax/iconsax.dart';
import 'package:get_storage/get_storage.dart';
import 'package:get/get.dart';

class AppSidebar extends StatefulWidget {
  final DashboardNavigationController controller;
  const AppSidebar({super.key, required this.controller});

  @override
  State<AppSidebar> createState() => _AppSidebarState();
}

class _AppSidebarState extends State<AppSidebar> {
  static const int alphaHover = 13;
  static const int alphaSelected = 26;
  final storage = GetStorage();
  final profileController = Get.put(ProfileController());
  String username = '';
  String email = '';
  String? profileImage;
  bool isSuperuser = false;
  bool isActive = false;

  @override
  void initState() {
    super.initState();
    username = storage.read('user_name') ?? 'User';
    email = storage.read('email') ?? '';
    profileImage = storage.read('profile_image');
    isSuperuser = storage.read('is_superuser') ?? false;
    isActive = storage.read('is_active') ?? false;
  }

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
                    leading: const Icon(CupertinoIcons.home),
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
                    leading: const Icon(Iconsax.messages),
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
                    leading: const Icon(Iconsax.chart_2),
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
                    leading: const Icon(Iconsax.setting_2),
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
              selectedColor: DineSwiftColors.textColor,
              hoverColor: DineSwiftColors.secondaryColor.withAlpha(alphaHover),
              leading: Stack(
                children: [
                  CircleAvatar(
                    backgroundColor: DineSwiftColors.primaryColor,
                    backgroundImage: profileImage != null ? AssetImage(profileImage!) : null,
                    child: profileImage == null
                      ? Text(
                          username.isNotEmpty ? username[0].toUpperCase() : 'U',
                          style: const TextStyle(
                            color: DineSwiftColors.whiteColor,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      : null,
                  ),
                  if (isSuperuser)
                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: Container(
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: DineSwiftColors.successColor,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.verified,
                          size: 12,
                          color: DineSwiftColors.whiteColor,
                        ),
                      ),
                    ),
                ],
              ),
              title: Text(
                username, 
                style: const TextStyle(
                  fontSize: DineSwiftSize.md,
                  color: DineSwiftColors.blackColor,
                  fontWeight: FontWeight.w600
                ),
              ),
              subtitle: Text(
                email, 
                style: const TextStyle(
                  fontSize: DineSwiftSize.smd,
                  color: DineSwiftColors.blackColor,
                  fontWeight: FontWeight.w500,
                  fontStyle: FontStyle.italic
                ),
              ),
              enabled: isActive,
              onTap: () {
                
              },
            ),
          ],
        ),
      ),
    );
  }
}