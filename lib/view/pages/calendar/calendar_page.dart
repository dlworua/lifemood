import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  // 임시로 감정 이모지 날짜별 데이터
  final Map<DateTime, String> _emotions = {
    DateTime.utc(2025, 7, 17): '😊',
    DateTime.utc(2025, 7, 18): '😢',
    DateTime.utc(2025, 7, 19): '😡',
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("감정 캘린더")),
      body: TableCalendar(
        firstDay: DateTime.utc(2020, 1, 1),
        lastDay: DateTime.utc(2030, 12, 31),
        focusedDay: _focusedDay,
        selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
        onDaySelected: (selectedDay, focusedDay) {
          setState(() {
            _selectedDay = selectedDay;
            _focusedDay = focusedDay;
          });
        },
        calendarBuilders: CalendarBuilders(
          defaultBuilder: (context, day, focusedDay) {
            final emoji = _emotions[DateTime.utc(day.year, day.month, day.day)];
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [Text('${day.day}'), if (emoji != null) Text(emoji)],
              ),
            );
          },
        ),
      ),
    );
  }
}
