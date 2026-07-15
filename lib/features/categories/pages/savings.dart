import 'package:finwise/core/constants/app_assets.dart';
import 'package:finwise/core/constants/app_colors.dart';
import 'package:finwise/core/functions/get_category_id.dart';
import 'package:finwise/core/functions/navigations.dart';
import 'package:finwise/core/routes/routes.dart';
import 'package:finwise/core/styles/text_styles.dart';
import 'package:finwise/core/widgets/default_app_bar.dart';
import 'package:finwise/core/widgets/main_button.dart';
import 'package:finwise/core/widgets/my_body_view.dart';
import 'package:finwise/core/widgets/progress_section.dart';
import 'package:finwise/features/Transaction/presentation/cubit/transaction_cubit.dart';
import 'package:finwise/features/categories/widgets/savings_sub_item.dart';
import 'package:finwise/features/profile/cubit/user_cubit.dart';
import 'package:finwise/features/profile/cubit/user_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:finwise/features/Transaction/data/model/transaction_model.dart';
import 'package:gap/gap.dart';

class Savings extends StatelessWidget {
  const Savings({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserCubit, UserState>(
      builder: (context, userState) {
        final txList = context.watch<TransactionCubit>().transactionsList;
        final budget = userState.budget;
        final expense = userState.expense;
        final balance = userState.balance;
        final percentage = userState.budgetPercentage;

        return Scaffold(
          appBar: const DefaultAppBar(title: "Savings"),
          body: MyBodyView(
            clipBehavior: Clip.hardEdge,
            topSection: ProgressSection(
              percentage: percentage,
              totalAmount: budget,
              totalExpense: expense,
              totalBalance: balance,
            ),
            bottomSection: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: SavingsSubItem(
                          icon: AppAssets.travel,
                          bgColor: AppColors.oceanBlueButton,
                          label: "Travel",
                          onTap: () {
                            final filtered = txList
                                .where((tx) => _isCategoryMatch(tx, 'Travel'))
                                .toList();
                            pushTo(
                              context,
                              Routes.foodScreen,
                              extra: {
                                'categoryName': 'Travel',
                                'transactions': filtered,
                              },
                            );
                          },
                        ),
                      ),
                      Gap(15),
                      Expanded(
                        child: SavingsSubItem(
                          icon: AppAssets.newHome,
                          label: "New House",
                          onTap: () {
                            final filtered = txList
                                .where((tx) => _isCategoryMatch(tx, 'Rent'))
                                .toList();
                            pushTo(
                              context,
                              Routes.foodScreen,
                              extra: {
                                'categoryName': 'New House',
                                'transactions': filtered,
                              },
                            );
                          },
                        ),
                      ),
                      Gap(15),
                      Expanded(
                        child: SavingsSubItem(
                          icon: AppAssets.car,
                          label: "Car",
                          onTap: () {
                            final filtered = txList
                                .where(
                                  (tx) => _isCategoryMatch(tx, 'Transport'),
                                )
                                .toList();
                            pushTo(
                              context,
                              Routes.foodScreen,
                              extra: {
                                'categoryName': 'Car',
                                'transactions': filtered,
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                  Gap(30),
                  SavingsSubItem(
                    icon: AppAssets.wedding,
                    label: "Wedding",
                    width: 100,
                    height: 95,
                    onTap: () {
                      final filtered = txList
                          .where((tx) => _isCategoryMatch(tx, 'Other'))
                          .toList();
                      pushTo(
                        context,
                        Routes.foodScreen,
                        extra: {
                          'categoryName': 'Wedding',
                          'transactions': filtered,
                        },
                      );
                    },
                  ),
                  Gap(170),
                  Center(
                    child: MainButton(
                      size: ButtonSize.small,
                      text: "Add More",
                      textStyle: TextStyles.bodyMedium.copyWith(
                        color: Color(0xff093030),
                      ),
                      onPress: () {},
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

bool _isCategoryMatch(TransactionModel tx, String categoryName) {
  final targetId = getCategoryId(categoryName);
  final txCatName = tx.categoryName.toLowerCase().trim();
  final targetName = categoryName.toLowerCase().trim();
  return tx.categoryId == targetId || txCatName == targetName;
}
