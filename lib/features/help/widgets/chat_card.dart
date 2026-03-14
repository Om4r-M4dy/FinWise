import 'package:finwise/core/constants/app_assets.dart';
import 'package:finwise/core/constants/app_colors.dart';
import 'package:finwise/core/functions/navigations.dart';
import 'package:finwise/core/routes/routes.dart';
import 'package:finwise/core/styles/text_styles.dart';
import 'package:finwise/core/widgets/custom_svg_picture.dart';
import 'package:flutter/material.dart';

class ChatCard extends StatelessWidget {
  const ChatCard({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){pushTo(context, Routes.chatScreen);},
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadiusGeometry.circular(14),
          color: AppColors.lightGreen,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            ListTile(
              leading: CustomSvgPicture(
                path: AppAssets.botSupport,
                height: 45,
              ),
              title: Text('Help center', style: TextStyles.body_15),
              subtitle: Text("Hello! I'm here to assist you", style: TextStyles.body_15),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0,0,11,9),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 4,vertical: 2),
                decoration: BoxDecoration(
                  borderRadius: BorderRadiusGeometry.circular(15),
                  color: AppColors.background,
                ),
                child: Text('Feb 08 -2024 ', style: TextStyles.caption3_12),
              ),
            ),
          ],
        ),
      ),
    );
  }
}