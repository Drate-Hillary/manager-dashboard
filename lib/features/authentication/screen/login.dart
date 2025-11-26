import 'package:dineswift_management/features/authentication/screen/sign_up.dart';
import 'package:dineswift_management/features/authentication/screen/widgets/forgot_password.dart';
import 'package:dineswift_management/features/authentication/services/auth_service.dart';
import 'package:dineswift_management/features/dashboard/screens/dashboard.dart';
import 'package:dineswift_management/util/constants/colors.dart';
import 'package:dineswift_management/util/constants/image_string.dart';
import 'package:dineswift_management/util/constants/size.dart';
import 'package:dineswift_management/util/constants/text_strings.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:iconsax/iconsax.dart';
class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {    
    return LoginScreenContent();
  }
}

class LoginScreenContent extends StatefulWidget {
  const LoginScreenContent({super.key});

  @override
  State<LoginScreenContent> createState() => LoginScreenContentState();
}

class LoginScreenContentState extends State<LoginScreenContent> {
  bool isPasswordVisible = false;
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool isLoading = false;

  Future<void> handleLogin() async {
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      Fluttertoast.showToast(
        msg: "Email and password are required",
        backgroundColor: DineSwiftColors.errorColor,
        textColor: DineSwiftColors.whiteColor,
      );
      return;
    }

    setState(() => isLoading = true);
    try {
      final user = await AuthService.login(
        email: emailController.text,
        password: passwordController.text,
      );

      if (user != null) {
        final storage = GetStorage();
        await storage.write('user_id', user['id']);
        await storage.write('user_name', user['username']);
        await storage.write('email', user['email']);
        await storage.write('is_superuser', user['is_superuser']);
        await storage.write('is_active', user['is_active']);

        Fluttertoast.showToast(
          msg: "Login Successful",
          backgroundColor: DineSwiftColors.successColor,
          textColor: DineSwiftColors.whiteColor,
        );
        Get.offAll(() => DineSwiftDashboard());
      } else {
        Fluttertoast.showToast(
          msg: "Invalid email or password",
          backgroundColor: DineSwiftColors.errorColor,
          textColor: DineSwiftColors.whiteColor,
        );
      }
    } catch (e) {
      Fluttertoast.showToast(
        msg: e.toString().replaceAll('Exception: ', ''),
        backgroundColor: DineSwiftColors.errorColor,
        textColor: DineSwiftColors.whiteColor,
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    int alpha = (0.98 * 255).round();
    return Scaffold(
      backgroundColor: DineSwiftColors.whiteColor.withAlpha(alpha),
      body: Center(
        child: Container(
          height: 400,
          width: 700,

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
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded( 
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      DineSwiftTextStrings.loginTitle,
                      style: TextStyle(
                        fontSize: DineSwiftSize.fontSizeXxxl,
                        fontWeight: FontWeight.bold,
                        color: DineSwiftColors.blackColor,
                        
                      ),
                    ),

                    const SizedBox(height: DineSwiftSize.sizedBoxHeightLg),

                    // email field
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        DineSwiftTextStrings.email,
                        style: TextStyle(
                          fontSize: DineSwiftSize.fontSizeMd,
                          fontWeight: FontWeight.w500,
                          color: DineSwiftColors.darkerGrey,
                        ),
                      ),
                    ),
                    TextField(
                      controller: emailController,
                      decoration: InputDecoration(
                        hintText: DineSwiftTextStrings.emailHint,
                        prefixIcon: const Icon(Iconsax.user),
                        filled: true,
                        fillColor: DineSwiftColors.whiteColor,
                        focusColor: DineSwiftColors.whiteColor,
                        hoverColor: DineSwiftColors.whiteColor,
                        enabledBorder: UnderlineInputBorder(
                          borderSide: const BorderSide(color: DineSwiftColors.darkGrey),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: const BorderSide(
                            color: DineSwiftColors.primaryColor,
                            width: 1.5
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: DineSwiftSize.sizedBoxHeightMd),

                    // Password field
                    Row(
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            DineSwiftTextStrings.password,
                            style: const TextStyle(
                              fontSize: DineSwiftSize.fontSizeMd,
                              fontWeight: FontWeight.w500,
                              color: DineSwiftColors.darkerGrey,
                            ),
                          ),
                        ),

                        const Spacer(),

                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () {
                              Get.to(()=> ForgotPasswordScreen());
                            },
                            child: const Text(
                              DineSwiftTextStrings.forgotPassword,
                              style: TextStyle(
                                color: DineSwiftColors.primaryColor,
                                fontSize: DineSwiftSize.fontSizeSm,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),

                        ),
                      ],
                    ),
                    TextField(
                      controller: passwordController,
                      obscureText: !isPasswordVisible,
                      decoration: InputDecoration(
                        hintText: DineSwiftTextStrings.passwordHint,
                        prefixIcon: const Icon(Iconsax.lock),
                        suffixIcon: IconButton(
                          icon: Icon(isPasswordVisible ? Iconsax.eye : Iconsax.eye_slash),
                          onPressed: () {
                            setState(() { isPasswordVisible = !isPasswordVisible; });
                          },
                          color: DineSwiftColors.darkerGrey,
                        ),
                        filled: true,
                        fillColor: DineSwiftColors.whiteColor,
                        focusColor: DineSwiftColors.whiteColor,
                        hoverColor: DineSwiftColors.whiteColor,
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: DineSwiftColors.darkGrey.withAlpha(80)),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: const BorderSide(
                            color: DineSwiftColors.primaryColor,
                            width: 1.5
                          ),
                        ),

                      ),
                    ),

                    const SizedBox(height: 32),

                    // Login button
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 56),
                        backgroundColor: DineSwiftColors.primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(DineSwiftSize.cardRadiusSm),
                        ),
                      ),
                      icon: isLoading ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: DineSwiftColors.blackColor, strokeWidth: 2)) : const Icon(Iconsax.login, color: DineSwiftColors.whiteColor, size: 24),
                      label: Text(
                        isLoading ? DineSwiftTextStrings.isLogging : DineSwiftTextStrings.signIn,
                        style: TextStyle(
                          fontSize: DineSwiftSize.fontSizeMd,
                          fontWeight: FontWeight.w500,
                          color: isLoading ? DineSwiftColors.blackColor : DineSwiftColors.whiteColor,
                        ),
                      ),

                      onPressed: isLoading ? null : handleLogin,
                    ),
                  ],
                ),
              ),

              const SizedBox(width: DineSwiftSize.md),

              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    DineSwiftImages.signIn,
                    height: 250,
                    width: 300,
                    fit: BoxFit.contain,
                  ),

                  const SizedBox(height: DineSwiftSize.sizedBoxHeightMd),

                  TextButton(
                    onPressed: (){
                      Get.to(()=> SignUpScreen());

                    }, 
                    style: TextButton.styleFrom(
                      minimumSize: const Size(100, 40),
                      backgroundColor: DineSwiftColors.whiteColor,
                      foregroundColor: DineSwiftColors.primaryColor.withAlpha(10)
                    ),
                    child: Text(
                      DineSwiftTextStrings.createAccount,
                      style: TextStyle(
                        fontSize: DineSwiftSize.fontSizeMd,
                        fontWeight: FontWeight.w500,
                        color: DineSwiftColors.textColor,
                      ),
                    )
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
