import 'package:finwise/core/constants/app_assets.dart';
import 'package:finwise/core/styles/theme_cubit.dart';
import 'package:finwise/features/profile/cubit/user_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:finwise/core/constants/app_colors.dart';
import 'package:finwise/core/functions/navigations.dart';
import 'package:finwise/core/routes/routes.dart';
import 'package:finwise/core/styles/text_styles.dart';
import 'package:finwise/core/widgets/custom_svg_picture.dart';
import 'package:finwise/core/widgets/default_app_bar.dart';
import 'package:finwise/core/widgets/my_body_view.dart';
import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DefaultAppBar(title: "Settings"),
      body: MyBodyView(
        bottomSection: SingleChildScrollView(
          child: Column(
            children: [
              SettingChoice(
                icon: AppAssets.notification,
                title: "Notification Settings",
                onPress: () {
                  pushTo(context, Routes.notificationSettingsScreen);
                },
              ),
              BlocBuilder<ThemeCubit, bool>(
                builder: (context, isDark) {
                  return SettingSwitch(
                    icon: AppAssets.eye,
                    title: "Dark Theme",
                    value: isDark,
                    onChanged: (value) {
                      context.read<ThemeCubit>().toggleTheme();
                      final userCubit = context.read<UserCubit>();
                      if (userCubit.user != null) {
                        userCubit.updateSettings(darkTheme: value);
                      }
                    },
                  );
                },
              ),
              SettingChoice(
                icon: AppAssets.profile,
                title: "Delete Account ",
                onPress: () {
                  pushTo(context, Routes.deleteAccountScreen);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SettingChoice extends StatelessWidget {
  const SettingChoice({
    super.key,
    required this.icon,
    required this.title,
    required this.onPress,
  });
  final String icon;
  final String title;
  final void Function()? onPress;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        height: 31,
        width: 31,
        padding: EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: AppColors.mainGreen,
          borderRadius: BorderRadius.circular(30),
        ),
        child: CustomSvgPicture(path: icon),
      ),
      title: Text(title, style: TextStyles.bodyMedium),
      trailing: IconButton(
        onPressed: onPress,
        icon: Icon(
          Icons.arrow_forward_ios,
          weight: 7,
          color: AppColors.lettersAndIcons,
        ),
      ),
    );
  }
}

class SettingSwitch extends StatelessWidget {
  const SettingSwitch({
    super.key,
    required this.icon,
    required this.title,
    required this.value,
    required this.onChanged,
  });
  final String icon;
  final String title;
  final bool value;
  final void Function(bool) onChanged;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        height: 31,
        width: 31,
        padding: EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: AppColors.mainGreen,
          borderRadius: BorderRadius.circular(30),
        ),
        child: CustomSvgPicture(path: icon),
      ),
      title: Text(title, style: TextStyles.bodyMedium),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeThumbColor: AppColors.mainGreen,
      ),
    );
  }
}
