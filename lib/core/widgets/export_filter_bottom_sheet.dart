import 'package:finwise/core/constants/app_colors.dart';
import 'package:finwise/core/functions/export_csv.dart';
import 'package:finwise/core/styles/text_styles.dart';
import 'package:finwise/core/widgets/dialogs/custom_snackbar.dart';
import 'package:finwise/features/Transaction/data/model/transaction_model.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';

void showExportFilterBottomSheet(
  BuildContext context,
  List<TransactionModel> allTransactions,
) {
  if (allTransactions.isEmpty) {
    CustomSnackBar.showError(context, 'No transactions available to export.');
    return;
  }

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Theme.of(context).colorScheme.surface,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(28),
        topRight: Radius.circular(28),
      ),
    ),
    builder: (sheetContext) {
      return _ExportFilterSheetContent(allTransactions: allTransactions);
    },
  );
}

class _ExportFilterSheetContent extends StatefulWidget {
  const _ExportFilterSheetContent({required this.allTransactions});

  final List<TransactionModel> allTransactions;

  @override
  State<_ExportFilterSheetContent> createState() =>
      __ExportFilterSheetContentState();
}

class __ExportFilterSheetContentState
    extends State<_ExportFilterSheetContent> {
  DateTime _selectedCustomMonth = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final currentMonthTxs = widget.allTransactions.where((tx) {
      return tx.date.year == now.year && tx.date.month == now.month;
    }).toList();

    final currentYearTxs = widget.allTransactions.where((tx) {
      return tx.date.year == now.year;
    }).toList();

    final customMonthLabel = DateFormat('MMMM yyyy').format(_selectedCustomMonth);
    final customMonthTxs = widget.allTransactions.where((tx) {
      return tx.date.year == _selectedCustomMonth.year &&
          tx.date.month == _selectedCustomMonth.month;
    }).toList();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Drag handle
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const Gap(16),

          // Header
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.mainGreen.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.file_download_outlined,
                  color: AppColors.mainGreen,
                  size: 24,
                ),
              ),
              const Gap(14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Export Transactions',
                      style: TextStyles.bodyLarge.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    const Gap(2),
                    Text(
                      'Select date range to export as CSV',
                      style: TextStyles.bodyMedium.copyWith(
                        fontSize: 13,
                        color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const Gap(20),
          const Divider(height: 1),
          const Gap(16),

          // Option 1: Current Month
          _buildOptionTile(
            context,
            icon: Icons.calendar_view_month_rounded,
            title: 'Current Month',
            subtitle: DateFormat('MMMM yyyy').format(now),
            count: currentMonthTxs.length,
            isDark: isDark,
            onTap: () => _handleExport(
              context,
              currentMonthTxs,
              'transactions_${now.year}_${now.month.toString().padLeft(2, '0')}.csv',
            ),
          ),
          const Gap(10),

          // Option 2: Current Year
          _buildOptionTile(
            context,
            icon: Icons.calendar_today_rounded,
            title: 'Current Year',
            subtitle: '${now.year}',
            count: currentYearTxs.length,
            isDark: isDark,
            onTap: () => _handleExport(
              context,
              currentYearTxs,
              'transactions_${now.year}.csv',
            ),
          ),
          const Gap(10),

          // Option 3: All Time
          _buildOptionTile(
            context,
            icon: Icons.all_inbox_rounded,
            title: 'All Time',
            subtitle: 'All recorded transactions',
            count: widget.allTransactions.length,
            isDark: isDark,
            onTap: () => _handleExport(
              context,
              widget.allTransactions,
              'transactions_export_all.csv',
            ),
          ),
          const Gap(10),

          // Option 4: Custom Month & Year
          _buildOptionTile(
            context,
            icon: Icons.edit_calendar_rounded,
            title: 'Custom Month ($customMonthLabel)',
            subtitle: 'Tap to pick month & year',
            count: customMonthTxs.length,
            isDark: isDark,
            trailingAction: IconButton(
              icon: const Icon(Icons.date_range_rounded, size: 20),
              color: AppColors.mainGreen,
              onPressed: () => _pickCustomMonth(context),
            ),
            onTap: () => _handleExport(
              context,
              customMonthTxs,
              'transactions_${_selectedCustomMonth.year}_${_selectedCustomMonth.month.toString().padLeft(2, '0')}.csv',
            ),
          ),

          const Gap(16),
        ],
      ),
    );
  }

  Widget _buildOptionTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required int count,
    required bool isDark,
    required VoidCallback onTap,
    Widget? trailingAction,
  }) {
    final theme = Theme.of(context);
    final cardBg = isDark
        ? theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5)
        : AppColors.lightGreen.withValues(alpha: 0.35);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: cardBg,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: AppColors.mainGreen.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Icon(icon, color: AppColors.mainGreen, size: 22),
            const Gap(14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyles.bodyMedium.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: TextStyles.bodyMedium.copyWith(
                      fontSize: 12,
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.55),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.mainGreen.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '$count items',
                style: TextStyles.bodyMedium.copyWith(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.mainGreen,
                ),
              ),
            ),
            if (trailingAction != null) ...[
              const Gap(4),
              trailingAction,
            ],
          ],
        ),
      ),
    );
  }

  Future<void> _pickCustomMonth(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedCustomMonth,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      helpText: 'Select Month & Year',
    );
    if (picked != null) {
      setState(() {
        _selectedCustomMonth = picked;
      });
    }
  }

  Future<void> _handleExport(
    BuildContext context,
    List<TransactionModel> filteredTxs,
    String fileName,
  ) async {
    if (filteredTxs.isEmpty) {
      CustomSnackBar.showError(
        context,
        'No transactions found for the selected period.',
      );
      return;
    }

    Navigator.pop(context); // Close bottom sheet

    final success = await exportTransactionsToCsv(
      filteredTxs,
      fileName: fileName,
    );

    if (!success && context.mounted) {
      CustomSnackBar.showError(context, 'Failed to export transactions.');
    }
  }
}
