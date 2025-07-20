import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/model/feeling_entry.dart';
import '../../view_model/feeling_view_model.dart';
import '../widgets/emoji_selector.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  String? _selectedEmoji;
  final _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final feelings = ref.watch(feelingViewModelProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('LifeMood')),
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
                      _controller.clear();
                      setState(() => _selectedEmoji = null);
                    },
              child: const Text('기록하기'),
            ),
            const SizedBox(height: 20),
            const Divider(),
            const Text('오늘까지의 감정 기록'),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
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
          ],
        ),
      ),
    );
  }
}
