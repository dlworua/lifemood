// lib/view/pages/feeling/feeling_editor_page.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lifemood/view/widgets/emoji_selector.dart';
import '../../../../data/model/feeling_entry.dart';
import '../../../../view_model/feeling_view_model.dart';

class FeelingEditorPage extends ConsumerStatefulWidget {
  const FeelingEditorPage({super.key});

  @override
  ConsumerState<FeelingEditorPage> createState() => _FeelingEditorPageState();
}

class _FeelingEditorPageState extends ConsumerState<FeelingEditorPage> {
  String? _selectedEmoji;
  final _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('감정 기록하기')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text("오늘 하루, 당신의 감정은 어땠나요?"),
            const SizedBox(height: 10),
            EmojiSelector(
              onEmojiSelected: (emoji) {
                setState(() => _selectedEmoji = emoji);
              },
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _controller,
              decoration: const InputDecoration(hintText: '오늘을 간단히 기록해보세요'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _selectedEmoji == null
                  ? null
                  : () {
                      final entry = FeelingEntry(
                        date: DateTime.now(),
                        emoji: _selectedEmoji!,
                        note: _controller.text,
                      );
                      ref
                          .read(feelingViewModelProvider.notifier)
                          .addFeeling(entry);
                      Navigator.pop(context); // 홈으로 복귀
                    },
              child: const Text('기록하기'),
            ),
          ],
        ),
      ),
    );
  }
}
