import 'package:finwise/core/widgets/my_body_view.dart';
import 'package:finwise/core/widgets/row_app_bar.dart';
import 'package:finwise/features/calendar/widget/dashboard.dart';
import 'package:finwise/features/calendar/widget/app_calendar.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

/// Screen for viewing and interacting with calendar-based expense data.
///
/// Composes `MyBodyView` with a fixed top app bar and a scrollable bottom section.
/// The `AppCalendar` callback is a placeholder for parent-level state updates.
class CalendarScreen extends StatelessWidget {
  const CalendarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MyBodyView(
      topSection: Column(
        children: [
          SafeArea(child: RowAppBar(title: 'Calendar')),
          Gap(70),
        ],
      ),
      bottomSection: SingleChildScrollView(
        child: Column(
          children: [
            AppCalendar(onDaySelected: (selectedDay, focusedDay) {}),
            Gap(35),
            Dashboard(),
          ],
        ),
      ),
    );
  }
}
