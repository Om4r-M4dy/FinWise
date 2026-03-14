import 'package:finwise/core/styles/text_styles.dart';
import 'package:finwise/core/widgets/default_app_bar.dart';
import 'package:finwise/core/widgets/my_body_view.dart';
import 'package:finwise/features/help/widgets/chat_card.dart';
import 'package:finwise/features/help/widgets/start_another_chat_button.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class CustomerService extends StatelessWidget {
  const CustomerService({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DefaultAppBar(title: 'Online Support'),
      body: MyBodyView(
        bottomSection: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('active chats', style: TextStyles.body_15),
              Gap(18),
              ChatCard(),
              Gap(48),
              Text('Ended chats', style: TextStyles.body_15),
              Gap(18),
              ChatCard(),
              Gap(18),
              ChatCard(),
              Gap(18),
              ChatCard(),
              Gap(18),
              ChatCard(),
              Gap(18),
              ChatCard(),
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: StartAnotherChatButton(),
    );
  }
}