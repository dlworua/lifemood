import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lifemood/data/model/feeling_entry.dart';
import 'package:lifemood/view/widgets/emoji_selector.dart';
import 'package:lifemood/view_model/feeling_view_model.dart';

class FeelingEditorPage extends ConsumerStatefulWidget {
  final DateTime selectedDate;
  final String? initialEmoji;
  final String? initialNote;
  final String? entryId; // null이면 새 항목

  const FeelingEditorPage({
    super.key,
    required this.selectedDate,
    this.initialEmoji,
    this.initialNote,
    this.entryId,
  });

  @override
  ConsumerState<FeelingEditorPage> createState() => _FeelingEditorPageState();
}

class _FeelingEditorPageState extends ConsumerState<FeelingEditorPage> {
  late TextEditingController _noteController;
  String? _selectedEmoji;

  @override
  void initState() {
    super.initState();
    _noteController = TextEditingController(text: widget.initialNote ?? '');
    _selectedEmoji = widget.initialEmoji;
  }

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  void _saveFeeling() {
    final emoji = _selectedEmoji;
    final note = _noteController.text.trim();

    if (emoji == null || note.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('이모지와 노트를 모두 입력해주세요.')));
      return;
    }

    final feeling = FeelingEntry(
      id: widget.entryId ?? UniqueKey().toString(),
      date: widget.selectedDate,
      emoji: emoji,
      note: note,
    );

    if (widget.entryId != null) {
      ref.read(feelingViewModelProvider.notifier).updateFeeling(feeling);
    } else {
      ref.read(feelingViewModelProvider.notifier).addFeeling(feeling);
    }

    Navigator.pop(context); // 저장 후 뒤로 이동
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.entryId != null ? '감정 수정하기' : '감정 기록하기'),
        actions: [
          IconButton(icon: const Icon(Icons.check), onPressed: _saveFeeling),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${widget.selectedDate.year}-${widget.selectedDate.month.toString().padLeft(2, '0')}-${widget.selectedDate.day.toString().padLeft(2, '0')}',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 16),
            EmojiSelector(
              initialEmoji: _selectedEmoji,
              onEmojiSelected: (emoji) {
                setState(() {
                  _selectedEmoji = emoji;
                });
              },
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _noteController,
              maxLines: 5,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: '오늘의 감정을 기록해보세요',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
