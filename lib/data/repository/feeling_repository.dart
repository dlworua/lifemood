import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../model/feeling_entry.dart';

class FeelingRepository {
  final _db = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  Future<FeelingEntry> saveFeeling(FeelingEntry entry) async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) throw Exception('로그인된 유저가 없습니다.');

    final userFeelingCollection = _db
        .collection('users')
        .doc(uid)
        .collection('feelings');

    final docRef = userFeelingCollection.doc(); // 자동 ID 생성
    await docRef.set(entry.toJson());

    return FeelingEntry(
      id: docRef.id,
      date: entry.date,
      emoji: entry.emoji,
      note: entry.note,
    );
  }

  Future<List<FeelingEntry>> getFeelings() async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) throw Exception('로그인된 유저가 없습니다.');

    final userFeelingCollection = _db
        .collection('users')
        .doc(uid)
        .collection('feelings');
    final snapshot = await userFeelingCollection.get();

    return snapshot.docs
        .map((doc) => FeelingEntry.fromJson(doc.id, doc.data()))
        .toList();
  }

  Future<void> updateFeeling(FeelingEntry entry) async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) throw Exception('로그인된 유저가 없습니다.');

    final docRef = _db
        .collection('users')
        .doc(uid)
        .collection('feelings')
        .doc(entry.id);

    await docRef.update(entry.toJson());
  }
}
