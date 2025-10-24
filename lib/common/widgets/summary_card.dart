import 'package:flutter/material.dart';
import 'package:dineswift_management/util/constants/colors.dart';
import 'package:dineswift_management/util/constants/size.dart';


class SummaryCard extends StatelessWidget {
  const SummaryCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  final String title;
  final String value;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Card(
        color: DineSwiftColors.whiteColor,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Icon(
                      icon,
                      color: color,
                      size: DineSwiftSize.iconMdx,
                    ),
                  ),
                  const SizedBox(width: DineSwiftSize.spaceBtwItems),
                  Expanded(
                    child: Text(
                      title,
                      style: const TextStyle(fontSize: DineSwiftSize.md, color: DineSwiftColors.blackColor, fontWeight: FontWeight.w500),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                value,
                style: const TextStyle(
                  fontSize: DineSwiftSize.fontSizeLg,
                  fontWeight: FontWeight.bold,
                ),
              ),
              
            ],
          ),
        ),
      ),
    );
  }
}