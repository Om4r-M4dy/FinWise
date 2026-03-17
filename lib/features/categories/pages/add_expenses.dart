import 'package:date_field/date_field.dart';
import 'package:finwise/core/constants/app_assets.dart';
import 'package:finwise/core/constants/app_colors.dart';
import 'package:finwise/core/styles/text_styles.dart';
import 'package:finwise/core/widgets/custom_svg_picture.dart';
import 'package:finwise/core/widgets/default_app_bar.dart';
import 'package:finwise/core/widgets/main_button.dart';
import 'package:finwise/core/widgets/my_body_view.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class AddExpenses extends StatelessWidget {
  const AddExpenses({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DefaultAppBar(title: "Add Expenses"),
      body: MyBodyView(
        topSection: Container(height: 5),
        bottomSection: Padding(
          padding: const EdgeInsets.symmetric(vertical: 15),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.only(left: 10),
                  child: Text(
                    "Date",
                    style: TextStyles.body_15.copyWith(
                      color: AppColors.lettersAndIcons,
                    ),
                  ),
                ),
                Gap(1),
                SizedBox(
                  height: 41,
                  child: DateTimeFormField(
                    mode: DateTimeFieldPickerMode.date,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: AppColors.lightGreen,
                      hintText: "April 30 ,2024",
                      hintStyle: TextStyles.body_15.copyWith(
                        color: AppColors.lettersAndIcons,
                      ),
                      suffixIcon: Container(
                        margin: EdgeInsets.all(10),
                        child: CustomSvgPicture(path: AppAssets.calender),
                      ),
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(18),
                      ),
                    ),
                  ),
                ),
                Gap(30),
                Container(
                  margin: EdgeInsets.only(left: 10),
                  child: Text(
                    "Category",
                    style: TextStyles.body_15.copyWith(
                      color: AppColors.lettersAndIcons,
                    ),
                  ),
                ),
                Gap(1),
                SizedBox(
                  height: 41,
                  child: DropdownButtonFormField(
                    hint: Text(
                      "Select the category",
                      style: TextStyles.body_15.copyWith(
                        color: AppColors.darkGreen,
                        fontWeight: FontWeight.w400,
                      ),
                    ),

                    decoration: InputDecoration(
                      filled: true,
                      fillColor: AppColors.lightGreen,

                      suffixIcon: Container(
                        margin: EdgeInsets.all(8),
                        child: CustomSvgPicture(path: AppAssets.arrowDown),
                      ),
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(18),
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 16,
                      ),
                    ),
                    items: [
                      DropdownMenuItem(
                        value: "1",
                        child: Text(
                          "Category1",
                          style: TextStyles.body_15.copyWith(
                            color: AppColors.lettersAndIcons,
                          ),
                        ),
                      ),
                      DropdownMenuItem(
                        value: "2",
                        child: Text(
                          "Category2",
                          style: TextStyles.body_15.copyWith(
                            color: AppColors.lettersAndIcons,
                          ),
                        ),
                      ),
                      DropdownMenuItem(
                        value: "3",
                        child: Text(
                          "Category3",
                          style: TextStyles.body_15.copyWith(
                            color: AppColors.lettersAndIcons,
                          ),
                        ),
                      ),
                    ],
                    onChanged: (value) {},
                  ),
                ),

                Gap(30),
                Container(
                  margin: EdgeInsets.only(left: 10),
                  child: Text(
                    "Account",
                    style: TextStyles.body_15.copyWith(
                      color: AppColors.lettersAndIcons,
                    ),
                  ),
                ),
                Gap(1),
                SizedBox(
                  height: 41,
                  child: TextFormField(
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: AppColors.lightGreen,
                      hintText: "\$26.00",
                      hintStyle: TextStyles.body_15.copyWith(
                        color: AppColors.lettersAndIcons,
                      ),
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(18),
                      ),
                    ),
                  ),
                ),
                Gap(30),
                Container(
                  margin: EdgeInsets.only(left: 10),
                  child: Text(
                    "Exspense Title",
                    style: TextStyles.body_15.copyWith(
                      color: AppColors.lettersAndIcons,
                    ),
                  ),
                ),
                Gap(1),
                SizedBox(
                  height: 41,
                  child: TextFormField(
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: AppColors.lightGreen,
                      hintText: "Dinner",
                      hintStyle: TextStyles.body_15.copyWith(
                        color: AppColors.lettersAndIcons,
                      ),
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(18),
                      ),
                    ),
                  ),
                ),
                Gap(30),

                TextFormField(
                  maxLines: 5,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: AppColors.lightGreen,
                    hintText: "Enter message",
                    hintStyle: TextStyles.body_15.copyWith(
                      color: AppColors.mainGreen,
                    ),
                    border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),
                ),
                Gap(30),
                Center(
                  child: MainButton(
                    size: ButtonSize.small,
                    text: "Save",
                    onPress: () {},
                    textStyle: TextStyles.body_15.copyWith(
                      color: AppColors.lettersAndIcons,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
