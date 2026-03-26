import 'package:finwise/features/Security/pages/terms_and_conditions.dart';
import 'package:finwise/features/analysis/pages/analysis_screen.dart';
import 'package:finwise/features/categories/pages/add_expenses.dart';
import 'package:finwise/features/categories/pages/add_savings.dart';
import 'package:finwise/features/categories/pages/car.dart';
import 'package:finwise/features/categories/pages/entertainment_screen.dart';
import 'package:finwise/features/categories/pages/food_screen.dart';
import 'package:finwise/features/categories/pages/gifts_screen.dart';
import 'package:finwise/features/categories/pages/groceries_screen.dart';
import 'package:finwise/features/categories/pages/main_categories.dart';
import 'package:finwise/features/categories/pages/medicine_screen.dart';
import 'package:finwise/features/categories/pages/new_house.dart';
import 'package:finwise/features/categories/pages/rent_screen.dart';
import 'package:finwise/features/categories/pages/savings.dart';
import 'package:finwise/features/categories/pages/transport_screen.dart';
import 'package:finwise/features/categories/pages/travel.dart';
import 'package:finwise/features/categories/pages/wedding.dart';
import 'package:finwise/features/help/pages/chat_screen.dart';
import 'package:finwise/features/help/pages/customer_service.dart';
import 'package:finwise/features/help/pages/help_center.dart';
import 'package:finwise/features/launch/launch_screen.dart';
import 'package:finwise/features/notification/pages/notification_screen.dart';
import 'package:finwise/features/on_boarding/page/on_boarding.dart';
import 'package:finwise/features/quick_analysis/page/quick_analysis_screen.dart';
import 'package:finwise/features/search/page/search_screen.dart';
import 'package:finwise/features/settings/delete_account/pages/delete_account_screen.dart';
import 'package:finwise/features/settings/notification_settings/pages/notification_settings_screen.dart';
import 'package:finwise/features/settings/page/settings_screen.dart';
import 'package:finwise/features/profile/page/edit_profile.dart';
import 'package:finwise/features/profile/page/profile_screen.dart';
import 'package:go_router/go_router.dart';

class Routes {
  // route names
  static const String launch = '/';
  static const String onBoarding = '/on_boarding';
  static const String termsAndConditions = '/terms_and_conditions';
  static const String analysisScreen = '/analysis';
  static const String categories = '/main_categories';
  static const String helpCenter = '/help_center';
  static const String customerService = '/customer_service';
  static const String chatScreen = '/chat_screen';
  static const String foodScreen = '/foodScreen';
  static const String addExpenses = '/add_expenses';
  static const String transportScreen = '/transport_screen';
  static const String groceriesScreen = '/groceries_screen';
  static const String giftsScreen = '/gifts_screen';
  static const String medicineScreen = '/medicine_screen';
  static const String rentScreen = '/rent_screen';
  static const String wedding = '/wedding';
  static const String travel = '/travel';
  static const String newHouse = '/new_house';
  static const String car = '/car';
  static const String savings = '/savings';
  static const String addSavings = '/add_savings';
  static const String entertainmentScreen = '/entertainment_screen';
  static const String quickAnalysisScreen = '/quick_analysis';
  static const String settingsScreen = '/settings';
  static const String notificationSettingsScreen = '/notification_settings';
  static const String deleteAccountScreen = '/delete_account';
  static const String notificationScreen = '/notification';

  static const String profileScreen = '/profile';
  static const String editProfileScreen = '/edit_profile';
  static const String searchScreen = '/search';

  // config
  static final routes = GoRouter(
    routes: [
      GoRoute(path: launch, builder: (context, state) => const LaunchScreen()),
      GoRoute(
        path: onBoarding,
        builder: (context, state) => const OnBoardingScreen(),
      ),
      GoRoute(
        path: categories,
        builder: (context, state) => const MainCategories(),
      ),
      GoRoute(
        path: termsAndConditions,
        builder: (context, state) => const TermsAndConditions(),
      ),
      GoRoute(
        path: helpCenter,
        builder: (context, state) => const HelpCenter(),
      ),
      GoRoute(
        path: customerService,
        builder: (context, state) => const CustomerService(),
      ),
      GoRoute(
        path: chatScreen,
        builder: (context, state) => const ChatScreen(),
      ),
      GoRoute(
        path: foodScreen,
        builder: (context, state) => const FoodScreen(),
      ),
      GoRoute(
        path: addExpenses,
        builder: (context, state) => const AddExpenses(),
      ),
      GoRoute(
        path: transportScreen,
        builder: (context, state) => const TransportScreen(),
      ),
      GoRoute(
        path: groceriesScreen,
        builder: (context, state) => const GroceriesScreen(),
      ),
      GoRoute(
        path: rentScreen,
        builder: (context, state) => const RentScreen(),
      ),
      GoRoute(
        path: giftsScreen,
        builder: (context, state) => const GiftsScreen(),
      ),
      GoRoute(
        path: entertainmentScreen,
        builder: (context, state) => const EntertainmentScreen(),
      ),
      GoRoute(
        path: medicineScreen,
        builder: (context, state) => const MedicineScreen(),
      ),
      GoRoute(path: travel, builder: (context, state) => const Travel()),
      GoRoute(path: wedding, builder: (context, state) => const Wedding()),
      GoRoute(path: car, builder: (context, state) => const Car()),
      GoRoute(path: newHouse, builder: (context, state) => const NewHouse()),
      GoRoute(path: savings, builder: (context, state) => const Savings()),
      GoRoute(
        path: addSavings,
        builder: (context, state) => const AddSavings(),
      ),
      GoRoute(
        path: analysisScreen,
        builder: (context, state) => const AnalysisScreen(),
      ),
      GoRoute(
        path: quickAnalysisScreen,
        builder: (context, state) => const QuickAnalysisScreen(),
      ),
      GoRoute(
        path: settingsScreen,
        builder: (context, state) => const SettingsScreen(),
      ),
      GoRoute(
        path: notificationSettingsScreen,
        builder: (context, state) => NotificationSettingsScreen(),
      ),
      GoRoute(
        path: deleteAccountScreen,
        builder: (context, state) => const DeleteAccountScreen(),
      ),
      GoRoute(
        path: notificationScreen,
        builder: (context, state) => const NotificationScreen(),
      ),
      GoRoute(
        path: profileScreen,
        builder: (context, state) => const ProfileScreen(),
      ),
      GoRoute(
        path: editProfileScreen,
        builder: (context, state) => const EditProfileScreen(),
      ),
      GoRoute(
        path: searchScreen,
        builder: (context, state) => const SearchScreen(),
      ),
    ],
  );
}
