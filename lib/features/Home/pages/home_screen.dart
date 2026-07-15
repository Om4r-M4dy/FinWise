import 'package:finwise/core/constants/app_assets.dart';
import 'package:finwise/core/constants/app_colors.dart';
import 'package:finwise/core/functions/navigations.dart';
import 'package:finwise/core/routes/routes.dart';
import 'package:finwise/core/services/local/user_prefs.dart';
import 'package:finwise/core/styles/text_styles.dart';
import 'package:finwise/core/widgets/custom_svg_picture.dart';
import 'package:finwise/core/widgets/icon_with_text_button.dart';
import 'package:finwise/core/widgets/info_record.dart';
import 'package:finwise/core/widgets/my_body_view.dart';
import 'package:finwise/core/widgets/progress_section.dart';
import 'package:finwise/features/Home/widgets/last_week_analysis.dart';
import 'package:finwise/features/Transaction/data/model/transaction_model.dart';
import 'package:finwise/features/Transaction/presentation/cubit/transaction_cubit.dart';
import 'package:finwise/features/Transaction/presentation/cubit/transaction_states.dart';
import 'package:finwise/features/analysis/widgets/date_header.dart';
import 'package:finwise/features/profile/cubit/user_cubit.dart';
import 'package:finwise/features/profile/cubit/user_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:finwise/core/extentions/transaction_extension.dart';
import 'package:finwise/features/profile/page/complet_profile.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int index = 0;

  String name = UserPrefs.getName() ?? "there";
  bool _isBottomSheetOpen = false;

  void _checkUserProfile(UserState state) {
    if (state.budget <= 0 && !_isBottomSheetOpen) {
      _isBottomSheetOpen = true;

      WidgetsBinding.instance.addPostFrameCallback((_) async {
        await showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          enableDrag: false,
          isDismissible: false,
          backgroundColor: Colors.transparent,
          builder: (context) => const CompleteProfileBottomSheet(),
        );
        
        _isBottomSheetOpen = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final transactions = context.watch<TransactionCubit>().transactionsList;

    return BlocConsumer<UserCubit, UserState>(
      listener: (context, userState) {
        _checkUserProfile(userState);
      },
      listenWhen: (previous, current) {
        return previous.budget != current.budget;
      },
      builder: (context, userState) {
        _checkUserProfile(userState);

        final userName = userState.userName;
        final budget = userState.budget;
        final expense = userState.expense;
        final balance = userState.balance;
        final income = userState.income;

        final percentage = userState.budgetPercentage;

        final lastWeekData = _calculateLastWeekAnalysis(
          transactions: transactions,
          totalIncome: income,
          totalExpense: expense,
        );

        return Column(
          children: [
            AppBar(
              leadingWidth: 0,
              titleSpacing: 22.5,
              automaticallyImplyLeading: false,
              title: Align(
                alignment: Alignment.centerLeft,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Hi, $userName ', style: TextStyles.bodyLarge),
                    Text(
                      'What do you want to track ?',
                      style: TextStyles.bodySmall,
                    ),
                  ],
                ),
              ),
              actions: [
                IconButton(
                  onPressed: () => pushTo(context, Routes.notificationScreen),
                  icon: CustomSvgPicture(path: AppAssets.appBarNotification),
                ),
              ],
            ),

            const Gap(8),
            Expanded(
              child: MyBodyView(
                clipBehavior: Clip.hardEdge,
                noPadding: true,
                topSection: ProgressSection(
                  percentage: percentage,
                  totalAmount: budget,
                  totalExpense: expense,
                  totalBalance: balance,
                ),
                bottomSection: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 37.0,
                    vertical: 20,
                  ),
                  child: Column(
                    children: [
                      LastWeekAnalysis(
                        revenue: lastWeekData['revenue'] ?? 0.0,
                        expenses: lastWeekData['expenses'] ?? 0.0,
                        savingsPercent: lastWeekData['savingsPercent'] ?? 0.0,
                      ),
                      const Gap(26),

                      _transactionsWithDateFilters(),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Column _transactionsWithDateFilters() {
    return Column(
      children: [
        DateHeader(
          selectedIndex: index,
          labels: const ["Daily", "Weekly", "Monthly"],
          onUpdate: (value) => setState(() => index = value),
        ),

        BlocBuilder<TransactionCubit, TransactionStates>(
          builder: (context, txState) {
            // Loading
            if (txState is TransactionLoadingState) {
              return const Padding(
                padding: EdgeInsets.symmetric(vertical: 32),
                child: CircularProgressIndicator(),
              );
            }

            // Error
            if (txState is TransactionErrorState) {
              return Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  'Could not load transactions.',
                  style: TextStyles.bodySmall,
                ),
              );
            }

            final all = context.read<TransactionCubit>().transactionsList;

            // Apply time filter
            final now = DateTime.now();
            final filtered = all.where((tx) {
              if (index == 0) {
                // Daily
                return tx.date.year == now.year &&
                    tx.date.month == now.month &&
                    tx.date.day == now.day;
              } else if (index == 1) {
                // Weekly (last 7 days rolling)
                final sevenDaysAgo = DateTime(
                  now.year,
                  now.month,
                  now.day,
                ).subtract(const Duration(days: 6));
                return tx.date.isAfter(sevenDaysAgo) ||
                    (tx.date.year == sevenDaysAgo.year &&
                        tx.date.month == sevenDaysAgo.month &&
                        tx.date.day == sevenDaysAgo.day);
              } else if (index == 2) {
                // Monthly
                return tx.date.year == now.year && tx.date.month == now.month;
              }
              return true;
            }).toList();

            // Empty
            if (filtered.isEmpty) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 32),
                child: Column(
                  children: [
                    Text(
                      'No transactions found for this period.',
                      style: TextStyles.bodySmall.copyWith(
                        color: AppColors.lettersAndIcons.withValues(alpha: 0.6),
                      ),
                    ),
                    const Gap(8),
                    IconWithTextButton(
                      icon: Icons.add_rounded,
                      text: 'Add Transaction',
                      onPress: () {
                        pushTo(context, Routes.addTransaction);
                      },
                    ),
                  ],
                ),
              );
            }

            // Show latest 5 of filtered list
            final recent = filtered.take(10).toList();

            return ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: recent.length,
              itemBuilder: (context, index) {
                final item = recent[index];
                return Padding(
                  padding: EdgeInsets.only(
                    bottom: index == recent.length - 1 ? 8.0 : 19.0,
                  ),
                  child: InfoRecord(
                    bgColor: item.type.toLowerCase() == 'expense'
                        ? AppColors.lightBlueButton
                        : AppColors.mainGreen.withValues(alpha: 0.6),
                    title: item.title,
                    date: item.formattedDate,
                    cat: item.categoryName.isNotEmpty
                        ? item.categoryName
                        : 'General',
                    amount: item.getFormattedAmount(showPlusForIncome: true),
                    amountColor: item.getAmountColor(useGreenForIncome: true),
                  ),
                );
              },
            );
          },
        ),
      ],
    );
  }

  Map<String, dynamic> _calculateLastWeekAnalysis({
    required List<TransactionModel> transactions,
    required double totalIncome,
    required double totalExpense,
  }) {
    final now = DateTime.now();
    final sevenDaysAgo = DateTime(
      now.year,
      now.month,
      now.day,
    ).subtract(const Duration(days: 6));

    double revenueLastWeek = 0.0;
    double expensesLastWeek = 0.0;

    for (final tx in transactions) {
      final isWithinLastWeek =
          tx.date.isAfter(sevenDaysAgo) ||
          (tx.date.year == sevenDaysAgo.year &&
              tx.date.month == sevenDaysAgo.month &&
              tx.date.day == sevenDaysAgo.day);

      if (isWithinLastWeek) {
        if (tx.type.toLowerCase() == 'income') {
          revenueLastWeek += tx.amount;
        } else if (tx.type.toLowerCase() == 'expense') {
          expensesLastWeek += tx.amount;
        }
      }
    }

    double savingsPercent = 0.0;
    if (totalIncome > 0) {
      savingsPercent = ((totalIncome - totalExpense) / totalIncome * 100).clamp(
        0.0,
        100.0,
      );
    }

    return {
      'revenue': revenueLastWeek,
      'expenses': expensesLastWeek,
      'savingsPercent': savingsPercent,
    };
  }
}
