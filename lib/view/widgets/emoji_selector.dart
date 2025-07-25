import 'package:flutter/material.dart';

class EmojiSelector extends StatefulWidget {
  final String? initialEmoji;
  final void Function(String emoji) onEmojiSelected;

  const EmojiSelector({
    super.key,
    this.initialEmoji,
    required this.onEmojiSelected,
  });

  @override
  State<EmojiSelector> createState() => _EmojiSelectorState();
}

class _EmojiSelectorState extends State<EmojiSelector> {
  String? _selectedEmoji;

  final List<String> _emojis = ['😊', '😢', '😠', '😴', '🥰', '😮', '😎'];

  @override
  void initState() {
    super.initState();
    _selectedEmoji = widget.initialEmoji;
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10,
      children: _emojis.map((emoji) {
        final isSelected = emoji == _selectedEmoji;
        return GestureDetector(
          onTap: () {
            setState(() {
              _selectedEmoji = emoji;
            });
            widget.onEmojiSelected(emoji);
          },
          child: Container(
            padding: const EdgeInsets.all(4),
            decoration: isSelected
                ? BoxDecoration(
                    border: Border.all(color: Colors.blue, width: 2),
                    borderRadius: BorderRadius.circular(8),
                  )
                : null,
            child: Text(emoji, style: const TextStyle(fontSize: 32)),
          ),
        );
      }).toList(),
    );
  }
}
