import 'package:finwise/core/constants/app_colors.dart';
import 'package:finwise/core/functions/navigations.dart';
import 'package:finwise/core/styles/text_styles.dart';
import 'package:finwise/core/widgets/main_button.dart';
import 'package:finwise/features/settings/delete_account/cubit/delete_account_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

class DeleteDialog extends StatelessWidget {
  const DeleteDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(20),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("Delete account", style: TextStyles.bodyLarge),
              const Gap(27),
              const Text(
                "Are you sure you want to delete your account?",
                style: TextStyles.bodyMedium,
              ),
              const Gap(27),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Text(
                  "By deleting your account, you agree that you understand the consequences of this action and that you agree to permanently delete your account and all associated data.",
                  textAlign: TextAlign.center,
                  style: TextStyles.bodyMedium.copyWith(
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              const Gap(30),

              MainButton(
                text: "yes, Delete account",
                onPress: () {
                  pop(context); // Close double check dialog
                  context.read<DeleteAccountCubit>().deleteUserDataAndAccount();
                },
                backgroundColor: Colors.red,
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
          ),
        ),
      ),
    );
  }
}
