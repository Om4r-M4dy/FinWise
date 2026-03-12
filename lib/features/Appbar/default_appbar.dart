import 'package:finwise/core/constants/app_assets.dart';
import 'package:finwise/core/styles/text_styles.dart';
import 'package:flutter/material.dart';

 class DefaultAppbar extends StatelessWidget
    implements PreferredSizeWidget {
  const DefaultAppbar({
    super.key,
    required this.title,
    this.titleColor = const Color(0xff093030),
  });

  final String title;
  final Color titleColor;
  @override
Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.blueGrey,
      leading: IconButton(
        onPressed: () {
          Navigator.pop(context);
        },
        icon: Image.asset(AppAssets.back),
      ),
      title: Center(
        child: Text(
          title,
          style: AppTextStyles.title20.copyWith(
            fontFamily: "Poppins",
            color: titleColor,
          ),
        ),
      ),
      actions: [
        IconButton(
          onPressed: () {},

          icon: Image.asset(AppAssets.abbbarNotification),
        ),
      ],
    );
  }
}
