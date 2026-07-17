import 'package:finwise/features/Calendar/page/calendar_screen.dart';
import 'package:finwise/features/Home/persentation/pages/home_screen.dart';
import 'package:finwise/features/Home/persentation/pages/nav_bar.dart';
import 'package:finwise/features/Security/change_pin_screen.dart';
import 'package:finwise/features/Security/fingerprint_screen.dart';
import 'package:finwise/features/Security/fingerprint_details_screen.dart';
import 'package:finwise/features/Security/add_fingerprint_screen.dart';
import 'package:finwise/features/Security/loading_change_finger_screen.dart';
import 'package:finwise/features/Security/loading_deleted_fingerprint_screen.dart';
import 'package:finwise/features/Security/loading_change_pin_screen.dart';
import 'package:finwise/features/Security/security_screen.dart';
import 'package:finwise/features/Security/terms_and_conditions.dart';
import 'package:finwise/features/Transaction/presentation/pages/transaction_screen.dart';
import 'package:finwise/features/analysis/pages/analysis_screen.dart';
import 'package:finwise/features/auth/persentation/pages/reset_password/conf_new_password_screen.dart';
import 'package:finwise/features/auth/persentation/pages/reset_password/forgot_password.dart';
import 'package:finwise/features/auth/persentation/pages/login_register/login_screen.dart';
import 'package:finwise/features/auth/persentation/pages/reset_password/new_password_screen.dart';
import 'package:finwise/features/auth/persentation/pages/security_verify/security_pin_screen.dart';
import 'package:finwise/features/auth/persentation/pages/security_verify/security_fingerprint_screen.dart';
import 'package:finwise/features/auth/persentation/pages/login_register/signup_screen.dart';
import 'package:finwise/features/auth/persentation/pages/security_verify/verify_screen.dart';
import 'package:finwise/features/categories/pages/transactions_by_category_screen.dart';
import 'package:finwise/features/Transaction/data/model/transaction_model.dart';
import 'package:finwise/features/profile/persentation/pages/edit_profile/edit_financial_info.dart';
import 'package:finwise/features/profile/persentation/pages/edit_profile/edit_profile.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:finwise/features/auth/persentation/cubit/auth_cubit.dart';
import 'package:finwise/features/Transaction/presentation/cubit/transaction_cubit.dart';
import 'package:finwise/features/saving_goals/persentation/cubit/goal_cubit.dart';
import 'package:finwise/features/Transaction/presentation/pages/add_transaction.dart';
import 'package:finwise/features/categories/pages/sub_pages/add_savings.dart';
import 'package:finwise/features/categories/pages/sub_pages/car.dart';
import 'package:finwise/features/categories/pages/sub_pages/entertainment_screen.dart';
import 'package:finwise/features/categories/pages/sub_pages/gifts_screen.dart';
import 'package:finwise/features/categories/pages/sub_pages/groceries_screen.dart';
import 'package:finwise/features/categories/pages/main_categories.dart';
import 'package:finwise/features/categories/pages/sub_pages/medicine_screen.dart';
import 'package:finwise/features/categories/pages/sub_pages/new_house.dart';
import 'package:finwise/features/saving_goals/persentation/page/savings.dart';
import 'package:finwise/features/categories/pages/sub_pages/transport_screen.dart';
import 'package:finwise/features/categories/pages/sub_pages/travel.dart';
import 'package:finwise/features/categories/pages/sub_pages/wedding.dart';
import 'package:finwise/features/help/pages/chat_screen.dart';
import 'package:finwise/features/help/pages/customer_service.dart';
import 'package:finwise/features/help/pages/help_center.dart';
import 'package:finwise/features/launch/auth_screen.dart';
import 'package:finwise/features/launch/launch_screen.dart';
import 'package:finwise/features/notification/persentation/pages/notification_screen.dart';
import 'package:finwise/features/on_boarding/persentation/page/on_boarding.dart';
import 'package:finwise/core/routes/routes.dart';
import 'package:finwise/features/profile/persentation/pages/user_profile/profile_screen.dart';
import 'package:finwise/features/quick_analysis/page/quick_analysis_screen.dart';
import 'package:finwise/features/search/page/search_screen.dart';
import 'package:finwise/features/settings/delete_account/pages/delete_account_screen.dart';
import 'package:finwise/features/settings/notification_settings/pages/notification_settings_screen.dart';
import 'package:finwise/features/settings/page/settings_screen.dart';
import 'package:finwise/core/functions/get_category_id.dart';
import 'package:finwise/core/constants/transaction_type_enum.dart';
import 'package:go_router/go_router.dart';

class AppRouter {
  static final routes = GoRouter(
    routes: [
      GoRoute(
        path: Routes.launch,
        builder: (context, state) => const LaunchScreen(),
      ),
      GoRoute(
        path: Routes.authScreen,
        builder: (context, state) => const AuthScreen(),
      ),
      GoRoute(
        path: Routes.onBoarding,
        builder: (context, state) => const OnBoardingScreen(),
      ),

      // Shell route for all authenticated/authenticated-related screens requiring TransactionCubit and GoalCubit
      ShellRoute(
        builder: (context, state, child) {
          return MultiBlocProvider(
            providers: [
              BlocProvider<TransactionCubit>(
                create: (context) => TransactionCubit(),
              ),
              BlocProvider<GoalCubit>(create: (context) => GoalCubit()),
            ],
            child: child,
          );
        },
        routes: [
          GoRoute(
            path: Routes.categories,
            builder: (context, state) => const MainCategories(),
          ),
          GoRoute(
            path: Routes.helpCenter,
            builder: (context, state) => const HelpCenter(),
          ),
          GoRoute(
            path: Routes.customerService,
            builder: (context, state) => const CustomerService(),
          ),
          GoRoute(
            path: Routes.chatScreen,
            builder: (context, state) => const ChatScreen(),
          ),
          GoRoute(
            path: Routes.addTransactionByCategory,
            builder: (context, state) {
              final extra = state.extra as Map<String, dynamic>;
              final categoryName = extra['categoryName'] as String;
              final goalId = extra['goalId'] as String?;
              return TransactionsByCategoryScreen(
                categoryName: categoryName,
                goalId: goalId,
              );
            },
          ),
          GoRoute(
            path: Routes.addTransaction,
            builder: (context, state) {
              final extra = state.extra as Map<String, dynamic>?;
              final categoryName = extra?['category'] as String?;
              final title = extra?['title'] as String?;
              final amount = extra?['amount'] as double?;
              final note = extra?['note'] as String?;
              final type = extra?['type'] as String?;

              final transactionToEdit =
                  extra?['transactionToEdit'] as TransactionModel?;
              final cubit = context.read<TransactionCubit>();
              if (transactionToEdit != null) {
                cubit.populateControllers(transactionToEdit);
              } else {
                cubit.clearControllers();

                if (categoryName != null) {
                  final categoryId = getCategoryId(categoryName);
                  cubit.setCategory(categoryId);
                }
                if (title != null) {
                  cubit.titleController.text = title;
                }
                if (amount != null) {
                  cubit.amountController.text = amount.toStringAsFixed(2);
                }
                if (note != null) {
                  cubit.noteController.text = note;
                }
                if (type != null) {
                  if (type.toLowerCase() == 'income') {
                    cubit.setType(TransactionTypeEnum.income.value);
                  } else {
                    cubit.setType(TransactionTypeEnum.expense.value);
                  }
                }
              }
              return AddTransaction(transactionToEdit: transactionToEdit);
            },
          ),
          GoRoute(
            path: Routes.transportScreen,
            builder: (context, state) => const TransportScreen(),
          ),
          GoRoute(
            path: Routes.groceriesScreen,
            builder: (context, state) => const GroceriesScreen(),
          ),
          GoRoute(
            path: Routes.giftsScreen,
            builder: (context, state) => const GiftsScreen(),
          ),
          GoRoute(
            path: Routes.entertainmentScreen,
            builder: (context, state) => const EntertainmentScreen(),
          ),
          GoRoute(
            path: Routes.medicineScreen,
            builder: (context, state) => const MedicineScreen(),
          ),
          GoRoute(
            path: Routes.travel,
            builder: (context, state) => const Travel(),
          ),
          GoRoute(
            path: Routes.wedding,
            builder: (context, state) => const Wedding(),
          ),
          GoRoute(path: Routes.car, builder: (context, state) => const Car()),
          GoRoute(
            path: Routes.newHouse,
            builder: (context, state) => const NewHouse(),
          ),
          GoRoute(
            path: Routes.savings,
            builder: (context, state) => const Savings(),
          ),
          GoRoute(
            path: Routes.addSavings,
            builder: (context, state) => const AddSavings(),
          ),
          GoRoute(
            path: Routes.analysisScreen,
            builder: (context, state) => const AnalysisScreen(),
          ),
          GoRoute(
            path: Routes.quickAnalysisScreen,
            builder: (context, state) => const QuickAnalysisScreen(),
          ),
          GoRoute(
            path: Routes.settingsScreen,
            builder: (context, state) => const SettingsScreen(),
          ),
          GoRoute(
            path: Routes.notificationSettingsScreen,
            builder: (context, state) => NotificationSettingsScreen(),
          ),
          GoRoute(
            path: Routes.deleteAccountScreen,
            builder: (context, state) => const DeleteAccountScreen(),
          ),
          GoRoute(
            path: Routes.notificationScreen,
            builder: (context, state) => const NotificationScreen(),
          ),
          GoRoute(
            path: Routes.profileScreen,
            builder: (context, state) => const ProfileScreen(),
          ),
          GoRoute(
            path: Routes.editProfileScreen,
            builder: (context, state) => const EditProfileScreen(),
          ),
          GoRoute(
            path: Routes.editFinancialInfoScreen,
            builder: (context, state) => const EditFinancialInfoScreen(),
          ),
          GoRoute(
            path: Routes.searchScreen,
            builder: (context, state) => const SearchScreen(),
          ),
          GoRoute(
            path: Routes.calendarScreen,
            builder: (context, state) => const CalendarScreen(),
          ),
          GoRoute(
            path: Routes.homeScreen,
            builder: (context, state) => const HomeScreen(),
          ),
          GoRoute(
            path: Routes.bottomNavBar,
            builder: (context, state) {
              return const NavBar();
            },
          ),
          GoRoute(
            path: Routes.transactionScreen,
            builder: (context, state) => TransactionScreen(),
          ),
        ],
      ),

      GoRoute(
        path: Routes.termsAndConditions,
        builder: (context, state) => const TermsAndConditions(),
      ),
      // Security Routes
      GoRoute(
        path: Routes.securitypinScreen,
        builder: (context, state) => SecuritypinScreen(),
      ),
      GoRoute(
        path: Routes.securityFingerprintScreen,
        builder: (context, state) => SecurityFingerprintScreen(),
      ),
      GoRoute(
        path: Routes.signupScreen,
        builder: (context, state) => SignupScreen(),
      ),
      GoRoute(
        path: Routes.loginScreen,
        builder: (context, state) => BlocProvider(
          create: (context) => AuthCubit(),
          child: const LoginScreen(),
        ),
      ),
      GoRoute(
        path: Routes.forgotPasswordScreen,
        builder: (context, state) => ForgotPasswordScreen(),
      ),
      GoRoute(
        path: Routes.verifyScreen,
        builder: (context, state) => const VerifyScreen(),
      ),
      GoRoute(
        path: Routes.passwordChangedScreen,
        builder: (context, state) => PasswordChangedScreen(),
      ),
      GoRoute(
        path: Routes.newPasswordScreen,
        builder: (context, state) => NewPasswordScreen(),
      ),
      // security
      GoRoute(
        path: Routes.securityScreen,
        builder: (context, state) => SecurityScreen(),
      ),
      GoRoute(
        path: Routes.changePinScreen,
        builder: (context, state) => ChangepinScreen(),
      ),
      GoRoute(
        path: Routes.loadingChangePinScreen,
        builder: (context, state) => LoadingchangepinScreen(),
      ),
      GoRoute(
        path: Routes.fingerprintScreen,
        builder: (context, state) => FingerprintScreen(),
      ),
      GoRoute(
        path: Routes.fingerprintDetailsScreen,
        builder: (context, state) => FingerprintDetailsScreen(),
      ),
      GoRoute(
        path: Routes.loadingDeletedFingerprintScreen,
        builder: (context, state) => LoadingDeletedFingerprintScreen(),
      ),
      GoRoute(
        path: Routes.addFingerprintScreen,
        builder: (context, state) => AddFingerprintScreen(),
      ),
      GoRoute(
        path: Routes.loadingChangeFingerScreen,
        builder: (context, state) => LoadingchangefingerScreen(),
      ),
    ],
  );
}
