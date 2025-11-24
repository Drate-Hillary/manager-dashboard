import 'package:flutter/material.dart';

class DineSwiftColors {
  DineSwiftColors._();

  static const Gradient linearGradient = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [
      Color(0xff1565C0), 
      Color(0xff42A5F5)
    ],
    stops: [
      0.51, 0.98
    ]
  );

  static const Color primaryColor = Color(0xff1565C0);
  static const Color secondaryColor = Color(0xff42A5F5);
  static const Color lightSecondaryColor = Color.fromARGB(255, 235, 245, 255);
  static const Color backgroundColor = Color(0xFFF5FBFF);
  static const Color iconColor = Color(0xff0D47A1);
  static const Color textColor = Color.fromARGB(255, 11, 60, 134);

  //error and validation colors
  static const Color errorColor = Color(0xffd32f2f);
  static const Color successColor = Color(0xff388e3c);
  static const Color warningColor = Color(0xFFF57C00);
  static const Color infoColor = Color(0xff1976d2);

  // light colors
  static const Color lightErrorColor = Color.fromARGB(255, 255, 211, 211);
  static const Color lightSuccessColor = Color.fromRGBO(213, 251, 215, 1);
  static const Color lightWarningColor = Color.fromARGB(255, 255, 240, 210);
  static const Color lightInfoColor = Color.fromARGB(255, 210, 237, 255);
  static const Color lightTextColor = Color.fromARGB(255, 25, 118, 210);

  // neutral colors
  static const Color whiteColor = Color(0xffffffff);
  static const Color blackColor = Color(0xff000000);
  static const Color softGrey = Color(0xffeeeeee);
  static const Color lightGrey = Color(0xffe0e0e0);
  static const Color darkerGrey = Color(0xff4f4f4f);
  static const Color darkGrey = Color(0xff939393);
}