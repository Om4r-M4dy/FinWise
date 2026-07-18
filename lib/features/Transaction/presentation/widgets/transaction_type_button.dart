import 'package:flutter/material.dart';
import 'package:finwise/core/constants/app_colors.dart';
import 'package:finwise/core/styles/text_styles.dart';
import 'package:finwise/features/Transaction/presentation/cubit/transaction_cubit.dart';

class TransactionTypeButton extends StatelessWidget {
  const TransactionTypeButton({
    super.key,
    required this.cubit,
    required this.type,
  });

  final TransactionCubit cubit;
  final String type;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: () => cubit.setType(type),
      child: Container(
        height: 48,
        decoration: BoxDecoration(
          color: cubit.selectedType == type
              ? AppColors.mainGreen.withValues(alpha: 0.15)
              : theme.colorScheme.primaryContainer,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: cubit.selectedType == type
                ? AppColors.mainGreen
                : Colors.transparent,
            width: 2,
          ),
        ),
        alignment: Alignment.center,
        child: Text(
          type,
          style: TextStyles.bodySmall.copyWith(
            color: cubit.selectedType == type
                ? AppColors.mainGreen
                : theme.colorScheme.onPrimaryContainer,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
