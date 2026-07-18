import 'package:finwise/core/functions/calculate_budget_percentage.dart';
import 'package:finwise/core/functions/calculate_last_week_analysis.dart';
import 'package:finwise/core/constants/app_colors.dart';
import 'package:finwise/core/functions/navigations.dart';
import 'package:finwise/core/routes/routes.dart';
import 'package:finwise/core/services/local/user_prefs.dart';
import 'package:finwise/core/styles/text_styles.dart';
import 'package:finwise/core/widgets/buttons/icon_with_text_button.dart';
import 'package:finwise/core/widgets/info_record.dart';
import 'package:finwise/core/widgets/my_body_view.dart';
import 'package:finwise/core/widgets/sections/progress_section.dart';
import 'package:finwise/core/widgets/shimmer/shimmer_loading.dart';
import 'package:finwise/features/Home/persentation/widgets/last_week_analysis.dart';
import 'package:finwise/features/Transaction/presentation/cubit/transaction_cubit.dart';
import 'package:finwise/features/Transaction/presentation/cubit/transaction_states.dart';
import 'package:finwise/features/analysis/widgets/date_header.dart';
import 'package:finwise/features/profile/persentation/cubit/user_cubit.dart';
import 'package:finwise/features/profile/persentation/cubit/user_state.dart';
import 'package:finwise/core/widgets/buttons/notification_badge_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:finwise/core/extentions/transaction_extension.dart';
import 'package:finwise/features/profile/persentation/pages/user_profile/complet_profile.dart';
import 'package:finwise/core/widgets/ai_scanner_helper.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int index = 0;

  String name = UserPrefs.getName() ?? "there";
  bool _isBottomSheetOpen = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        final userState = context.read<UserCubit>().state;
        _checkUserProfile(userState);
      }
    });
  }

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

        if (mounted) {
          setState(() {
            _isBottomSheetOpen = false;
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final transactions = context
        .watch<TransactionCubit>()
        .statsTransactionsList;

    return BlocConsumer<UserCubit, UserState>(
      listener: (context, userState) {
        _checkUserProfile(userState);
      },
      listenWhen: (previous, current) {
        return previous.budget != current.budget;
      },
      builder: (context, userState) {
        final userName = userState.userName;
        final budget = userState.budget;
        final expense = userState.expense;
        final balance = userState.balance;
        final income = userState.income;

        final monthlyExpense = context
            .watch<TransactionCubit>()
            .monthlyExpenses;
        final percentage = calculateBudgetPercentage(monthlyExpense, budget);

        final lastWeekData = calculateLastWeekAnalysis(
          transactions: transactions,
          totalIncome: income,
          totalExpense: expense,
        );

        return Scaffold(
          backgroundColor: Colors.transparent,
          floatingActionButtonLocation: const _OffsetFabLocation(),
          floatingActionButton: Container(
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  Color(0xFF8E2DE2), // Deep Violet
                  Color(0xFF4A00E0), // Vibrant Blue
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF8E2DE2).withValues(alpha: 0.4),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: FloatingActionButton(
              backgroundColor: Colors.transparent,
              elevation: 0,
              focusElevation: 0,
              hoverElevation: 0,
              highlightElevation: 0,
              shape: const CircleBorder(),
              onPressed: () => AIScannerHelper.showAIScannerSheet(context),
              child: const Icon(
                Icons.auto_awesome_rounded,
                color: Colors.white,
                size: 28,
              ),
            ),
          ),
          body: Column(
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
                      Text(
                        'Hi, $userName ',
                        style: TextStyles.bodyLarge.copyWith(
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                      ),
                      Text(
                        'What do you want to track ?',
                        style: TextStyles.bodySmall.copyWith(
                          color: Theme.of(
                            context,
                          ).colorScheme.onSurface.withValues(alpha: 0.8),
                        ),
                      ),
                    ],
                  ),
                ),
                actions: const [NotificationBadgeButton()],
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
                    padding: const EdgeInsets.only(
                      left: 37.0,
                      right: 37.0,
                      top: 20.0,
                      bottom: 110.0,
                    ),
                    child: Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            pushTo(context, Routes.quickAnalysisScreen);
                          },
                          child: LastWeekAnalysis(
                            revenue: lastWeekData['revenue'] ?? 0.0,
                            expenses: lastWeekData['expenses'] ?? 0.0,
                            savingsPercent:
                                lastWeekData['savingsPercent'] ?? 0.0,
                          ),
                        ),
                        const Gap(16),
                        GestureDetector(
                          onTap: () => pushTo(context, Routes.aiAdvisorScreen),
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: Theme.of(context).brightness == Brightness.dark
                                    ? [AppColors.darkGreen, AppColors.dark05]
                                    : [AppColors.darkGreen, AppColors.lettersAndIcons],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: AppColors.mainGreen.withValues(alpha: 0.2),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.psychology_rounded,
                                    color: AppColors.mainGreen,
                                    size: 24,
                                  ),
                                ),
                                const Gap(14),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'AI Financial Advisor',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const Gap(2),
                                      Text(
                                        'Get smart tips based on your spending',
                                        style: TextStyle(
                                          color: Colors.white.withValues(alpha: 0.7),
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const Icon(
                                  Icons.arrow_forward_ios_rounded,
                                  color: AppColors.mainGreen,
                                  size: 16,
                                ),
                              ],
                            ),
                          ),
                        ),
                        const Gap(26),
                        _transactionsWithDateFilters(),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
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
                padding: EdgeInsets.symmetric(vertical: 16),
                child: TransactionsListShimmer(itemCount: 2),
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

            final all = context.read<TransactionCubit>().statsTransactionsList;

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
                        color: Theme.of(
                          context,
                        ).colorScheme.onSurface.withValues(alpha: 0.6),
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
                    transaction: item,
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
}

class _OffsetFabLocation extends FloatingActionButtonLocation {
  const _OffsetFabLocation();

  @override
  Offset getOffset(ScaffoldPrelayoutGeometry geometry) {
    final Offset standardOffset = FloatingActionButtonLocation.endFloat
        .getOffset(geometry);
    return Offset(standardOffset.dx, standardOffset.dy - 75.0);
  }
}
