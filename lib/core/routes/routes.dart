import 'package:finwise/features/Security/pages/terms_and_conditions.dart';
import 'package:finwise/features/launch/launch_screen.dart';
import 'package:go_router/go_router.dart';

class Routes {
  // route names
  static const String launch = '/';
  static const String termsAndConditions = '/terms_and_conditions';

  // config
  static final routes = GoRouter(
    routes: [
      GoRoute(path: launch, builder: (context, state) => const LaunchScreen()),
      GoRoute(path: termsAndConditions, builder: (context, state) => const TermsAndConditions()),
    ],
  );
}