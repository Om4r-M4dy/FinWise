import 'package:finwise/core/constants/app_colors.dart';
import 'package:finwise/core/styles/text_styles.dart';
import 'package:finwise/core/widgets/custom_svg_picture.dart';
import 'package:flutter/material.dart';

class TransactionBox extends StatefulWidget {
  const TransactionBox({
    super.key,
    this.pathIcon,
    required this.titel,
    required this.palance,
    this.iconColor,
    this.palanceColor,
  });
  final String? pathIcon;
  final String titel;
  final String palance;
  final Color? iconColor;
  final Color? palanceColor;

  @override
  State<TransactionBox> createState() => _TransactionBoxState();
}

class _TransactionBoxState extends State<TransactionBox> {
  bool isSelected = false;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: () {
          setState(() {
            isSelected = !isSelected;
          });
        },
        child: Container(
          decoration: BoxDecoration(
            color: isSelected? AppColors.oceanBlueButton: AppColors.background,
            borderRadius: BorderRadius.circular(14),
          ),
          height: 100,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CustomSvgPicture(
                height: 25,
                width: 25,
                path: widget.pathIcon ?? '',
                color: isSelected? AppColors.background: widget.iconColor,
              ),
              Text(widget.titel, style: TextStyles.body_15.copyWith(color: isSelected? AppColors.background:AppColors.lettersAndIcons)),
              Text(
                '\$${widget.palance}',
                style: TextStyles.title_20.copyWith(color:isSelected? AppColors.background: widget.palanceColor),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
