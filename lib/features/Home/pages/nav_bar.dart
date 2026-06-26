import 'package:finwise/core/constants/app_assets.dart';
import 'package:finwise/core/constants/app_colors.dart';
import 'package:finwise/core/widgets/custom_svg_picture.dart';
import 'package:finwise/features/Home/model/navBar_screens.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

// ignore: must_be_immutable
class NavBar extends StatefulWidget {
  const NavBar({super.key});

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  int currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: navScreens[currentIndex],

      bottomNavigationBar: Container(
        height: 108,
        padding: EdgeInsets.only(top: 36, bottom: 36, left: 60, right: 60),

        decoration: BoxDecoration(
          color: AppColors.lightGreen,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(70),
            topRight: Radius.circular(70),
          ),
        ),
        child: BottomNavigationBar(
          enableFeedback: false,
          elevation: 0,

          // fixedColor: Colors.transparent,
          backgroundColor: Colors.transparent,
          unselectedItemColor: Colors.transparent,
          selectedItemColor: AppColors.mainGreen,
          currentIndex: currentIndex,
          selectedFontSize: 0,
          unselectedFontSize: 0,
          type: BottomNavigationBarType.fixed,
          items: [
            nav_item(AppAssets.home),
            nav_item(AppAssets.analysis),
            nav_item(AppAssets.transactions),
            nav_item(AppAssets.category),
            nav_item(AppAssets.profile),
          ],
          onTap: (index) {
            setState(() {
              currentIndex = index;
            });
          },
        ),
      ),
    );
  }

  BottomNavigationBarItem nav_item(String path) {
    return BottomNavigationBarItem(
      label: '',
      icon: CustomSvgPicture(path: path),
      activeIcon: CustomSvgPicture(path: path, color: AppColors.mainGreen),
    );
  }
}
