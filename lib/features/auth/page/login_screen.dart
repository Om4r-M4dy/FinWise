import 'package:finwise/core/constants/app_assets.dart';
import 'package:finwise/core/constants/app_colors.dart';
import 'package:finwise/core/constants/app_fonts.dart';
import 'package:finwise/core/styles/text_styles.dart';
import 'package:finwise/features/auth/widgets/auth_text_field.dart';
import 'package:finwise/features/auth/widgets/socialbutton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const Gap(68),

          Text(
            "Welcome",
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
                    Gap(90),

                    /// Username
                    Text(
                      "Username Or Email",
                      style: TextStyles.caption1_14.copyWith(
                        color: AppColors.lettersAndIcons,
                        fontFamily: AppFonts.poppins,
                        fontWeight: FontWeight.w500,
                      ),
                    ),

                    const Gap(8),

                    AuthTextField(hintText: "example@example.com"),

                    const Gap(20),

                    /// Password
                    Text(
                      "Password",
                      style: TextStyles.caption1_14.copyWith(
                        color: AppColors.lettersAndIcons,
                        fontFamily: AppFonts.poppins,
                        fontWeight: FontWeight.w500,
                      ),
                    ),

                    const Gap(8),

                    AuthTextField(hintText: "Password", isPassword: true),
                    const Gap(30),

                    /// Login Button
                    Center(
                      child: SizedBox(
                        width: 207,
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.mainGreen,

                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          child: Text(
                            "Log In",
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

                    const Gap(10),

                    /// Forgot password
                    Center(
                      child: TextButton(
                        onPressed: () {},
                        child: Text(
                          "Forgot Password?",
                          style: TextStyles.caption1_14.copyWith(
                            color: AppColors.lettersAndIcons,
                            fontFamily: AppFonts.leagueSpartan,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),

                    const Gap(10),

                    /// Sign Up button
                    Center(
                      child: SizedBox(
                        width: 207,
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.lightGreen,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
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

                    const Gap(20),

                    /// Fingerprint
                    const Center(
                      child: Text.rich(
                        TextSpan(
                          text: "Use ",
                          children: [
                            TextSpan(
                              text: "Fingerprint",
                              style: TextStyle(color: AppColors.blueButton),
                            ),
                            TextSpan(text: " To Access"),
                          ],
                        ),
                      ),
                    ),
                    Gap(28),
                    Center(child: Text("or sign up with")),
                    Gap(19),
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
                    Gap(19),
                    Center(child: Text("oDon’t have an account? Sign Up")),
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
