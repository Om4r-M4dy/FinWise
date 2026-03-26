import 'package:finwise/core/constants/app_assets.dart';
import 'package:finwise/core/constants/app_colors.dart';
import 'package:finwise/core/styles/text_styles.dart';
import 'package:finwise/core/widgets/custom_svg_picture.dart';
import 'package:finwise/core/widgets/custom_text_form_field.dart';
import 'package:finwise/core/widgets/main_button.dart';
import 'package:finwise/core/widgets/my_body_view.dart';
import 'package:finwise/core/widgets/row_app_bar.dart';
import 'package:finwise/features/search/widget/expense_card.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TransactionType _selectedTransactionType = TransactionType.expense;
  bool _showSearchResults = false;
  @override
  Widget build(BuildContext context) {
    return MyBodyView(
      topSection: Column(
        children: [
          SafeArea(child: RowAppBar(title: 'Search')),
          Gap(30),
          CustomTextFormField(
            hintText: 'Search...',
            fillColor: AppColors.background,
            radius: 30,
            readOnly: true,
          ),
          Gap(24),
        ],
      ),

      bottomSection: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Categories', style: TextStyles.body_15),
            Gap(7),
            CustomTextFormField(
              hintText: 'Select the category',
              suffixIcon: UnconstrainedBox(
                child: CustomSvgPicture(
                  path: AppAssets.arrowDown,
                  width: 5,
                  height: 9,
                ),
              ),
              readOnly: true,
            ),
            Gap(30),
            Text('Date', style: TextStyles.body_15),
            Gap(7),
            CustomTextFormField(
              hintText: '30 /APR/2023',
              suffixIcon: UnconstrainedBox(
                child: CustomSvgPicture(
                  path: AppAssets.calender,
                  width: 24,
                  height: 22,
                ),
              ),
              readOnly: true,
            ),
            Gap(40),
            //Radio Button
            Text('Report', style: TextStyles.body_15),
            Gap(9),
            RadioGroup<TransactionType>(
              //is ther any problem with this widget?
              groupValue: _selectedTransactionType,
              onChanged: (value) {},
              child: Row(
                children: [
                  _radioButtonBuilder(
                    title: 'Income',
                    value: TransactionType.income,
                  ),
                  Gap(55),
                  _radioButtonBuilder(
                    title: 'Expense',
                    value: TransactionType.expense,
                  ),
                ],
              ),
            ),
            Gap(50),
            Center(
              child: MainButton(
                text: 'Search',
                onPress: () {
                  setState(() {
                    _showSearchResults = true;
                  });
                },
              ),
            ),
            Gap(70),
            if (_showSearchResults) ExpenseCard(),
          ],
        ),
      ),
    );
  }

  Widget _radioButtonBuilder({
    required String title,
    required TransactionType value,
  }) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedTransactionType = value;
        });
      },
      child: Row(
        children: [
          Radio<TransactionType>(
            //to remove the radio button constraines
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            visualDensity: const VisualDensity(
              horizontal: VisualDensity.minimumDensity,
              vertical: VisualDensity.minimumDensity,
            ),
            value: value,
            activeColor: AppColors.mainGreen,
          ),
          Gap(12),
          Text(title, style: TextStyles.subtitle_17),
        ],
      ),
    );
  }
}

//transaction type to the Radio button
enum TransactionType { income, expense }
