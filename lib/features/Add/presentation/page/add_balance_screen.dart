import 'package:date_field/date_field.dart';
import 'package:finwise/core/constants/app_assets.dart';
import 'package:finwise/core/constants/app_colors.dart';
import 'package:finwise/core/extentions/dialogs.dart';
import 'package:finwise/core/functions/navigations.dart';
import 'package:finwise/core/routes/routes.dart';
import 'package:finwise/core/styles/text_styles.dart';
import 'package:finwise/core/widgets/custom_svg_picture.dart';
import 'package:finwise/core/widgets/main_button.dart';
import 'package:finwise/core/widgets/my_body_view.dart';
import 'package:finwise/features/Add/data/models/categories_model.dart';
import 'package:finwise/features/Add/presentation/cubit/add_balance_cubit.dart';
import 'package:finwise/features/Add/presentation/cubit/add_balance_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

class AddBalanceScreen extends StatelessWidget {
  const AddBalanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var cubit = context.read<AddBalanceCubit>();
    return BlocListener<AddBalanceCubit, AddBalanceState>(
      listener: (context, state) {
        if (state is AddBalanceLoading) {
          showLoadingDialog(context);
        } else if (state is AddBalanceSuccess) {
          pop(context); // dismiss loading dialog
          replaceWith(context, Routes.bottomNavBar);
        } else if (state is AddBalanceFailure) {
          pop(context); // dismiss loading dialog
          showMyDialog(context, state.errorMessage);
        }
      },
      child: Form(
        key: cubit.formKey,
        child: Scaffold(
          body: MyBodyView(
            bottomSection: Padding(
              padding: const EdgeInsets.only(top: 15),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ── Date ──────────────────────────────────────────
                    Container(
                      margin: const EdgeInsets.only(left: 10),
                      child: Text(
                        "Date",
                        style: TextStyles.bodyMedium.copyWith(
                          color: AppColors.lettersAndIcons,
                        ),
                      ),
                    ),
                    const Gap(1),
                    SizedBox(
                      height: 41,
                      child: DateTimeFormField(
                        mode: DateTimeFieldPickerMode.date,
                        onChanged: (DateTime? value) {
                          if (value != null) {
                            cubit.dateController.text = value.toIso8601String();
                          }
                        },
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: AppColors.lightGreen,
                          hintText: "April 30 ,2024",
                          hintStyle: TextStyles.bodyMedium.copyWith(
                            color: AppColors.lettersAndIcons,
                          ),
                          suffixIcon: Container(
                            margin: const EdgeInsets.all(10),
                            child: CustomSvgPicture(path: AppAssets.calender),
                          ),
                          border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(18),
                          ),
                        ),
                      ),
                    ),
                    const Gap(30),

                    // ── Category ──────────────────────────────────────
                    Container(
                      margin: const EdgeInsets.only(left: 10),
                      child: Text(
                        "Category",
                        style: TextStyles.bodyMedium.copyWith(
                          color: AppColors.lettersAndIcons,
                        ),
                      ),
                    ),
                    const Gap(1),
                    SizedBox(
                      height: 41,
                      child: DropdownButtonFormField<String>(
                        hint: Text(
                          "Select the category",
                          style: TextStyles.bodyMedium.copyWith(
                            color: AppColors.darkGreen,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: AppColors.lightGreen,
                          suffixIcon: Container(
                            margin: const EdgeInsets.all(8),
                            child: CustomSvgPicture(path: AppAssets.arrowDown),
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
                        items: getCategoriesMenu(),
                        onChanged: (value) {
                          cubit.categoryController.text = value ?? '';
                        },
                      ),
                    ),
                    const Gap(30),

                    // ── Type ──────────────────────────────────────────
                    Container(
                      margin: const EdgeInsets.only(left: 10),
                      child: Text(
                        "Type",
                        style: TextStyles.bodyMedium.copyWith(
                          color: AppColors.lettersAndIcons,
                        ),
                      ),
                    ),
                    const Gap(1),
                    SizedBox(
                      height: 41,
                      child: DropdownButtonFormField<String>(
                        hint: Text(
                          "Select the type",
                          style: TextStyles.bodyMedium.copyWith(
                            color: AppColors.darkGreen,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: AppColors.lightGreen,
                          suffixIcon: Container(
                            margin: const EdgeInsets.all(8),
                            child: CustomSvgPicture(path: AppAssets.arrowDown),
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
                        items: const [
                          DropdownMenuItem(
                            value: "income",
                            child: Text("Income"),
                          ),
                          DropdownMenuItem(
                            value: "expense",
                            child: Text("Expense"),
                          ),
                        ],
                        onChanged: (value) {
                          cubit.typeController.text = value ?? '';
                        },
                      ),
                    ),
                    const Gap(30),

                    // ── Amount ────────────────────────────────────────
                    Container(
                      margin: const EdgeInsets.only(left: 10),
                      child: Text(
                        "Amount",
                        style: TextStyles.bodyMedium.copyWith(
                          color: AppColors.lettersAndIcons,
                        ),
                      ),
                    ),
                    const Gap(1),
                    SizedBox(
                      height: 41,
                      child: TextFormField(
                        autovalidateMode: AutovalidateMode.onUnfocus,
                        controller: cubit.amountController,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return "Please enter the amount";
                          }
                          return null;
                        },
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: AppColors.lightGreen,
                          hintText: "\$26.00",
                          hintStyle: TextStyles.bodyMedium.copyWith(
                            color: AppColors.lettersAndIcons,
                          ),
                          border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(18),
                          ),
                        ),
                      ),
                    ),
                    const Gap(30),

                    // ── Expense Title ─────────────────────────────────
                    Container(
                      margin: const EdgeInsets.only(left: 10),
                      child: Text(
                        "Expense Title",
                        style: TextStyles.bodyMedium.copyWith(
                          color: AppColors.lettersAndIcons,
                        ),
                      ),
                    ),
                    const Gap(1),
                    SizedBox(
                      height: 41,
                      child: TextFormField(
                        autovalidateMode: AutovalidateMode.onUnfocus,
                        controller: cubit.titelController,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return "Please enter the title";
                          }
                          return null;
                        },

                        decoration: InputDecoration(
                          filled: true,
                          fillColor: AppColors.lightGreen,
                          hintText: "Dinner",
                          hintStyle: TextStyles.bodyMedium.copyWith(
                            color: AppColors.lettersAndIcons,
                          ),
                          border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.circular(18),
                          ),
                        ),
                      ),
                    ),
                    const Gap(30),

                    // ── Message ───────────────────────────────────────
                    TextFormField(
                      controller: cubit.messageController,
                      maxLines: 5,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: AppColors.lightGreen,
                        hintText: "Enter message",
                        hintStyle: TextStyles.bodyMedium.copyWith(
                          color: AppColors.mainGreen,
                        ),
                        border: OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.circular(18),
                        ),
                      ),
                    ),
                    const Gap(30),

                    // ── Save Button ───────────────────────────────────
                    Center(
                      child: MainButton(
                        size: ButtonSize.small,
                        text: "Save",
                        onPress: () {
                          if (cubit.formKey.currentState!.validate()) {
                            showLoadingDialog(context);
                            cubit.addTransaction();
                            pop(context);
                            // pushTo(context, Routes.homeScreen);
                          }
                        },
                        textStyle: TextStyles.bodyMedium.copyWith(
                          color: AppColors.lettersAndIcons,
                        ),
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
}
