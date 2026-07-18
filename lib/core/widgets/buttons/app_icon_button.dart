import 'package:finwise/core/constants/app_colors.dart';
import 'package:finwise/core/widgets/custom_svg_picture.dart';
import 'package:flutter/material.dart';

/// A custom interactive icon button utilizing SVG icons.
///
/// This widget is built to organize and unify the appearance of icon buttons across the app.
/// It internally uses [Material] and [InkWell] to ensure visual feedback (a ripple effect)
/// upon tapping, which enhances the User Experience (UX).
///
/// Example usage:
/// ```dart
/// AppIconButton(
///   path: 'assets/icons/food.svg',
///   onTap: () => print('food tapped!'),
/// )
/// ```
class AppIconButton extends StatelessWidget {
  /// Creates an [AppIconButton].
  ///
  /// The [path] parameter is required.
  const AppIconButton({
    super.key,
    required this.path,
    this.iconWidth,
    this.iconHeight,
    this.iconColor,
    this.bgColor = AppColors.lightBlueButton,
    this.bgWidth = 105,
    this.bgHeight = 97,
    this.onTap,
    this.borderRadius = 26,
  });

  /// The path to the SVG file inside the assets folder (e.g., 'assets/icons/home.svg').
  final String path;

  /// The width of the SVG icon. If null, it defaults to the file's original size.
  final double? iconWidth;

  /// The height of the SVG icon. If null, it defaults to the file's original size.
  final double? iconHeight;

  /// The color of the icon. If provided, it overrides the original colors of the SVG.
  final Color? iconColor;

  /// The total width of the button (the clickable area). Defaults to 105.
  final double bgWidth;

  /// The total height of the button (the clickable area). Defaults to 97.
  final double bgHeight;

  /// The background color of the button. Defaults to [AppColors.lightBlueButton].
  final Color bgColor;

  /// The border radius of the button's corners. Defaults to 26.
  final double borderRadius;

  /// The callback that is called when the button is tapped.
  ///
  /// If this is left as `null`, the button will be disabled and will not react to touches.
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: bgColor,
      borderRadius: BorderRadius.circular(borderRadius),
      clipBehavior: Clip.antiAlias,// prevents the ripple from bleeding outside the rounded corners
      child: InkWell(
        onTap: onTap,
        child: SizedBox(
          width: bgWidth,
          height: bgHeight,
          child: Center(
            child: CustomSvgPicture(
              path: path,
              width: iconWidth,
              height: iconHeight,
              color: iconColor,
            ),
          ),
        ),
      ),
    );
  }
}