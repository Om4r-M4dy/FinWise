import 'package:finwise/core/constants/app_colors.dart';
import 'package:finwise/core/styles/text_styles.dart';
import 'package:finwise/features/on_boarding/Widget/background_card.dart';
import 'package:finwise/features/on_boarding/Widget/build_page_content.dart';
import 'package:finwise/features/on_boarding/data/on_boarding_data.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

/// A stateful widget that displays the onboarding flow of the application.
/// It introduces the user to the app's core features before navigating to the main/login screen.
class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({super.key});

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  /// Controller to handle page navigation within the [PageView].
  final PageController _pageController = PageController();

  /// Tracks the index of the currently displayed page to update UI accordingly.
  int _currentIndex = 0;

  @override
  void dispose() {
    // Disposes the controller to free up resources and prevent memory leaks.
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 1. Static background element
          const BackgroundCard(),

          // 2. Main content
          Column(
            children: [
              // Scrollable area containing the image and text for each onboarding page
              Expanded(
                child: PageView(
                  controller: _pageController,
                  onPageChanged: (index) =>
                      setState(() => _currentIndex = index),
                  children: [buildPageContent(0), buildPageContent(1)],
                ),
              ),

              // Fixed bottom area containing the navigation button and page indicators
              Padding(
                padding: const EdgeInsets.only(bottom: 40.0),
                child: Column(
                  children: [
                    TextButton(
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      onPressed: () {
                        // Navigate to the next page if available
                        if (_currentIndex < onBoardingPages.length - 1) {
                          _pageController.nextPage(
                            duration: const Duration(milliseconds: 400),
                            curve: Curves.easeInOut,
                          );
                        } else {
                          //navigate to home
                        }
                      },
                      // Dynamically change button text on the last page
                      child: Text(
                        _currentIndex == onBoardingPages.length - 1
                            ? 'Get Started'
                            : 'Next',
                        style: TextStyles.size_30,
                      ),
                    ),
                    const Gap(27),

                    // Page indicator dots
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        onBoardingPages.length,
                        (index) => _buildDot(index),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Builds an animated dot indicator for the [PageView].
  /// Highlights the dot corresponding to the [_currentIndex].
  ///
  /// [index] is the position of the dot in the list.
  Widget _buildDot(int index) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 400),
      margin: const EdgeInsets.symmetric(horizontal: 5),
      height: 13,
      width: 13,
      decoration: BoxDecoration(
        color: (_currentIndex == index)
            ? AppColors.mainGreen
            : Colors.transparent,
        border: Border.all(
          color: (_currentIndex == index) ? AppColors.mainGreen : Colors.black,
          width: 2,
        ),
        shape: BoxShape.circle,
      ),
    );
  }
}