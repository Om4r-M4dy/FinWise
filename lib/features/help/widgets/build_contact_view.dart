import 'package:finwise/core/constants/app_assets.dart';
import 'package:finwise/core/functions/navigations.dart';
import 'package:finwise/core/routes/routes.dart';
import 'package:finwise/core/styles/text_styles.dart';
import 'package:finwise/core/widgets/custom_svg_picture.dart';
import 'package:flutter/material.dart';

class BuildContactView extends StatelessWidget {
  const BuildContactView({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> contacts = [
      {
        'name': 'Customer Service',
        'icon': AppAssets.botSupport,
        'action': () => pushTo(context, Routes.customerService),
      },
      {'name': 'Website', 'icon': AppAssets.botWebsite},
      {'name': 'Facebook', 'icon': AppAssets.botFacebook},
      {'name': 'Whatsapp', 'icon': AppAssets.botWhatsapp},
      {'name': 'Instagram', 'icon': AppAssets.botInstagram},
    ];

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: contacts.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: ListTile(
            leading: CustomSvgPicture(path: contacts[index]['icon'] as String),
            title: Text(
              contacts[index]['name'] as String,
              style: TextStyles.body_15,
            ),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              final VoidCallback? action = contacts[index]['action'];
              if (action != null) {
                action();
              }
            },
          ),
        );
      },
    );
  }
}