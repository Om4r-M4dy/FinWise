import 'package:finwise/core/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// A reusable custom widget for rendering SVG images from assets.
///
/// This widget acts as a wrapper around [SvgPicture.asset] to standardize
/// SVG rendering across the application. It safely handles color tinting
/// using [ColorFilter.mode] with [BlendMode.srcIn], ensuring compatibility
/// and avoiding deprecated properties.
///
/// Example usage:
/// ```dart
/// CustomSvgPicture(
///   path: 'assets/icons/food.svg',
///   color: Colors.blue,
///   width: 24.0,
///   height: 24.0,
/// )
/// ```
class CustomSvgPicture extends StatelessWidget {
  /// Creates a [CustomSvgPicture].
  ///
  /// The [path] parameter is required and must point to a valid SVG asset
  /// defined in the `pubspec.yaml` file.
  const CustomSvgPicture({
    super.key,
    this.color,
    required this.path,
    this.width,
    this.height,
    this.autoTint = true,
  });

  /// The relative path to the SVG asset (e.g., 'assets/icons/food.svg').
  final String path;

  /// An optional color to tint the SVG image.
  ///
  /// If provided, it applies a [BlendMode.srcIn] color filter, completely
  /// replacing the original colors of the SVG with this specified color.
  final Color? color;

  /// The custom width of the SVG image. If null, it uses the SVG's width.
  final double? width;

  /// The custom height of the SVG image. If null, it uses the SVG's height.
  final double? height;

  /// Whether to automatically tint the SVG in dark mode if no [color] is specified.
  ///
  /// Avoids tinting multi-color brand logos and illustrations by default.
  final bool autoTint;

  bool get _shouldAutoTint {
    if (!autoTint) return false;
    final lowerPath = path.toLowerCase();
    if (lowerPath.contains('logo') ||
        lowerPath.contains('google') ||
        lowerPath.contains('facebook') ||
        lowerPath.contains('instagram') ||
        lowerPath.contains('whatsapp') ||
        lowerPath.contains('website') ||
        lowerPath.contains('calender') ||
        lowerPath.contains('analysis') ||
        lowerPath.contains('search') ||
        lowerPath.contains('bot_') ||
        lowerPath.contains('lottie') ||
        lowerPath.contains('banner') ||
        lowerPath.contains('illustration')) {
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final resolvedColor =
        color ??
        (isDark && _shouldAutoTint
            ? path.toLowerCase().contains('income')
                  ? AppColors.mainGreen
                  : Theme.of(context).colorScheme.onSurface
            : null);

    return SvgPicture.asset(
      path,
      width: width,
      height: height,
      colorFilter: resolvedColor != null
          ? ColorFilter.mode(resolvedColor, BlendMode.srcIn)
          : null,
    );
  }
}
