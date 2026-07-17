import 'dart:io';
import 'package:device_preview/device_preview.dart';
import 'package:finwise/core/routes/app_router.dart';
import 'package:finwise/core/services/local/bloc_observer.dart';
import 'package:finwise/core/services/local/user_prefs.dart';
import 'package:finwise/core/styles/themes.dart';
import 'package:finwise/core/styles/theme_cubit.dart';
import 'package:finwise/features/profile/cubit/user_cubit.dart';
import 'package:finwise/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:finwise/features/notification/cubit/notification_cubit.dart';
import 'package:finwise/core/services/notification/notification_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await NotificationService.init();
  await UserPrefs.init();
  Bloc.observer = MyBlocObserver();
  runApp(
    DevicePreview(
      // enabled: false,
      enabled: !kReleaseMode,
      builder: (context) => const MainApp(),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<UserCubit>(create: (_) => UserCubit()),
        BlocProvider<NotificationCubit>(create: (_) => NotificationCubit()),
        BlocProvider<ThemeCubit>(create: (_) => ThemeCubit()),
      ],
      child: BlocBuilder<ThemeCubit, bool>(
        builder: (context, isDark) {
          return MaterialApp.router(
            routerConfig: AppRouter.routes,
            debugShowCheckedModeBanner: false,
            theme: isDark ? AppThemes.darkTheme : AppThemes.lightTheme,
            builder: (context, child) {
              return SafeArea(
                top: false,
                bottom: Platform.isAndroid,
                child: child ?? const SizedBox.shrink(),
              );
            },
          );
        },
      ),
    );
  }
}
