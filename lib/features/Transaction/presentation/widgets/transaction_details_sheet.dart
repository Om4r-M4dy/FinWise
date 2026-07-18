import 'package:finwise/core/constants/app_colors.dart';
import 'package:finwise/core/styles/text_styles.dart';
import 'package:finwise/core/widgets/buttons/icon_with_text_button.dart';
import 'package:finwise/features/Transaction/data/model/transaction_model.dart';
import 'package:finwise/features/Transaction/presentation/cubit/transaction_cubit.dart';
import 'package:finwise/features/profile/persentation/cubit/user_cubit.dart';
import 'package:finwise/features/saving_goals/persentation/cubit/goal_cubit.dart';
import 'package:finwise/core/functions/navigations.dart';
import 'package:finwise/core/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:finwise/core/extentions/transaction_extension.dart';

void showTransactionDetailsSheet(
  BuildContext context,
  TransactionModel transaction,
) {
  final transactionCubit = context.read<TransactionCubit>();
  final userCubit = context.read<UserCubit>();

  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (modalContext) {
      return MultiBlocProvider(
        providers: [
          BlocProvider.value(value: transactionCubit),
          BlocProvider.value(value: userCubit),
        ],
        child: TransactionDetailsSheet(transaction: transaction),
      );
    },
  );
}

class TransactionDetailsSheet extends StatelessWidget {
  final TransactionModel transaction;
  const TransactionDetailsSheet({super.key, required this.transaction});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final amountColor =
        transaction.getAmountColor(useGreenForIncome: true) ??
        theme.colorScheme.onSurface;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(32),
          topRight: Radius.circular(32),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 5,
              decoration: BoxDecoration(
                color: AppColors.mainGreen,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          const Gap(24),
          Text(
            'Transaction Details',
            style: TextStyles.bodyLarge.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onSurface,
            ),
          ),
          const Gap(20),

          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: AppColors.mainGreen.withValues(alpha: 0.15),
                width: 1.2,
              ),
              boxShadow: [
                BoxShadow(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.04),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildRow(context, 'Title', transaction.title),
                Divider(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.12),
                  height: 24,
                  thickness: 1,
                ),
                _buildRow(
                  context,
                  'Category',
                  transaction.categoryName.isNotEmpty
                      ? transaction.categoryName
                      : 'General',
                ),
                Divider(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.12),
                  height: 24,
                  thickness: 1,
                ),
                _buildRow(
                  context,
                  'Amount',
                  transaction.getFormattedAmount(showPlusForIncome: true),
                  valueColor: amountColor,
                ),
                Divider(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.12),
                  height: 24,
                  thickness: 1,
                ),
                _buildRow(context, 'Type', transaction.type.toUpperCase()),
                Divider(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.12),
                  height: 24,
                  thickness: 1,
                ),
                _buildRow(context, 'Date & Time', transaction.formattedDate),
                if (transaction.note.trim().isNotEmpty) ...[
                  Divider(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.12),
                    height: 24,
                    thickness: 1,
                  ),
                  Text(
                    'Note',
                    style: TextStyles.bodyMedium.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const Gap(6),
                  Text(
                    transaction.note,
                    style: TextStyles.bodyMedium.copyWith(
                      color: theme.colorScheme.onSurface,
                    ),
                  ),
                ],
              ],
            ),
          ),
          const Gap(28),

          Row(
            children: [
              Expanded(
                child: IconWithTextButton(
                  onPress: () {
                    pop(context); // Close bottom sheet
                    pushTo(
                      context,
                      Routes.addTransaction,
                      extra: {'transactionToEdit': transaction},
                    );
                  },
                  icon: Icons.edit_rounded,
                  text: 'Edit',
                  backgroundColor: Colors.transparent,
                  foregroundColor: AppColors.mainGreen.withValues(alpha: 0.8),
                ),
              ),
              const Gap(16),
              Expanded(
                child: IconWithTextButton(
                  onPress: () => _confirmDelete(context),
                  icon: Icons.delete_forever_rounded,
                  text: 'Delete',
                  backgroundColor: Colors.transparent,
                  foregroundColor: Colors.redAccent,
                ),
              ),
            ],
          ),
          const Gap(12),
        ],
      ),
    );
  }

  Widget _buildRow(
    BuildContext context,
    String label,
    String value, {
    Color? valueColor,
  }) {
    final theme = Theme.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyles.bodyMedium.copyWith(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
            fontWeight: FontWeight.w500,
          ),
        ),
        const Gap(16),
        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.end,
            style: TextStyles.bodyMedium.copyWith(
              fontWeight: FontWeight.bold,
              color: valueColor ?? theme.colorScheme.onSurface,
            ),
          ),
        ),
      ],
    );
  }

  void _confirmDelete(BuildContext context) {
    final theme = Theme.of(context);
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: theme.colorScheme.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Text(
            'Delete Transaction',
            style: TextStyles.bodyLarge.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onSurface,
            ),
          ),
          content: Text(
            'Are you sure you want to delete this transaction? This action cannot be undone.',
            style: TextStyles.bodyMedium.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.8),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: Text(
                'Cancel',
                style: TextStyles.bodyMedium.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.pop(dialogContext); // Close dialog
                pop(context); // Close bottom sheet

                final transactionCubit = context.read<TransactionCubit>();
                final userCubit = context.read<UserCubit>();
                final goalCubit = context.read<GoalCubit>();

                await transactionCubit.deleteTransactionWithFinancials(
                  transaction: transaction,
                  userCubit: userCubit,
                  goalCubit: goalCubit,
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }
}
