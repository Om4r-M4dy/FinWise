import 'package:date_field/date_field.dart';
import 'package:finwise/core/constants/app_assets.dart';
import 'package:finwise/core/constants/app_colors.dart';
import 'package:finwise/core/constants/categories.dart';
import 'package:finwise/core/constants/transaction_type_enum.dart';
import 'package:finwise/core/extentions/dialogs.dart';
import 'package:finwise/core/functions/navigations.dart';
import 'package:finwise/core/styles/text_styles.dart';
import 'package:finwise/core/widgets/custom_svg_picture.dart';
import 'package:finwise/core/widgets/default_app_bar.dart';
import 'package:finwise/core/widgets/main_button.dart';
import 'package:finwise/core/widgets/my_body_view.dart';
import 'package:finwise/core/widgets/ai_scanner_helper.dart';
import 'package:finwise/features/Transaction/presentation/cubit/transaction_cubit.dart';
import 'package:finwise/features/Transaction/presentation/cubit/transaction_states.dart';
import 'package:finwise/features/profile/cubit/user_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

class AddTransaction extends StatelessWidget {
  final bool showAppBar;
  
  const AddTransaction({super.key, this.showAppBar = true});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<TransactionCubit>();

    return Scaffold(
      appBar: showAppBar ? const DefaultAppBar(title: "Add Transaction") : null,
      body: MyBodyView(
        topSection: InkWell(
          onTap: () => AIScannerHelper.showAIScannerSheet(context, isAlreadyOnAddScreen: true),
          borderRadius: BorderRadius.circular(20),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.25),
                width: 1.5,
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.auto_awesome_rounded,
                    color: Colors.white,
                    size: 32,
                  ),
                ),
                const Gap(12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "Scan with AI",
                        style: TextStyles.bodyLarge.copyWith(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        "Fast fill transaction from image or receipt",
                        style: TextStyles.bodySmall.copyWith(
                          color: Colors.white.withValues(alpha: 0.8),
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: Colors.white,
                  size: 16,
                ),
              ],
            ),
          ),
        ),
        bottomSection: Padding(
          padding: const EdgeInsets.symmetric(vertical: 15),
          child: SingleChildScrollView(
            child: BlocConsumer<TransactionCubit, TransactionStates>(
              listener: (context, state) {
                if (state is TransactionLoadingState) {
                  showLoadingDialog(context);
                } else if (state is TransactionSuccessState) {
                  pop(context);
                  showMyDialog(
                    context,
                    'Transaction saved successfully!',
                    type: DialogType.success,
                  );
                  pop(context);
                } else if (state is TransactionErrorState) {
                  pop(context);
                  showMyDialog(context, state.errorMessage);
                }
              },
              builder: (context, state) {
                return Form(
                  key: cubit.formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(left: 10),
                        child: Text(
                          "Transaction Type",
                          style: TextStyles.bodyMedium.copyWith(
                            color: AppColors.lettersAndIcons,
                          ),
                        ),
                      ),
                      const Gap(8),
                      Row(
                        children: [
                          Expanded(
                            child: TransactionTypeButton(
                              cubit: cubit,
                              type: TransactionTypeEnum.expense.value,
                            ),
                          ),
                          const Gap(16),
                          Expanded(
                            child: TransactionTypeButton(
                              cubit: cubit,
                              type: TransactionTypeEnum.income.value,
                            ),
                          ),
                        ],
                      ),
                      const Gap(24),

                      Container(
                        margin: const EdgeInsets.only(left: 10),
                        child: Text(
                          "Date",
                          style: TextStyles.bodyMedium.copyWith(
                            color: AppColors.lettersAndIcons,
                          ),
                        ),
                      ),
                      const Gap(4),
                      SizedBox(
                        height: 48,
                        child: DateTimeFormField(
                          initialValue: cubit.selectedDate,
                          mode: DateTimeFieldPickerMode.date,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: AppColors.lightGreen,
                            hintText: "Select Date",
                            hintStyle: TextStyles.bodyMedium.copyWith(
                              color: AppColors.lettersAndIcons.withValues(
                                alpha: 0.5,
                              ),
                            ),
                            suffixIcon: Container(
                              margin: const EdgeInsets.all(10),
                              child: CustomSvgPicture(path: AppAssets.calender),
                            ),
                            border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.circular(18),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 10,
                              horizontal: 16,
                            ),
                          ),
                          onChanged: (DateTime? val) {
                            if (val != null) {
                              cubit.setDate(val);
                            }
                          },
                        ),
                      ),
                      const Gap(24),

                      Container(
                        margin: const EdgeInsets.only(left: 10),
                        child: Text(
                          "Category",
                          style: TextStyles.bodyMedium.copyWith(
                            color: AppColors.lettersAndIcons,
                          ),
                        ),
                      ),
                      const Gap(4),
                      SizedBox(
                        height: 48,
                        child: DropdownButtonFormField<String>(
                          initialValue: cubit.selectedCategory,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: AppColors.lightGreen,
                            suffixIcon: Container(
                              margin: const EdgeInsets.all(8),
                              child: CustomSvgPicture(
                                path: AppAssets.arrowDown,
                              ),
                            ),
                            border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.circular(18),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 10,
                              horizontal: 16,
                            ),
                          ),
                          items: categories.map((category) {
                            return DropdownMenuItem<String>(
                              value: category['key'],
                              child: Text(
                                category['label']!,
                                style: TextStyles.bodyMedium.copyWith(
                                  color: AppColors.lettersAndIcons,
                                ),
                              ),
                            );
                          }).toList(),
                          onChanged: (value) {
                            if (value != null) {
                              cubit.setCategory(value);
                            }
                          },
                        ),
                      ),
                      const Gap(24),

                      Container(
                        margin: const EdgeInsets.only(left: 10),
                        child: Text(
                          "Title",
                          style: TextStyles.bodyMedium.copyWith(
                            color: AppColors.lettersAndIcons,
                          ),
                        ),
                      ),
                      const Gap(4),
                      SizedBox(
                        height: 48,
                        child: TextFormField(
                          controller: cubit.titleController,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: AppColors.lightGreen,
                            hintText: "e.g. Dinner, Salary",
                            hintStyle: TextStyles.bodyMedium.copyWith(
                              color: AppColors.lettersAndIcons.withValues(
                                alpha: 0.5,
                              ),
                            ),
                            border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.circular(18),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 10,
                              horizontal: 16,
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return "Please enter a title";
                            }
                            return null;
                          },
                        ),
                      ),
                      const Gap(24),

                      Container(
                        margin: const EdgeInsets.only(left: 10),
                        child: Text(
                          "Amount",
                          style: TextStyles.bodyMedium.copyWith(
                            color: AppColors.lettersAndIcons,
                          ),
                        ),
                      ),
                      const Gap(4),
                      SizedBox(
                        height: 48,
                        child: TextFormField(
                          controller: cubit.amountController,
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: AppColors.lightGreen,
                            hintText: "\$0.00",
                            hintStyle: TextStyles.bodyMedium.copyWith(
                              color: AppColors.lettersAndIcons.withValues(
                                alpha: 0.5,
                              ),
                            ),
                            border: OutlineInputBorder(
                              borderSide: BorderSide.none,
                              borderRadius: BorderRadius.circular(18),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 10,
                              horizontal: 16,
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return "Please enter an amount";
                            }
                            if (double.tryParse(value.trim()) == null) {
                              return "Please enter a valid number";
                            }
                            return null;
                          },
                        ),
                      ),
                      const Gap(24),
                      Container(
                        margin: const EdgeInsets.only(left: 10),
                        child: Text(
                          "Note",
                          style: TextStyles.bodyMedium.copyWith(
                            color: AppColors.lettersAndIcons,
                          ),
                        ),
                      ),
                      const Gap(4),
                      TextFormField(
                        controller: cubit.noteController,
                        maxLines: 4,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: AppColors.lightGreen,
                          hintText: "Enter message / description",
                          hintStyle: TextStyles.bodyMedium.copyWith(
                            color: AppColors.lettersAndIcons.withValues(
                              alpha: 0.5,
                            ),
                          ),
                          border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(18),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 12,
                            horizontal: 16,
                          ),
                        ),
                      ),
                      const Gap(32),
                      Center(
                        child: MainButton(
                          size: ButtonSize.small,
                          text: "Save",
                          onPress: () =>
                              cubit.saveTransaction(context.read<UserCubit>()),
                          textStyle: TextStyles.bodyMedium.copyWith(
                            color: AppColors.lettersAndIcons,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class TransactionTypeButton extends StatelessWidget {
  const TransactionTypeButton({
    super.key,
    required this.cubit,
    required this.type,
  });

  final TransactionCubit cubit;
  final String type;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => cubit.setType(type),
      child: Container(
        height: 48,
        decoration: BoxDecoration(
          color: cubit.selectedType == type
              ? AppColors.mainGreen.withValues(alpha: 0.15)
              : AppColors.lightGreen,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: cubit.selectedType == type
                ? AppColors.mainGreen
                : Colors.transparent,
            width: 2,
          ),
        ),
        alignment: Alignment.center,
        child: Text(
          type,
          style: TextStyles.bodySmall.copyWith(
            color: cubit.selectedType == type
                ? AppColors.mainGreen
                : AppColors.lettersAndIcons,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
