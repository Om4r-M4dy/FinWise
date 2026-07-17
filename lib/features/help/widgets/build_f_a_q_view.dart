import 'package:finwise/core/constants/app_colors.dart';
import 'package:finwise/core/styles/text_styles.dart';
import 'package:flutter/material.dart';

class BuildFAQView extends StatelessWidget {
  const BuildFAQView({super.key});

  @override
  Widget build(BuildContext context) {
    final faqs = [
      "How to use FinWise?",
      "How much does it cost to use FinWise?",
      "How to contact support?",
      "How can I reset my password if I forget it?",
      "Are there any privacy or data security measures in place?",
      "Can I customize settings within the application?",
      "How can I delete my account?",
      "How do I access my expense history?",
      "Can I use the app offline?",
    ];

    final answers = [
      "FinWise helps you track your financial health. Add transactions (income or expenses) in categories, set up goals, and view your monthly budgets and analyses on the dashboard.",
      "FinWise is completely free to use. All tracking, category planning, budgeting, and dashboard analytics tools are free of charge.",
      "You can contact support directly from the 'Contact Us' tab by sending an email to eedf4730@gmail.com or messaging via WhatsApp at +201011082763.",
      "Since security settings are hidden locally, please contact support at eedf4730@gmail.com for manual assistance with account access.",
      "Yes, your transactions and financial profiles are stored securely in Firestore. We prioritize your privacy and do not share data with third parties.",
      "Yes, you can toggle the Dark Theme, manage Notification Settings, and update your profile details under the Settings screen.",
      "Go to Settings -> Delete Account, enter your password to verify ownership, and confirm deletion to permanently erase your profile and records.",
      "You can view your full transaction history by selecting the 'Transactions' option on your Profile Screen or tapping history logs on the dashboard.",
      "While some features work offline with cached data, an active internet connection is recommended to sync changes to your account."
    ];

    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      children: faqs.asMap().entries.map((entry) {
        int index = entry.key;
        String question = entry.value;
        return Theme(
          data: Theme.of(context).copyWith(
            dividerColor: Colors.transparent,
            unselectedWidgetColor: isDark ? Colors.white : AppColors.lettersAndIcons,
          ),
          child: ExpansionTile(
            iconColor: AppColors.mainGreen,
            collapsedIconColor: isDark ? Colors.white : AppColors.lettersAndIcons,
            title: Text(
              question,
              style: TextStyles.bodyMedium.copyWith(
                color: isDark ? Colors.white : AppColors.lettersAndIcons,
                fontWeight: FontWeight.w600,
              ),
            ),
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 16, right: 16, bottom: 12),
                child: Text(
                  answers[index],
                  style: TextStyles.bodySmall.copyWith(
                    color: isDark
                        ? Colors.white.withValues(alpha: 0.7)
                        : AppColors.lettersAndIcons.withValues(alpha: 0.7),
                  ),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
