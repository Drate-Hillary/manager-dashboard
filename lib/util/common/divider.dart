import 'package:flutter/material.dart';
import 'package:dineswift_management/util/constants/colors.dart';

class DineSwiftDivider extends StatelessWidget {
  const DineSwiftDivider({
    super.key,
    this.height = 1,
    this.color = DineSwiftColors.softGrey,
  });

  final double height;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Divider(height: height, color: color);
  }
}