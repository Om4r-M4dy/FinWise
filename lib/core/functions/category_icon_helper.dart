import 'package:finwise/core/constants/app_assets.dart';

/// Returns the matching SVG asset path for a category name
String getIconForCategory(String category) {
  switch (category.toLowerCase().trim()) {
    case 'salary':
      return AppAssets.salary;
    case 'groceries':
      return AppAssets.groceries;
    case 'food':
      return AppAssets.food;
    case 'transport':
      return AppAssets.transport;
    case 'entertainment':
    case 'leisure':
      return AppAssets.entertainment;
    case 'medicine':
      return AppAssets.medicine;
    case 'travel':
      return AppAssets.travel;
    case 'car':
      return AppAssets.car;
    case 'gift':
    case 'gifts':
      return AppAssets.gift;
    case 'rent':
    case 'new house':
    case 'newhouse':
      return AppAssets.newHome;
    case 'saving':
    case 'savings':
    case 'saving & investments':
      return AppAssets.saving;
    case 'car':
      return AppAssets.car;
    case 'new house':
      return AppAssets.newHome;
    case 'travel':
      return AppAssets.travel;
    case 'wedding':
      return AppAssets.wedding;
    case 'income':
      return AppAssets.income;
    case 'other':
    default:
      return AppAssets.more;
  }
}
