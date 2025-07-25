import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lifemood/data/model/feeling_entry.dart';
import 'package:lifemood/view_model/feeling_view_model.dart';
import 'package:table_calendar/table_calendar.dart';
import '../feeling/feeling_detail_page.dart';
import '../feeling/feeling_editor_page.dart';

class CalendarPage extends ConsumerStatefulWidget {
  const CalendarPage({super.key});

  @override
  ConsumerState<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends ConsumerState<CalendarPage> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  // 날짜별 여러 감정 기록 저장
  Map<DateTime, List<FeelingEntry>> _emotionMap = {};

  @override
  void initState() {
    super.initState();
    _loadFeelings();
  }

  DateTime _normalize(DateTime date) =>
      DateTime(date.year, date.month, date.day);

  Future<void> _loadFeelings() async {
    await ref.read(feelingViewModelProvider.notifier).loadFeelings();
    final feelings = ref.read(feelingViewModelProvider);

    setState(() {
      _emotionMap = {};
      for (var entry in feelings) {
        final date = _normalize(entry.date);
        _emotionMap.putIfAbsent(date, () => []).add(entry);
      }
    });
  }

  String? _getMostUsedEmoji(List<FeelingEntry>? entries) {
    if (entries == null || entries.isEmpty) return null;
    final emojiCount = <String, int>{};
    for (var entry in entries) {
      emojiCount[entry.emoji] = (emojiCount[entry.emoji] ?? 0) + 1;
    }
    return emojiCount.entries.reduce((a, b) => a.value >= b.value ? a : b).key;
  }

  Widget _buildDayCell(DateTime day) {
    final entries = _emotionMap[_normalize(day)];
    final emoji = _getMostUsedEmoji(entries);

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('${day.day}', style: const TextStyle(fontSize: 14)),
          SizedBox(
            height: 32,
            child: emoji != null
                ? Center(
                    child: Text(emoji, style: const TextStyle(fontSize: 20)),
                  )
                : null,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("감정 캘린더")),
      body: TableCalendar(
        firstDay: DateTime.utc(2000, 1, 1),
        lastDay: DateTime.utc(2100, 12, 31),
        focusedDay: _focusedDay,
        selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
        calendarFormat: CalendarFormat.month,
        availableCalendarFormats: const {CalendarFormat.month: '월'},
        headerStyle: HeaderStyle(
          formatButtonVisible: false,
          titleCentered: true,
          titleTextFormatter: (date, locale) => '${date.year}년 ${date.month}월',
        ),
        daysOfWeekHeight: 50,
        onDaySelected: (selectedDay, focusedDay) async {
          setState(() {
            _selectedDay = selectedDay;
            _focusedDay = focusedDay;
          });

          final normalizedDate = _normalize(selectedDay);
          final selectedEntries = _emotionMap[normalizedDate] ?? [];

          if (selectedEntries.isEmpty) {
            await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => FeelingEditorPage(selectedDate: selectedDay),
              ),
            );
            await _loadFeelings();
            setState(() {});
          } else {
            await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => FeelingDetailPage(
                  selectedDate: selectedDay,
                  feelingEntries: selectedEntries,
                ),
              ),
            );
            await _loadFeelings();
            setState(() {});
          }
        },
        calendarBuilders: CalendarBuilders(
          dowBuilder: (context, day) {
            final text = [
              'Sun',
              'Mon',
              'Tue',
              'Wed',
              'Thu',
              'Fri',
              'Sat',
            ][day.weekday % 7];
            Color color;
            if (day.weekday == DateTime.sunday) {
              color = Colors.red;
            } else if (day.weekday == DateTime.saturday) {
              color = Colors.blue;
            } else {
              color = const Color(0xFF333366);
            }
            return Center(
              child: Text(
                text,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: color,
                  fontSize: 15,
                ),
              ),
            );
          },
          defaultBuilder: (context, day, focusedDay) => _buildDayCell(day),
          todayBuilder: (context, day, focusedDay) => Container(
            decoration: BoxDecoration(
              color: Colors.blue.shade100,
              borderRadius: BorderRadius.circular(8),
            ),
            child: _buildDayCell(day),
          ),
          selectedBuilder: (context, day, focusedDay) => Container(
            decoration: BoxDecoration(
              color: Colors.blueAccent.shade100,
              borderRadius: BorderRadius.circular(8),
            ),
            child: _buildDayCell(day),
          ),
        ),
      ),
    );
  }
}
