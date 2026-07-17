import 'package:finwise/core/styles/text_styles.dart';
import 'package:finwise/core/widgets/default_app_bar.dart';
import 'package:finwise/core/widgets/my_body_view.dart';
import 'package:finwise/core/services/local/user_prefs.dart';
import 'package:finwise/features/settings/notification_settings/widgets/toggle.dart';
import 'package:flutter/material.dart';

class NotificationSettingsScreen extends StatefulWidget {
  const NotificationSettingsScreen({super.key});

  @override
  State<NotificationSettingsScreen> createState() => _NotificationSettingsScreenState();
}

class _NotificationSettingsScreenState extends State<NotificationSettingsScreen> {
  final List<Map<String, String>> settings = [
    {"title": "General Notification", "key": "notif_general"},
    {"title": "Sound", "key": "notif_sound"},
    {"title": "Sound Call", "key": "notif_sound_call"},
    {"title": "Vibrate", "key": "notif_vibrate"},
    {"title": "Transaction Update", "key": "notif_transaction_update"},
    {"title": "Expense Reminder ", "key": "notif_expense_reminder"},
    {"title": "Budget Notifications", "key": "notif_budget"},
    {"title": "Low Balance Alerts", "key": "notif_low_balance"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const DefaultAppBar(title: "Notification Settings"),
      body: MyBodyView(
        bottomSection: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: settings.map((item) {
                final title = item["title"]!;
                final key = item["key"]!;
                final isOn = UserPrefs.getNotifSetting(key);

                return Padding(
                  padding: const EdgeInsets.only(bottom: 27),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        title,
                        style: TextStyles.bodyMedium.copyWith(
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                      Toggle(
                        isOn: isOn,
                        onChanged: (value) async {
                          await UserPrefs.setNotifSetting(key, value);
                          setState(() {});
                        },
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }
}
