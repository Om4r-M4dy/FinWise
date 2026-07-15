import 'dart:io';
import 'package:go_router/go_router.dart';

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
        return NetworkImage(imagePath);
      }
    }
    return const AssetImage(AppAssets.profileImage);
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

    return MyBodyView(
      topSection: SafeArea(
        bottom: false,
        child: SizedBox(
          width: double.infinity,
          height: context.screenHeight * 0.13,
          child: AppBar(
            backgroundColor: AppColors.mainGreen,
            leading: SizedBox.shrink(),
            title: Text("Profile", style: TextStyles.bodyLarge),
            actions: [
              IconButton(
                onPressed: () {
                  pushTo(context, Routes.notificationScreen);
                },
                icon: CustomSvgPicture(path: AppAssets.appBarNotification),
              ),
            ],
          ),
        ),
      ),
      bottomSection: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.topCenter,
        children: [
          Positioned(
            top: -profileImageRadius - 15,
            child: CircleAvatar(
              radius: profileImageRadius,
              backgroundImage: _getProfileImage(displayImage),
            ),
          ),

          Padding(
            padding: const EdgeInsets.only(top: profileImageRadius + 20.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,

                children: [
                  Text(displayName, style: TextStyles.bodyLarge),
                  Text(displayEmail, style: TextStyles.bodySmall),
                  Gap(60),
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
                    path: AppAssets.transactions,
                    title: 'Transactions',
                    onTap: () {
                      pushTo(context, Routes.transactionScreen);
                    },
                  ),
                  Gap(34),
                  ProfileOption(
                    path: AppAssets.security,
                    title: 'Security',
                    onTap: () {
                      pushTo(context, Routes.securityScreen);
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
                    onTap: () async {
                      await FirebaseAuth.instance.signOut();
                      await UserPrefs.clearAuthData();
                      if (context.mounted) {
                        context.read<UserCubit>().clearUser();
                        removeUntil(context, Routes.loginScreen);
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
