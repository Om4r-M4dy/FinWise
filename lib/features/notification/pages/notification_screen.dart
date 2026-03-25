import 'package:finwise/core/constants/app_assets.dart';
import 'package:finwise/core/constants/app_colors.dart';
import 'package:finwise/core/styles/text_styles.dart';
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
      // TODO: make it back to home screen...
      appBar: DefaultAppBar(title: "Notification"), 
      body: MyBodyView(
        
        bottomSection: SingleChildScrollView(
          child: Column(
            children: [
              CompleteNotifySection(sectionName: "Today",notifyList: todaynotifyList,),
              Gap(25),
              CompleteNotifySection(sectionName: "Yesterday",notifyList: yesterdaynotifyList,),
                 Gap(25),
              CompleteNotifySection(sectionName: "This Weekend",notifyList: thisWeekendnotifyList,),
            
            
            ],
          ),
        ),



      ),
    );
  }
}

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
        Text(sectionName,style: TextStyles.caption1_14.copyWith(fontWeight: FontWeight.w400),),
     Gap(7),
    
    ListView.separated(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemBuilder: (context,index){
        NotifyModel model=notifyList[index];
    return NotificationElement(iconPath: model.iconPath??AppAssets.notification,
    title: model.title??"",
    subTitle:model.subTitle??"",
    date: model.date??"",
    transactionDetails:model.transactionDetails
    );
      }, separatorBuilder: (context,index){
    return   Container(
                  height: 1,
                  width: double.infinity,
                  margin: const EdgeInsets.only(top: 15,bottom: 25),
                  color: AppColors.oceanBlueButton.withValues(alpha: 0.5),
                );
      }
      , itemCount: notifyList.length)
       ],
    );
  }
}

