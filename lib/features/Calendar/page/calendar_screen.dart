import 'package:finwise/core/widgets/my_body_view.dart';
import 'package:finwise/core/widgets/row_app_bar.dart';
import 'package:finwise/features/Calendar/widget/app_calendar.dart';
import 'package:finwise/features/Calendar/widget/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

/// Screen for viewing and interacting with calendar-based expense data.
///
/// Composes `MyBodyView` with a fixed top app bar and a scrollable bottom section.
/// The selected day from `AppCalendar` is lifted up here and passed to `Dashboard`
/// to drive filtering of transactions by the chosen date.
class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  /// The day the user last tapped on the calendar. Null means no filter applied.
  DateTime? _selectedDay;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MyBodyView(
        topSection: Column(
          children: [SafeArea(child: RowAppBar(title: 'Calendar'))],
        ),
        bottomSection: SingleChildScrollView(
          child: Column(
            children: [
              AppCalendar(
                onDaySelected: (selectedDay, focusedDay) {
                  setState(() {
                    _selectedDay = selectedDay;
                  });
                },
              ),
              const Gap(35),
              Dashboard(selectedDay: _selectedDay),
            ],
          ),
        ),
      ),
    );
  }
}
