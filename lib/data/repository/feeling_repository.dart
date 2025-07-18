// lib/data/repository/feeling_repository.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/feeling_entry.dart';

class FeelingRepository {
  final _collection = FirebaseFirestore.instance.collection('feelings');

  Future<void> addFeeling(FeelingEntry entry) async {
    await _collection.doc(entry.id).set(entry.toMap());
  }

  Future<List<FeelingEntry>> getFeelings() async {
    final snapshot = await _collection
        .orderBy('createdAt', descending: true)
        .get();

    return snapshot.docs
        .map((doc) => FeelingEntry.fromMap(doc.data()))
        .toList();
  }
}
