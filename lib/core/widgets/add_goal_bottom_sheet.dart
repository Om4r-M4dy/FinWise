import 'package:finwise/core/constants/app_colors.dart';
import 'package:finwise/core/styles/text_styles.dart';
import 'package:finwise/features/analysis/cubit/goal_cubit.dart';
import 'package:finwise/features/analysis/data/model/goal_model.dart';
import 'package:finwise/features/profile/cubit/user_cubit.dart';
import 'package:finwise/features/profile/cubit/user_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

void showAddGoalBottomSheet(
  BuildContext context, {
  GoalModel? goal,
  VoidCallback? onDeleteSuccess,
}) {
  final titleController = TextEditingController(text: goal?.title);
  final amountController = TextEditingController(
    text: goal != null ? goal.targetAmount.toStringAsFixed(2) : '',
  );
  final formKey = GlobalKey<FormState>();

  final theme = Theme.of(context);

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: theme.colorScheme.surface,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(30),
        topRight: Radius.circular(30),
      ),
    ),
    builder: (sheetContext) {
      final sheetTheme = Theme.of(sheetContext);
      final sheetIsDark = sheetTheme.brightness == Brightness.dark;
      final progress = goal != null && goal.targetAmount > 0
          ? (goal.currentAmount / goal.targetAmount).clamp(0.0, 1.0)
          : 0.0;

      return Padding(
        padding: EdgeInsets.only(
          left: 24,
          right: 24,
          top: 24,
          bottom: MediaQuery.of(sheetContext).viewInsets.bottom + 24,
        ),
        child: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: sheetTheme.colorScheme.onSurface.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const Gap(20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    goal != null ? "Savings Target Details" : "Add Savings Target",
                    style: TextStyles.bodyLarge.copyWith(
                      fontWeight: FontWeight.bold,
                      color: sheetTheme.colorScheme.onSurface,
                    ),
                  ),
                  if (goal != null)
                    IconButton(
                      icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                      onPressed: () {
                        _showDeleteConfirmationDialog(
                          context,
                          goal,
                          sheetContext,
                          onDeleteSuccess,
                        );
                      },
                    ),
                ],
              ),
              const Gap(10),
              if (goal != null) ...[
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: sheetIsDark ? AppColors.darkGreen : AppColors.lightGreen,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Current Progress",
                            style: TextStyles.bodyMedium.copyWith(
                              color: sheetTheme.colorScheme.onSurface.withValues(alpha: 0.7),
                            ),
                          ),
                          Text(
                            "${(progress * 100).toInt()}%",
                            style: TextStyles.bodyMedium.copyWith(
                              fontWeight: FontWeight.bold,
                              color: AppColors.mainGreen,
                            ),
                          ),
                        ],
                      ),
                      const Gap(8),
                      LinearProgressIndicator(
                        value: progress,
                        backgroundColor: sheetIsDark ? AppColors.dark05 : AppColors.background,
                        color: AppColors.mainGreen,
                        minHeight: 8,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      const Gap(8),
                      Text(
                        "${goal.currentAmount.toStringAsFixed(2)} / ${goal.targetAmount.toStringAsFixed(2)}",
                        style: TextStyles.bodySmall.copyWith(
                          color: sheetTheme.colorScheme.onSurface.withValues(alpha: 0.6),
                        ),
                      ),
                    ],
                  ),
                ),
                const Gap(20),
              ],
              TextFormField(
                controller: titleController,
                style: TextStyles.bodyMedium.copyWith(
                  color: sheetTheme.colorScheme.onSurface,
                ),
                decoration: InputDecoration(
                  labelText: goal != null ? "Target Name" : "Target Name (e.g. Travel, Car, New House)",
                  labelStyle: TextStyles.bodyMedium.copyWith(
                    color: sheetTheme.colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                  filled: true,
                  fillColor: sheetIsDark ? AppColors.darkGreen : AppColors.lightGreen,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide.none,
                  ),
                ),
                validator: (val) {
                  if (val == null || val.trim().isEmpty) {
                    return "Please enter a target name";
                  }
                  return null;
                },
              ),
              const Gap(16),
              TextFormField(
                controller: amountController,
                style: TextStyles.bodyMedium.copyWith(
                  color: sheetTheme.colorScheme.onSurface,
                ),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(
                  labelText: "Target Amount",
                  labelStyle: TextStyles.bodyMedium.copyWith(
                    color: sheetTheme.colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                  filled: true,
                  fillColor: sheetIsDark ? AppColors.darkGreen : AppColors.lightGreen,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide.none,
                  ),
                ),
                validator: (val) {
                  if (val == null || val.trim().isEmpty) {
                    return "Please enter an amount";
                  }
                  if (double.tryParse(val.trim()) == null) {
                    return "Please enter a valid number";
                  }
                  return null;
                },
              ),
              const Gap(24),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      final userState = context.read<UserCubit>().state;
                      final String? userId = userState is UserLoaded
                          ? userState.user.uid
                          : context.read<UserCubit>().currentUser;

                      if (userId != null) {
                        if (goal != null) {
                          context.read<GoalCubit>().updateGoal(
                            goalId: goal.goalId,
                            title: titleController.text.trim(),
                            targetAmount: double.parse(amountController.text.trim()),
                            currentAmount: goal.currentAmount,
                            userId: userId,
                            createdAt: goal.createdAt,
                          );
                        } else {
                          context.read<GoalCubit>().addGoal(
                            title: titleController.text.trim(),
                            targetAmount: double.parse(amountController.text.trim()),
                            userId: userId,
                          );
                        }
                        Navigator.pop(sheetContext);
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.mainGreen,
                    foregroundColor: AppColors.lettersAndIcons,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  child: Text(
                    goal != null ? "Save Changes" : "Save Target",
                    style: TextStyles.bodyMedium.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}

void _showDeleteConfirmationDialog(
  BuildContext context,
  GoalModel goal,
  BuildContext sheetContext,
  VoidCallback? onDeleteSuccess,
) {
  showDialog(
    context: context,
    builder: (dialogContext) {
      final dialogTheme = Theme.of(dialogContext);
      return AlertDialog(
        backgroundColor: dialogTheme.colorScheme.surface,
        title: Text(
          "Delete Goal",
          style: TextStyles.bodyLarge.copyWith(
            fontWeight: FontWeight.bold,
            color: dialogTheme.colorScheme.onSurface,
          ),
        ),
        content: Text(
          "Are you sure you want to delete this savings goal? This action cannot be undone.",
          style: TextStyles.bodyMedium.copyWith(
            color: dialogTheme.colorScheme.onSurface.withValues(alpha: 0.8),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(
              "Cancel",
              style: TextStyles.bodyMedium.copyWith(
                color: dialogTheme.colorScheme.onSurface,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              final userState = context.read<UserCubit>().state;
              final String? userId = userState is UserLoaded
                  ? userState.user.uid
                  : context.read<UserCubit>().currentUser;
              if (userId != null) {
                context.read<GoalCubit>().deleteGoal(goal.goalId, userId);
              }
              Navigator.pop(dialogContext); // Close dialog
              Navigator.pop(sheetContext); // Close bottom sheet
              if (onDeleteSuccess != null) {
                onDeleteSuccess();
              }
            },
            child: Text(
              "Delete",
              style: TextStyles.bodyMedium.copyWith(
                color: Colors.redAccent,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      );
    },
  );
}
