import 'dart:io';
import 'package:go_router/go_router.dart';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:finwise/core/constants/app_assets.dart';
import 'package:finwise/core/constants/app_colors.dart';
import 'package:finwise/core/extentions/context_extensions.dart';
import 'package:finwise/core/functions/navigations.dart';
import 'package:finwise/core/routes/routes.dart';
import 'package:finwise/core/styles/text_styles.dart';
import 'package:finwise/core/widgets/custom_svg_picture.dart';
import 'package:finwise/core/widgets/my_body_view.dart';
import 'package:finwise/features/profile/widget/profile_option.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:finwise/core/styles/theme_cubit.dart';
import 'package:finwise/features/profile/cubit/user_cubit.dart';
import 'package:finwise/core/services/local/user_prefs.dart';
import 'package:gap/gap.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  static const double profileImageRadius = 117 / 2;

  String _userName = '';
  String? _profileImagePath;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  // Loads cached profile values from local SharedPreferences synchronously.
  void _loadUserData() {
    setState(() {
      _userName = UserPrefs.getName() ?? 'User';
      _profileImagePath = UserPrefs.getProfileImagePath();
    });
  }

  // ── Profile Image Widget ──────────────────────────────────────────────
  // Resolves the image source dynamically. Supports local files, network URLs,
  // and falls back to a default asset image.
  ImageProvider _getProfileImage(String? imagePath) {
    if (imagePath != null && imagePath.isNotEmpty) {
      if (File(imagePath).existsSync()) {
        return FileImage(File(imagePath));
      } else if (imagePath.startsWith('http') ||
          imagePath.startsWith('https')) {
        return CachedNetworkImageProvider(imagePath);
      }
    }
    return const AssetImage(AppAssets.defaultProfile);
    // return const AssetImage(AppAssets.profileImage);
  }

  Future<void> _showLogoutConfirmationDialog() async {
    final bool? confirm = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: AppColors.background,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          title: Text(
            'Logout',
            style: TextStyles.bodyLarge.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.lettersAndIcons,
            ),
          ),
          content: Text(
            'Are you sure you want to log out of FinWise?',
            style: TextStyles.bodyMedium.copyWith(
              color: AppColors.lettersAndIcons.withValues(alpha: 0.8),
            ),
          ),
          actionsPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 16,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(
                'Cancel',
                style: TextStyles.bodyMedium.copyWith(
                  color: AppColors.lettersAndIcons.withValues(alpha: 0.6),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
              ),
              onPressed: () => Navigator.of(context).pop(true),
              child: Text(
                'Logout',
                style: TextStyles.bodyMedium.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );

    if (confirm == true && mounted) {
      try {
        await FirebaseAuth.instance.signOut();
      } catch (_) {
        // Proceed with local logout even if network signOut throws an error
      }
      await UserPrefs.clearAuthData();
      if (mounted) {
        context.read<UserCubit>().clearUser();
        removeUntil(context, Routes.loginScreen);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Watch UserCubit so the widget rebuilds when user profile data is updated
    final user = context.watch<UserCubit>().user;
    final displayName = user?.username ?? _userName;
    final displayImage =
        (user?.profilePicture != null && user!.profilePicture!.isNotEmpty)
        ? user.profilePicture
        : _profileImagePath;
    final displayEmail = user?.email ?? '';
    final theme = Theme.of(context);

    return MyBodyView(
      clipBehavior: Clip.none,
      topSection: SafeArea(
        bottom: false,
        child: SizedBox(
          width: double.infinity,
          height: context.screenHeight * 0.13,
          child: AppBar(
            backgroundColor: theme.appBarTheme.backgroundColor,
            leading: const SizedBox.shrink(),
            title: Text(
              "Profile",
              style: TextStyles.bodyLarge.copyWith(
                color: theme.colorScheme.onSurface,
              ),
            ),
            actions: [
              IconButton(
                onPressed: () {
                  final themeCubit = context.read<ThemeCubit>();
                  final userCubit = context.read<UserCubit>();
                  themeCubit.toggleTheme();
                  if (userCubit.user != null) {
                    userCubit.updateSettings(darkTheme: themeCubit.state);
                  }
                },
                icon: Container(
                  width: 30,
                  height: 30,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primaryContainer,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    context.watch<ThemeCubit>().state
                        ? Icons.light_mode_rounded
                        : Icons.dark_mode_rounded,
                    size: 18,
                    color: theme.colorScheme.onPrimaryContainer,
                  ),
                ),
              ),
              IconButton(
                onPressed: () {
                  pushTo(context, Routes.notificationScreen);
                },
                icon: Container(
                  width: 30,
                  height: 30,
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primaryContainer,
                    shape: BoxShape.circle,
                  ),
                  child: CustomSvgPicture(
                    path: AppAssets.notification,
                    color: theme.colorScheme.onPrimaryContainer,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      noPadding: true,
      bottomSection: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.topCenter,
        children: [
          Positioned.fill(
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(70.0)),
              child: SingleChildScrollView(
                padding: const EdgeInsets.only(
                  left: 37.0,
                  right: 37.0,
                  top: profileImageRadius + 12.0,
                  bottom: 110.0,
                ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,

                children: [
                  Text(displayName, style: TextStyles.bodyLarge),
                  Text(displayEmail, style: TextStyles.bodySmall),
                  Gap(25),
                  ProfileOption(
                    path: AppAssets.profile,
                    title: 'Edit Profile',
                    onTap: () async {
                      // Use GoRouter context.push directly to safely await the result
                      await context.push(Routes.editProfileScreen);
                      _loadUserData();
                    },
                  ),
                  Gap(34),
                  ProfileOption(
                    path: AppAssets.dollar,
                    title: 'Edit Financial Info',
                    onTap: () async {
                      await context.push(Routes.editFinancialInfoScreen);
                      _loadUserData();
                    },
                  ),
                  Gap(34),
                  ProfileOption(
                    path: AppAssets.transactions,
                    title: 'Transactions',
                    onTap: () {
                      pushTo(context, Routes.transactionScreen);
                    },
                  ),
                  Gap(34),
                  ProfileOption(
                    path: AppAssets.analysis,
                    title: 'Quick Analysis',
                    onTap: () {
                      pushTo(context, Routes.quickAnalysisScreen);
                    },
                  ),
                  Gap(34),
                  ProfileOption(
                    path: AppAssets.setting,
                    title: 'Setting',
                    onTap: () {
                      pushTo(context, Routes.settingsScreen);
                    },
                  ),
                  Gap(34),
                  ProfileOption(
                    path: AppAssets.help,
                    title: 'Help',
                    onTap: () {
                      pushTo(context, Routes.helpCenter);
                    },
                  ),
                  Gap(34),
                  ProfileOption(
                    path: AppAssets.legout,
                    title: 'Logout',
                    onTap: _showLogoutConfirmationDialog,
                  ),
                ],
              ),
            ),
          ),
        ),
          Positioned(
            top: -profileImageRadius - 15,
            child: CircleAvatar(
              radius: profileImageRadius,
              backgroundImage: _getProfileImage(displayImage),
            ),
          ),
        ],
      ),
    );
  }
}
