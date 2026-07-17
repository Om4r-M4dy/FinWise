import 'package:finwise/core/constants/app_assets.dart';
import 'package:finwise/core/constants/app_colors.dart';
import 'package:finwise/core/widgets/custom_svg_picture.dart';
import 'package:finwise/features/Home/model/navbar_screens.dart';
import 'package:finwise/features/Transaction/presentation/cubit/transaction_cubit.dart';
import 'package:finwise/features/analysis/cubit/goal_cubit.dart';
import 'package:finwise/features/profile/cubit/user_cubit.dart';
import 'package:finwise/features/profile/cubit/user_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NavBar extends StatefulWidget {
  const NavBar({super.key});

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    // Load transactions and goals once — shared across Home, Analysis, Transaction tabs
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final userState = context.read<UserCubit>().state;
      if (userState is UserLoaded) {
        context.read<TransactionCubit>().getTransactions(userState.user.uid!);
        context.read<GoalCubit>().loadGoals(userState.user.uid!);
      }
    });
  }

  final List<String> icons = [
    AppAssets.home,
    AppAssets.analysis,
    AppAssets.more,
    AppAssets.category,
    AppAssets.profile,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      // backgroundColor: AppColors.background,
      appBar: navScreens[currentIndex].appBar?.call(context),
      body: navScreens[currentIndex].page,

      bottomNavigationBar: SizedBox(
        width: double.infinity,
        child: Container(
          color: Colors.transparent,
          child: Container(
            height: 80,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primaryContainer,
              borderRadius: const BorderRadius.only(
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
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
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







