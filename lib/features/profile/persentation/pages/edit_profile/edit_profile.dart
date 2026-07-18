import 'dart:io';

import 'package:finwise/core/constants/app_colors.dart';
import 'package:finwise/core/extentions/context_extensions.dart';
import 'package:finwise/core/styles/text_styles.dart';
import 'package:finwise/core/widgets/custom_text_form_field.dart';
import 'package:finwise/core/widgets/buttons/main_button.dart';
import 'package:finwise/core/widgets/my_body_view.dart';
import 'package:finwise/core/widgets/row_app_bar.dart';
import 'package:finwise/core/widgets/dialogs/loading_dialog.dart';
import 'package:finwise/core/widgets/dialogs/custom_snackbar.dart';
import 'package:finwise/core/services/local/user_prefs.dart';
import 'package:finwise/features/profile/persentation/cubit/user_cubit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:finwise/core/services/firebase/firestore_provider.dart';
import 'package:finwise/features/profile/data/models/user_model.dart';
import 'package:finwise/features/profile/persentation/pages/edit_profile/widgets/profile_avatar_picker.dart';
import 'package:finwise/core/extentions/image_uploader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

class EditProfileScreen extends StatefulWidget {
  static const double profileImageRadius = 117 / 2;

  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  // State variables for notification and theme switches
  bool isActiveNotification = true;
  bool isActiveDarkThem = false;

  // Image Picker and picked profile image path
  final ImagePicker _picker = ImagePicker();
  String? _profileImagePath;

  // Text editing controllers for the profile form fields
  late final TextEditingController _usernameController;
  late final TextEditingController _phoneController;
  late final TextEditingController _emailController;

  // Reference to the current user model in UserCubit
  UserModel? _currentUser;

  @override
  void initState() {
    super.initState();
    // Retrieve the user from global state
    _currentUser = context.read<UserCubit>().user;

    // Initialize controllers with current user values (or fallbacks)
    _usernameController = TextEditingController(
      text: _currentUser?.username ?? UserPrefs.getName() ?? '',
    );
    _phoneController = TextEditingController(
      text: _currentUser?.phone ?? UserPrefs.getPhone() ?? '',
    );
    _emailController = TextEditingController(text: _currentUser?.email ?? '');

    // Initialize switches from settings map
    isActiveNotification = _currentUser?.settings?['pushNotifications'] ?? true;
    isActiveDarkThem = _currentUser?.settings?['darkTheme'] ?? false;

    // Initialize profile image path from cached UserPrefs or Firestore
    _profileImagePath =
        UserPrefs.getProfileImagePath() ?? _currentUser?.profilePicture;
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  // ── Pick Image from Gallery/Camera ─────────────────────────────────────
  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: source,
        maxWidth: 512,
        maxHeight: 512,
        imageQuality: 80,
      );

      if (!mounted) return;
      if (pickedFile != null) {
        setState(() {
          _profileImagePath = pickedFile.path;
        });
      }
    } catch (e) {
      if (!mounted) return;
      CustomSnackBar.showError(context, 'Could not pick image: $e');
    }
  }

  // ── Update Profile Logic ───────────────────────────────────────────────
  Future<void> _updateProfile() async {
    final name = _usernameController.text.trim();
    final phone = _phoneController.text.trim();

    // Validation checks
    if (name.isEmpty) {
      CustomSnackBar.showError(context, "Username cannot be empty");
      return;
    }
    if (phone.isEmpty) {
      CustomSnackBar.showError(context, "Phone number cannot be empty");
      return;
    }

    final user = FirebaseAuth.instance.currentUser;
    if (user == null || _currentUser == null) {
      CustomSnackBar.showError(
        context,
        "User session not found. Please log in again.",
      );
      return;
    }

    // Show loading overlay during async update process
    LoadingDialog.show(context);

    try {
      // 1. Upload new image to Cloudinary if it's a local file path
      String? finalProfilePictureUrl = _currentUser!.profilePicture;
      if (_profileImagePath != null &&
          _profileImagePath!.isNotEmpty &&
          !(_profileImagePath!.startsWith('http') ||
              _profileImagePath!.startsWith('https'))) {
        final uploadedUrl = await uploadImageToCloudinary(
          File(_profileImagePath!),
        );
        if (uploadedUrl == null || uploadedUrl.isEmpty) {
          if (!mounted) return;
          LoadingDialog.hide(context);
          CustomSnackBar.showError(
            context,
            "Failed to upload profile picture to Cloudinary.",
          );
          return;
        }
        finalProfilePictureUrl = uploadedUrl;
      } else {
        finalProfilePictureUrl = _profileImagePath;
      }

      // 2. Update Firebase Auth Display Name
      await user.updateDisplayName(name);

      // 3. Build the updated UserModel retaining existing financials but updating settings, name, phone, and image
      final updatedModel = UserModel(
        uid: _currentUser!.uid,
        username: name,
        email: _currentUser!.email,
        phone: phone,
        profilePicture: finalProfilePictureUrl,
        totalBalance: _currentUser!.totalBalance,
        totalExpense: _currentUser!.totalExpense,
        totalIncome: _currentUser!.totalIncome,
        dob: _currentUser!.dob,
        monthlyBudgetLimit: _currentUser!.monthlyBudgetLimit,
        settings: {
          'pushNotifications': isActiveNotification,
          'darkTheme': isActiveDarkThem,
        },
      );

      // 4. Persist details to Firestore and update the global UserCubit state
      await FirestoreProvider.editUser(updatedModel);

      if (!mounted) return;
      final userCubit = context.read<UserCubit>();

      // 5. Update the local UserPrefs cache
      await UserPrefs.setName(name);
      await UserPrefs.setPhone(phone);
      if (finalProfilePictureUrl != null) {
        await UserPrefs.setProfileImagePath(finalProfilePictureUrl);
      }

      // Hide loading dialog and notify user of success before going back
      if (!mounted) return;
      LoadingDialog.hide(context);
      CustomSnackBar.showSuccess(context, "Profile updated successfully!");

      // Update cubit and pop screen after a micro-delay to prevent Navigator lock
      Future.delayed(const Duration(milliseconds: 50), () {
        if (mounted) {
          Navigator.pop(context);
        }
        userCubit.setUser(updatedModel);
      });
    } catch (e) {
      if (!mounted) return;
      LoadingDialog.hide(context);
      CustomSnackBar.showError(context, "Failed to update profile: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    // Determine the ID to display
    final String displayId = _currentUser?.uid ?? 'N/A';
    final String displayName = _usernameController.text.isNotEmpty
        ? _usernameController.text
        : (_currentUser?.username ?? 'User');

    return Scaffold(
      body: MyBodyView(
        clipBehavior: Clip.none,
        topSection: SafeArea(
          bottom: false,
          child: SizedBox(
            width: double.infinity,
            height: context.screenHeight * 0.12,
            child: RowAppBar(title: 'Edit my Profile'),
          ),
        ),
        noPadding: true,
        bottomSection: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.topCenter,
          children: [
            Positioned.fill(
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(70.0),
                ),
                child: SingleChildScrollView(
                  padding: EdgeInsets.only(
                    left: 37.0,
                    right: 37.0,
                    top: EditProfileScreen.profileImageRadius + 12.0,
                    bottom: 20.0,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [
                      Align(
                        alignment: Alignment.center,
                        child: Text(displayName, style: TextStyles.bodyLarge),
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: Text(
                          'ID: ${displayId.length > 8 ? displayId.substring(0, 8) : displayId}',
                          style: TextStyles.bodySmall,
                        ),
                      ),
                      const Gap(20),

                      Text('Account Settings', style: TextStyles.bodyLarge),
                      const Gap(20),
                      Text('Username', style: TextStyles.bodyMedium),
                      const Gap(13),
                      CustomTextFormField(
                        controller: _usernameController,
                        hintText: 'Username',
                      ),
                      const Gap(17),
                      Text('phone', style: TextStyles.bodyMedium),
                      const Gap(13),
                      CustomTextFormField(
                        controller: _phoneController,
                        hintText: 'Phone number',
                        keyboardType: TextInputType.phone,
                      ),
                      const Gap(17),
                      Text('email address', style: TextStyles.bodyMedium),
                      const Gap(13),
                      CustomTextFormField(
                        controller: _emailController,
                        hintText: 'Email address',
                        readOnly: true,
                      ),
                      const Gap(40),

                      _rowCustomSwitch('push notifications'),
                      const Gap(37),
                      Center(
                        child: MainButton(
                          text: 'Update Profile',
                          onPress: _updateProfile,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              top: -EditProfileScreen.profileImageRadius - 15,
              child: ProfileAvatarPicker(
                profileImagePath: _profileImagePath,
                radius: EditProfileScreen.profileImageRadius,
                onTap: () {
                  ProfileAvatarPicker.showImagePickerSheet(
                    context: context,
                    onPick: _pickImage,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Row _rowCustomSwitch(String title) {
    return Row(
      children: [
        Text(title, style: TextStyles.bodyMedium),
        const Spacer(),
        Switch(
          value: isActiveNotification,
          onChanged: (value) {
            setState(() {
              isActiveNotification = value;
            });
          },

          thumbColor: const WidgetStatePropertyAll(Colors.white),

          trackOutlineColor: const WidgetStatePropertyAll(Colors.transparent),

          trackColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return AppColors.mainGreen;
            }
            return AppColors.mainGreen.withValues(alpha: 0.4);
          }),
        ),
      ],
    );
  }
}
