import 'package:dineswift_management/util/theme/custom_theme/checkbox_theme.dart';
import 'package:dineswift_management/util/theme/custom_theme/text_theme.dart';
import 'package:flutter/material.dart';

import 'package:dineswift_management/util/theme/custom_theme/appbar_theme.dart';



// import 'package:e_commerce_app/util/theme/custom_theme/text_theme.dart';
// import 'package:e_commerce_app/util/theme/custom_theme/appbar_theme.dart';
// import 'package:e_commerce_app/util/theme/custom_theme/bottom_sheet_theme.dart';
// import 'package:e_commerce_app/util/theme/custom_theme/checkbox_theme.dart';
// import 'package:e_commerce_app/util/theme/custom_theme/chip_theme.dart';
// import 'package:e_commerce_app/util/theme/custom_theme/custom_text_form_field.dart';
// import 'package:e_commerce_app/util/theme/custom_theme/elevated_button_theme.dart';


class AppTheme {
  AppTheme._();

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    fontFamily: 'Poppins',
    brightness: Brightness.light,
    scaffoldBackgroundColor: Colors.white,
    primaryColor: Colors.blue,
    textTheme: CustomTextTheme.dineSwiftTextTheme,
    appBarTheme: CustomAppbarTheme.dineSwiftAppBarTheme,
    checkboxTheme: CustomCheckBoxTheme.dineSwiftCheckBoxTheme,
  );
}