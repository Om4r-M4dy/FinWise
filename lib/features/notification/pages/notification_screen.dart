import 'package:finwise/core/constants/app_assets.dart';
import 'package:finwise/core/constants/app_colors.dart';
import 'package:finwise/core/styles/text_styles.dart';
import 'package:finwise/core/widgets/custom_svg_picture.dart';
import 'package:finwise/core/widgets/default_app_bar.dart';
import 'package:finwise/core/widgets/my_body_view.dart';
import 'package:finwise/features/notification/data/notify_lists.dart';
import 'package:finwise/features/notification/widgets/notification_element.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DefaultAppBar(title: "Notification"),
      body: MyBodyView(
        
        bottomSection: Column(
          children: [
            CompleteNotifySection(sectionName: "Today",notifyList: todaynotifyList,),
            CompleteNotifySection(sectionName: "Yesterday",notifyList: yesterdaynotifyList,),
            CompleteNotifySection(sectionName: "This Weekend",notifyList: thisWeekendnotifyList,),
          
          
          ],
        ),



      ),
    );
  }
}

// class CompleteNotifySection extends StatelessWidget {
//   const CompleteNotifySection({
//     super.key, required this.sectionName, required this.notifyList,
//   });
// final String sectionName;
// final List<NotifyModel> notifyList;
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(sectionName,style: TextStyles.caption1_14.copyWith(fontWeight: FontWeight.w400),),
//      Gap(7),
    
//     ListView.separated(
//       physics: NeverScrollableScrollPhysics(),
//       itemBuilder: (context,index){
//         NotifyModel model=notifyList[index];
//     return NotificationElement(iconPath: model.iconPath??AppAssets.notification,
//     title: model.title??"",
//     subTitle:model.subTitle??"",
//     date: model.date??"",
//     transactionDetails:model.transactionDetails
//     );
//       }, separatorBuilder: (context,index){
//     return Column(
//       children: [
//     Gap(10),
//         Container(
//                     height: 1,
//                     width: MediaQuery.of(context).size.width,
//                     margin: const EdgeInsets.symmetric(vertical: 15),
//                     color: AppColors.oceanBlueButton,
//                   ),
//       ],
//     );
//       }
//       , itemCount: notifyList.length)
//        ],
//     );
//   }
// }


class CompleteNotifySection extends StatelessWidget {
  const CompleteNotifySection({
    super.key, required this.sectionName, required this.notifyList,
  });
  final String sectionName;
  final List<NotifyModel> notifyList;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(sectionName, style: TextStyles.caption1_14.copyWith(fontWeight: FontWeight.w400)),
        const Gap(7),
        
        ...notifyList.asMap().entries.map((entry) {
          int index = entry.key;
          NotifyModel model = entry.value;

          return Column(
            children: [
              NotificationElement(
                iconPath: model.iconPath ?? AppAssets.notification,
                title: model.title ?? "",
                subTitle: model.subTitle ?? "",
                date: model.date ?? "",
                transactionDetails: model.transactionDetails,
              ),
                
              if (index != notifyList.length - 1)
                Container(
                  height: 1,
                  width: double.infinity,
                  margin: const EdgeInsets.only(top: 15,bottom: 25),
                  color: AppColors.oceanBlueButton.withValues(alpha: 0.5),
                ),
            ],
          );
        }),
        const Gap(25), 
      ],
    );
  }
}







