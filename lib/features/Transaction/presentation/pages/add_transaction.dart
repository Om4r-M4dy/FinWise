import 'package:date_field/date_field.dart';
import 'package:finwise/core/constants/app_assets.dart';
import 'package:finwise/core/constants/app_colors.dart';
import 'package:finwise/core/constants/categories.dart';
import 'package:finwise/core/constants/transaction_type_enum.dart';
import 'package:finwise/core/extentions/dialogs.dart';
import 'package:finwise/core/widgets/dialogs/loading_dialog.dart';
import 'package:finwise/core/functions/navigations.dart';
import 'package:finwise/core/routes/routes.dart';
import 'package:finwise/core/styles/text_styles.dart';
import 'package:finwise/core/widgets/custom_svg_picture.dart';
import 'package:finwise/core/widgets/default_app_bar.dart';
import 'package:finwise/core/widgets/main_button.dart';
import 'package:finwise/core/widgets/my_body_view.dart';
import 'package:finwise/features/Transaction/presentation/cubit/transaction_cubit.dart';
import 'package:finwise/features/Transaction/presentation/widgets/ai_scanner_bar.dart';
import 'package:finwise/features/Transaction/presentation/cubit/transaction_states.dart';
import 'package:finwise/features/profile/cubit/user_cubit.dart';
import 'package:finwise/features/Transaction/data/model/transaction_model.dart';
import 'package:finwise/features/analysis/cubit/goal_cubit.dart';
import 'package:finwise/features/analysis/cubit/goal_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

class AddTransaction extends StatelessWidget {
  final TransactionModel? transactionToEdit;
  final bool showAppBar;

  const AddTransaction({
    super.key,
    this.transactionToEdit,
    this.showAppBar = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cubit = context.read<TransactionCubit>();

    return Scaffold(
      appBar: showAppBar
          ? DefaultAppBar(
              title: transactionToEdit == null
                  ? "Add Transaction"
                  : "Edit Transaction",
            )
          : null,

      body: MyBodyView(
        clipBehavior: Clip.antiAlias,
        topSection: const AIScannerBar(),
        noPadding: true,
        bottomSection: SingleChildScrollView(
          padding: const EdgeInsets.only(
            left: 37.0,
            right: 37.0,
            top: 40.0,
            bottom: 110.0,
          ),
          child: BlocConsumer<TransactionCubit, TransactionStates>(
            listener: (context, state) {
              if (state is TransactionLoadingState) {
                LoadingDialog.show(context);
              } else if (state is TransactionSuccessState) {
                LoadingDialog.hide(context);
                showMyDialog(
                  context,
                  transactionToEdit == null
                      ? 'Transaction saved successfully!'
                      : 'Transaction updated successfully!',
                  type: DialogType.success,
                );
                showAppBar
                    ? pop(context)
                    : pushTo(context, Routes.bottomNavBar, extra: 0);
              } else if (state is TransactionErrorState) {
                LoadingDialog.hide(context);
                showMyDialog(context, state.errorMessage);
              }
            },
            builder: (context, state) {
              return Form(
                key: cubit.formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(left: 10),
                      child: Text(
                        "Transaction Type",
                        style: TextStyles.bodyMedium.copyWith(
                          color: theme.colorScheme.onSurface,
                        ),
                      ),
                    ),
                    const Gap(8),
                    Row(
                      children: [
                        Expanded(
                          child: TransactionTypeButton(
                            cubit: cubit,
                            type: TransactionTypeEnum.expense.value,
                          ),
                        ),
                        const Gap(16),
                        Expanded(
                          child: TransactionTypeButton(
                            cubit: cubit,
                            type: TransactionTypeEnum.income.value,
                          ),
                        ),
                      ],
                    ),
                    const Gap(24),

                    Container(
                      margin: const EdgeInsets.only(left: 10),
                      child: Text(
                        "Date",
                        style: TextStyles.bodyMedium.copyWith(
                          color: theme.colorScheme.onSurface,
                        ),
                      ),
                    ),
                    const Gap(4),
                    SizedBox(
                      height: 48,
                      child: DateTimeFormField(
                        initialValue: cubit.selectedDate,
                        mode: DateTimeFieldPickerMode.date,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: theme.colorScheme.primaryContainer,
                          hintText: "Select Date",
                          hintStyle: TextStyles.bodyMedium.copyWith(
                            color: theme.colorScheme.onSurface.withValues(
                              alpha: 0.5,
                            ),
                          ),
                          suffixIcon: Container(
                            margin: const EdgeInsets.all(10),
                            child: CustomSvgPicture(path: AppAssets.calender),
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
                        onChanged: (DateTime? val) {
                          if (val != null) {
                            cubit.setDate(val);
                          }
                        },
                      ),
                    ),
                    const Gap(24),

                    Container(
                      margin: const EdgeInsets.only(left: 10),
                      child: Text(
                        "Category",
                        style: TextStyles.bodyMedium.copyWith(
                          color: theme.colorScheme.onSurface,
                        ),
                      ),
                    ),
                    const Gap(4),
                    SizedBox(
                      height: 48,
                      child: DropdownButtonFormField<String>(
                        initialValue: cubit.selectedCategory,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: theme.colorScheme.primaryContainer,
                          suffixIcon: Container(
                            margin: const EdgeInsets.all(8),
                            child: CustomSvgPicture(path: AppAssets.arrowDown),
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
                        items: categories.map((category) {
                          return DropdownMenuItem<String>(
                            value: category['key'],
                            child: Text(
                              category['label']!,
                              style: TextStyles.bodyMedium.copyWith(
                                color: theme.colorScheme.onSurface,
                              ),
                            ),
                          );
                        }).toList(),
                        onChanged: (value) {
                          if (value != null) {
                            cubit.setCategory(value);
                          }
                        },
                      ),
                    ),
                    const Gap(24),

                    if (cubit.selectedCategory == '2') ...[
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
                            final dropdownValue = hasSelectedGoal
                                ? cubit.selectedGoalId
                                : null;

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
                                      color: theme.colorScheme.onSurface
                                          .withValues(alpha: 0.5),
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
                          cubit.selectedType ==
                                  TransactionTypeEnum.expense.value
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

                    Container(
                      margin: const EdgeInsets.only(left: 10),
                      child: Text(
                        "Title",
                        style: TextStyles.bodyMedium.copyWith(
                          color: theme.colorScheme.onSurface,
                        ),
                      ),
                    ),
                    const Gap(4),
                    SizedBox(
                      height: 48,
                      child: TextFormField(
                        controller: cubit.titleController,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: theme.colorScheme.primaryContainer,
                          hintText: "e.g. Dinner, Salary",
                          hintStyle: TextStyles.bodyMedium.copyWith(
                            color: theme.colorScheme.onSurface.withValues(
                              alpha: 0.5,
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
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return "Please enter a title";
                          }
                          return null;
                        },
                      ),
                    ),
                    const Gap(24),

                    Container(
                      margin: const EdgeInsets.only(left: 10),
                      child: Text(
                        "Amount",
                        style: TextStyles.bodyMedium.copyWith(
                          color: theme.colorScheme.onSurface,
                        ),
                      ),
                    ),
                    const Gap(4),
                    SizedBox(
                      height: 48,
                      child: TextFormField(
                        controller: cubit.amountController,
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: theme.colorScheme.primaryContainer,
                          hintText: "\$0.00",
                          hintStyle: TextStyles.bodyMedium.copyWith(
                            color: theme.colorScheme.onSurface.withValues(
                              alpha: 0.5,
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
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return "Please enter an amount";
                          }
                          if (double.tryParse(value.trim()) == null) {
                            return "Please enter a valid number";
                          }
                          return null;
                        },
                      ),
                    ),
                    const Gap(24),
                    Container(
                      margin: const EdgeInsets.only(left: 10),
                      child: Text(
                        "Note",
                        style: TextStyles.bodyMedium.copyWith(
                          color: theme.colorScheme.onSurface,
                        ),
                      ),
                    ),
                    const Gap(4),
                    TextFormField(
                      controller: cubit.noteController,
                      maxLines: 4,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: theme.colorScheme.primaryContainer,
                        hintText: "Enter message / description",
                        hintStyle: TextStyles.bodyMedium.copyWith(
                          color: theme.colorScheme.onSurface.withValues(
                            alpha: 0.5,
                          ),
                        ),
                        border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(18),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 12,
                          horizontal: 16,
                        ),
                      ),
                    ),
                    const Gap(32),
                    Center(
                      child: MainButton(
                        size: ButtonSize.small,
                        text: transactionToEdit == null ? "Save" : "Update",
                        onPress: () {
                          if (transactionToEdit == null) {
                            cubit.saveTransaction(
                              context.read<UserCubit>(),
                              goalCubit: context.read<GoalCubit>(),
                            );
                          } else {
                            cubit.editTransaction(
                              userCubit: context.read<UserCubit>(),
                              oldTransaction: transactionToEdit!,
                              goalCubit: context.read<GoalCubit>(),
                            );
                          }
                        },
                        textStyle: TextStyles.bodyMedium.copyWith(
                          color: theme.colorScheme.onSurface,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

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
