import 'package:finwise/core/constants/app_colors.dart';
import 'package:finwise/core/functions/navigations.dart';
import 'package:finwise/core/styles/text_styles.dart';
import 'package:finwise/core/widgets/main_button.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class DeleteDialog extends StatelessWidget {
  const DeleteDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    child: Container(
      padding: const EdgeInsets.all(20),
      height: 450,
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text("Delete account", style: TextStyles.title_20),
          const Gap(27),
          const Text("Are you sure you want to log out?", style: TextStyles.body_15),
const Gap(27),
           Padding(
             padding: const EdgeInsets.symmetric(horizontal: 15),
             child: Text("By deleting your account, you agree that you understand the consequences of this action and that you agree to permanently delete your account and all associated data. ", 
                       textAlign: TextAlign.center,
                       style: TextStyles.subtitle_17.copyWith(fontWeight: FontWeight.w400 )
                       
                       ),
           ),
const Gap(30),
        
            MainButton(text: "yes, Delete account", onPress:() {
          pop(context);
            },
            textStyle: TextStyles.body_15.copyWith(
              color: AppColors.lettersAndIcons,
            ),
            ),
              Gap(11),
             MainButton(text: "cancel", onPress:() {
              pop(context);
            },
            textStyle: TextStyles.body_15.copyWith(
              color: AppColors.darkGreen,
            ),
            backgroundColor: AppColors.lightGreen,
            ),
    
        ],
      ),
    ),
  );
  }
}
