import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:finwise/core/constants/app_assets.dart';
import 'package:finwise/core/constants/transaction_type_enum.dart';
import 'package:finwise/core/styles/text_styles.dart';
import 'package:finwise/core/widgets/custom_svg_picture.dart';
import 'package:finwise/features/Transaction/presentation/cubit/transaction_cubit.dart';
import 'package:finwise/features/saving_goals/persentation/cubit/goal_cubit.dart';
import 'package:finwise/features/saving_goals/persentation/cubit/goal_state.dart';

class TransactionGoalSelector extends StatelessWidget {
  final TransactionCubit cubit;

  const TransactionGoalSelector({super.key, required this.cubit});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    if (cubit.selectedCategory != '2') return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.only(left: 10),
          child: Text(
            "Link to Saving Goal",
            style: TextStyles.bodyMedium.copyWith(
              color: theme.colorScheme.onSurface,
            ),
          ),
        ),
        const Gap(4),
        SizedBox(
          height: 48,
          child: BlocBuilder<GoalCubit, GoalState>(
            builder: (context, goalState) {
              final hasSelectedGoal =
                  goalState is GoalLoadedState &&
                  goalState.goals.any(
                    (g) => g.goalId == cubit.selectedGoalId,
                  );
              final dropdownValue =
                  hasSelectedGoal ? cubit.selectedGoalId : null;

              List<DropdownMenuItem<String>> items = [];
              if (goalState is GoalLoadedState) {
                items = goalState.goals.map((goal) {
                  return DropdownMenuItem<String>(
                    value: goal.goalId,
                    child: Text(
                      goal.title,
                      style: TextStyles.bodyMedium.copyWith(
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                  );
                }).toList();
              }

              return DropdownButtonFormField<String?>(
                isExpanded: true,
                initialValue: dropdownValue,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: theme.colorScheme.primaryContainer,
                  hintText: "Select a Savings Goal (Optional)",
                  hintStyle: TextStyles.bodyMedium.copyWith(
                    color: theme.colorScheme.onSurface.withValues(
                      alpha: 0.5,
                    ),
                  ),
                  suffixIcon: Container(
                    margin: const EdgeInsets.all(8),
                    child: CustomSvgPicture(
                      path: AppAssets.arrowDown,
                    ),
                  ),
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 16,
                  ),
                ),
                items: [
                  DropdownMenuItem<String?>(
                    value: null,
                    child: Text(
                      "None / General Savings",
                      style: TextStyles.bodyMedium.copyWith(
                        color: theme.colorScheme.onSurface.withValues(
                          alpha: 0.5,
                        ),
                      ),
                    ),
                  ),
                  ...items,
                ],
                onChanged: (value) {
                  cubit.setGoalId(value);
                },
              );
            },
          ),
        ),
        const Gap(6),
        Padding(
          padding: const EdgeInsets.only(left: 10),
          child: Text(
            cubit.selectedType == TransactionTypeEnum.expense.value
                ? "* This transaction will add money to the selected goal."
                : "* This transaction will withdraw money from the selected goal.",
            style: TextStyles.bodySmall.copyWith(
              color: theme.colorScheme.onSurface.withValues(
                alpha: 0.6,
              ),
              fontStyle: FontStyle.italic,
            ),
          ),
        ),
        const Gap(24),
      ],
    );
  }
}
