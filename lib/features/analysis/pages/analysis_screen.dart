import 'package:finwise/core/widgets/default_app_bar.dart';
import 'package:finwise/core/widgets/my_body_view.dart';
import 'package:finwise/core/widgets/progress_section.dart';
import 'package:flutter/material.dart';

class AnalysisScreen extends StatelessWidget {
  const AnalysisScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DefaultAppBar(title: "Analysis"),
      body: MyBodyView(
        topSection: ProgressSection(percentage: 30, totalAmount: 20000.00, totalExpanse: 1187.40, totalBalance: 7783.00),
        bottomSection: Column(
          children: [
            
          ],
        )),
    );
  }
}