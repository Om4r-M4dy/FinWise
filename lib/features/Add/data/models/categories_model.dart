import 'dart:ui';

import 'package:finwise/core/constants/app_assets.dart';
import 'package:finwise/core/constants/app_colors.dart';
import 'package:finwise/core/styles/text_styles.dart';
import 'package:flutter/material.dart';

class Ids {
  static const String food = 'food';
  static const String transport = 'transport';
  static const String medicine = 'medicine';
  static const String groceries = 'groceries';
  static const String rent = 'rent';
  static const String gifts = 'gifts';
  static const String savings = 'savings';
  static const String leisure = 'leisure';
  static const String other = 'other';
}

class CategoriesModel {
  final String? id;
  final String? name;
  final String? icon;
  final Color? color;
  final String? type;
  CategoriesModel({this.id, this.name, this.icon, this.color, this.type});

  List<CategoriesModel> getCategories() {
    return [
      CategoriesModel(
        id: Ids.food,
        name: 'Food',
        icon: AppAssets.food,
        color: AppColors.lightBlueButton,
        type: 'expense',
      ),
      CategoriesModel(
        id: Ids.transport,
        name: 'Transport',
        icon: AppAssets.transport,
        color: AppColors.lightBlueButton,
        type: 'expense',
      ),
      CategoriesModel(
        id: Ids.medicine,
        name: 'Salary',
        icon: AppAssets.medicine,
        color: AppColors.lightBlueButton,
        type: 'income',
      ),
      CategoriesModel(
        id: Ids.groceries,
        name: 'Groceries',
        icon: AppAssets.groceries,
        color: AppColors.lightBlueButton,
        type: 'expense',
      ),

      CategoriesModel(
        id: Ids.rent,
        name: 'Rent',
        icon: AppAssets.rent,
        color: AppColors.lightBlueButton,
        type: 'expense',
      ),

      CategoriesModel(
        id: Ids.gifts,
        name: 'Gifts',
        icon: AppAssets.gift,
        color: AppColors.lightBlueButton,
        type: 'expense',
      ),

      CategoriesModel(
        id: Ids.savings,
        name: 'Savings',
        icon: AppAssets.saving,
        color: AppColors.lightBlueButton,
        type: 'income',
      ),

      CategoriesModel(
        id: Ids.leisure,
        name: 'Leisure',
        icon: AppAssets.entertainment,
        color: AppColors.lightBlueButton,
        type: 'expense',
      ),
      CategoriesModel(
        id: Ids.other,
        name: 'Other',
        icon: AppAssets.more,
        color: AppColors.lightBlueButton,
        type: 'expense',
      ),
    ];
  }
}

List<DropdownMenuItem<String>> getCategoriesMenu()  {
  return [
    DropdownMenuItem(
      value: Ids.food,
      child: Text(
        'Food',
        style: TextStyles.bodyMedium.copyWith(color: AppColors.lettersAndIcons),
      ),
    ),
    DropdownMenuItem(
      value: Ids.transport,
      child: Text(
        'Transport',
        style: TextStyles.bodyMedium.copyWith(color: AppColors.lettersAndIcons),
      ),
    ),
    DropdownMenuItem(
      value: Ids.medicine,
      child: Text(
        'Medicine',
        style: TextStyles.bodyMedium.copyWith(color: AppColors.lettersAndIcons),
      ),
    ),
    DropdownMenuItem(
      value: Ids.groceries,
      child: Text(
        'Groceries',
        style: TextStyles.bodyMedium.copyWith(color: AppColors.lettersAndIcons),
      ),
    ),
    DropdownMenuItem(
      value: Ids.rent,
      child: Text(
        'Rent',
        style: TextStyles.bodyMedium.copyWith(color: AppColors.lettersAndIcons),
      ),
    ),
    DropdownMenuItem(
      value: Ids.gifts,
      child: Text(
        'Gifts',
        style: TextStyles.bodyMedium.copyWith(color: AppColors.lettersAndIcons),
      ),
    ),
    DropdownMenuItem(
      value: Ids.savings,
      child: Text(
        'Savings',
        style: TextStyles.bodyMedium.copyWith(color: AppColors.lettersAndIcons),
      ),
    ),
    DropdownMenuItem(
      value: Ids.leisure,
      child: Text(
        'Leisure',
        style: TextStyles.bodyMedium.copyWith(color: AppColors.lettersAndIcons),
      ),
    ),
    DropdownMenuItem(
      value: Ids.other,
      child: Text(
        'Other',
        style: TextStyles.bodyMedium.copyWith(color: AppColors.lettersAndIcons),
      ),
    ),
  ];
}
