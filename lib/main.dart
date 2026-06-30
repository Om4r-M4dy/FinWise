import 'dart:io';
import 'package:device_preview/device_preview.dart';
import 'package:finwise/core/routes/routes.dart';
import 'package:finwise/core/styles/themes.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(DevicePreview(
    // enabled: false
    enabled: !kReleaseMode,
    builder: (context) => const MainApp()));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: Routes.routes,
      debugShowCheckedModeBanner: false,
      theme: AppThemes.lightTheme,
      builder: (context, child) {
        return SafeArea(
          top: false,
          bottom: Platform.isAndroid,
          child: child ?? const SizedBox.shrink(),
        );
      },
    );
  }
}
