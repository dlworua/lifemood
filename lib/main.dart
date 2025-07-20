import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lifemood/view/pages/auth/login_page.dart';
import 'package:lifemood/view/pages/auth/register_page.dart';
import 'package:lifemood/view_model/auth_view_model.dart';
import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'view/pages/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    // ignore: unused_catch_stack
  } catch (e, stack) {
    print('🔥 Firebase init failed: $e');
    return; // Firebase 초기화 실패 시 앱 실행 중단
  }

  runApp(const ProviderScope(child: LifeMoodApp()));
}

class LifeMoodApp extends ConsumerWidget {
  const LifeMoodApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authViewModelProvider);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Lifemood',
      routes: {'/register': (_) => const RegisterPage()},
      home: user == null ? const LoginPage() : const HomePage(),
    );
  }
}
