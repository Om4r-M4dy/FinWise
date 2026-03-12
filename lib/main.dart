import 'dart:io';
import 'package:finwise/core/constants/app_assets.dart';
import 'package:finwise/core/functions/navigations.dart';
import 'package:finwise/core/styles/text_styles.dart';
import 'package:finwise/core/styles/themes.dart';
import 'package:finwise/features/Appbar/default_appbar.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppThemes.lightTheme,
      builder: (context, child) {
        return SafeArea(
          top: false,
          bottom: Platform.isAndroid,
          child: child ?? const SizedBox.shrink(),
        );
      },
      home: Scaffold(
        appBar: DefaultAppbar(title: "Title"),

        body: Center(child: Text('Hello World!')),
      ),
    );
  }
}
