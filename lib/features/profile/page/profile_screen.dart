import 'package:finwise/core/constants/app_assets.dart';
import 'package:finwise/core/constants/app_colors.dart';
import 'package:finwise/core/functions/context_extensions.dart';
import 'package:finwise/core/functions/navigations.dart';
import 'package:finwise/core/routes/routes.dart';
import 'package:finwise/core/styles/text_styles.dart';
import 'package:finwise/core/widgets/custom_svg_picture.dart';
import 'package:finwise/core/widgets/my_body_view.dart';
import 'package:finwise/features/profile/widget/profile_option.dart';
import 'package:finwise/core/widgets/row_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});
  static const double profileImageRadius = 117 / 2;
  static const String name = 'John Smith';
  static const String id = '25030024';

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
            child: CircleAvatar(
              radius: profileImageRadius,
              backgroundImage: AssetImage(AppAssets.profileImage),
            ),
          ),

          Padding(
            padding: const EdgeInsets.only(top: profileImageRadius + 20.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,

                children: [
                  Text(name, style: TextStyles.bodyLarge),
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
                      // pushTo(context, Routes.security);
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
                  ProfileOption(path: AppAssets.legout, title: 'Logout'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
