import 'package:finwise/core/constants/app_assets.dart';
import 'package:finwise/core/constants/app_colors.dart';
import 'package:finwise/core/constants/app_fonts.dart';
import 'package:finwise/core/styles/text_styles.dart';
import 'package:finwise/features/auth/widgets/auth_text_field.dart';
import 'package:finwise/features/auth/widgets/socialbutton.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class SignupScreen extends StatelessWidget {
  double space = 16;
  SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const Gap(68),

          Text(
            "Create Account",
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
                    Gap(27),
                    Text(
                      "Full name",
                      style: TextStyles.caption1_14.copyWith(
                        color: AppColors.lettersAndIcons,
                        fontFamily: AppFonts.poppins,
                        fontWeight: FontWeight.w500,
                      ),
                    ),

                    const Gap(8),
                    AuthTextField(hintText: "Your Name"),
                    Gap(space),
                    Text(
                      "Email",
                      style: TextStyles.caption1_14.copyWith(
                        color: AppColors.lettersAndIcons,
                        fontFamily: AppFonts.poppins,
                        fontWeight: FontWeight.w500,
                      ),
                    ),

                    const Gap(8),
                    AuthTextField(hintText: "example@example.com"),
                    Gap(space),

                    /// Username
                    Text(
                      "Mobile Number",
                      style: TextStyles.caption1_14.copyWith(
                        color: AppColors.lettersAndIcons,
                        fontFamily: AppFonts.poppins,
                        fontWeight: FontWeight.w500,
                      ),
                    ),

                    const Gap(8),

                    AuthTextField(hintText: "+ 123 456 789"),
                    Gap(space),
                    Text(
                      "Date of birth",
                      style: TextStyles.caption1_14.copyWith(
                        color: AppColors.lettersAndIcons,
                        fontFamily: AppFonts.poppins,
                        fontWeight: FontWeight.w500,
                      ),
                    ),

                    const Gap(8),

                    AuthTextField(hintText: "DD / MM /YYY"),

                    Gap(space),

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
                    Gap(space),
                    Text(
                      "Confirm Password",
                      style: TextStyles.caption1_14.copyWith(
                        color: AppColors.lettersAndIcons,
                        fontFamily: AppFonts.poppins,
                        fontWeight: FontWeight.w500,
                      ),
                    ),

                    AuthTextField(hintText: "Password", isPassword: true),
                    const Gap(28),
                    Center(child: Text("By continuing, you agree to ")),

                    Center(
                      child: Text(
                        "Terms of Use and Privacy Policy.,",
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                    Gap(13),

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
                    Gap(11),
                    Center(child: Text("Already have an account? Log In")),
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
