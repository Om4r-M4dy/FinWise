import 'package:finwise/features/profile/persentation/cubit/user_cubit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:finwise/core/constants/app_colors.dart';
import 'package:finwise/core/extentions/dialogs.dart';
import 'package:finwise/core/styles/text_styles.dart';
import 'package:finwise/core/widgets/buttons/main_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

class CompleteProfileBottomSheet extends StatefulWidget {
  const CompleteProfileBottomSheet({super.key});

  @override
  State<CompleteProfileBottomSheet> createState() =>
      _CompleteProfileBottomSheetState();
}

class _CompleteProfileBottomSheetState extends State<CompleteProfileBottomSheet>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _incomeController = TextEditingController();
  final _budgetLimitController = TextEditingController();
  final _balanceController = TextEditingController();
  bool _isLoading = false;

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    );
    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.15), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Curves.easeOutCubic,
          ),
        );
    _animationController.forward();
  }

  @override
  void dispose() {
    _incomeController.dispose();
    _budgetLimitController.dispose();
    _balanceController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _saveIncome() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid == null) {
        if (mounted) {
          showMyDialog(context, 'User session expired. Please log in again.');
        }
        return;
      }

      final monthlyTotalIncom = double.parse(_incomeController.text.trim());
      final budgetLimit = double.parse(_budgetLimitController.text.trim());
      final balance = double.parse(_balanceController.text.trim());

      await context.read<UserCubit>().updateFinancials(
        monthlyBudgetLimit: budgetLimit,
        totalIncome: monthlyTotalIncom,
        totalBalance: balance,
      );

      if (mounted) {
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        showMyDialog(context, 'Failed to save. Please try again.');
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      // Prevent closing the sheet via back button
      canPop: false,
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: SlideTransition(
          position: _slideAnimation,
          child: Container(
            padding: EdgeInsets.only(
              top: 28,
              left: 24,
              right: 24,
              bottom: MediaQuery.of(context).viewInsets.bottom + 32,
            ),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
            ),
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // ── Handle ──────────────────────────────────────────
                    Container(
                      width: 44,
                      height: 4,
                      decoration: BoxDecoration(
                        color: AppColors.mainGreen.withValues(alpha: 0.4),
                        borderRadius: BorderRadius.circular(100),
                      ),
                    ),
                    const Gap(24),

                    // ── Illustration ─────────────────────────────────────
                    Container(
                      width: 90,
                      height: 90,
                      decoration: BoxDecoration(
                        color: AppColors.lightGreen,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.mainGreen.withValues(alpha: 0.25),
                            blurRadius: 24,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.account_balance_wallet_rounded,
                        size: 44,
                        color: AppColors.darkGreen,
                      ),
                    ),
                    const Gap(20),

                    // ── Title ────────────────────────────────────────────
                    Text(
                      'Complete Your Profile',
                      style: TextStyles.headlineLarge.copyWith(
                        color: AppColors.darkGreen,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const Gap(8),

                    // ── Subtitle ─────────────────────────────────────────
                    Text(
                      'Tell us your monthly income so we can\npersonalize your financial experience.',
                      textAlign: TextAlign.center,
                      style: TextStyles.bodySmall.copyWith(
                        color: AppColors.lettersAndIcons.withValues(alpha: 0.6),
                        height: 1.5,
                      ),
                    ),
                    const Gap(32),

                    _buildTextField(
                      label: 'Total Balance',
                      controller: _balanceController,
                      hint: '0.00',
                    ),
                    const Gap(16),
                    _buildTextField(
                      label: 'Monthly Income',
                      controller: _incomeController,
                      hint: '0.00',
                    ),
                    const Gap(16),
                    _buildTextField(
                      label: 'Monthly Budget Limit',
                      controller: _budgetLimitController,
                      hint: '0.00',
                    ),
                    const Gap(32),

                    // ── Save Button ───────────────────────────────────────
                    _isLoading
                        ? const CircularProgressIndicator(
                            color: AppColors.mainGreen,
                          )
                        : MainButton(
                            size: ButtonSize.large,
                            text: 'Save & Continue',
                            onPress: _saveIncome,
                            textStyle: TextStyles.bodyMedium.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required TextEditingController controller,
    required String hint,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyles.caption1_14.copyWith(
            color: AppColors.lettersAndIcons,
            fontWeight: FontWeight.w600,
          ),
        ),
        const Gap(8),
        TextFormField(
          controller: controller,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
          ],
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return 'Please enter $label';
            }
            final parsed = double.tryParse(value.trim());
            if (parsed == null || parsed <= 0) {
              return 'Please enter a valid amount greater than 0';
            }
            return null;
          },
          style: TextStyles.bodyMedium.copyWith(
            color: AppColors.lettersAndIcons,
            fontWeight: FontWeight.w600,
          ),
          decoration: InputDecoration(
            filled: true,
            fillColor: AppColors.lightGreen,
            hintText: hint,
            hintStyle: TextStyles.bodyMedium.copyWith(
              color: AppColors.lettersAndIcons.withValues(alpha: 0.4),
            ),
            prefixIcon: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                '\$',
                style: TextStyles.bodyLarge.copyWith(
                  color: AppColors.mainGreen,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            prefixIconConstraints: const BoxConstraints(minWidth: 0),
            border: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(18),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(
                color: AppColors.mainGreen,
                width: 1.5,
              ),
              borderRadius: BorderRadius.circular(18),
            ),
            errorBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.redAccent, width: 1.5),
              borderRadius: BorderRadius.circular(18),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
          ),
        ),
      ],
    );
  }
}
