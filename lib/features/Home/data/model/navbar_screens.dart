import 'package:finwise/core/constants/app_assets.dart';
import 'package:finwise/core/styles/text_styles.dart';
import 'package:finwise/features/Transaction/presentation/cubit/transaction_cubit.dart';
import 'package:finwise/features/Transaction/presentation/pages/add_transaction.dart';
import 'package:flutter/material.dart';
import 'package:finwise/features/Home/persentation/pages/home_screen.dart';
import 'package:finwise/features/analysis/pages/analysis_screen.dart';
import 'package:finwise/features/categories/pages/main_categories.dart';
import 'package:finwise/features/profile/persentation/pages/user_profile/profile_screen.dart';
import 'package:finwise/core/widgets/buttons/notification_badge_button.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

final List<NavItemModel> navScreens = [
  NavItemModel(icon: AppAssets.home, appBar: null, page: HomeScreen()),

  NavItemModel(
    icon: AppAssets.analysis,
    appBar: (context) {
      final theme = Theme.of(context);
      return AppBar(
        backgroundColor: theme.appBarTheme.backgroundColor,
        leading: const SizedBox.shrink(),
        title: Text(
          "Analysis",
          style: TextStyles.bodyLarge.copyWith(
            color: theme.colorScheme.onSurface,
          ),
        ),
        actions: const [NotificationBadgeButton()],
      );
    },
    page: AnalysisScreen(),
  ),

  NavItemModel(
    icon: AppAssets.transactions,
    appBar: (context) {
      final theme = Theme.of(context);
      return AppBar(
        backgroundColor: theme.appBarTheme.backgroundColor,
        leading: const SizedBox.shrink(),
        title: Text(
          "Add Transaction",
          style: TextStyles.bodyLarge.copyWith(
            color: theme.colorScheme.onSurface,
          ),
        ),
        actions: const [NotificationBadgeButton()],
      );
    },
    page: BlocProvider(
      create: (context) => TransactionCubit(),
      child: const AddTransaction(showAppBar: false),
    ),
  ),
  NavItemModel(
    icon: AppAssets.category,
    appBar: (context) {
      final theme = Theme.of(context);
      return AppBar(
        backgroundColor: theme.appBarTheme.backgroundColor,
        leading: const SizedBox.shrink(),
        title: Text(
          "Categories",
          style: TextStyles.bodyLarge.copyWith(
            color: theme.colorScheme.onSurface,
          ),
        ),
        actions: const [NotificationBadgeButton()],
      );
    },
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
