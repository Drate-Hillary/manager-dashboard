import 'package:flutter/material.dart';

class DineSwiftColors {
  DineSwiftColors._();

  static const Gradient linearGradient = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [
      Color(0xffc34c16), 
      Color(0xffee9c77)
    ],
    stops: [
      0.51, 0.98
    ]
  );

  static const Color primaryColor = Color(0xffc34c16);
  static const Color secondaryColor = Color(0xffee9c77);
  static const Color lightSecondaryColor = Color.fromARGB(255, 255, 244, 236);
  static const Color backgroundColor = Color(0xFFFFF1EB);
  static const Color iconColor = Color(0xff9b3f15);
  static const Color textColor = Color.fromARGB(255, 137, 56, 18);

  //error and validation colors
  static const Color errorColor = Color(0xffd32f2f);
  static const Color successColor = Color(0xff388e3c);
  static const Color warningColor = Color(0xFFF57C00);
  static const Color infoColor = Color(0xff1976d2);

  // neutral colors
  static const Color whiteColor = Color(0xffffffff);
  static const Color blackColor = Color(0xff000000);
  static const Color softGrey = Color(0xffeeeeee);
  static const Color lightGrey = Color(0xffe0e0e0);
  static const Color darkerGrey = Color(0xff4f4f4f);
  static const Color darkGrey = Color(0xff939393);
}