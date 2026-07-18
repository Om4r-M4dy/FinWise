import 'package:finwise/core/constants/app_assets.dart';
import 'package:finwise/core/constants/app_colors.dart';
import 'package:finwise/core/constants/app_fonts.dart';
import 'package:finwise/core/extentions/app_regex.dart';
import 'package:finwise/core/extentions/dialogs.dart';
import 'package:finwise/core/functions/navigations.dart';
import 'package:finwise/core/routes/routes.dart';
import 'package:finwise/core/styles/text_styles.dart';
import 'package:finwise/features/auth/persentation/widgets/auth_layout.dart';
import 'package:finwise/features/auth/persentation/widgets/auth_text_field.dart';
import 'package:finwise/features/auth/persentation/widgets/custom_auth_button.dart';
import 'package:finwise/features/auth/persentation/widgets/socialbutton.dart';
import 'package:finwise/features/profile/cubit/user_cubit.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:finwise/features/auth/persentation/cubit/auth_cubit.dart';
import 'package:finwise/features/auth/persentation/cubit/auth_state.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    var cubit = context.read<AuthCubit>();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthLoading) {
          showLoadingDialog(context);
        } else if (state is AuthSuccess) {
          pop(context); // Dismiss the loading dialog
          // Hand the loaded user to the global UserCubit before navigating
          context.read<UserCubit>().setUser(state.userModel);
          replaceWith(context, Routes.bottomNavBar);
        } else if (state is AuthFailure) {
          pop(context);
          showMyDialog(context, state.errorMessage);
        }
      },
      child: Form(
        key: cubit.formKey,
        child: AuthLayout(
          title: "Welcome",
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Gap(90),

                /// Username
                Text(
                  "Username Or Email",
                  style: TextStyles.caption1_14.copyWith(
                    color: isDark ? Colors.white : AppColors.lettersAndIcons,
                    fontFamily: AppFonts.poppins,
                    fontWeight: FontWeight.w500,
                  ),
                ),

                const Gap(8),

                AuthTextField(
                  hintText: "example@example.com",
                  controller: cubit.emailController,
                  validate: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter your email";
                    } else if (!AppRegex.isEmailValid(value)) {
                      return "Please enter a valid email";
                    }
                    return null;
                  },
                ),

                const Gap(20),

                /// Password
                Text(
                  "Password",
                  style: TextStyles.caption1_14.copyWith(
                    color: isDark ? Colors.white : AppColors.lettersAndIcons,
                    fontFamily: AppFonts.poppins,
                    fontWeight: FontWeight.w500,
                  ),
                ),

                const Gap(8),

                AuthTextField(
                  hintText: "Password",
                  isPassword: true,
                  controller: cubit.passwordController,
                  validate: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter your password";
                    }
                    return null;
                  },
                ),
                const Gap(30),

                /// Login Button
                CustomAuthButton(
                  text: "Log In",
                  onPressed: () {
                    if (cubit.formKey.currentState!.validate()) {
                      cubit.loginWithEmailAndPassword();
                    }
                  },
                ),

                const Gap(10),

                /// Forgot password
                Center(
                  child: TextButton(
                    onPressed: () {
                      pushTo(context, Routes.forgotPasswordScreen);
                    },
                    child: Text(
                      "Forgot Password?",
                      style: TextStyles.caption1_14.copyWith(
                        color: isDark ? Colors.white70 : AppColors.lettersAndIcons,
                        fontFamily: AppFonts.leagueSpartan,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),

                const Gap(10),

                /// Sign Up button
                CustomAuthButton(
                  text: "Sign Up",
                  onPressed: () {
                    replaceWith(context, Routes.signupScreen);
                  },
                  backgroundColor: isDark ? AppColors.darkGreen : AppColors.lightGreen,
                  textColor: isDark ? Colors.white : AppColors.lettersAndIcons,
                ),

                const Gap(20),

                /// Fingerprint
                Center(
                  child: GestureDetector(
                    onTap: () {
                      replaceWith(context, Routes.securityFingerprintScreen);
                    },
                    child: Text.rich(
                      TextSpan(
                        text: "Use ",
                        style: TextStyle(color: isDark ? Colors.white70 : AppColors.lettersAndIcons),
                        children: const [
                          TextSpan(
                            text: "Fingerprint",
                            style: TextStyle(color: AppColors.blueButton),
                          ),
                          TextSpan(text: " To Access"),
                        ],
                      ),
                    ),
                  ),
                ),
                const Gap(28),
                Center(
                  child: Text(
                    "or sign up with",
                    style: TextStyle(
                      color: isDark ? Colors.white70 : AppColors.lettersAndIcons,
                      fontSize: 12,
                    ),
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
                        context.read<AuthCubit>().loginWithFacebook(context);
                      },
                    ),

                    const Gap(16),

                    SocialButton(
                      icon: AppAssets.google,
                      onTap: () {
                        context.read<AuthCubit>().loginWithGoogle(context);
                      },
                    ),
                  ],
                ),
                const Gap(19),
                Center(
                  child: GestureDetector(
                    onTap: () {
                      replaceWith(context, Routes.signupScreen);
                    },
                    child: Text.rich(
                      TextSpan(
                        text: "Don't have an account? ",
                        style: TextStyle(
                          color: isDark ? Colors.white70 : AppColors.gray39,
                        ),
                        children: const [
                          TextSpan(
                            text: "Sign Up",
                            style: TextStyle(color: AppColors.lightBlueButton),
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
    );
  }
}
