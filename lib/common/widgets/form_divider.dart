// import 'package:dineswift_management/util/constants/colors.dart';
// import 'package:dineswift_management/util/helpers/helper.dart';
// import 'package:flutter/material.dart';
// import 'package:e_commerce/util/constants/colors.dart';
// import 'package:e_commerce/util/constants/text_strings.dart';
// import 'package:e_commerce/util/helpers/helper_function.dart';
//
//
// // class FormDivider extends StatelessWidget {
//   const FormDivider({
//     super.key,
//     required this.dividerText,
//   });
//
//   final String dividerText;
//
//   @override
//   Widget build(BuildContext context) {
//     final dark = DineSwiftHelperFunctions.isDarkMode(context);
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         Flexible(
//           child: Divider(
//             color: dark ? DineSwiftColors.darkGrey : DineSwiftColors.lightGrey,
//             thickness: 0.5,
//             indent: 60,
//             endIndent: 5,
//           ),
//         ),
//
//         Text(
//           TextStrings.orSignInWith,
//           style: Theme.of(context).textTheme.labelMedium,
//         ),
//
//         Flexible(
//           child: Divider(
//             color: dark ? AppColors.darkGrey : AppColors.lightGrey,
//             thickness: 0.5,
//             indent: 5,
//             endIndent: 60,
//           ),
//         ),
//
//       ],
//     );
//   }
// }
//
