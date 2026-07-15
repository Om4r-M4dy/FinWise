import 'package:finwise/core/constants/app_colors.dart';
import 'package:finwise/core/constants/app_fonts.dart';
import 'package:flutter/material.dart';

/// A full-screen loading overlay that blocks user interaction
/// while an async operation is in progress.
///
/// Usage: Wrap your page content in a [Stack] and place this widget
/// on top, controlled by a boolean [isLoading] flag.
///
/// Example:
/// ```dart
/// Stack(
///   children: [
///     // your page content
///     MyPageContent(),
///     // overlay
///     LoadingOverlay(isLoading: _isLoading),
///   ],
/// )
/// ```
class LoadingOverlay extends StatelessWidget {
  final bool isLoading;
  final String? message;

  const LoadingOverlay({super.key, required this.isLoading, this.message});

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: !isLoading,
      child: AnimatedOpacity(
        opacity: isLoading ? 1.0 : 0.0,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
        child: Container(
          color: Colors.black.withOpacity(0.45),
          child: Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 28),
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.mainGreen.withOpacity(0.25),
                    blurRadius: 24,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Animated spinner with app branding color
                  SizedBox(
                    width: 48,
                    height: 48,
                    child: CircularProgressIndicator(
                      strokeWidth: 4,
                      valueColor: const AlwaysStoppedAnimation<Color>(
                        AppColors.mainGreen,
                      ),
                      backgroundColor: AppColors.mainGreen.withOpacity(0.15),
                    ),
                  ),
                  if (message != null) ...[
                    const SizedBox(height: 18),
                    Text(
                      message!,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        fontFamily: AppFonts.poppins,
                        color: AppColors.lettersAndIcons,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
