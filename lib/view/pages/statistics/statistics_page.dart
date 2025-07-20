import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lifemood/data/model/feeling_entry.dart';
import 'package:lifemood/data/model/statistics_filter.dart';
import 'package:lifemood/view_model/feeling_view_model.dart';
import 'package:lifemood/view_model/statistics_view_model.dart';

class StatisticsPage extends ConsumerWidget {
  const StatisticsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allFeelings = ref.watch(feelingViewModelProvider);
    final statsState = ref.watch(statisticsViewModelProvider);
    final statsVM = ref.read(statisticsViewModelProvider.notifier);

    // 최초 진입 시 필터 적용 (빌드 중 직접 호출 금지)
    ref.listen<List<FeelingEntry>>(feelingViewModelProvider, (previous, next) {
      if (next.isNotEmpty) {
        statsVM.applyFilter(next, statsState.filter);
      }
    });

    // PieChart 데이터 준비
    final frequency = <String, int>{};
    for (final f in statsState.filteredEntries) {
      frequency[f.emoji] = (frequency[f.emoji] ?? 0) + 1;
    }

    final pieSections = frequency.entries.map((entry) {
      return PieChartSectionData(
        title: '${entry.key} (${entry.value})',
        value: entry.value.toDouble(),
        color: Colors.primaries[entry.key.hashCode % Colors.primaries.length],
        radius: 60,
        titleStyle: const TextStyle(fontSize: 14),
      );
    }).toList();

    return Scaffold(
      appBar: AppBar(title: const Text('감정 통계')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: allFeelings.isEmpty
            ? const Center(child: Text('아직 기록이 없어요 😢'))
            : Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      DropdownButton<StatisticsFilter>(
                        value: statsState.filter,
                        onChanged: (value) {
                          if (value != null) {
                            statsVM.applyFilter(allFeelings, value);
                          }
                        },
                        items: StatisticsFilter.values.map((filter) {
                          return DropdownMenuItem(
                            value: filter,
                            child: Text(_getFilterLabel(filter)),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    '가장 많이 사용한 감정',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: PieChart(
                      PieChartData(
                        sections: pieSections,
                        centerSpaceRadius: 40,
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

String _getFilterLabel(StatisticsFilter type) {
  switch (type) {
    case StatisticsFilter.day:
      return '오늘';
    case StatisticsFilter.week:
      return '이번 주';
    case StatisticsFilter.month:
      return '이번 달';
    case StatisticsFilter.year:
      return '올해';
  }
}
