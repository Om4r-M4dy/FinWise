import 'package:finwise/core/constants/app_assets.dart';
import 'package:finwise/core/constants/app_colors.dart';
import 'package:finwise/core/styles/text_styles.dart';
import 'package:finwise/core/widgets/custom_svg_picture.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:finwise/features/profile/cubit/user_cubit.dart';
import 'package:finwise/features/profile/cubit/user_state.dart';

import 'package:finwise/core/functions/format_amount.dart';

class IncomeExpenseRow extends StatelessWidget {
  const IncomeExpenseRow({super.key, this.bg});
  final Color? bg;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserCubit, UserState>(
      builder: (context, userState) {
        final user = userState is UserLoaded ? userState.user : null;
        final income = user?.totalIncome ?? 0.0;
        final expense = user?.totalExpense ?? 0.0;

        return Row(
          children: [
            Expanded(
              child: Info(
                bg: bg,
                icon: AppAssets.income,
                color: AppColors.mainGreen,
                title: "Income",
                amount: formatAmount(income),
              ),
            ),
            Gap(15),
            Expanded(
              child: Info(
                bg: bg,
                icon: AppAssets.expense,
                color: AppColors.oceanBlueButton,
                title: "Expense",
                amount: formatAmount(expense),
                isExpense: true,
              ),
            ),
          ],
        );
      },
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
    this.isExpense = false,
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
            const Gap(4),
            Text(
              title,
              style: TextStyles.bodyMedium.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              amount,
              style: TextStyles.bodyLarge.copyWith(
                fontWeight: FontWeight.w600,
                color: isExpense ? color : AppColors.dark05,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
