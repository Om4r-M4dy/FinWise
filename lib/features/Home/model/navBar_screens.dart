import 'package:finwise/core/constants/app_assets.dart';
import 'package:finwise/core/constants/app_colors.dart';
import 'package:finwise/core/functions/navigations.dart';
import 'package:finwise/core/routes/routes.dart';
import 'package:finwise/core/styles/text_styles.dart';
import 'package:finwise/core/widgets/custom_svg_picture.dart';
import 'package:finwise/core/widgets/default_app_bar.dart';
import 'package:finwise/features/Add/presentation/cubit/add_balance_cubit.dart';
import 'package:finwise/features/Add/presentation/page/add_balance_screen.dart';
import 'package:flutter/material.dart';

import 'package:finwise/features/Home/pages/home_screen.dart';
import 'package:finwise/features/Transaction/presentation/pages/transaction_screen.dart';
import 'package:finwise/features/analysis/pages/analysis_screen.dart';
import 'package:finwise/features/categories/pages/main_categories.dart';
import 'package:finwise/features/profile/page/profile_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

final List<NavItemModel> navScreens = [
  NavItemModel(icon: AppAssets.home, appBar: null, page: HomeScreen()),

  NavItemModel(
    icon: AppAssets.analysis,
    appBar: (context) => AppBar(
      backgroundColor: AppColors.mainGreen,
      leading: SizedBox.shrink(),
      title: Text("Analysis", style: TextStyles.bodyLarge),
      actions: [
        IconButton(
          onPressed: () {
            pushTo(context, Routes.notificationScreen);
          },
          icon: CustomSvgPicture(path: AppAssets.appBarNotification),
        ),
      ],
    ),
    page: AnalysisScreen(),
  ),

  NavItemModel(
    icon: AppAssets.more,
    appBar: (context) => AppBar(
      backgroundColor: AppColors.mainGreen,
      leading: SizedBox.shrink(),
      title: Text("Add Balance", style: TextStyles.bodyLarge),
      actions: [
        IconButton(
          onPressed: () {
            pushTo(context, Routes.notificationScreen);
          },
          icon: CustomSvgPicture(path: AppAssets.appBarNotification),
        ),
      ],
    ),
    page: BlocProvider(
      create: (context) => AddBalanceCubit(),
      child: const AddBalanceScreen(),
    ),
  ),
  NavItemModel(
    icon: AppAssets.category,
    appBar: (context) => AppBar(
      backgroundColor: AppColors.mainGreen,
      leading: SizedBox.shrink(),
      title: Text("Categories", style: TextStyles.bodyLarge),
      actions: [
        IconButton(
          onPressed: () {
            pushTo(context, Routes.notificationScreen);
          },
          icon: CustomSvgPicture(path: AppAssets.appBarNotification),
        ),
      ],
    ),
    page: MainCategories(),
  ),
  NavItemModel(icon: AppAssets.profile, appBar: null, page: ProfileScreen()),
];

class NavItemModel {
  final Widget page;
  final PreferredSizeWidget? Function(BuildContext context)? appBar;

  final String icon;

  const NavItemModel({required this.page, required this.icon, this.appBar});
}
