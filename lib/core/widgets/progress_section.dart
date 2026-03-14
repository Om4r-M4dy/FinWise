import 'package:finwise/core/constants/app_assets.dart';
import 'package:finwise/core/constants/app_colors.dart';
import 'package:finwise/core/styles/text_styles.dart';
import 'package:finwise/core/widgets/custom_svg_picture.dart';
import 'package:finwise/core/widgets/percentage_bar.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class ProgressSection extends StatelessWidget {
  const ProgressSection({
    super.key,
    required this.percentage,
    required this.totalAmount,
    required this.totalExpanse,
    required this.totalBalance,
    this.extraInfo,
  });
  final double percentage;
  final double totalAmount;
  final double totalExpanse;
  final double totalBalance;
  final Widget? extraInfo;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        IntrinsicHeight(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              TotalMoney(total: totalBalance),
              VerticalDivider(
                color: AppColors.background,
                thickness: 1,
                width: 24,
                indent: 8,
                endIndent: 8,
              ),
              TotalMoney(total: totalExpanse, isExpanse: true),
            ],
          ),
        ),
        const Gap(12),
        PercentageBar(percentage: percentage, totalAmount: totalAmount),
        if (extraInfo != null) ...[
          const Gap(29),
          extraInfo!,
          const Gap(22),
        ] else
          const Gap(10),
        Row(
          children: [
            Icon(Icons.check_box_outlined, color: AppColors.dark05, size: 12),
            const Gap(6),
            Text(
              "30% of your expenses, looks good.",
              style: TextStyles.body_15,
            ),
          ],
        ),
      ],
    );
  }
}

class TotalMoney extends StatelessWidget {
  const TotalMoney({super.key, required this.total, this.isExpanse = false});
  final bool isExpanse;
  final double total;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            CustomSvgPicture(
              path: isExpanse ? AppAssets.expense : AppAssets.income,
              width: 12,
            ),
            const Gap(7),
            Text(
              isExpanse ? "Total Expanse" : "Total Balance",
              style: TextStyles.caption2_13,
            ),
          ],
        ),
        Text(
          isExpanse
              ? "- \$${total.toStringAsFixed(2)}"
              : "\$${total.toStringAsFixed(2)}",
          style: TextStyles.headline_24.copyWith(
            color: isExpanse ? AppColors.oceanBlueButton : AppColors.background,
          ),
        ),
      ],
    );
  }
}
