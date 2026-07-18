import 'dart:io';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:image_picker/image_picker.dart';
import 'package:finwise/core/constants/app_assets.dart';
import 'package:finwise/core/constants/app_colors.dart';
import 'package:finwise/core/styles/text_styles.dart';

class ProfileAvatarPicker extends StatelessWidget {
  final String? profileImagePath;
  final double radius;
  final VoidCallback onTap;

  const ProfileAvatarPicker({
    super.key,
    required this.profileImagePath,
    required this.radius,
    required this.onTap,
  });

  ImageProvider _getProfileImage() {
    if (profileImagePath != null && profileImagePath!.isNotEmpty) {
      if (File(profileImagePath!).existsSync()) {
        return FileImage(File(profileImagePath!));
      } else if (profileImagePath!.startsWith('http') ||
          profileImagePath!.startsWith('https')) {
        return NetworkImage(profileImagePath!);
      }
    }
    return const AssetImage(AppAssets.defaultProfile);
  }

  static void showImagePickerSheet({
    required BuildContext context,
    required Function(ImageSource) onPick,
  }) {
    final theme = Theme.of(context);
    showModalBottomSheet(
      context: context,
      backgroundColor: theme.colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const Gap(16),
                Text(
                  'Change Profile Photo',
                  style: TextStyles.bodyLarge.copyWith(fontSize: 18),
                ),
                const Gap(20),
                ListTile(
                  leading: Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: AppColors.mainGreen.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.camera_alt_rounded,
                      color: AppColors.mainGreen,
                    ),
                  ),
                  title: const Text(
                    'Camera',
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                  subtitle: Text(
                    'Take a new photo',
                    style: TextStyle(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                      fontSize: 12,
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    onPick(ImageSource.camera);
                  },
                ),
                ListTile(
                  leading: Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: AppColors.mainGreen.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.photo_library_rounded,
                      color: AppColors.mainGreen,
                    ),
                  ),
                  title: const Text(
                    'Gallery',
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                  subtitle: Text(
                    'Choose from gallery',
                    style: TextStyle(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                      fontSize: 12,
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    onPick(ImageSource.gallery);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        alignment: Alignment.bottomRight,
        children: [
          CircleAvatar(
            radius: radius,
            backgroundImage: _getProfileImage(),
          ),
          Positioned(
            bottom: 4,
            right: 4,
            child: Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: AppColors.mainGreen,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.15),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: const Icon(
                Icons.edit,
                color: Colors.white,
                size: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
