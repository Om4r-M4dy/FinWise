import 'package:finwise/core/constants/app_assets.dart';
import 'package:finwise/core/constants/app_colors.dart';
import 'package:finwise/core/functions/context_extensions.dart';
import 'package:finwise/core/styles/text_styles.dart';
import 'package:finwise/core/widgets/app_icon_button.dart';
import 'package:finwise/core/widgets/custom_text_form_field.dart';
import 'package:finwise/core/widgets/main_button.dart';
import 'package:finwise/core/widgets/my_body_view.dart';
import 'package:finwise/features/profile/widget/row_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class EditProfileScreen extends StatefulWidget {
  static const double profileImageRadius = 117 / 2;
  static const String name = 'John Smith';
  static const String id = '25030024';

  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  bool isActiveNotification = true;
  bool isActiveDarkThem = false;

  @override
  Widget build(BuildContext context) {
    return MyBodyView(
      topSection: SafeArea(
        bottom: false,
        child: SizedBox(
          width: double.infinity,
          height: context.screenHeight * 0.12,
          child: RowAppBar(title: 'Edit my Profile'),
        ),
      ),
      bottomSection: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.topCenter,
        children: [
          Positioned(
            top: -EditProfileScreen.profileImageRadius - 15,
            child: Stack(
              alignment: Alignment.bottomRight,
              children: [
                CircleAvatar(
                  radius: EditProfileScreen.profileImageRadius,
                  backgroundImage: AssetImage(AppAssets.profileImage),
                ),
                Positioned(
                  right: 13,
                  child: AppIconButton(
                    path: AppAssets.cam,
                    bgWidth: 25,
                    bgHeight: 25,
                    bgColor: AppColors.mainGreen,
                  ),
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.only(
              top: EditProfileScreen.profileImageRadius + 20.0,
            ),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      EditProfileScreen.name,
                      style: TextStyles.title_20,
                    ),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      'ID: ${EditProfileScreen.id}',
                      style: TextStyles.caption2_13,
                    ),
                  ),
                  Gap(30),

                  Text('Account Settings', style: TextStyles.title_20),
                  Gap(30),
                  Text('Username', style: TextStyles.body_15),
                  Gap(13),
                  CustomTextFormField(hintText: 'John Smith'),
                  Gap(17),
                  Text('phone', style: TextStyles.body_15),
                  Gap(13),
                  CustomTextFormField(hintText: '+44 555 5555 55'),
                  Gap(17),
                  Text('email address', style: TextStyles.body_15),
                  Gap(13),
                  CustomTextFormField(hintText: 'example@example.com'),
                  Gap(40),

                  _rowCustomSwitch('push notifications', 0),
                  Gap(37),
                  _rowCustomSwitch('Turn dark Theme', 1),
                  Gap(36),
                  Center(
                    child: MainButton(text: 'Update Profile', onPress: () {
                      
                    },),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }



  Row _rowCustomSwitch(String title, int targetSwitch) {
    return Row(
      children: [
        Text(title, style: TextStyles.body_15),
        Spacer(),
        Switch(
          value: targetSwitch == 0 ? isActiveNotification : isActiveDarkThem,
          onChanged: (value) {
            setState(() {
              targetSwitch == 0
                  ? isActiveNotification = value
                  : isActiveDarkThem = value;
            });
          },

          thumbColor: WidgetStateProperty.all(Colors.white),

          trackOutlineColor: WidgetStateProperty.all(Colors.transparent),

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
