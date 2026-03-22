import 'dart:math';

import 'package:finwise/core/constants/app_colors.dart';
import 'package:finwise/core/styles/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class DateHeader extends StatelessWidget {
final int selectedIndex;
  final List<String> labels;
  final ValueChanged<int> onUpdate;

  const DateHeader({
    super.key,
    required this.selectedIndex,
    required this.labels,
    required this.onUpdate,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      padding: EdgeInsets.all(4),
      decoration: BoxDecoration(
color: AppColors.lightGreen,
borderRadius: BorderRadius.circular(25),
      ),
      child: LayoutBuilder(
        builder: (context,constraints){
          double segmentWidth=constraints.maxWidth / labels.length;
return Stack(
  children: [
    AnimatedAlign(
      alignment: Alignment(
        (selectedIndex/(labels.length- 1) * 2) - 1, 0),
    duration: const Duration(milliseconds: 250),
    curve: Curves.easeInOut,
    child: Container(
      width: segmentWidth,
      height: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.mainGreen,
        borderRadius: BorderRadius.circular(20),
      ),
      ),
    ),
    Row(
      children: List.generate(labels.length,
       (index){
        return Expanded(
          child: GestureDetector(
            onTap:()=> onUpdate(index),
            behavior: HitTestBehavior.opaque,
            child: Center(
              child: Text(labels[index],
              style:TextStyles.body_15.copyWith(
                color: selectedIndex==index?AppColors.dark05:AppColors.darkGreen
              ),),
            ),
          )
        
        );
       })
    )
  ],
);
        },),
    );
  }
}