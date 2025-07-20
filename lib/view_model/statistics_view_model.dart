import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lifemood/data/model/feeling_entry.dart';
import 'package:lifemood/data/model/statistics_filter.dart';

final statisticsViewModelProvider =
    StateNotifierProvider<StatisticsViewModel, StatisticsState>(
      (ref) => StatisticsViewModel(),
    );

class StatisticsState {
  final StatisticsFilter filter;
  final List<FeelingEntry> filteredEntries;

  StatisticsState({required this.filter, required this.filteredEntries});

  StatisticsState copyWith({
    StatisticsFilter? filter,
    List<FeelingEntry>? filteredEntries,
  }) {
    return StatisticsState(
      filter: filter ?? this.filter,
      filteredEntries: filteredEntries ?? this.filteredEntries,
    );
  }
}

class StatisticsViewModel extends StateNotifier<StatisticsState> {
  StatisticsViewModel()
    : super(
        StatisticsState(filter: StatisticsFilter.month, filteredEntries: []),
      );

  void applyFilter(List<FeelingEntry> allEntries, StatisticsFilter filter) {
    final now = DateTime.now();
    List<FeelingEntry> result;

    switch (filter) {
      case StatisticsFilter.day:
        result = allEntries
            .where(
              (e) =>
                  e.date.year == now.year &&
                  e.date.month == now.month &&
                  e.date.day == now.day,
            )
            .toList();
        break;
      case StatisticsFilter.week:
        final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
        final endOfWeek = startOfWeek.add(const Duration(days: 6));
        result = allEntries
            .where(
              (e) =>
                  e.date.isAfter(
                    startOfWeek.subtract(const Duration(seconds: 1)),
                  ) &&
                  e.date.isBefore(endOfWeek.add(const Duration(days: 1))),
            )
            .toList();
        break;
      case StatisticsFilter.month:
        result = allEntries
            .where((e) => e.date.year == now.year && e.date.month == now.month)
            .toList();
        break;
      case StatisticsFilter.year:
        result = allEntries.where((e) => e.date.year == now.year).toList();
        break;
    }

    state = state.copyWith(filter: filter, filteredEntries: result);
  }
}
