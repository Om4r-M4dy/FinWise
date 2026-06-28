import 'package:flutter/material.dart';

import 'package:finwise/features/Home/pages/home_screen.dart';
import 'package:finwise/features/Transaction/pages/transaction_screen.dart';
import 'package:finwise/features/analysis/pages/analysis_screen.dart';
import 'package:finwise/features/categories/pages/main_categories.dart';
import 'package:finwise/features/profile/page/profile_screen.dart';

final List<Widget> navScreens = [
  HomeScreen(),
  AnalysisScreen(),
  TransactionScreen(),
  MainCategories(),
  ProfileScreen(),
];