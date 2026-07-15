import 'package:finwise/core/constants/app_assets.dart';
import 'package:finwise/core/constants/app_colors.dart';
import 'package:finwise/core/functions/navigations.dart';
import 'package:finwise/core/routes/routes.dart';
import 'package:finwise/core/widgets/my_body_view.dart';
import 'package:finwise/core/widgets/progress_section.dart';
import 'package:finwise/features/Transaction/presentation/cubit/transaction_cubit.dart';
import 'package:finwise/features/categories/widgets/category_item.dart';
import 'package:finwise/features/profile/cubit/user_cubit.dart';
import 'package:finwise/features/profile/cubit/user_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

class MainCategories extends StatelessWidget {
  const MainCategories({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserCubit, UserState>(
      builder: (context, userState) {
        final txList = context.watch<TransactionCubit>().transactionsList;
        final budget = userState is UserLoaded
            ? userState.user?.monthlyBudgetLimit ?? 0
            : 0.0;

        // Calculate total expense
        final totalExpense = txList
            .where((tx) => tx.type == 'expense')
            .fold(0.0, (sum, tx) => sum + tx.amount);

        // Calculate percentage (avoid division by zero)
        final percentage = budget > 0
            ? (totalExpense / budget * 100).clamp(0.0, 100.0)
            : 0.0;

        final balance = userState is UserLoaded
            ? userState.user?.totalBalance ?? 0.0
            : 0.0;

        return MyBodyView(
          clipBehavior: Clip.hardEdge,
          topSection: ProgressSection(
            percentage: percentage,
            totalAmount: budget,
            totalExpense: totalExpense,
            totalBalance: balance,
          ),
          bottomSection: SingleChildScrollView(
            child: Column(
              children: [
                Gap(13),
                Row(
                  children: [
                    CategoryItem(
                      icon: AppAssets.food,
                      label: "Food",
                      onTap: () {
                        pushTo(context, Routes.foodScreen);
                      },
                    ),
                    Gap(21),
                    CategoryItem(
                      icon: AppAssets.transport,
                      label: "Transport",
                      bgColor: AppColors.lightBlueButton,
                      onTap: () {
                        pushTo(context, Routes.transportScreen);
                      },
                    ),
                    Gap(21),
                    CategoryItem(
                      icon: AppAssets.medicine,
                      label: "Medicine",
                      bgColor: AppColors.lightBlueButton,
                      onTap: () {
                        pushTo(context, Routes.medicineScreen);
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
                        pushTo(context, Routes.groceriesScreen);
                      },
                    ),
                    Gap(21),

                    CategoryItem(
                      icon: AppAssets.rent,
                      label: "Rent",
                      bgColor: AppColors.lightBlueButton,
                      onTap: () {
                        pushTo(context, Routes.rentScreen);
                      },
                    ),
                    Gap(21),
                    CategoryItem(
                      icon: AppAssets.gift,
                      label: "Gifts",
                      bgColor: AppColors.lightBlueButton,
                      onTap: () {
                        pushTo(context, Routes.giftsScreen);
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
                        pushTo(context, Routes.entertainmentScreen);
                      },
                    ),
                    Gap(21),
                    CategoryItem(
                      icon: AppAssets.more,
                      label: "More",
                      bgColor: AppColors.lightBlueButton,
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
