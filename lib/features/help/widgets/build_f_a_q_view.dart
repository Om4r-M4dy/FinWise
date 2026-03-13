import 'package:finwise/core/styles/text_styles.dart';
import 'package:flutter/material.dart';

class BuildFAQView extends StatelessWidget {
  const BuildFAQView({
    super.key,
  });

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

  return Column(
  children: faqs.asMap().entries.map((entry) {
    int index = entry.key;
    String question = entry.value;
    return Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        title: Text(question, style: TextStyles.body_15),
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16,),
            child: Text(answers[index], style: TextStyles.caption2_13),
          ),
        ],
      ),
    );
  }).toList(),
);
}
}