import 'package:finwise/features/splash/splash_screen.dart';
import 'package:go_router/go_router.dart';

class Routes {
  // route names
  static const String splash = '/';

  // config
  static final routes = GoRouter(
    routes: [
      GoRoute(path: splash, builder: (context, state) => const SplashScreen()),
    ],
  );
}
