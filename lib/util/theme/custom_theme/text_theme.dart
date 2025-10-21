import 'package:flutter/material.dart';

class CustomTextTheme {
  CustomTextTheme._();

  static int opacity = (0.5 * 255).round();

  static TextTheme dineSwiftTextTheme = TextTheme(
    headlineLarge: const TextStyle(). copyWith(
      color: Colors.black,
      fontSize: 32,
      fontWeight: FontWeight.bold,
    ),
    headlineMedium: const TextStyle(). copyWith(
      color: Colors.black,
      fontSize: 28,
      fontWeight: FontWeight.w600,
    ),
    headlineSmall: const TextStyle(). copyWith(
      color: Colors.black,
      fontSize: 18,
      fontWeight: FontWeight.w400,
    ),

    titleLarge: const TextStyle(). copyWith(
      color: Colors.black,
      fontSize: 16,
      fontWeight: FontWeight.w600,
    ),
    titleMedium: const TextStyle(). copyWith(
      color: Colors.black,
      fontSize: 16,
      fontWeight: FontWeight.w500,
    ),
    titleSmall: const TextStyle(). copyWith(
      color: Colors.black,
      fontSize: 16,
      fontWeight: FontWeight.w400,
    ),

    bodyLarge: const TextStyle(). copyWith(
      color: Colors.black,
      fontSize: 14,
      fontWeight: FontWeight.w500,
    ),
    bodyMedium: const TextStyle(). copyWith(
      color: Colors.black,
      fontSize: 14,
      fontWeight: FontWeight.normal,
    ),
    bodySmall: const TextStyle(). copyWith(
      color: Colors.black.withAlpha(opacity),
      fontSize: 14,
      fontWeight: FontWeight.w400,
    ),

    labelLarge: const TextStyle(). copyWith(
      color: Colors.black,
      fontSize: 12,
      fontWeight: FontWeight.normal,
    ),
    labelMedium: const TextStyle(). copyWith(
      color: Colors.black,
      fontSize: 12,
      fontWeight: FontWeight.normal,
    ),
  );

  
}