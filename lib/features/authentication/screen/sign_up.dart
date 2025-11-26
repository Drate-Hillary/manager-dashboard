import 'package:dineswift_management/features/authentication/screen/login.dart';
import 'package:dineswift_management/features/authentication/services/auth_service.dart';
import 'package:dineswift_management/features/dashboard/screens/dashboard.dart';
import 'package:dineswift_management/features/dashboard/screens/widgets/dashboard_overview.dart';
import 'package:dineswift_management/util/constants/colors.dart';
import 'package:dineswift_management/util/constants/image_string.dart';
import 'package:dineswift_management/util/constants/size.dart';
import 'package:dineswift_management/util/constants/text_strings.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:iconsax/iconsax.dart';
import 'package:uuid/uuid.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const SignUpContent();
  }
}

class SignUpContent extends StatefulWidget {
  const SignUpContent({super.key});

  @override
  State<SignUpContent> createState() => SignUpContentState();
}

class SignUpContentState extends State<SignUpContent> {
  bool isPasswordVisible = false;
  bool isRepeatPasswordVisible = false;
  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final repeatPassword = TextEditingController();
  final uuid = const Uuid();

  bool isLoading = false;

  Future<void> handleRegistration() async {
    if (usernameController.text.isEmpty || emailController.text.isEmpty || 
        passwordController.text.isEmpty || repeatPassword.text.isEmpty) {
      Fluttertoast.showToast(
        msg: "All fields are required",
        backgroundColor: DineSwiftColors.errorColor,
        textColor: DineSwiftColors.whiteColor,
      );
      return;
    }

    if (passwordController.text != repeatPassword.text) {
      Fluttertoast.showToast(
        msg: "Passwords do not match",
        backgroundColor: DineSwiftColors.errorColor,
        textColor: DineSwiftColors.whiteColor,
      );
      return;
    }

    setState(() => isLoading = true);
    try {
      final user = await AuthService.registerManager(
        username: usernameController.text,
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
          msg: "Registration Successful",
          backgroundColor: DineSwiftColors.successColor,
          textColor: DineSwiftColors.whiteColor,
        );
        Get.offAll(() => DineSwiftDashboard());
      }
    } catch (e) {
      Fluttertoast.showToast(
        msg: "Registration failed: ${e.toString()}",
        backgroundColor: DineSwiftColors.errorColor,
        textColor: DineSwiftColors.whiteColor,
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  void dispose() {
    usernameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    repeatPassword.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    int alpha = (0.98 * 255).round();
    return Scaffold(
      backgroundColor: DineSwiftColors.whiteColor.withAlpha(alpha),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            height: 450,
            width: 700,

            decoration: BoxDecoration(
              color: DineSwiftColors.whiteColor,
              boxShadow: [
                BoxShadow(
                  color: DineSwiftColors.blackColor.withAlpha(10),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
              borderRadius: BorderRadius.circular(DineSwiftSize.cardRadiusSm),
              border: Border.all(color: DineSwiftColors.darkGrey.withAlpha(20)),
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
                        DineSwiftTextStrings.signUp,
                        style: TextStyle(
                          fontSize: DineSwiftSize.fontSizeXxxl,
                          fontWeight: FontWeight.w700,
                          color: DineSwiftColors.blackColor,
                        ),
                      ),

                      const SizedBox(height: DineSwiftSize.sizedBoxHeightLg),

                      // username field
                      TextField(
                        controller: usernameController,
                        decoration: InputDecoration(
                          hintText: DineSwiftTextStrings.userNameHint,
                          prefixIcon: const Icon(
                            Iconsax.user,
                            color: DineSwiftColors.blackColor,
                            size: 20,
                          ),
                          filled: true,
                          fillColor: DineSwiftColors.whiteColor,
                          focusColor: DineSwiftColors.whiteColor,
                          hoverColor: DineSwiftColors.whiteColor,
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: DineSwiftColors.darkGrey.withAlpha(80),
                            ),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: DineSwiftColors.primaryColor,
                              width: 1.5,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: DineSwiftSize.sizedBoxHeightSm),

                      // email field
                      TextField(
                        controller: emailController,
                        decoration: InputDecoration(
                          hintText: DineSwiftTextStrings.emailHint,
                          prefixIcon: const Icon(
                            Iconsax.message_2,
                            color: DineSwiftColors.blackColor,
                            size: 20,
                          ),
                          filled: true,
                          fillColor: DineSwiftColors.whiteColor,
                          focusColor: DineSwiftColors.whiteColor,
                          hoverColor: DineSwiftColors.whiteColor,
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: DineSwiftColors.darkGrey.withAlpha(80),
                            ),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: DineSwiftColors.primaryColor,
                              width: 1.5,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: DineSwiftSize.sizedBoxHeightSm),

                      // Password field
                      TextField(
                        controller: passwordController,
                        obscureText: !isPasswordVisible,
                        decoration: InputDecoration(
                          hintText: DineSwiftTextStrings.passwordHint,
                          prefixIcon: const Icon(
                            Iconsax.lock_1,
                            color: DineSwiftColors.blackColor,
                            size: 20,
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(
                              isPasswordVisible
                                ? Iconsax.eye
                                : Iconsax.eye_slash,
                              color: DineSwiftColors.blackColor,
                              size: 20,
                            ),
                            onPressed: () {
                              setState(() {
                                isPasswordVisible = !isPasswordVisible;
                              });
                            },
                            color: DineSwiftColors.darkerGrey,
                          ),
                          filled: true,
                          fillColor: DineSwiftColors.whiteColor,
                          focusColor: DineSwiftColors.whiteColor,
                          hoverColor: DineSwiftColors.whiteColor,
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: DineSwiftColors.darkGrey.withAlpha(80),
                            ),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: DineSwiftColors.primaryColor,
                              width: 1.5,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: DineSwiftSize.sizedBoxHeightSm),

                      // repeat password
                      TextField(
                        controller: repeatPassword,
                        obscureText: !isRepeatPasswordVisible,
                        decoration: InputDecoration(
                          hintText: DineSwiftTextStrings.repeatPasswordHint,
                          prefixIcon: const Icon(
                            Iconsax.lock_1,
                            color: DineSwiftColors.blackColor,
                            size: 20,
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(
                              isRepeatPasswordVisible
                                ? Iconsax.eye
                                : Iconsax.eye_slash,
                              color: DineSwiftColors.blackColor,
                              size: 20,
                            ),
                            onPressed: () {
                              setState(() {
                                isRepeatPasswordVisible = !isRepeatPasswordVisible;
                              });
                            },
                            color: DineSwiftColors.darkerGrey,
                          ),
                          filled: true,
                          fillColor: DineSwiftColors.whiteColor,
                          focusColor: DineSwiftColors.whiteColor,
                          hoverColor: DineSwiftColors.whiteColor,
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: DineSwiftColors.darkGrey.withAlpha(80),
                            ),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                              color: DineSwiftColors.primaryColor,
                              width: 1.5,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 32),

                      Row(
                        children: [
                          TextButton(
                            onPressed: isLoading ? null : handleRegistration,
                            style: TextButton.styleFrom(
                              backgroundColor: DineSwiftColors.primaryColor,
                              minimumSize: const Size(150, 46),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                  DineSwiftSize.cardRadiusLg,
                                ),
                              ),
                            ),
                            child: isLoading
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    color: DineSwiftColors.whiteColor,
                                    strokeWidth: 2,
                                  ),
                                )
                              : Text(
                                  DineSwiftTextStrings.createAccount,
                                  style: TextStyle(
                                    fontSize: DineSwiftSize.fontSizeSm,
                                    fontWeight: FontWeight.w500,
                                    color: DineSwiftColors.whiteColor,
                                  ),
                                ),
                          ),
                          const Spacer(),
                          TextButton(
                            onPressed: (){
                              Get.to(()=> LoginScreen());
                            },
                            style: TextButton.styleFrom(
                              minimumSize: const Size(150, 46),
                              backgroundColor: DineSwiftColors.primaryColor.withAlpha(20),
                              foregroundColor: DineSwiftColors.primaryColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                  DineSwiftSize.cardRadiusLg,
                                ),
                              ),
                            ),
                            child: Text(
                              DineSwiftTextStrings.alreadyRegistered,
                              style: TextStyle(
                                fontSize: DineSwiftSize.fontSizeSm,
                                fontWeight: FontWeight.w500,
                                color: DineSwiftColors.blackColor,
                              ),
                            ),
                          ),
                        ],
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
                      DineSwiftImages.signUp,
                      height: 250,
                      width: 300,
                      fit: BoxFit.contain,
                    ),
                  ],
                ),

                // Row(
                //   mainAxisAlignment: MainAxisAlignment.center,
                //   crossAxisAlignment: CrossAxisAlignment.center,
                //   children: [
                //     ElevatedButton.icon(
                //       style: ElevatedButton.styleFrom(
                //         minimumSize: const Size(double.infinity, 56),
                //         backgroundColor: DineSwiftColors.primaryColor,
                //         shape: RoundedRectangleBorder(
                //           borderRadius: BorderRadius.circular(DineSwiftSize.cardRadiusSm),
                //         ),
                //       ),
                //       icon: isLoading ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: DineSwiftColors.blackColor, strokeWidth: 2)) : const Icon(Iconsax.login_1, color: DineSwiftColors.whiteColor, size: 24),
                //       label: Text(
                //         isLoading ? DineSwiftTextStrings.registering : DineSwiftTextStrings.register,
                //         style: TextStyle(
                //           fontSize: DineSwiftSize.fontSizeMd,
                //           fontWeight: FontWeight.w500,
                //           color: isLoading ? DineSwiftColors.blackColor : DineSwiftColors.whiteColor,
                //         ),
                //       ),
                //       onPressed: () {
                //         Get.offAll(()=> DineSwiftDashboard());
                //       },
                //       // onPressed: isLoading ? null : () async {
                //       //   // setState(() => isLoading = true);
                //       //   // final user = await AuthService.loginWaiter(usernameController.text, passwordController.text);
                //       //   // setState(() => isLoading = false);
                //       //   if (user != null) {
                //       //     final storage = GetStorage();
                //       //     await storage.write('user_name', user['username'] ?? user['name'] ?? 'User');
                //       //     await storage.write('user_image', user['profile_image'] ?? user['image']);
                //       //     await storage.write('email', user['email'] ?? '');
                //       //     // Fluttertoast.showToast(
                //       //     //   msg: "Login Successful",
                //       //     //   backgroundColor: DineSwiftColors.successColor,
                //       //     //   textColor: DineSwiftColors.whiteColor,
                //       //     //   fontSize: DineSwiftSize.fontSizeMd,
                //       //     // );
                //       //     Get.offAll(()=> DineSwiftDashboard());
                //       //   } else {
                //       //     Fluttertoast.showToast(
                //       //       msg: "Invalid username or password",
                //       //       backgroundColor: DineSwiftColors.errorColor,
                //       //       textColor: DineSwiftColors.whiteColor,
                //       //       fontSize: DineSwiftSize.fontSizeMd,
                //       //     );
                //       //   }
                //       // },
                //     ),
                //
                //     const Spacer(),
                //     TextButton(
                //       style: TextButton.styleFrom(
                //         minimumSize: const Size(150, 56),
                //         backgroundColor: DineSwiftColors.whiteColor,
                //         foregroundColor: DineSwiftColors.whiteColor,
                //       ),
                //       onPressed: () {
                //         Get.to(()=> LoginScreen());
                //       },
                //       child: const Text(
                //         DineSwiftTextStrings.alreadyRegistered,
                //         style: TextStyle(
                //           fontSize: DineSwiftSize.fontSizeMd,
                //           fontWeight: FontWeight.w600,
                //           color: DineSwiftColors.blackColor,
                //           decoration: TextDecoration.underline,
                //         ),
                //       ),
                //     ),
                //   ],
                // )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
