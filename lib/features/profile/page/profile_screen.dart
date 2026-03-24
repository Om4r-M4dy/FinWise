import 'package:finwise/core/constants/app_assets.dart';
import 'package:finwise/core/functions/context_extensions.dart';
import 'package:finwise/core/functions/navigations.dart';
import 'package:finwise/core/routes/routes.dart';
import 'package:finwise/core/styles/text_styles.dart';
import 'package:finwise/core/widgets/my_body_view.dart';
import 'package:finwise/features/profile/widget/profile_option.dart';
import 'package:finwise/features/profile/widget/row_app_bar.dart';
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
      topSection: SafeArea(bottom: false,
        child: SizedBox(
          width: double.infinity,
          height: context.screenHeight * 0.13,
          child: RowAppBar(title: 'Profile'),
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
                  Text(name, style: TextStyles.title_20),
                  Text('ID: $id', style: TextStyles.caption2_13),
                  Gap(60),
                  ProfileOption(
                    path: AppAssets.profile,
                    title: 'Edit Profile',
                    onTap: () {pushTo(context, Routes.editProfileScreen);},
                  ),
                  Gap(34),
                  ProfileOption(path: AppAssets.security, title: 'Security'),
                  Gap(34),
                  ProfileOption(path: AppAssets.setting, title: 'Setting'),
                  Gap(34),
                  ProfileOption(path: AppAssets.help, title: 'Help'),
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
