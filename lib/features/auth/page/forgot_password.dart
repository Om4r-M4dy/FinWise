import 'package:finwise/core/constants/app_assets.dart';
import 'package:finwise/core/constants/app_colors.dart';
import 'package:finwise/core/constants/app_fonts.dart';
import 'package:finwise/core/styles/text_styles.dart';
import 'package:finwise/core/functions/navigations.dart';
import 'package:finwise/features/auth/page/securityPin_screen.dart';
import 'package:finwise/features/auth/page/signup_screen.dart';
import 'package:finwise/features/auth/widgets/auth_text_field.dart';
import 'package:finwise/features/auth/widgets/socialbutton.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const Gap(68),
          Text(
            "Forgot Password",
            style: TextStyles.size_30.copyWith(
              color: AppColors.lettersAndIcons,
              fontFamily: AppFonts.poppins,
              fontWeight: FontWeight.w600,
            ),
          ),
          const Gap(65),
          Expanded(
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(38),
              decoration: const BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
                ),
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Gap(27),

                    Text(
                      "Reset Password?",
                      style: TextStyles.headline_24.copyWith(
                        fontSize: 20,
                        color: AppColors.lettersAndIcons,
                        fontFamily: AppFonts.poppins,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    const Gap(10),

                    Text(
                      "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.",
                      style: TextStyles.caption1_14.copyWith(
                        color: AppColors.lettersAndIcons,
                        fontFamily: AppFonts.poppins,
                        fontWeight: FontWeight.w400,
                        height: 1.5,
                      ),
                    ),

                    const Gap(40),

                    Text(
                      "Enter Email Address",
                      style: TextStyles.caption1_14.copyWith(
                        color: AppColors.lettersAndIcons,
                        fontFamily: AppFonts.poppins,
                        fontWeight: FontWeight.w500,
                      ),
                    ),

                    const Gap(8),

                    AuthTextField(hintText: "example@example.com"),

                    const Gap(40),

                    /// Next Step Button
                    Center(
                      child: SizedBox(
                        width: 207,
                        child: ElevatedButton(
                          onPressed: () {
                            pushReplacment(context, SecuritypinScreen());
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.mainGreen,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          child: Text(
                            "Next Step",
                            style: TextStyles.headline_24.copyWith(
                              fontSize: 20,
                              color: AppColors.lettersAndIcons,
                              fontFamily: AppFonts.poppins,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),

                    const Gap(20),

                    /// Sign Up Button
                    Center(
                      child: SizedBox(
                        width: 207,
                        child: ElevatedButton(
                          onPressed: () {
                            pushReplacment(context, SignupScreen());
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.lightGreen,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            elevation: 0,
                          ),
                          child: Text(
                            "Sign Up",
                            style: TextStyles.headline_24.copyWith(
                              fontSize: 20,
                              color: AppColors.lettersAndIcons,
                              fontFamily: AppFonts.poppins,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),

                    const Gap(28),

                    const Center(
                      child: Text(
                        "or sign up with",
                        style: TextStyle(fontSize: 12),
                      ),
                    ),

                    const Gap(19),

                    //google && facebook
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SocialButton(
                          icon: AppAssets.facebook,
                          onTap: () {
                            print("Facebook login");
                          },
                        ),

                        const Gap(16),

                        SocialButton(
                          icon: AppAssets.google,
                          onTap: () {
                            print("Google login");
                          },
                        ),
                      ],
                    ),

                    const Gap(19),

                    Center(
                      child: GestureDetector(
                        onTap: () {
                          pushReplacment(context, SignupScreen());
                        },
                        child: const Text.rich(
                          TextSpan(
                            text: "Don't have an account? ",
                            style: TextStyle(
                              color: AppColors.gray39,
                              fontSize: 12,
                            ),
                            children: [
                              TextSpan(
                                text: "Sign Up",
                                style: TextStyle(
                                  color: AppColors.lightBlueButton,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
