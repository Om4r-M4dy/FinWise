import 'package:finwise/core/constants/app_colors.dart';
import 'package:finwise/core/constants/app_fonts.dart';
import 'package:finwise/core/functions/navigations.dart';
import 'package:finwise/core/routes/routes.dart';
import 'package:finwise/core/styles/text_styles.dart';
import 'package:finwise/features/auth/persentation/widgets/auth_text_field.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class NewPasswordScreen extends StatelessWidget {
  const NewPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const Gap(30),

          Text(
            "New password",
            style: TextStyles.size_30.copyWith(
              color: AppColors.lettersAndIcons,
              fontFamily: AppFonts.poppins,
              fontWeight: FontWeight.w600,
            ),
          ),
          Gap(65),

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
                    Gap(78),
                    Row(
                      children: [
                        Text(
                          "New Password",
                          style: TextStyles.caption1_14.copyWith(
                            color: AppColors.lettersAndIcons,
                            fontFamily: AppFonts.poppins,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),

                    const Gap(8),

                    AuthTextField(hintText: "Password", isPassword: true),
                    Gap(42),
                    Row(
                      children: [
                        Text(
                          "Confirm New Password",
                          style: TextStyles.caption1_14.copyWith(
                            color: AppColors.lettersAndIcons,
                            fontFamily: AppFonts.poppins,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),

                    AuthTextField(hintText: "Password", isPassword: true),
                    Gap(169),
                    SizedBox(
                      width: double.infinity,

                      child: ElevatedButton(
                        onPressed: () {
                          replaceWith(context, Routes.passwordChangedScreen);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.mainGreen,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),

                        child: Text(
                          "Change Password",
                          style: TextStyles.headline_24.copyWith(
                            fontSize: 20,
                            color: AppColors.lettersAndIcons,
                            fontFamily: AppFonts.poppins,
                            fontWeight: FontWeight.w600,
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
