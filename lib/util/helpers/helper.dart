import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';

class DineSwiftHelperFunctions {

  static Color? getColor(String value){

    if (value == "green"){
      return Colors.green;
    } else if (value == "red"){
      return Colors.red;
    } else if (value == "blue"){
      return Colors.blue;
    } else if (value == "yellow"){
      return Colors.yellow;
    } else if (value == "black"){
      return Colors.black;
    } else if (value == "white"){
      return Colors.white;
    } else if (value == "grey"){
      return Colors.grey;
    }else if (value == "purple"){
      return Colors.purple;
    } else if (value == "orange"){
      return Colors.orange;
    } else if (value == "pink"){
      return Colors.pink;
    } else if (value == "brown"){
      return Colors.brown;
    } else if (value == "cyan"){
      return Colors.cyan;
    } else if (value == "teal"){
      return Colors.teal;
    } else if (value == "indigo"){
      return Colors.indigo;
    } else if (value == "lime"){
      return Colors.lime;
    } else if (value == "amber"){
      return Colors.amber;
    } else if (value == "deepOrange"){
      return Colors.deepOrange;
    } else if (value == "deepPurple"){
      return Colors.deepPurple;
    } else if (value == "lightBlue"){
      return Colors.lightBlue;
    } else if (value == "lightGreen"){
      return Colors.lightGreen;
    } else if (value == "deepPurpleAccent"){
      return Colors.deepPurpleAccent;
    } else if (value == "blueGrey"){
      return Colors.blueGrey;
    } else if (value == "transparent"){
      return Colors.transparent;
    }  else {
      return null;
    }
  }

  static String showSnackbar(String title, String message) {
    ScaffoldMessenger.of(Get.context!).showSnackBar(
      SnackBar(
        content: Text('$title: $message'),
      ),
    );
    return message;
  }

  static String showAlert(String title, String message) {
    showDialog(
      context: Get.context!,
      builder: (BuildContext context ) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
    return message;
  }

  static void navigateToScreen(BuildContext context, Widget screen) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => screen),
    );
  }

  static String truncateText(String text, int maxLength) {
    if (text.length <= maxLength) {
      return text;
    } else {
      return '${text.substring(0, maxLength)}...';
    }
  }

  static bool isDarkMode(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark;
  }

  static Size getScreenSize() {
    return MediaQuery.of(Get.context!).size;
  }

  static double getScreenWidth() {
    return MediaQuery.of(Get.context!).size.width;
  }

  static double getScreenHeight() {
    return MediaQuery.of(Get.context!).size.height;
  }

  static String getFormattedDate(DateTime date, {String format = 'dd MMM yyyy'}) {
    return DateFormat(format).format(date);
  }

  static List<Widget> wrapWidgets(List<Widget> widgets, int rowSize) {
    List<Widget> wrappedWidgets = [];
    for (var i = 0; i < widgets.length; i += rowSize) {
      int end = (i + rowSize < widgets.length) ? i + rowSize : widgets.length;
      wrappedWidgets.add(Row(children: widgets.sublist(i, end)));
    }
    return wrappedWidgets;
  }
}