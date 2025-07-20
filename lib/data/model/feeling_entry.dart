class FeelingEntry {
  final DateTime date;
  final String emoji;
  final String note;

  FeelingEntry({required this.date, required this.emoji, required this.note});

  Map<String, dynamic> toJson() => {
    'date': date.toIso8601String(),
    'emoji': emoji,
    'note': note,
  };

  factory FeelingEntry.fromJson(Map<String, dynamic> json) => FeelingEntry(
    date: DateTime.parse(json['date']),
    emoji: json['emoji'],
    note: json['note'],
  );
}
