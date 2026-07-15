import 'package:finwise/core/constants/app_assets.dart';
import 'package:finwise/core/constants/app_colors.dart';
import 'package:finwise/core/constants/app_fonts.dart';
import 'package:finwise/core/functions/navigations.dart';
import 'package:finwise/core/routes/routes.dart';
import 'package:finwise/core/styles/text_styles.dart';
import 'package:finwise/features/auth/persentation/widgets/socialbutton.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:verification_code_field/verification_code_field.dart';

class SecuritypinScreen extends StatefulWidget {
  const SecuritypinScreen({super.key});

  @override
  State<SecuritypinScreen> createState() => _SecuritypinScreenState();
}

class _SecuritypinScreenState extends State<SecuritypinScreen> {
  String otpCode = '';

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const Gap(30),

            Text(
              "Security pin",
              style: TextStyles.headlineLarge.copyWith(
                fontSize: 30,
                color: AppColors.lettersAndIcons,
                fontFamily: AppFonts.poppins,
                fontWeight: FontWeight.w600,
              ),
            ),

            const Gap(30),

            Expanded(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: const BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40),
                    topRight: Radius.circular(40),
                  ),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const Gap(90),

                      Text(
                        "Enter security pin",
                        style: TextStyles.headlineLarge.copyWith(
                          fontSize: 20,
                          color: AppColors.lettersAndIcons,
                          fontFamily: AppFonts.poppins,
                          fontWeight: FontWeight.w600,
                        ),
                      ),

                      const Gap(68),

                      Center(
                        child: FittedBox(
                          child: VerificationCodeField(
                            fieldSize: width < 360 ? 38 : 45,
                            codeDigit: CodeDigit.six,
                            filled: true,
                            fillColor: Colors.grey.shade200,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(100),
                              borderSide: BorderSide.none,
                            ),
                            onSubmit: (code) {
                              otpCode = code;
                              print(code);
                            },
                          ),
                        ),
                      ),

                      const Gap(89),

                      SizedBox(
                        width: 207,
                        child: ElevatedButton(
                          onPressed: () {
                            if (otpCode.length == 6) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'PIN login not fully implemented yet.',
                                  ),
                                ),
                              );
                              replaceWith(context, Routes.loginScreen);
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Please enter a 6-digit PIN.'),
                                ),
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.mainGreen,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),

                          child: Text(
                            "Accept",
                            style: TextStyles.headline_24.copyWith(
                              fontSize: 20,
                              color: AppColors.lettersAndIcons,
                              fontFamily: AppFonts.poppins,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),

                      const Gap(20),

                      SizedBox(
                        width: 207,
                        child: ElevatedButton(
                          onPressed: () {
                            // Handle send again action
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
                            "Send again",
                            style: TextStyles.headline_24.copyWith(
                              fontSize: 20,
                              color: AppColors.lettersAndIcons,
                              fontFamily: AppFonts.poppins,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),

                      const Gap(154),

                      const Text(
                        "or sign up with",
                        style: TextStyle(fontSize: 12),
                      ),

                      const Gap(16),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SocialButton(icon: AppAssets.facebook, onTap: () {}),

                          const Gap(16),

                          SocialButton(icon: AppAssets.google, onTap: () {}),
                        ],
                      ),

                      const Gap(20),

                      GestureDetector(
                        onTap: () {
                          replaceWith(context, Routes.signupScreen);
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
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
