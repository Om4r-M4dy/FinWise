import 'package:finwise/core/constants/app_assets.dart';
import 'package:finwise/core/constants/app_colors.dart';
import 'package:finwise/core/widgets/custom_svg_picture.dart';
import 'package:finwise/features/Home/model/navBar_screens.dart';
import 'package:flutter/material.dart';

class NavBar extends StatefulWidget {
  const NavBar({super.key});

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  int currentIndex = 0;

  final List<String> icons = [
    AppAssets.home,
    AppAssets.analysis,
    AppAssets.transactions,
    AppAssets.category,
    AppAssets.profile,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: AppColors.background,
      appBar: navScreens[currentIndex].appBar?.call(context),
      body: navScreens[currentIndex].page,

      bottomNavigationBar: SizedBox(
        width: double.infinity,
        child: Container(
          color: AppColors.background,
          child: Container(
            height: 80,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            decoration: const BoxDecoration(
              color: AppColors.lightGreen,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(70),
                topRight: Radius.circular(70),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(icons.length, (index) {
                bool isSelected = currentIndex == index;

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      currentIndex = index;
                    });
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    curve: Curves.easeInOut,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.mainGreen
                          : Colors.transparent,
                      // shape: BoxShape.circle,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: CustomSvgPicture(
                      path: icons[index],
                      width: 25,
                      height: 25,
                      color: Colors.black,
                    ),
                  ),
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}
