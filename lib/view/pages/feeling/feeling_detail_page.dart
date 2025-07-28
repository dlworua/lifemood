import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/model/feeling_entry.dart';
import 'feeling_editor_page.dart';
import '../../../view_model/feeling_view_model.dart';

class FeelingDetailPage extends ConsumerStatefulWidget {
  final DateTime selectedDate;
  final List<FeelingEntry> feelingEntries;

  const FeelingDetailPage({
    super.key,
    required this.selectedDate,
    required this.feelingEntries,
  });

  @override
  ConsumerState<FeelingDetailPage> createState() => _FeelingDetailPageState();
}

class _FeelingDetailPageState extends ConsumerState<FeelingDetailPage> {
  @override
  Widget build(BuildContext context) {
    final allFeelings = ref.watch(feelingViewModelProvider);
    final selectedEntries = allFeelings.where((e) {
      return e.date.year == widget.selectedDate.year &&
          e.date.month == widget.selectedDate.month &&
          e.date.day == widget.selectedDate.day;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          '${widget.selectedDate.year}-${widget.selectedDate.month}-${widget.selectedDate.day} 감정 기록',
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: '감정 추가',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                      FeelingEditorPage(selectedDate: widget.selectedDate),
                ),
              );
            },
          ),
        ],
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: selectedEntries.length,
        separatorBuilder: (_, __) => const Divider(),
        itemBuilder: (context, index) {
          final entry = selectedEntries[index];
          return ListTile(
            leading: Text(entry.emoji, style: const TextStyle(fontSize: 28)),
            title: Text(entry.note),
            subtitle: Text(entry.date.toIso8601String()),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => FeelingEditorPage(
                    selectedDate: entry.date,
                    initialEmoji: entry.emoji,
                    initialNote: entry.note,
                    entryId: entry.id,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
