import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../data/repository/auth_repository.dart';

final authRepositoryProvider = Provider((ref) => AuthRepository());

final authViewModelProvider = StateNotifierProvider<AuthViewModel, User?>(
  (ref) => AuthViewModel(ref.read(authRepositoryProvider)),
);

class AuthViewModel extends StateNotifier<User?> {
  final AuthRepository _authRepository;

  AuthViewModel(this._authRepository) : super(null) {
    _authRepository.authStateChanges.listen((user) {
      state = user;
    });
  }

  Future<void> signIn(String email, String password) async {
    state = await _authRepository.signIn(email, password);
  }

  Future<void> register(String email, String password) async {
    state = await _authRepository.register(email, password);
  }

  Future<void> signOut() async {
    await _authRepository.signOut();
  }
}
