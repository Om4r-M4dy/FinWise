import 'package:finwise/core/functions/calculate_budget_percentage.dart';
import 'package:finwise/core/constants/app_assets.dart';
import 'package:finwise/core/constants/app_colors.dart';
import 'package:finwise/core/functions/is_category_match.dart';
import 'package:finwise/core/functions/navigations.dart';
import 'package:finwise/core/routes/routes.dart';
import 'package:finwise/core/widgets/my_body_view.dart';
import 'package:finwise/core/widgets/sections/progress_section.dart';
import 'package:finwise/features/Transaction/presentation/cubit/transaction_cubit.dart';
import 'package:finwise/features/categories/widgets/category_item.dart';
import 'package:finwise/features/profile/persentation/cubit/user_cubit.dart';
import 'package:finwise/features/profile/persentation/cubit/user_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

class MainCategories extends StatelessWidget {
  const MainCategories({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserCubit, UserState>(
      builder: (context, userState) {
        final transactionList = context
            .watch<TransactionCubit>()
            .statsTransactionsList;
        final user = userState is UserLoaded ? userState.user : null;
        final budget = user?.monthlyBudgetLimit ?? 0.0;
        final expense = user?.totalExpense ?? 0.0;
        final balance = user?.totalBalance ?? 0.0;
        final monthlyExpense = context
            .watch<TransactionCubit>()
            .monthlyExpenses;
        final percentage = calculateBudgetPercentage(monthlyExpense, budget);

        return MyBodyView(
          clipBehavior: Clip.hardEdge,
          noPadding: true,
          topSection: ProgressSection(
            percentage: percentage,
            totalAmount: budget,
            totalExpense: expense,
            totalBalance: balance,
          ),
          bottomSection: SingleChildScrollView(
            padding: const EdgeInsets.only(
              left: 37.0,
              right: 37.0,
              top: 20.0,
              bottom: 110.0,
            ),
            child: Column(
              children: [
                Gap(13),
                Row(
                  children: [
                    CategoryItem(
                      icon: AppAssets.food,
                      label: "Food",
                      bgColor: AppColors.lightBlueButton,
                      onTap: () {
                        final filtered = transactionList
                            .where((tx) => isCategoryMatch(tx, 'Food'))
                            .toList();
                        pushTo(
                          context,
                          Routes.addTransactionByCategory,
                          extra: {
                            'categoryName': 'Food',
                            'transactions': filtered,
                          },
                        );
                      },
                    ),
                    Gap(21),
                    CategoryItem(
                      icon: AppAssets.transport,
                      label: "Transport",
                      bgColor: AppColors.lightBlueButton,
                      onTap: () {
                        final filtered = transactionList
                            .where((tx) => isCategoryMatch(tx, 'Transport'))
                            .toList();
                        pushTo(
                          context,
                          Routes.addTransactionByCategory,
                          extra: {
                            'categoryName': 'Transport',
                            'transactions': filtered,
                          },
                        );
                      },
                    ),
                    Gap(21),
                    CategoryItem(
                      icon: AppAssets.medicine,
                      label: "Medicine",
                      bgColor: AppColors.lightBlueButton,
                      onTap: () {
                        final filtered = transactionList
                            .where((tx) => isCategoryMatch(tx, 'Medicine'))
                            .toList();
                        pushTo(
                          context,
                          Routes.addTransactionByCategory,
                          extra: {
                            'categoryName': 'Medicine',
                            'transactions': filtered,
                          },
                        );
                      },
                    ),
                  ],
                ),
                Gap(38),
                Row(
                  children: [
                    CategoryItem(
                      icon: AppAssets.groceries,
                      label: "Groceries",
                      bgColor: AppColors.lightBlueButton,
                      onTap: () {
                        final filtered = transactionList
                            .where((tx) => isCategoryMatch(tx, 'Groceries'))
                            .toList();
                        pushTo(
                          context,
                          Routes.addTransactionByCategory,
                          extra: {
                            'categoryName': 'Groceries',
                            'transactions': filtered,
                          },
                        );
                      },
                    ),
                    Gap(21),

                    CategoryItem(
                      icon: AppAssets.rent,
                      label: "Rent",
                      bgColor: AppColors.lightBlueButton,
                      onTap: () {
                        final filtered = transactionList
                            .where((tx) => isCategoryMatch(tx, 'Rent'))
                            .toList();
                        pushTo(
                          context,
                          Routes.addTransactionByCategory,
                          extra: {
                            'categoryName': 'Rent',
                            'transactions': filtered,
                          },
                        );
                      },
                    ),
                    Gap(21),
                    CategoryItem(
                      icon: AppAssets.gift,
                      label: "Gifts",
                      bgColor: AppColors.lightBlueButton,
                      onTap: () {
                        final filtered = transactionList
                            .where((tx) => isCategoryMatch(tx, 'Gifts'))
                            .toList();
                        pushTo(
                          context,
                          Routes.addTransactionByCategory,
                          extra: {
                            'categoryName': 'Gifts',
                            'transactions': filtered,
                          },
                        );
                      },
                    ),
                  ],
                ),
                Gap(38),
                Row(
                  children: [
                    CategoryItem(
                      icon: AppAssets.saving,
                      label: "Savings",
                      bgColor: AppColors.lightBlueButton,
                      onTap: () {
                        pushTo(context, Routes.savings);
                      },
                    ),
                    Gap(21),

                    CategoryItem(
                      icon: AppAssets.entertainment,
                      label: "Leisure",
                      bgColor: AppColors.lightBlueButton,
                      onTap: () {
                        final filtered = transactionList
                            .where((tx) => isCategoryMatch(tx, 'Leisure'))
                            .toList();
                        pushTo(
                          context,
                          Routes.addTransactionByCategory,
                          extra: {
                            'categoryName': 'Leisure',
                            'transactions': filtered,
                          },
                        );
                      },
                    ),
                    Gap(21),
                    CategoryItem(
                      iconWidget: const Icon(
                        Icons.more_horiz,
                        color: Colors.white,
                        size: 36,
                      ),
                      label: "Other",
                      bgColor: AppColors.lightBlueButton,
                      onTap: () {
                        final filtered = transactionList
                            .where((tx) => isCategoryMatch(tx, 'Other'))
                            .toList();
                        pushTo(
                          context,
                          Routes.addTransactionByCategory,
                          extra: {
                            'categoryName': 'Other',
                            'transactions': filtered,
                          },
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
