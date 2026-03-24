import 'package:finwise/core/styles/text_styles.dart';
import 'package:finwise/core/widgets/default_app_bar.dart';
import 'package:finwise/core/widgets/my_body_view.dart';
import 'package:finwise/features/settings/notification_settings/widgets/toggle.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class NotificationSettingsScreen extends StatelessWidget {
  const NotificationSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DefaultAppBar(title: "Notification Settings"),
    body: MyBodyView(
      bottomSection: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              NotifysettingElement(title: "General Notification",),
              Gap(27),
              NotifysettingElement(title: "Sound",),
                Gap(27),
              NotifysettingElement(title: "Sound Call",),
                Gap(27),
              NotifysettingElement(title: "Vibrate",),
                Gap(27),
              NotifysettingElement(title: "Transaction Update",),
                Gap(27),
              NotifysettingElement(title: "Expense Reminder ",),
                Gap(27),
              NotifysettingElement(title: "Budget Notifications",),
                Gap(27),
              NotifysettingElement(title: "Low Balance Alerts",),
           
           
            ],
          ),
        ),
      )),
    );
  }
}

class NotifysettingElement extends StatelessWidget {
  const NotifysettingElement({
    super.key, required this.title,
  });
final String title;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title,style: TextStyles.body_15.copyWith(
          color: Color(0xff363130),
        ),),
      Toggle(),
      ],
    );
  }
}