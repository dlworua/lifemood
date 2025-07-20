import 'package:flutter/material.dart';

class EmojiSelector extends StatelessWidget {
  final void Function(String emoji) onEmojiSelected;

  const EmojiSelector({required this.onEmojiSelected, super.key});

  @override
  Widget build(BuildContext context) {
    const emojis = ['😊', '😢', '😠', '😴', '🥰', '😮', '😎'];

    return Wrap(
      spacing: 10,
      children: emojis.map((emoji) {
        return GestureDetector(
          onTap: () => onEmojiSelected(emoji),
          child: Text(emoji, style: const TextStyle(fontSize: 32)),
        );
      }).toList(),
    );
  }
}
