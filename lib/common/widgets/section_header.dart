import 'package:dineswift_management/util/constants/colors.dart';
import 'package:dineswift_management/util/constants/size.dart';
import 'package:flutter/material.dart';

class SectionHeader extends StatelessWidget {
  const SectionHeader({
    super.key,
    required this.title,
    required this.icon,
    required this.color,
  });

  final String title;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(DineSwiftSize.borderRadiusSm),
            border: Border.all(color: color.withOpacity(0.2)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ]
          ),
          child: Icon(
            icon, 
            color: color, 
            size: DineSwiftSize.iconMd,
          ),
        ),
        const SizedBox(width: DineSwiftSize.sizedBoxWidthSm),
        Text(
          title,
          style: const TextStyle(
            fontSize: DineSwiftSize.fontSizeMd, 
            fontWeight: FontWeight.w600,
            color: DineSwiftColors.blackColor,
          ),
        ),
      ],
    );
  }
}