import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class MyBodyView extends StatelessWidget {
  const MyBodyView({
    super.key,
    this.topSection,
    required this.bottomSection,
    this.noPadding = false,
    this.clipBehavior = Clip.antiAlias,
  });

  final Widget? topSection;
  final Widget bottomSection;
  final bool noPadding;
  final Clip clipBehavior;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (topSection != null) ...[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 37.0, vertical: 20),
            child: topSection,
          ),
        ] else
          const Gap(20),
        Expanded(
          child: Container(
            width: double.infinity,
            clipBehavior: clipBehavior,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(70.0)),
            ),
            child: noPadding
                ? bottomSection
                : Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 37.0,
                      vertical: 20,
                    ),
                    child: bottomSection,
                  ),
          ),
        ),
      ],
    );
  }
}
