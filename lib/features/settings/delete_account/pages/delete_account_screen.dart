import 'package:finwise/core/constants/app_colors.dart';
import 'package:finwise/core/extentions/dialogs.dart';
import 'package:finwise/core/functions/navigations.dart';
import 'package:finwise/core/routes/routes.dart';
import 'package:finwise/core/styles/text_styles.dart';
import 'package:finwise/core/widgets/default_app_bar.dart';
import 'package:finwise/core/widgets/main_button.dart';
import 'package:finwise/core/widgets/my_body_view.dart';
import 'package:finwise/features/auth/persentation/widgets/auth_text_field.dart';
import 'package:finwise/features/profile/cubit/user_cubit.dart';
import 'package:finwise/features/settings/delete_account/cubit/delete_account_cubit.dart';
import 'package:finwise/features/settings/delete_account/cubit/delete_account_state.dart';
import 'package:finwise/features/settings/delete_account/widgets/delete_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

class DeleteAccountScreen extends StatefulWidget {
  const DeleteAccountScreen({super.key});

  @override
  State<DeleteAccountScreen> createState() => _DeleteAccountScreenState();
}

class _DeleteAccountScreenState extends State<DeleteAccountScreen> {
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DeleteAccountCubit(),
      child: BlocListener<DeleteAccountCubit, DeleteAccountState>(
        listener: (context, state) {
          if (state is AccountDeletionLoading) {
            showLoadingDialog(context);
          } else if (state is AccountDeletionSuccess) {
            // Dismiss loading dialog (which was shown via showLoadingDialog)
            pop(context);
            // Clear user local state
            context.read<UserCubit>().clearUser();
            // Redirect to login screen
            removeUntil(context, Routes.loginScreen);
          } else if (state is AccountDeletionFailure) {
            // Dismiss loading dialog
            pop(context);
            // Show error message
            showMyDialog(context, state.errorMessage, type: DialogType.error);
          }
        },
        child: Scaffold(
          appBar: const DefaultAppBar(title: "Delete Account"),
          body: MyBodyView(
            bottomSection: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Are You Sure You Want To Delete Your Account?",
                    textAlign: TextAlign.center,
                    style: TextStyles.bodyMedium,
                  ),
                  const Gap(24),
                  Container(
                    padding: const EdgeInsets.only(left: 25, right: 25, top: 25),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(18),
                      color: Theme.of(context).colorScheme.primaryContainer,
                    ),
                    child: Text(
                      """This action will permanently delete all of your data, and you will not be able to recover it. Please keep the following in mind before proceeding:
                    
            • All your expenses, income and associated transactions will be eliminated.
            
            • You will not be able to access your account or any related information.
            
            • This action cannot be undone.
                                    """,
                      style: TextStyles.bodySmall.copyWith(
                        color: Theme.of(context).colorScheme.onPrimaryContainer,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ),
                  const Gap(34),
                  Text(
                    "Please Enter Your Password To Confirm Deletion Of Your Account.",
                    textAlign: TextAlign.center,
                    style: TextStyles.bodyMedium,
                  ),
                  const Gap(20),

                  // Password input field and status
                  BlocBuilder<DeleteAccountCubit, DeleteAccountState>(
                    builder: (context, state) {
                      final cubit = context.read<DeleteAccountCubit>();
                      final isConfirmed = cubit.isPasswordConfirmed;
                      final isVerifying = state is PasswordVerificationLoading;
                      
                      String? errorText;
                      if (state is PasswordVerificationFailure) {
                        errorText = state.errorMessage;
                      }

                      return Column(
                        children: [
                          AuthTextField(
                            hintText: "Enter your password",
                            isPassword: true,
                            controller: _passwordController,
                            errorText: errorText,
                            enabled: !isConfirmed && !isVerifying,
                          ),
                          const Gap(20),
                          if (isConfirmed)
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.check_circle, color: AppColors.mainGreen),
                                const Gap(8),
                                Text(
                                  "Password verified successfully",
                                  style: TextStyles.bodyMedium.copyWith(color: AppColors.mainGreen),
                                ),
                              ],
                            )
                          else
                            MainButton(
                              text: isVerifying ? "Verifying..." : "Confirm Password",
                              onPress: isVerifying
                                  ? null
                                  : () {
                                      cubit.verifyPassword(_passwordController.text);
                                    },
                            ),
                        ],
                      );
                    },
                  ),
                  const Gap(34),

                  // Delete account and cancel buttons
                  BlocBuilder<DeleteAccountCubit, DeleteAccountState>(
                    builder: (context, state) {
                      final cubit = context.read<DeleteAccountCubit>();
                      final isConfirmed = cubit.isPasswordConfirmed;

                      return Column(
                        children: [
                          MainButton(
                            text: "Delete account",
                            onPress: isConfirmed
                                ? () {
                                    showDialog(
                                      context: context,
                                      builder: (dialogContext) => BlocProvider.value(
                                        value: context.read<DeleteAccountCubit>(),
                                        child: const DeleteDialog(),
                                      ),
                                    );
                                  }
                                : null,
                            backgroundColor: isConfirmed ? Colors.red : Colors.grey.shade400,
                            textColor: Colors.white,
                          ),
                          const Gap(11),
                          MainButton(
                            text: "cancel",
                            onPress: () {
                              pop(context);
                            },
                            backgroundColor: AppColors.mainGreen,
                            textColor: AppColors.lettersAndIcons,
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
