import 'package:finwise/core/constants/app_assets.dart';
import 'package:finwise/core/constants/app_colors.dart';
import 'package:finwise/core/functions/navigations.dart';
import 'package:finwise/core/routes/routes.dart';
import 'package:finwise/core/styles/text_styles.dart';
import 'package:finwise/core/widgets/custom_svg_picture.dart';
import 'package:finwise/core/widgets/default_app_bar.dart';
import 'package:finwise/core/widgets/info_record.dart';
import 'package:finwise/core/widgets/my_body_view.dart';
import 'package:finwise/core/widgets/progress_section.dart';
import 'package:finwise/features/Transaction/widgets/transaction_box.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flip_card/flip_card_controller.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class TransactionScreen extends StatelessWidget {
  TransactionScreen({super.key});
  final FlipCardController flipController = FlipCardController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.mainGreen,
         leading:SizedBox.shrink(),
        title: Text('Transaction', style: TextStyles.bodyLarge),
        actions: [
          IconButton(
            onPressed: () {
              pushTo(context, Routes.notificationScreen);
            },
            icon: CustomSvgPicture(path: AppAssets.appBarNotification),
          ),
        ],
      ),
      body: MyBodyView(
        
        topSection: Column(
          children: [
            InkWell(
              onTap: () {
                flipController.toggleCard();
              },
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.lightGreen,
                  borderRadius: BorderRadius.circular(14),
                ),
                height: 75,
                width: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text('Total Balance', style: TextStyles.bodyMedium),
                    Text(
                      '\$7,783.00',
                      style: TextStyles.headlineLarge.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Gap(17),
            FlipCard(
              controller: flipController,
              flipOnTouch: false,
              front: Row(
                children: [
                  TransactionBox(
                    titel: 'Incom',
                    palance: '4,120.00',
                    pathIcon: AppAssets.income,
                    iconColor: AppColors.mainGreen,
                  ),
                  Gap(15),
                  TransactionBox(
                    titel: 'Expense',
                    palance: '1,187.40',
                    pathIcon: AppAssets.expense,
                    iconColor: AppColors.oceanBlueButton,
                    palanceColor: AppColors.oceanBlueButton,
                  ),
                ],
              ),
              back: ProgressSection(
                percentage: 30,
                totalAmount: 20000.00,
                totalExpanse: 1187.40,
                totalBalance: 7783.00,
              ),
            ),
          ],
        ),
        bottomSection: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('April', style: TextStyles.bodyMedium),
                  // Container(
                  //   decoration: BoxDecoration(
                  //     borderRadius: BorderRadius.circular(12.5),
                  //     color: AppColors.mainGreen,
                  //   ),
                  //   child: CustomSvgPicture(
                  //     path: AppAssets.calender,
                  //     // width: 18,height: 16,
                  //   ),
                  // ),
                  IconButton(
                    onPressed: () {},
                    icon: const CustomSvgPicture(path: AppAssets.calender),
                  ),
                ],
              ),
              Gap(20),
              Column(
                children: [
                  InfoRecord(
                    iconPath: AppAssets.groceries,
                    bgColor: AppColors.blueButton,
                    title: "Groceries",
                    date: "17:00 - April 24",
                    cat: "Pantry",
                    amount: "-\$100,00",
                    amountColor: AppColors.oceanBlueButton,
                  ),
                  Gap(19),
                  InfoRecord(
                    iconPath: AppAssets.groceries,
                    bgColor: AppColors.oceanBlueButton,
                    title: "Rent",
                    date: "8:30 - April 15",
                    cat: "Rent",
                    amount: "-\$674,40",
                    amountColor: AppColors.oceanBlueButton,
                  ),
                  Gap(19),
                  InfoRecord(
                    iconPath: AppAssets.salary,
                    bgColor: AppColors.blueButton,
                    title: "Transport",
                    date: "7:30 - April 08",
                    cat: "Fuel",
                    amount: "\$4,13",
                    amountColor: AppColors.oceanBlueButton,
                  ),
                  Gap(19),
                  InfoRecord(
                    iconPath: AppAssets.salary,
                    title: "Salary",
                    date: "18:27 - April 30",
                    cat: "Monthly",
                    amount: "\$4.000,00",
                  ),
                ],
              ),
              Gap(24),
              Text('March', style: TextStyles.bodyMedium),
              Gap(18),
              Column(
                children: [
                  InfoRecord(
                    iconPath: AppAssets.groceries,
                    bgColor: AppColors.blueButton,
                    title: "Food",
                    date: "19:30 - March 31",
                    cat: "Dinner",
                    amount: "-\$70,40",
                    amountColor: AppColors.oceanBlueButton,
                  ),
                  Gap(19),
                  InfoRecord(
                    iconPath: AppAssets.groceries,
                    bgColor: AppColors.oceanBlueButton,
                    title: "Rent",
                    date: "8:30 - April 15",
                    cat: "Rent",
                    amount: "-\$674,40",
                    amountColor: AppColors.oceanBlueButton,
                  ),
                  Gap(19),
                  InfoRecord(
                    iconPath: AppAssets.salary,
                    bgColor: AppColors.blueButton,
                    title: "Transport",
                    date: "7:30 - April 08",
                    cat: "Fuel",
                    amount: "\$4,13",
                    amountColor: AppColors.oceanBlueButton,
                  ),
                  Gap(19),
                  InfoRecord(
                    iconPath: AppAssets.salary,
                    title: "Salary",
                    date: "18:27 - April 30",
                    cat: "Monthly",
                    amount: "\$4.000,00",
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
