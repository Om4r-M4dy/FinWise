import 'package:finwise/core/constants/app_assets.dart';
import 'package:finwise/core/constants/app_colors.dart';
import 'package:finwise/core/styles/text_styles.dart';
import 'package:finwise/core/widgets/custom_svg_picture.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class IncomeExpenseRow extends StatelessWidget {
  const IncomeExpenseRow({super.key, this.bg});
  final Color? bg;

  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Info(
            bg: bg,
            icon: AppAssets.income,
            color: AppColors.mainGreen,
            title: "Income",
            amount: "4,000.00",
          ),
        ),
        Gap(15),
        Expanded(
          child: Info(
            bg: bg,
            icon: AppAssets.expense,
            color: AppColors.oceanBlueButton,
            title: "Expense",
            amount: "1.187.40",
          ),
        ),
      ],
    );
  }
}

class Info extends StatelessWidget {
  const Info({
    super.key,
    required this.bg,
    required this.icon,
    required this.color,
    required this.title,
    required this.amount,
    this.isExpense=false,
  });

  final Color? bg;
  final String icon;
  final Color? color;
  final String title;
  final String amount;
final bool isExpense;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      decoration: BoxDecoration(
        color: bg ?? Colors.transparent,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Center(
        child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomSvgPicture(path: icon, color: color, width: 25),
          const  Gap(4),
            Text(
              title,
              style: TextStyles.body_15.copyWith(fontWeight: FontWeight.w500),
            ),
            Text(
             '\$$amount',
              style: TextStyles.title_20.copyWith(
                fontWeight: FontWeight.w600,
                color: isExpense?color:AppColors.dark05,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
