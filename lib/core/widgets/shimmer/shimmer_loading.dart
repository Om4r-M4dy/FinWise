import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:gap/gap.dart';

class ShimmerWidget extends StatelessWidget {
  final double width;
  final double height;
  final ShapeBorder shapeBorder;

  const ShimmerWidget.rectangular({
    super.key,
    required this.width,
    required this.height,
    this.shapeBorder = const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(12)),
    ),
  });

  const ShimmerWidget.circular({
    super.key,
    required this.width,
    required this.height,
    this.shapeBorder = const CircleBorder(),
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    final baseColor = isDark 
        ? const Color(0xff0E3E3E).withValues(alpha: 0.5) 
        : Colors.grey[300]!;
    final highlightColor = isDark 
        ? const Color(0xff00D09E).withValues(alpha: 0.15) 
        : Colors.grey[100]!;

    return Shimmer.fromColors(
      baseColor: baseColor,
      highlightColor: highlightColor,
      period: const Duration(milliseconds: 1500),
      child: Container(
        width: width,
        height: height,
        decoration: ShapeDecoration(
          color: isDark ? const Color(0xff0E3E3E) : Colors.grey[400]!,
          shape: shapeBorder,
        ),
      ),
    );
  }
}

class TransactionsListShimmer extends StatelessWidget {
  final int itemCount;

  const TransactionsListShimmer({super.key, this.itemCount = 4});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: itemCount,
      separatorBuilder: (context, index) => const Gap(19),
      itemBuilder: (context, index) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              // Icon Circle placeholder
              const ShimmerWidget.circular(width: 44, height: 44),
              const Gap(16),
              // Title and Note placeholder
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ShimmerWidget.rectangular(
                      width: MediaQuery.of(context).size.width * 0.35,
                      height: 16,
                    ),
                    const Gap(8),
                    ShimmerWidget.rectangular(
                      width: MediaQuery.of(context).size.width * 0.25,
                      height: 12,
                    ),
                  ],
                ),
              ),
              // Amount placeholder
              const ShimmerWidget.rectangular(width: 60, height: 18),
            ],
          ),
        );
      },
    );
  }
}

class GoalsListShimmer extends StatelessWidget {
  const GoalsListShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 180,
      child: ListView.builder(
        itemCount: 3,
        scrollDirection: Axis.horizontal,
        clipBehavior: Clip.none,
        padding: const EdgeInsets.symmetric(vertical: 8),
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(left: 6, right: 6),
            child: Container(
              width: 150,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ShimmerWidget.circular(width: 60, height: 60),
                  Gap(12),
                  ShimmerWidget.rectangular(width: 80, height: 14),
                  Gap(8),
                  ShimmerWidget.rectangular(width: 50, height: 10),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class QuickAnalysisShimmer extends StatelessWidget {
  const QuickAnalysisShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Last week analysis card placeholder
          const ShimmerWidget.rectangular(
            width: double.infinity,
            height: 120,
          ),
          const Gap(26),
          // Plot section placeholder
          const ShimmerWidget.rectangular(
            width: double.infinity,
            height: 200,
          ),
          const Gap(26),
          // Transactions list placeholder
          const TransactionsListShimmer(itemCount: 3),
        ],
      ),
    );
  }
}
