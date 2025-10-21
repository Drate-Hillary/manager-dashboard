import 'package:flutter/material.dart';

class CustomAppbarTheme {
  CustomAppbarTheme._();

  static const DineSwiftAppBarTheme = AppBarTheme(
    elevation: 0,
    centerTitle: false,
    scrolledUnderElevation: 0,
    backgroundColor: Color.fromARGB(0, 168, 81, 19),
    surfaceTintColor: Colors.transparent,
    iconTheme: IconThemeData(color: Color.fromARGB(255, 107, 61, 4), size: 24.0),
    actionsIconTheme: IconThemeData(color: Color.fromARGB(255, 107, 61, 4), size: 24.0),
    titleTextStyle: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w600, color: Colors.black),
  );
}