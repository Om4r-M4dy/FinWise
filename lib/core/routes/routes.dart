import 'package:finwise/features/Security/pages/terms_and_conditions.dart';
import 'package:finwise/features/help/pages/help_center.dart';
import 'package:finwise/features/launch/launch_screen.dart';
import 'package:finwise/features/on_boarding/page/on_boarding.dart';
import 'package:go_router/go_router.dart';

class Routes {
  // route names
  static const String launch = '/';
  static const String onBoarding = '/on_boarding';
  static const String termsAndConditions = '/terms_and_conditions';
  static const String helpCenter = '/help_center';

  // config
  static final routes = GoRouter(
    routes: [
      GoRoute(path: launch, builder: (context, state) => const LaunchScreen()),
      GoRoute(path: onBoarding, builder: (context, state) => const OnBoardingScreen()),
      GoRoute(path: termsAndConditions, builder: (context, state) => const TermsAndConditions()),
      GoRoute(path: helpCenter, builder: (context, state) => const HelpCenter()),
    ],
  );
}