import 'package:finwise/core/constants/app_assets.dart';

class OnboardingData {
  final String title;
  final String imagePath;

  OnboardingData({required this.title, required this.imagePath});
}

final List<OnboardingData> onBoardingPages = [
  OnboardingData(
    title: "Welcome To\nExpense Manager",
    imagePath: AppAssets.expenseManager,
  ),
  OnboardingData(
    title: "¿Are You Ready To\nTake Control Of\nYour Finances?",
    imagePath: AppAssets.controlMoney,
  ),
];
