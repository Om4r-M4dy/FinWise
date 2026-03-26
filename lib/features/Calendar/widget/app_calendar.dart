import 'package:finwise/core/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:finwise/core/styles/text_styles.dart';

/// Calendar UI wrapper around `TableCalendar` with internal selection state.
///
/// `onDaySelected` is called when the user picks a date, enabling parent widgets
/// to refresh any day-specific content without owning `TableCalendar` selection.
class AppCalendar extends StatefulWidget {
  final Function(DateTime selectedDay, DateTime focusedDay) onDaySelected;

  const AppCalendar({super.key, required this.onDaySelected});

  @override
  State<AppCalendar> createState() => _AppCalendarState();
}

class _AppCalendarState extends State<AppCalendar> {
  late DateTime _focusedDay;
  DateTime? _selectedDay;

  @override
  void initState() {
    super.initState();
    _focusedDay = DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    return TableCalendar(
      rowHeight: 38,
      firstDay: DateTime.utc(2020, 1, 1),
      lastDay: DateTime.utc(2030, 12, 31),
      focusedDay: _focusedDay,

      selectedDayPredicate: (day) {
        return isSameDay(_selectedDay, day);
      },

      onDaySelected: (selectedDay, focusedDay) {
        if (!isSameDay(_selectedDay, selectedDay)) {
          setState(() {
            _selectedDay = selectedDay;
            // Sync focused day with selected day to ensure the calendar view follows the user's selection
            _focusedDay = focusedDay;
          });

          // Notify the parent widget (e.g., to fetch specific transactions for this day)
          widget.onDaySelected(selectedDay, focusedDay);
        }
      },

      // Keeps the internal focus in sync when the user paginates months.
      // This avoids a state mismatch where a selected date could be outside the
      // visible month range after swiping.
      onPageChanged: (focusedDay) {
        _focusedDay = focusedDay;
      },

      // --- Header Configuration ---
      headerVisible: true,
      headerStyle: HeaderStyle(
        formatButtonVisible: false,
        titleCentered: true,
        titleTextStyle: TextStyles.subtitle_17.copyWith(
          color: AppColors.mainGreen,
          fontWeight: FontWeight.bold,
        ),
        leftChevronVisible: true,
        rightChevronVisible: true,
        leftChevronIcon: const Icon(
          Icons.chevron_left,
          color: AppColors.mainGreen,
          size: 28,
        ),
        rightChevronIcon: const Icon(
          Icons.chevron_right,
          color: AppColors.mainGreen,
          size: 28,
        ),
      ),

      // --- Days of the Week Configuration ---
      daysOfWeekStyle: DaysOfWeekStyle(
        weekdayStyle: TextStyles.caption1_14.copyWith(
          color: AppColors.blueButton,
        ),
        weekendStyle: TextStyles.caption1_14.copyWith(
          color: AppColors.blueButton,
        ),
      ),

      // --- Calendar Cells Configuration ---
      calendarStyle: CalendarStyle(
        outsideDaysVisible: false,
        defaultTextStyle: TextStyles.caption1_14,
        weekendTextStyle: TextStyles.caption1_14,

        selectedTextStyle: TextStyles.caption1_14.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
        selectedDecoration: const BoxDecoration(
          color: AppColors.mainGreen,
          shape: BoxShape.circle,
        ),

        // Style for the actual current day (Today)
        todayTextStyle: TextStyles.subtitle_17.copyWith(
          color: AppColors.mainGreen,
          fontWeight: FontWeight.bold,
        ),
        todayDecoration: const BoxDecoration(
          color: Colors.transparent,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}
