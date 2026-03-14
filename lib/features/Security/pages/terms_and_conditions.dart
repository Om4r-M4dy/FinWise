import 'package:finwise/core/constants/app_colors.dart';
import 'package:finwise/core/styles/text_styles.dart';
import 'package:finwise/core/widgets/default_app_bar.dart';
import 'package:finwise/core/widgets/main_button.dart';
import 'package:finwise/core/widgets/my_body_view.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class TermsAndConditions extends StatefulWidget {
  const TermsAndConditions({super.key});

  @override
  State<TermsAndConditions> createState() => _TermsAndConditionsState();
}

class _TermsAndConditionsState extends State<TermsAndConditions> {
  bool isAccepted = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DefaultAppBar(title: 'Terms And Conditions'),
      body: MyBodyView(
        bottomSection: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionTitle("Service Agreement & User Privacy"),
            _buildBodyText(
              "By using FinWise, you acknowledge that you are managing your personal finances at your own risk. Our platform provides analytical tools to help you track expenses, set savings goals, and monitor revenue, but it does not replace professional financial advice.",
            ),

            _buildSectionTitle("1. Agreement to Terms"),
            _buildBodyText(
              "These terms constitute a legally binding agreement between you and FinWise. You agree that by accessing the App, you have read, understood, and agreed to be bound by all of these Terms and Conditions.",
            ),

            _buildSectionTitle("2. Usage Policy & Data"),
            _buildBulletPoint(
              "Users must provide accurate financial data for precise analysis.",
            ),
            _buildBulletPoint(
              "Account security is the sole responsibility of the user.",
            ),
            _buildBulletPoint(
              "FinWise reserves the right to update features for better UX.",
            ),
            _buildBulletPoint(
              "Data encryption is active for all stored credentials.",
            ),

            _buildSectionTitle("3. Financial Responsibility"),
            _buildBodyText(
              "FinWise serves as a tracking and budgeting tool. We are not liable for any financial losses, investment failures, or debt accumulation occurring while using the app. Always consult with a certified financial planner for significant life decisions.",
            ),

            _buildSectionTitle("4. Privacy Commitment"),
            _buildBodyText(
              "We value your privacy. Your spending habits and income details are strictly used to generate your personal 'Quickly Analysis' charts and are never shared with third-party advertisers without explicit consent.",
            ),
            const Gap(17),
            Row(
              children: [
                Checkbox(
                  value: isAccepted,
                  activeColor: AppColors.mainGreen,
                  onChanged: (val) => setState(() => isAccepted = val!),
                ),
                Text("I accept all the terms and conditions"),
              ],
            ),
            const Gap(17),
            Center(
              child: MainButton(
                text: 'Accept',
                onPress: isAccepted ? () {} : null,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 8),
      child: Text(title, style: TextStyles.subtitle_17),
    );
  }

  Widget _buildBodyText(String text) {
    return Text(text, style: TextStyles.caption2_13);
  }

  Widget _buildBulletPoint(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(" • ", style: TextStyles.body_15),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }
}
