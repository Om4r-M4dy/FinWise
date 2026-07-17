import 'package:finwise/core/constants/app_assets.dart';
import 'package:finwise/core/constants/app_colors.dart';
import 'package:finwise/core/styles/text_styles.dart';
import 'package:finwise/core/widgets/custom_svg_picture.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class BuildContactView extends StatelessWidget {
  const BuildContactView({super.key});

  Future<void> _launchEmail() async {
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: 'eedf4730@gmail.com',
      queryParameters: {
        'subject': 'FinWise Support & Feedback',
      },
    );
    try {
      await launchUrl(emailLaunchUri);
    } catch (e) {
      debugPrint("Error launching email client: $e");
    }
  }

  Future<void> _launchWhatsApp() async {
    final Uri whatsappUri = Uri.parse("https://wa.me/201011082763");
    try {
      await launchUrl(whatsappUri, mode: LaunchMode.externalApplication);
    } catch (e) {
      debugPrint("Error launching WhatsApp chat: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final List<Map<String, dynamic>> contacts = [
      {
        'name': 'Email',
        'leading': Icon(
          Icons.email_outlined,
          color: isDark ? Colors.white : AppColors.lettersAndIcons,
        ),
        'action': () => _launchEmail(),
      },
      {
        'name': 'Whatsapp',
        'leading': const CustomSvgPicture(
          path: AppAssets.botWhatsapp,
        ),
        'action': () => _launchWhatsApp(),
      },
    ];

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: contacts.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: ListTile(
            leading: contacts[index]['leading'] as Widget,
            title: Text(
              contacts[index]['name'] as String,
              style: TextStyles.bodyMedium.copyWith(
                color: isDark ? Colors.white : AppColors.lettersAndIcons,
              ),
            ),
            trailing: Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: isDark ? Colors.white : AppColors.lettersAndIcons,
            ),
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
