// lib/view/pages/home_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lifemood/view/pages/feeling/feeling_editor_page.dart';
import '../../view_model/feeling_view_model.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final feelings = ref.watch(feelingViewModelProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('LifeMood')),
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
                  MaterialPageRoute(builder: (_) => const FeelingEditorPage()),
                );
              },
              child: const Text('감정 기록하기'),
            ),
          ],
        ),
      ),
    );
  }
}
