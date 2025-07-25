// lib/view/pages/home_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lifemood/view/pages/calendar/calendar_page.dart';
import 'package:lifemood/view/pages/feeling/feeling_editor_page.dart';
import 'package:lifemood/view/pages/service/notification_service.dart';
import 'package:lifemood/view/pages/statistics/statistics_page.dart';
import '../../view_model/feeling_view_model.dart';
import '../../view_model/auth_view_model.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  @override
  void initState() {
    super.initState();
    // 데이터 불러오기 호출
    Future.microtask(
      () => ref.read(feelingViewModelProvider.notifier).loadFeelings(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final feelings = ref.watch(feelingViewModelProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('LifeMood'),
        actions: [
          ElevatedButton(
            onPressed: () async {
              await ref.read(authViewModelProvider.notifier).signOut();
              if (mounted) {
                Navigator.of(context).popUntil((route) => route.isFirst);
              }
            },
            child: const Text('로그아웃'),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text('오늘까지의 감정 기록'),
            const SizedBox(height: 10),
            Expanded(
              child: feelings.isEmpty
                  ? const Center(child: Text('아직 감정 기록이 없습니다.'))
                  : ListView.builder(
                      itemCount: feelings.length,
                      itemBuilder: (context, index) {
                        final entry = feelings[index];
                        return ListTile(
                          leading: Text(
                            entry.emoji,
                            style: const TextStyle(fontSize: 24),
                          ),
                          title: Text(entry.note),
                          subtitle: Text(
                            entry.date.toIso8601String().substring(0, 10),
                          ),
                        );
                      },
                    ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        FeelingEditorPage(selectedDate: DateTime.now()),
                  ),
                );
              },
              child: const Text('감정 기록하기'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const StatisticsPage()),
                );
              },
              child: const Text('감정 통계 보기'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const CalendarPage()),
                );
              },
              child: const Text('감정 캘린더 보기'),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showNotification(); // ✅ 알림 호출
        },
        child: const Icon(Icons.notifications),
      ),
    );
  }
}
