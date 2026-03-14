import 'package:custom_sliding_segmented_control/custom_sliding_segmented_control.dart';
import 'package:finwise/core/constants/app_colors.dart';
import 'package:finwise/core/styles/text_styles.dart';
import 'package:finwise/core/widgets/default_app_bar.dart';
import 'package:finwise/core/widgets/my_body_view.dart';
import 'package:finwise/features/help/widgets/build_contact_view.dart';
import 'package:finwise/features/help/widgets/build_f_a_q_view.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class HelpCenter extends StatefulWidget {
  const HelpCenter({super.key});

  @override
  State<HelpCenter> createState() => _HelpCenterState();
}

class _HelpCenterState extends State<HelpCenter> {
  int selectedIndex = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DefaultAppBar(title: 'Help & FAQS'),
      body: MyBodyView(
        bottomSection: Center(
          child: Column(
            children: [
              Text('How Can We Help You?'),
              Gap(27),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(22),
                  color: AppColors.lightGreen,
                ),
                child: CustomSlidingSegmentedControl<int>(
                  initialValue: selectedIndex,
                  fixedWidth: (MediaQuery.of(context).size.width - 100) / 2,
                  height: 50,
                  children: {
                    1: SizedBox(
                      width: 169,
                      child: Center(
                        child: Text('FAQ', style: TextStyles.body_15),
                      ),
                    ),
                    2: SizedBox(
                      width: 169,
                      child: Center(
                        child: Text('Contact Us', style: TextStyles.body_15),
                      ),
                    ),
                  },
                  decoration: BoxDecoration(
                    color: AppColors.lightGreen,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  thumbDecoration: BoxDecoration(
                    color: AppColors.mainGreen,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  onValueChanged: (value) {
                    setState(() {
                      selectedIndex = value;
                    });
                  },
                ),
              ),
              Gap(9),
              Expanded(
                child: ListView(
                  children: [
                    selectedIndex == 1
                        ? const BuildFAQView()
                        : const BuildContactView(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}