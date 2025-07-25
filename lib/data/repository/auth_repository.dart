import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<User?> signIn(String email, String password) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      await _saveUserIfNotExists(credential.user);
      return credential.user;
    } on FirebaseAuthException catch (e) {
      throw e.message ?? '알 수 없는 오류';
    } catch (e) {
      throw '로그인 중 알 수 없는 오류가 발생했습니다.';
    }
  }

  Future<User?> register(String email, String password) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await _saveUserIfNotExists(credential.user);
      return credential.user;
    } on FirebaseAuthException catch (e) {
      throw e.message ?? '알 수 없는 오류';
    } catch (e) {
      throw '회원가입 중 알 수 없는 오류가 발생했습니다.';
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  Future<void> _saveUserIfNotExists(User? user) async {
    if (user == null) return;

    final docRef = _firestore.collection('users').doc(user.uid);
    final doc = await docRef.get();

    if (!doc.exists) {
      await docRef.set({
        'uid': user.uid,
        'email': user.email,
        'createdAt': FieldValue.serverTimestamp(),
      });
    }
  }
}
