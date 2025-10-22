import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:dineswift_management/util/constants/colors.dart';
import 'package:dineswift_management/util/constants/size.dart';

class DashboardOverview extends StatelessWidget {
  const DashboardOverview({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Row( 
              // Wrap the icon and text in a Row
              children: [
                Icon(Iconsax.home, size: 32.0, color: DineSwiftColors.iconColor),
                const SizedBox(width: DineSwiftSize.spaceBtwItems),
                Text(
                  'Daily Overview',
                  style: TextStyle(
                    fontSize: DineSwiftSize.xl,
                    fontWeight: FontWeight.bold,
                    color: DineSwiftColors.primaryColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16.0),
            buildingCards(context),

            const SizedBox(height: 24.0),

            // 2. Sales Over Time (Bar Chart)
            Text(
              "Today's Revenue by Hour",
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 16.0),
            buildSalesChartPlaceholder(),

            const SizedBox(height: 24.0),

            // 3. Live Order Feed & Top Selling Items (in a responsive layout)
            LayoutBuilder(
              builder: (context, constraints) {
                if (constraints.maxWidth > 600) {
                  // Wide screen: Show side-by-side
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(child: buildLiveOrderFeed(context)),
                      const SizedBox(width: 16.0),
                      Expanded(child: _buildTopSellingItems(context)),
                    ],
                  );
                } else {
                  // Narrow screen: Stack vertically
                  return Column(
                    children: [
                      buildLiveOrderFeed(context),
                      const SizedBox(height: 24.0),
                      _buildTopSellingItems(context),
                    ],
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  /// Builds the responsive row of KPI cards
  Widget buildingCards(BuildContext context) {
    return const Wrap(
      spacing: DineSwiftSize.spaceBtwCards,
      runSpacing: DineSwiftSize.xs,
      children: [
        KpiCard(
          title: "Today's Revenue",
          value: "UGX 111,450", // Example data
          icon: Iconsax.wallet,
          color: Colors.green,
        ),
        KpiCard(
          title: "Active Orders",
          value: "12", 
          icon: Iconsax.shopping_cart,
          color: Colors.blue,
        ),
        KpiCard(
          title: "Bookings Today",
          value: "28",
          icon: Iconsax.calendar,
          color: Colors.orange,
        ),
        KpiCard(
          title: "Low-Stock Alerts",
          value: "3", // Example data
          icon: Iconsax.warning_2,
          color: Colors.red,
        ),
      ],
    );
  }

  /// Placeholder for the Sales Bar Chart
  Widget buildSalesChartPlaceholder() {
    return Card(
      elevation: 2.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(DineSwiftSize.cardRadiusMd)),
      color: DineSwiftColors.whiteColor,
      child: Container(
        height: 300,
        padding: const EdgeInsets.all(10.0),
        alignment: Alignment.center,
        child: const Text(
          'Bar Chart Placeholder\n(Add a library like fl_chart)',
          textAlign: TextAlign.center,
          style: TextStyle(color: DineSwiftColors.blackColor),
        ),
      ),
    );
  }

  /// Builds the Live Order Feed list
  Widget buildLiveOrderFeed(BuildContext context) {
    return Card(
      elevation: 2.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      color: DineSwiftColors.whiteColor,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Live Order Feed',
              style: TextStyle(
                fontSize: DineSwiftSize.fontSizeLg,
                fontWeight: FontWeight.w600
              ),
            ),
            const Divider(),
            // Example list items
            ListTile(
              title: const Text('Order #105 - Table 5'),
              subtitle: const Text('2x Burger, 1x Fries'),
              trailing: Chip(
                label: const Text('Preparing', style: TextStyle(color: Colors.white)),
                backgroundColor: Colors.blue.shade700,
                padding: EdgeInsets.zero,
              ),
            ),
            ListTile(
              title: const Text('Order #104 - Table 2'),
              subtitle: const Text('1x Steak, 1x Salad'),
              trailing: Chip(
                label: const Text('New', style: TextStyle(color: Colors.white)),
                backgroundColor: Colors.green.shade700,
                padding: EdgeInsets.zero,
              ),
            ),
            ListTile(
              title: const Text(
                'Order #103 - Delivery',
                style: TextStyle(
                  fontSize: DineSwiftSize.fontSizeMd,
                  fontWeight: FontWeight.w500
                ),
              ),
              leading: const Icon(Icons.motorcycle_outlined), // Changed 'icon' to 'leading' and wrapped in Icon widget
              subtitle: const Text(
                '4x Pizza',
                style: TextStyle(
                  fontWeight: FontWeight.w500
                ),
              ),
              trailing: Badge(
                label: const Text('Out for Delivery', style: TextStyle(color: Colors.white, fontSize: DineSwiftSize.fontSizeSm)),
                backgroundColor: DineSwiftColors.primaryColor,
                padding: const EdgeInsets.symmetric(horizontal: 4.0),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Builds the Top Selling Items list
  Widget _buildTopSellingItems(BuildContext context) {
    return Card(
      elevation: 2.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      color: DineSwiftColors.lightSecondaryColor,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Top Selling Items',
              style: TextStyle(
                fontSize: DineSwiftSize.fontSizeLg,
                fontWeight: FontWeight.w600
              ),
            ),
            Divider(color: DineSwiftColors.primaryColor),
            // Example list items
            const ListTile(
              leading: CircleAvatar(backgroundColor: DineSwiftColors.primaryColor, child: Text('1', style: TextStyle(color: DineSwiftColors.whiteColor))),
              title: Row(
                children: [
                  Icon(Icons.fastfood_outlined),
                  SizedBox(width: 8),
                  Text('Classic Burger'),
                ],
              ),
              trailing: Text('42 sold'),
            ),
            const ListTile(
              leading: CircleAvatar(backgroundColor: DineSwiftColors.secondaryColor, child: Text('2', style: TextStyle(color: DineSwiftColors.whiteColor))),
              title: Row(
                children: [
                  Icon(Icons.local_pizza_outlined),
                  SizedBox(width: 8),
                  Text('Pizza'),
                ],
              ),
              trailing: Text('31 sold'),
            ),
            const ListTile(
              leading: CircleAvatar(backgroundColor: DineSwiftColors.secondaryColor, child: Text('3', style: TextStyle(color: DineSwiftColors.whiteColor))),
              title: Row(
                children: [
                  Icon(Iconsax.glass),
                  SizedBox(width: 8),
                  Text('Soda'),
                ],
              ),
              trailing: Text('25 sold'),
            ),
          ],
        ),
      ),
    );
  }
}

/// A reusable widget for the KPI cards
class KpiCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const KpiCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
      color: DineSwiftColors.whiteColor, // Set the background color of the card
      child: Container(
        width: 220, 
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  icon, 
                  size: DineSwiftSize.iconLg, 
                  color: color
                ),
                const SizedBox(width: DineSwiftSize.spaceBtwItems),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: DineSwiftSize.fontSizeMd,
                    fontWeight: FontWeight.w600
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12.0),
            Text(
              value,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 6.0,),
            Divider(
              height: 24.0,
              color: color,
            ), 
            
          ],
        ),
      ),
    );
  }
}