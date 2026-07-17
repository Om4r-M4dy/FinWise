import 'package:finwise/core/constants/app_colors.dart';
import 'package:finwise/core/functions/category_icon_helper.dart';
import 'package:finwise/core/styles/text_styles.dart';
import 'package:finwise/core/widgets/buttons/app_icon_button.dart';
import 'package:finwise/features/Transaction/data/model/transaction_model.dart';
import 'package:finwise/features/Transaction/presentation/widgets/transaction_details_sheet.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class InfoRecord extends StatelessWidget {
  const InfoRecord({
    super.key,
    this.transaction,
    this.iconPath,
    required this.title,
    required this.date,
    required this.cat,
    required this.amount,
    this.amountColor,
    this.bgColor,
  });

  final TransactionModel? transaction;
  final String? iconPath;
  final String title;
  final String date;
  final String cat;
  final String amount;
  final Color? amountColor;
  final Color? bgColor;

  @override
  Widget build(BuildContext context) {
    final recordRow = Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        AppIconButton(
          path: iconPath ?? getIconForCategory(cat),
          bgColor: bgColor ?? AppColors.lightBlueButton,
          iconColor: AppColors.background,
          iconWidth: 23,
          bgWidth: 47,
          bgHeight: 47,
          borderRadius: 16,
        ),
        const Gap(10),
        SizedBox(
          width: MediaQuery.of(context).size.width * .25,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyles.bodyMedium.copyWith(
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              Text(
                date,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyles.bodySmall.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.oceanBlueButton,
                ),
              ),
            ],
          ),
        ),

        Container(
          width: 1,
          height: MediaQuery.of(context).size.width * .08,
          margin: const EdgeInsets.symmetric(horizontal: 3),
          color: AppColors.mainGreen,
        ),
        SizedBox(
          width: 60,
          child: Text(
            cat,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyles.bodySmall.copyWith(
              fontWeight: FontWeight.w300,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
        ),
        Container(
          width: 1,
          height: MediaQuery.of(context).size.width * .08,
          margin: const EdgeInsets.symmetric(horizontal: 3),
          color: AppColors.mainGreen,
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width * .19,
          child: Text(
            amount,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyles.bodyMedium.copyWith(
              color: amountColor ?? Theme.of(context).colorScheme.onSurface,
            ),
          ),
        ),
      ],
    );

    if (transaction != null) {
      return InkWell(
        onTap: () => showTransactionDetailsSheet(context, transaction!),
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: recordRow,
        ),
      );
    }

    return recordRow;
  }
}
