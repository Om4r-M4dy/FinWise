import 'package:finwise/core/constants/app_colors.dart';
import 'package:finwise/core/functions/navigations.dart';
import 'package:finwise/core/styles/text_styles.dart';
import 'package:finwise/core/widgets/default_app_bar.dart';
import 'package:finwise/core/widgets/main_button.dart';
import 'package:finwise/core/widgets/my_body_view.dart';
import 'package:finwise/features/settings/delete_account/widgets/delete_dialog.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class DeleteAccoutScreen extends StatelessWidget {
  const DeleteAccoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DefaultAppBar(title: "Delete Accout"),
      body: MyBodyView(bottomSection: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text("Are You Sure You Want To Delete Your Account?",
          textAlign: TextAlign.center,

          style: TextStyles.body_15,),
      Gap(24),
          Container(
      padding: EdgeInsets.only(left: 25,right: 25,top: 25),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              color: AppColors.lightGreen
            ),
            child: Text(
              """This action will permanently delete all of your data, and you will not be able to recover it. Please keep the following in mind before proceeding:
                
  • All your expenses, income and associated transactions will be eliminated.
  
  • You will not be able to access your account or any related information.
  
  • This action cannot be undone.
                                """,
              style: TextStyles.caption2_13.copyWith(
                fontWeight: FontWeight.w300
              ),
            ),
          ),
          Gap(34),
           Text("Please Enter Your Password To Confirm Deletion Of Your Account.",
          textAlign: TextAlign.center,
          style: TextStyles.body_15,),
            Gap(34),
            // password field

            MainButton(text: "yes, Delete account", onPress:() {
              showDialog(context: context
              , builder: (context) => DeleteDialog());
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
      )),
    );
  }
}
