import 'package:flutter/material.dart';

class CustomCheckBoxTheme{
  CustomCheckBoxTheme._();

  static CheckboxThemeData dineSwiftCheckBoxTheme = CheckboxThemeData(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      checkColor: WidgetStateProperty.resolveWith((states) {
        if(states.contains(WidgetState.selected)){
          return const Color.fromARGB(255, 245, 195, 142);
        }else{
          return Colors.black;
        }
      }),
      fillColor: WidgetStateProperty.resolveWith((states){
        if (states.contains(WidgetState.selected)) {
          return const Color.fromARGB(255, 243, 135, 33);
        } else {
          return Colors.transparent;
        }
      })
  );


}