import 'package:finwise/core/constants/app_assets.dart';
import 'package:finwise/core/constants/app_colors.dart';
import 'package:finwise/core/constants/categories.dart';
import 'package:finwise/core/styles/text_styles.dart';
import 'package:finwise/core/widgets/custom_svg_picture.dart';
import 'package:finwise/core/widgets/custom_text_form_field.dart';
import 'package:finwise/core/widgets/buttons/main_button.dart';
import 'package:finwise/core/widgets/my_body_view.dart';
import 'package:finwise/core/widgets/row_app_bar.dart';
import 'package:finwise/features/search/widgets/search_results_list.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:intl/intl.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TransactionType _selectedTransactionType = TransactionType.expense;
  bool _showSearchResults = false;
  bool _isLoading = false;
  String _selectedCategoryKey = 'all';
  DateTime? _selectedDate;
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();

  @override
  void dispose() {
    _dateController.dispose();
    _titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MyBodyView(
        topSection: Column(
          children: [
            SafeArea(child: RowAppBar(title: 'Search')),
            const Gap(30),
            CustomTextFormField(
              controller: _titleController,
              hintText: 'Search by title...',
              fillColor: AppColors.background,
              radius: 30,
              onChange: (value) {
                setState(() {
                  _showSearchResults = false;
                });
              },
            ),
            const Gap(24),
          ],
        ),
        bottomSection: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Categories', style: TextStyles.bodyMedium),
              const Gap(7),
              DropdownButtonFormField<String>(
                initialValue: _selectedCategoryKey,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: AppColors.lightGreen,
                  suffixIcon: Container(
                    margin: const EdgeInsets.all(8),
                    child: const CustomSvgPicture(path: AppAssets.arrowDown),
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
                items: [
                  DropdownMenuItem<String>(
                    value: 'all',
                    child: Text(
                      'All Categories',
                      style: TextStyles.bodyMedium.copyWith(
                        color: AppColors.lettersAndIcons,
                      ),
                    ),
                  ),
                  ...categories.map((category) {
                    return DropdownMenuItem<String>(
                      value: category['key'],
                      child: Text(
                        category['label']!,
                        style: TextStyles.bodyMedium.copyWith(
                          color: AppColors.lettersAndIcons,
                        ),
                      ),
                    );
                  }),
                ],
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _selectedCategoryKey = value;
                      _showSearchResults = false;
                    });
                  }
                },
              ),
              const Gap(30),
              Text('Date', style: TextStyles.bodyMedium),
              const Gap(7),
              CustomTextFormField(
                controller: _dateController,
                hintText: 'Select Date',
                fillColor: AppColors.lightGreen,
                suffixIcon: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    if (_selectedDate != null)
                      IconButton(
                        icon: const Icon(
                          Icons.clear,
                          size: 20,
                          color: AppColors.lettersAndIcons,
                        ),
                        onPressed: () {
                          setState(() {
                            _selectedDate = null;
                            _dateController.clear();
                            _showSearchResults = false;
                          });
                        },
                      ),
                    UnconstrainedBox(
                      child: const CustomSvgPicture(
                        path: AppAssets.calender,
                        width: 24,
                        height: 22,
                      ),
                    ),
                    const Gap(12),
                  ],
                ),
                readOnly: true,
                onTap: () async {
                  final pickedDate = await showDatePicker(
                    context: context,
                    initialDate: _selectedDate ?? DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                    builder: (context, child) {
                      return Theme(
                        data: Theme.of(context).copyWith(
                          colorScheme: const ColorScheme.light(
                            primary: AppColors.mainGreen,
                            onPrimary: Colors.white,
                            onSurface: AppColors.lettersAndIcons,
                          ),
                        ),
                        child: child!,
                      );
                    },
                  );
                  if (pickedDate != null) {
                    setState(() {
                      _selectedDate = pickedDate;
                      _dateController.text = DateFormat(
                        'dd / MMM / yyyy',
                      ).format(pickedDate).toUpperCase();
                      _showSearchResults = false;
                    });
                  }
                },
              ),
              const Gap(40),
              //Radio Button
              Text('Report', style: TextStyles.bodyMedium),
              const Gap(9),
              RadioGroup<TransactionType>(
                groupValue: _selectedTransactionType,
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      _selectedTransactionType = value;
                      _showSearchResults = false;
                    });
                  }
                },
                child: Row(
                  children: [
                    _radioButtonBuilder(
                      title: 'Income',
                      value: TransactionType.income,
                    ),
                    const Gap(55),
                    _radioButtonBuilder(
                      title: 'Expense',
                      value: TransactionType.expense,
                    ),
                  ],
                ),
              ),
              const Gap(24),
              Center(
                child: MainButton(
                  text: 'Search',
                  onPress: () {
                    setState(() {
                      _isLoading = true;
                      _showSearchResults = false;
                    });
                    Future.delayed(const Duration(milliseconds: 600), () {
                      if (mounted) {
                        setState(() {
                          _isLoading = false;
                          _showSearchResults = true;
                        });
                      }
                    });
                  },
                ),
              ),
              const Gap(5),
              if (_isLoading)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 24.0),
                    child: CircularProgressIndicator(
                      color: AppColors.mainGreen,
                    ),
                  ),
                ),
              if (_showSearchResults && !_isLoading) ...[
                Text('Results', style: TextStyles.bodyMedium),
                SearchResultsList(
                  titleQuery: _titleController.text,
                  selectedCategoryKey: _selectedCategoryKey,
                  selectedDate: _selectedDate,
                  selectedTransactionType: _selectedTransactionType,
                ),
              ],
            ],
          ),
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
          _showSearchResults = false;
        });
      },
      child: Row(
        children: [
          Radio<TransactionType>(
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            visualDensity: const VisualDensity(
              horizontal: VisualDensity.minimumDensity,
              vertical: VisualDensity.minimumDensity,
            ),
            value: value,
            activeColor: AppColors.mainGreen,
          ),
          const Gap(12),
          Text(title, style: TextStyles.bodyMedium),
        ],
      ),
    );
  }
}

enum TransactionType { income, expense }
