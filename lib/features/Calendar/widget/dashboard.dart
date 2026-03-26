import 'package:finwise/core/constants/app_assets.dart';
import 'package:finwise/core/constants/app_colors.dart';
import 'package:finwise/core/styles/text_styles.dart';
import 'package:finwise/core/widgets/info_record.dart';
import 'package:finwise/core/widgets/main_button.dart';
import 'package:finwise/features/calendar/widget/categories_chart.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

enum DashboardView { spends, categories }

/// Displays a segmented dashboard for calendar details (spends vs categories).
///
/// This widget manages its own toggle state and swaps between a chart view and a
/// transaction list view as a lightweight local UI state machine.
class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  // Tracks the current tab selection; starts in categories to match onboarding flow.
  DashboardView _currentView = DashboardView.categories;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: MainButton(
                text: 'Spends',
                size: ButtonSize.small,
                textStyle: TextStyles.body_15,
                onPress: () {
                  setState(() {
                    _currentView = DashboardView.spends;
                  });
                },
                backgroundColor: _currentView == DashboardView.spends
                    ? AppColors.mainGreen
                    : AppColors.lightGreen,
              ),
            ),
            Gap(19),
            Expanded(
              child: MainButton(
                text: 'Categories',
                size: ButtonSize.small,
                textStyle: TextStyles.body_15,
                onPress: () {
                  setState(() {
                    _currentView = DashboardView.categories;
                  });
                },
                backgroundColor: _currentView == DashboardView.categories
                    ? AppColors.mainGreen
                    : AppColors.lightGreen,
              ),
            ),
          ],
        ),

        _currentView == DashboardView.categories
            ? const CategoriesChart()
            : ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),

                padding: const EdgeInsets.only(top: 35),

                itemCount: 4,

                separatorBuilder: (context, index) => const Gap(15),

                itemBuilder: (context, index) {
                  return const InfoRecord(
                    iconPath: AppAssets.groceries,
                    title: 'Groceries',
                    date: '17:00 - April 24',
                    cat: 'Pantry',
                    amount: '-100,00',
                  );
                },
              ),
      ],
    );
  }
}
