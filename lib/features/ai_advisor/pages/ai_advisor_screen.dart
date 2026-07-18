import 'package:finwise/core/constants/app_colors.dart';
import 'package:finwise/core/styles/text_styles.dart';
import 'package:finwise/core/widgets/default_app_bar.dart';
import 'package:finwise/features/Transaction/presentation/cubit/transaction_cubit.dart';
import 'package:finwise/features/ai_advisor/cubit/ai_advisor_cubit.dart';
import 'package:finwise/features/ai_advisor/cubit/ai_advisor_state.dart';
import 'package:finwise/features/profile/cubit/user_cubit.dart';
import 'package:finwise/features/profile/cubit/user_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:gap/gap.dart';

class AiAdvisorScreen extends StatefulWidget {
  const AiAdvisorScreen({super.key});

  @override
  State<AiAdvisorScreen> createState() => _AiAdvisorScreenState();
}

class _AiAdvisorScreenState extends State<AiAdvisorScreen> {
  final TextEditingController _queryController = TextEditingController();

  final List<String> _quickPrompts = [
    'Analyze my spending',
    'How to save 20%?',
    'Why did I exceed my limit?',
    'Top saving tips for this month',
  ];

  @override
  void dispose() {
    _queryController.dispose();
    super.dispose();
  }

  void _submitQuestion(String question) {
    if (question.trim().isEmpty) return;

    final transactions = context.read<TransactionCubit>().transactionsList;
    final userState = context.read<UserCubit>().state;

    context.read<AiAdvisorCubit>().askAdvisor(
          transactions: transactions,
          monthlyLimit: userState.budget,
          totalBalance: userState.balance,
          question: question,
        );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final txCubit = context.watch<TransactionCubit>();
    final userState = context.watch<UserCubit>().state;

    final monthlyExpenses = txCubit.monthlyExpenses;
    final budgetLimit = userState.budget;
    final balance = userState.balance;

    return Scaffold(
      appBar: const DefaultAppBar(title: 'AI Financial Advisor'),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Summary Banner Card
              _buildSummaryCard(context, monthlyExpenses, budgetLimit, balance, isDark),
              const Gap(20),

              // Action Chips Section
              Text(
                'Quick Questions',
                style: TextStyles.bodyMedium.copyWith(
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.onSurface,
                ),
              ),
              const Gap(10),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _quickPrompts.map((prompt) {
                  return ActionChip(
                    label: Text(prompt),
                    labelStyle: TextStyle(
                      color: isDark ? AppColors.lightGreen : AppColors.darkGreen,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                    backgroundColor: isDark
                        ? AppColors.dark05
                        : AppColors.lightGreen.withValues(alpha: 0.6),
                    side: BorderSide(
                      color: AppColors.mainGreen.withValues(alpha: 0.4),
                    ),
                    onPressed: () {
                      _queryController.text = prompt;
                      _submitQuestion(prompt);
                    },
                  );
                }).toList(),
              ),
              const Gap(20),

              // Custom Question TextField
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _queryController,
                      style: TextStyle(color: theme.colorScheme.onSurface),
                      decoration: InputDecoration(
                        hintText: 'Ask your AI Advisor anything...',
                        hintStyle: TextStyle(
                          color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                          fontSize: 14,
                        ),
                        filled: true,
                        fillColor: theme.colorScheme.primaryContainer,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide.none,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide(
                            color: theme.colorScheme.outline.withValues(alpha: 0.2),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: const BorderSide(
                            color: AppColors.mainGreen,
                            width: 1.5,
                          ),
                        ),
                      ),
                      onSubmitted: _submitQuestion,
                    ),
                  ),
                  const Gap(10),
                  Material(
                    color: AppColors.mainGreen,
                    borderRadius: BorderRadius.circular(16),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(16),
                      onTap: () => _submitQuestion(_queryController.text),
                      child: const Padding(
                        padding: EdgeInsets.all(14),
                        child: Icon(
                          Icons.send_rounded,
                          color: AppColors.lettersAndIcons,
                          size: 22,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const Gap(24),

              // Result Section
              BlocBuilder<AiAdvisorCubit, AiAdvisorState>(
                builder: (context, state) {
                  if (state is AiAdvisorLoading) {
                    return Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primaryContainer,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        children: [
                          const CircularProgressIndicator(
                            color: AppColors.mainGreen,
                          ),
                          const Gap(16),
                          Text(
                            'Analyzing your financial data...',
                            style: TextStyles.bodyMedium.copyWith(
                              color: theme.colorScheme.onSurface,
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  if (state is AiAdvisorError) {
                    return Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.red.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: Colors.red.withValues(alpha: 0.3),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.error_outline, color: Colors.red),
                              const Gap(8),
                              Text(
                                'Advisor Error',
                                style: TextStyles.bodyMedium.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red,
                                ),
                              ),
                            ],
                          ),
                          const Gap(8),
                          Text(
                            state.message,
                            style: TextStyle(
                              color: theme.colorScheme.onSurface,
                              fontSize: 14,
                            ),
                          ),
                          const Gap(12),
                          ElevatedButton.icon(
                            onPressed: () => _submitQuestion(state.question),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.mainGreen,
                              foregroundColor: AppColors.lettersAndIcons,
                            ),
                            icon: const Icon(Icons.refresh, size: 18),
                            label: const Text('Try Again'),
                          ),
                        ],
                      ),
                    );
                  }

                  if (state is AiAdvisorLoaded) {
                    return Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primaryContainer,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: AppColors.mainGreen.withValues(alpha: 0.3),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(
                                Icons.auto_awesome,
                                color: AppColors.mainGreen,
                                size: 20,
                              ),
                              const Gap(8),
                              Expanded(
                                child: Text(
                                  state.question,
                                  style: TextStyles.bodyMedium.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: theme.colorScheme.onSurface,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const Divider(height: 24),
                          MarkdownBody(
                            data: state.response,
                            styleSheet: MarkdownStyleSheet.fromTheme(theme).copyWith(
                              p: TextStyle(
                                color: theme.colorScheme.onSurface,
                                fontSize: 14,
                                height: 1.5,
                              ),
                              h1: TextStyle(
                                color: theme.colorScheme.onSurface,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                              h2: TextStyle(
                                color: theme.colorScheme.onSurface,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                              listBullet: TextStyle(
                                color: theme.colorScheme.onSurface,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }

                  // Default / Initial state
                  return Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primaryContainer.withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: theme.colorScheme.outline.withValues(alpha: 0.1),
                      ),
                    ),
                    child: Column(
                      children: [
                        Icon(
                          Icons.psychology_outlined,
                          size: 48,
                          color: AppColors.mainGreen.withValues(alpha: 0.8),
                        ),
                        const Gap(12),
                        Text(
                          'Ask AI Advisor',
                          style: TextStyles.bodyLarge.copyWith(
                            fontWeight: FontWeight.bold,
                            color: theme.colorScheme.onSurface,
                          ),
                        ),
                        const Gap(6),
                        Text(
                          'Tap one of the quick questions above or type your own to get smart, personalized financial tips.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
              const Gap(20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryCard(
    BuildContext context,
    double monthlyExpenses,
    double budgetLimit,
    double balance,
    bool isDark,
  ) {
    final isExceeded = budgetLimit > 0 && monthlyExpenses > budgetLimit;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDark
              ? [AppColors.darkGreen, AppColors.dark05]
              : [AppColors.darkGreen, AppColors.lettersAndIcons],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Row(
                children: [
                  Icon(Icons.query_stats_rounded, color: AppColors.mainGreen, size: 20),
                  Gap(8),
                  Text(
                    'Current Month Overview',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              if (isExceeded)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.red.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.redAccent.withValues(alpha: 0.5)),
                  ),
                  child: const Text(
                    'Over Budget',
                    style: TextStyle(
                      color: Colors.redAccent,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
            ],
          ),
          const Gap(12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildMetric('Spent', '\$${monthlyExpenses.toStringAsFixed(2)}', Colors.white),
              _buildMetric(
                'Budget Limit',
                budgetLimit > 0 ? '\$${budgetLimit.toStringAsFixed(2)}' : 'Not set',
                AppColors.mainGreen,
              ),
              _buildMetric('Balance', '\$${balance.toStringAsFixed(2)}', Colors.white),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMetric(String title, String value, Color valueColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(color: Colors.white60, fontSize: 11),
        ),
        const Gap(4),
        Text(
          value,
          style: TextStyle(
            color: valueColor,
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
