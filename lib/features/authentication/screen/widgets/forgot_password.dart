import 'package:dineswift_management/features/authentication/screen/widgets/verifcation_code.dart';
import 'package:dineswift_management/util/constants/colors.dart';
import 'package:dineswift_management/util/constants/size.dart';
import 'package:dineswift_management/util/constants/text_strings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    int alpha = (0.98 * 255).round();
    return Scaffold(
      backgroundColor: DineSwiftColors.whiteColor.withAlpha(alpha),

      body: Center(
        child: Container(
          width: 600,
          height: 350,

          decoration: BoxDecoration(
            color: DineSwiftColors.whiteColor, 
            boxShadow: [
              BoxShadow(
                color: DineSwiftColors.blackColor.withAlpha(10),
                blurRadius: 10,
                offset: const Offset(0, 5)
              )
            ],
            borderRadius: BorderRadius.circular(
              DineSwiftSize.cardRadiusSm,
            ),
            border: Border.all(
              color: DineSwiftColors.darkGrey.withAlpha(20)
            )
          ),
          padding: const EdgeInsets.symmetric(horizontal: DineSwiftSize.lg),

          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                DineSwiftTextStrings.forgetPasswordTitle,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 28.5,
                  color: Color(0xFF2D2D2D),
                ),
                textAlign: TextAlign.center,
              ),
              const Text(
                DineSwiftTextStrings.forgotPasswordSubTitle,
                style: TextStyle(
                  fontSize: 16,
                  color: Color(0xFF6B7280),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  DineSwiftTextStrings.employeeIdOrEmail,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[800],
                  ),
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                decoration: InputDecoration(
                  prefixIcon: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: const Icon(Iconsax.user, size: 25),
                  ),
                  hintText: DineSwiftTextStrings.employeeIdOrEmailHint,
                  hintStyle: const TextStyle(
                    fontSize: 16,
                    color: Color(0xFF2D2D2D),
                  ),
                  filled: true,
                  focusColor: DineSwiftColors.whiteColor,
                  fillColor: DineSwiftColors.whiteColor,
                  hoverColor: DineSwiftColors.whiteColor,
                  border: UnderlineInputBorder(
                    borderSide: const BorderSide(color: DineSwiftColors.darkGrey),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 16,
                    horizontal: 20,
                  ),
                  focusedBorder: UnderlineInputBorder( 
                    borderSide: const BorderSide(color: DineSwiftColors.primaryColor),
                  ),
                ),
              ),
              const SizedBox(height: DineSwiftSize.sizedBoxHeightLg),
              SizedBox(
                width: 320,
                height: 48,
                child: ElevatedButton(
                  onPressed: () {
                    Get.to(()=> VerificationCodeScreen());
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF3B82F6),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    DineSwiftTextStrings.continueButton,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 8),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.all(0),
                  backgroundColor: DineSwiftColors.whiteColor,
                  foregroundColor: DineSwiftColors.whiteColor,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(Iconsax.arrow_left, color: Colors.grey[800], size: 20),
                    const SizedBox(width: 8),
                    const Text(
                      DineSwiftTextStrings.backToLogin,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF6B7280),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
