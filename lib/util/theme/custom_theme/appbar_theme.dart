import 'package:flutter/material.dart';
import 'package:dineswift_management/util/constants/colors.dart';

class CustomAppbarTheme {
  CustomAppbarTheme._();
  static int opacity = (0.5 * 255).round();

  static const dineSwiftAppBarTheme = AppBarTheme(
    elevation: 3,
    centerTitle: false,
    shadowColor: DineSwiftColors.lightGrey,
    scrolledUnderElevation: 0,
    backgroundColor: DineSwiftColors.whiteColor,
    surfaceTintColor: Colors.transparent,
    iconTheme: IconThemeData(color: Color.fromARGB(255, 107, 61, 4), size: 24.0),
    actionsIconTheme: IconThemeData(color: Color.fromARGB(255, 107, 61, 4), size: 24.0),
    titleTextStyle: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w600, color: Colors.black),
  );
}