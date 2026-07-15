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
import 'package:intl/intl.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int index = 0;

  String name = UserPrefs.getName() ?? "there";
  // ── Helpers ──────────────────────────────────────────────────────────────

  /// "18:27 - April 30"
  String _formatDate(DateTime date) =>
      DateFormat('HH:mm - MMMM dd').format(date);

  /// Map category name → SVG asset path
  String _iconFor(String categoryName) {
    switch (categoryName.toLowerCase()) {
      case 'salary':
        return AppAssets.salary;
      case 'groceries':
        return AppAssets.groceries;
      case 'food':
        return AppAssets.food;
      case 'transport':
        return AppAssets.transport;
      case 'entertainment':
        return AppAssets.entertainment;
      case 'medicine':
        return AppAssets.medicine;
      case 'travel':
        return AppAssets.travel;
      case 'car':
        return AppAssets.car;
      case 'gift':
        return AppAssets.gift;
      case 'rent':
      case 'new house':
      case 'newhouse':
        return AppAssets.newHome;
      case 'saving':
      case 'savings':
        return AppAssets.saving;
      case 'income':
        return AppAssets.income;
      default:
        return AppAssets.dollar;
    }
  }

  /// "-$100.00" for expense, "$4,000.00" for income
  String _formatAmount(TransactionModel t) {
    final f = NumberFormat('#,##0.00').format(t.amount);
    return t.type == 'expense' ? '-\$$f' : '\$$f';
  }

  Color? _amountColor(TransactionModel t) =>
      t.type == 'expense' ? AppColors.oceanBlueButton : null;

  // ── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserCubit, UserState>(
      builder: (context, userState) {
        final user = userState is UserLoaded ? userState.user : null;
        final userName = user?.username ?? UserPrefs.getName() ?? "there";

        final budget = user?.monthlyBudgetLimit ?? 0;
        final expense = user?.totalExpense ?? 0;
        final balance = user?.totalBalance ?? 0;
        final percentage = budget > 0
            ? (expense / budget * 100).clamp(0.0, 100.0)
            : 0.0;

        return Column(
          children: [
            // ── AppBar ──────────────────────────────────────────────────────────
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
                    Text('Good Morning', style: TextStyles.bodySmall),
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

            // ── Body ────────────────────────────────────────────────────────────
            Expanded(
              child: MyBodyView(
                topSection: ProgressSection(
                  percentage: percentage,
                  totalAmount: budget,
                  totalExpense: expense,
                  totalBalance: balance,
                ),
                bottomSection: SingleChildScrollView(
                  child: Column(
                    children: [
                      last_week_analysis(), // TODO: Implement Last Week Analysis
                      const Gap(26),

                      // ── Date filter ────────────────────────────────────
                      //TODO: Implement Date Filter
                      DateHeader(
                        selectedIndex: index,
                        labels: const ["Daily", "Weekly", "Monthly"],
                        onUpdate: (value) => setState(() => index = value),
                      ),
                      const Gap(24),

                      // ── Transaction list ───────────────────────────────
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

                          final all = context
                              .read<TransactionCubit>()
                              .transactionsList;

                          // Empty
                          if (all.isEmpty) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 32),
                              child: Column(
                                children: [
                                  Text(
                                    'No transactions yet.',
                                    style: TextStyles.bodySmall,
                                  ),
                                  const Gap(8),
                                  IconWithTextButton(
                                    icon: Icons.add_rounded,
                                    text: 'Add Transaction',
                                    onPress: () {
                                      pushTo(context, Routes.addExpenses);
                                    },
                                  ),
                                ],
                              ),
                            );
                          }

                          // Show latest 5
                          final recent = all.take(5).toList();

                          return Column(
                            children: [
                              for (int i = 0; i < recent.length; i++) ...[
                                if (i > 0) const Gap(19),
                                InfoRecord(
                                  iconPath: _iconFor(recent[i].categoryName),
                                  title: recent[i].title,
                                  date: _formatDate(recent[i].date),
                                  cat: recent[i].categoryName,
                                  amount: _formatAmount(recent[i]),
                                  amountColor: _amountColor(recent[i]),
                                ),
                              ],
                              const Gap(8),
                            ],
                          );
                        },
                      ),
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
}
