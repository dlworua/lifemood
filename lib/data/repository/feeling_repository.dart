import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/feeling_entry.dart';

class FeelingRepository {
  final _collection = FirebaseFirestore.instance.collection('feelings');

  Future<void> saveFeeling(FeelingEntry entry) async {
    await _collection.doc(entry.date.toIso8601String()).set(entry.toJson());
  }

  Future<List<FeelingEntry>> getFeelings() async {
    final snapshot = await _collection.get();
    return snapshot.docs
        .map((doc) => FeelingEntry.fromJson(doc.data()))
        .toList();
  }
}
