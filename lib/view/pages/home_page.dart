// lib/view/pages/home_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../view_model/feeling_view_model.dart';

class HomePage extends ConsumerWidget {
  HomePage({super.key});

  final _controller = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final feelings = ref.watch(feelingViewModelProvider);
    final vm = ref.read(feelingViewModelProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Life Mood'),
        backgroundColor: const Color(0xFF8B5E3C), // 브라운
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // 입력창
            TextField(
              controller: _controller,
              maxLines: 2,
              decoration: const InputDecoration(
                hintText: '오늘의 기분이나 있었던 일을 적어보세요',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            // 저장 버튼
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFFA726), // 오렌지
              ),
              onPressed: () async {
                if (_controller.text.trim().isEmpty) return;

                await vm.addFeeling(_controller.text.trim());
                _controller.clear();
                FocusScope.of(context).unfocus();
              },
              child: const Text('기록하기'),
            ),
            const SizedBox(height: 24),
            // 감정 리스트
            Expanded(
              child: feelings.isEmpty
                  ? const Center(child: Text('아직 기록이 없어요 🫥'))
                  : ListView.builder(
                      itemCount: feelings.length,
                      itemBuilder: (context, index) {
                        final feeling = feelings[index];
                        return Card(
                          color: const Color(0xFFFFF3E0), // 아이보리 느낌
                          child: ListTile(
                            title: Text(feeling.content),
                            subtitle: Text(
                              '${feeling.createdAt.year}-${feeling.createdAt.month.toString().padLeft(2, '0')}-${feeling.createdAt.day.toString().padLeft(2, '0')}',
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
