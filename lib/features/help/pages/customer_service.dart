import 'package:finwise/core/constants/app_colors.dart';
import 'package:finwise/core/functions/navigations.dart';
import 'package:finwise/core/routes/routes.dart';
import 'package:finwise/core/styles/text_styles.dart';
import 'package:finwise/core/widgets/default_app_bar.dart';
import 'package:finwise/core/widgets/my_body_view.dart';
import 'package:flutter/material.dart';

class CustomerService extends StatelessWidget {
  const CustomerService({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DefaultAppBar(title: 'Online Support'),
      body: MyBodyView(bottomSection: Column()),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
  floatingActionButton: FloatingActionButton.extended(
    onPressed: () {
      pushTo(context, Routes.chatScreen);
    },
    
    label: const Text(
      'Start Another Chat',
      style: TextStyles.body_15
    ),
    backgroundColor: AppColors.mainGreen,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(30),
    ),
    elevation: 0,
  ),
    );
  }
}