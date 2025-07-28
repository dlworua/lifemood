// model/feeling_entry.dart
class FeelingEntry {
  final String id; // Firestore 문서 ID
  final DateTime date;
  final String emoji;
  final String note;

  FeelingEntry({
    required this.id,
    required this.date,
    required this.emoji,
    required this.note,
  });

  Map<String, dynamic> toJson() => {
    'date': date.toIso8601String(),
    'emoji': emoji,
    'note': note,
  };

  factory FeelingEntry.fromJson(String id, Map<String, dynamic> json) {
    return FeelingEntry(
      id: id,
      date: DateTime.parse(json['date']),
      emoji: json['emoji'],
      note: json['note'],
    );
  }
}
