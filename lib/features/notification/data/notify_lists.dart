import 'package:finwise/core/constants/app_assets.dart';

class NotifyModel{
final String? iconPath;
final String? title;
final String? subTitle;
final String? date;
final String? transactionDetails;

NotifyModel({
    required this.iconPath,
    required this.title,
    required this.subTitle,
    required this.date,
    this.transactionDetails,
  });

}

List<NotifyModel> todaynotifyList=[
NotifyModel(
    iconPath: AppAssets.notification,
    title: "Reminder!",
    subTitle: "Set up your automatic savings \nto meet your savings goal...",
    date: "17:00 - April 24",
  ),
NotifyModel(
    iconPath: AppAssets.star,
    title: "New update",
    subTitle: "Set up your automatic savings \nto meet your savings goal...",
    date: "17:00 - April 24",
  ),
];



List<NotifyModel> yesterdaynotifyList=[
NotifyModel(
   iconPath: AppAssets.dollar,
title: "Transactions",
subTitle:"A new transaction has been registered" ,
date: "17:00 - April 24",
transactionDetails: "Groceries | pantry | -\$100,00",
 ),
NotifyModel(
    iconPath: AppAssets.notification,
    title: "Reminder!",
    subTitle: "Set up your automatic savings \nto meet your savings goal...",
    date: "17:00 - April 24",
  ),
];


List<NotifyModel> thisWeekendnotifyList=[
NotifyModel(
    iconPath: AppAssets.notification,
    title: "Expense record",
    subTitle: "We recommend that you be more \nattentive to your finances.",
    date: "17:00 - April 24",
  ),
NotifyModel(
   iconPath: AppAssets.dollar,
title: "Transactions",
subTitle:"A new transaction has been registered" ,
date: "17:00 - April 24",
transactionDetails: "Food | Dinner | -\$70,40",
 ),
];

