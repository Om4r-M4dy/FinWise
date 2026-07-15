import 'dart:io';
import 'package:device_preview/device_preview.dart';
import 'package:finwise/core/routes/app_router.dart';
import 'package:finwise/core/services/local/bloc_observer.dart';
import 'package:finwise/core/services/local/user_prefs.dart';
import 'package:finwise/core/styles/themes.dart';
import 'package:finwise/features/auth/persentation/cubit/auth_cubit.dart';
import 'package:finwise/features/profile/cubit/user_cubit.dart';
import 'package:finwise/features/profile/cubit/user_cubit.dart';
import 'package:finwise/features/Transaction/presentation/cubit/transaction_cubit.dart';
import 'package:finwise/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
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
        // 1. هنا نقوم بتعريف الـ UserCubit كما كان سابقاً
        BlocProvider<UserCubit>(
          create: (_) => UserCubit(),
        ),
        // 2. هنا نضيف الـ AuthCubit الذي تحتاجه شاشة LaunchScreen
        BlocProvider<AuthCubit>(
          create: (_) => AuthCubit(), // تأكد من عمل import لـ AuthCubit في أعلى الملف
        ),
        // يمكنك أيضاً إضافة الـ TransactionCubit هنا إذا كنت تحتاجه بشكل عام في التطبيق
        /*
        BlocProvider<TransactionCubit>(
          create: (_) => TransactionCubit(),
        ),
        */
      ],
      child: MaterialApp.router(
        routerConfig: AppRouter.routes,
        debugShowCheckedModeBanner: false,
        theme: AppThemes.lightTheme,
        builder: (context, child) {
          return SafeArea(
            top: false,
            bottom: Platform.isAndroid,
            child: child ?? const SizedBox.shrink(),
          );
        },
      ),
    );
  }
}
