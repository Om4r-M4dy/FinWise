import 'package:finwise/core/extentions/context_extensions.dart';
import 'package:finwise/core/styles/text_styles.dart';
import 'package:finwise/core/widgets/custom_text_form_field.dart';
import 'package:finwise/core/widgets/main_button.dart';
import 'package:finwise/core/widgets/my_body_view.dart';
import 'package:finwise/core/widgets/row_app_bar.dart';
import 'package:finwise/core/widgets/dialogs/loading_dialog.dart';
import 'package:finwise/core/widgets/dialogs/custom_snackbar.dart';
import 'package:finwise/features/profile/cubit/user_cubit.dart';
import 'package:finwise/features/auth/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

class EditFinancialInfoScreen extends StatefulWidget {
  const EditFinancialInfoScreen({super.key});

  @override
  State<EditFinancialInfoScreen> createState() =>
      _EditFinancialInfoScreenState();
}

class _EditFinancialInfoScreenState extends State<EditFinancialInfoScreen> {
  late final TextEditingController _budgetController;
  late final TextEditingController _balanceController;
  late final TextEditingController _incomeController;

  UserModel? _currentUser;

  @override
  void initState() {
    super.initState();
    _currentUser = context.read<UserCubit>().user;

    _budgetController = TextEditingController(
      text: _currentUser?.monthlyBudgetLimit?.toString() ?? '0.0',
    );
    _balanceController = TextEditingController(
      text: _currentUser?.totalBalance?.toString() ?? '0.0',
    );
    _incomeController = TextEditingController(
      text: _currentUser?.totalIncome?.toString() ?? '0.0',
    );
  }

  @override
  void dispose() {
    _budgetController.dispose();
    _balanceController.dispose();
    _incomeController.dispose();
    super.dispose();
  }

  Future<void> _updateFinancials() async {
    final budgetText = _budgetController.text.trim();
    final balanceText = _balanceController.text.trim();
    final incomeText = _incomeController.text.trim();

    final budget = double.tryParse(budgetText);
    final balance = double.tryParse(balanceText);
    final income = double.tryParse(incomeText);

    if (budget == null || balance == null || income == null) {
      CustomSnackBar.showError(
        context,
        "Please enter valid numeric values for all fields",
      );
      return;
    }

    LoadingDialog.show(context);
    try {
      await context.read<UserCubit>().updateFinancials(
        monthlyBudgetLimit: budget,
        totalBalance: balance,
        totalIncome: income,
      );
      if (!mounted) return;
      LoadingDialog.hide(context);
      CustomSnackBar.showSuccess(
        context,
        "Financial info updated successfully!",
      );
      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;
      LoadingDialog.hide(context);
      CustomSnackBar.showError(context, "Failed to update financial info: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MyBodyView(
        topSection: SafeArea(
          bottom: false,
          child: SizedBox(
            width: double.infinity,
            height: context.screenHeight * 0.12,
            child: RowAppBar(title: 'Edit Financial Info'),
          ),
        ),
        noPadding: true,
        bottomSection: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 37.0, vertical: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Financial details', style: TextStyles.bodyLarge),
              const Gap(30),

              Text('Monthly Budget Limit', style: TextStyles.bodyMedium),
              const Gap(13),
              CustomTextFormField(
                controller: _budgetController,
                hintText: 'Monthly Budget Limit',
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
              ),
              const Gap(17),

              Text('Total Balance', style: TextStyles.bodyMedium),
              const Gap(13),
              CustomTextFormField(
                controller: _balanceController,
                hintText: 'Total Balance',
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
              ),
              const Gap(17),

              Text('Monthly Income', style: TextStyles.bodyMedium),
              const Gap(13),
              CustomTextFormField(
                controller: _incomeController,
                hintText: 'Monthly Income',
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
              ),
              const Gap(40),

              Center(
                child: MainButton(
                  text: 'Update Financials',
                  onPress: _updateFinancials,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
