// lib/data/model/feeling_entry.dart
import 'package:cloud_firestore/cloud_firestore.dart';

class FeelingEntry {
  final String id;
  final String content;
  final DateTime createdAt;

  FeelingEntry({
    required this.id,
    required this.content,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'content': content,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  factory FeelingEntry.fromMap(Map<String, dynamic> map) {
    return FeelingEntry(
      id: map['id'] ?? '',
      content: map['content'] ?? '',
      createdAt: (map['createdAt'] as Timestamp).toDate(),
    );
  }
}
