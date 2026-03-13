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

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      path,
      width: width,
      height: height,
      colorFilter: color != null
          ? ColorFilter.mode(color!, BlendMode.srcIn)
          : null,
    );
  }
}