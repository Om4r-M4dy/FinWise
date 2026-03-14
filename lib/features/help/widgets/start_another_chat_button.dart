import 'package:finwise/core/constants/app_colors.dart';
import 'package:finwise/core/functions/navigations.dart';
import 'package:finwise/core/routes/routes.dart';
import 'package:finwise/core/styles/text_styles.dart';
import 'package:flutter/material.dart';

class StartAnotherChatButton extends StatelessWidget {
  const StartAnotherChatButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      onPressed: () {
        pushTo(context, Routes.chatScreen);
      },
      label: Text(
        'Start Another Chat',
        style: TextStyles.body_15.copyWith(fontWeight: FontWeight.w500)
      ),
      backgroundColor: AppColors.mainGreen,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
      ),
      elevation: 0,
    );
  }
}