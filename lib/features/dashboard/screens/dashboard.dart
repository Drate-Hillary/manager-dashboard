import 'package:badges/badges.dart' as badges;
import 'package:dineswift_management/features/dashboard/controller/dashboard_navigation_controller.dart';
import 'package:dineswift_management/util/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'widgets/sidebar.dart';

class DineSwiftDashboard extends StatefulWidget {
  const DineSwiftDashboard({super.key});

  @override
  State<DineSwiftDashboard> createState() => _DineSwiftDashboardState();
}

class _DineSwiftDashboardState extends State<DineSwiftDashboard> {
  final DashboardNavigationController _controller = DashboardNavigationController();

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onScreenChanged);
  }

  @override
  void dispose() {
    _controller.removeListener(_onScreenChanged);
    _controller.dispose();
    super.dispose();
  }

  void _onScreenChanged() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Row(
        children: [
          AppSidebar(controller: _controller),
          Expanded(
            child: Scaffold(
              appBar: AppBar(
                centerTitle: false,
                automaticallyImplyLeading: false,
                backgroundColor: DineSwiftColors.primaryColor,
                actions: [
                  badges.Badge(
                    badgeContent: const Text('3', style: TextStyle(color: Colors.white)),
                    child: const CircleAvatar(
                      backgroundColor: DineSwiftColors.secondaryColor,
                      child: Icon(Iconsax.notification, color: DineSwiftColors.whiteColor),
                    ),
                  ),
                  const SizedBox(width: 20),
                ],
              ),
              body: _controller.currentScreen,
            ),
          ),
        ],
      ),
    );
  }
}
