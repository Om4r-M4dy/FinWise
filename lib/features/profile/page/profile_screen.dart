import 'dart:io';

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
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  static const double profileImageRadius = 117 / 2;
  static const String id = '25030024';

  String _userName = '';
  String? _profileImagePath;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _userName = prefs.getString('user_name') ?? 'User';
      _profileImagePath = prefs.getString('profile_image_path');
    });
  }

  // ── Pick Image ────────────────────────────────────────────────────────
  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: source,
        maxWidth: 512,
        maxHeight: 512,
        imageQuality: 80,
      );

      if (pickedFile != null) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('profile_image_path', pickedFile.path);
        if (mounted) {
          setState(() {
            _profileImagePath = pickedFile.path;
          });
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Could not pick image: $e')));
      }
    }
  }

  // ── Show Bottom Sheet ─────────────────────────────────────────────────
  void _showImagePickerSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.background,
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
                    color: AppColors.lettersAndIcons.withOpacity(0.3),
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
                      color: AppColors.mainGreen.withOpacity(0.1),
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
                      color: AppColors.lettersAndIcons.withOpacity(0.6),
                      fontSize: 12,
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    _pickImage(ImageSource.camera);
                  },
                ),
                ListTile(
                  leading: Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: AppColors.mainGreen.withOpacity(0.1),
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
                      color: AppColors.lettersAndIcons.withOpacity(0.6),
                      fontSize: 12,
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    _pickImage(ImageSource.gallery);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // ── Profile Image Widget ──────────────────────────────────────────────
  ImageProvider _getProfileImage() {
    if (_profileImagePath != null && File(_profileImagePath!).existsSync()) {
      return FileImage(File(_profileImagePath!));
    }
    return AssetImage(AppAssets.profileImage);
  }

  @override
  Widget build(BuildContext context) {
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
            child: Stack(
              children: [
                CircleAvatar(
                  radius: profileImageRadius,
                  backgroundImage: _getProfileImage(),
                ),
                Positioned(
                  bottom: 4,
                  right: 4,
                  child: GestureDetector(
                    onTap: _showImagePickerSheet,
                    child: Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: AppColors.mainGreen,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.15),
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
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.only(top: profileImageRadius + 20.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,

                children: [
                  Text(_userName, style: TextStyles.bodyLarge),
                  Text('ID: $id', style: TextStyles.bodySmall),
                  Gap(60),
                  ProfileOption(
                    path: AppAssets.profile,
                    title: 'Edit Profile',
                    onTap: () {
                      pushTo(context, Routes.editProfileScreen);
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
