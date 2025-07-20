import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'view/pages/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e, stack) {
    print('🔥 Firebase init failed: $e');
  }

  runApp(const ProviderScope(child: LifeMoodApp()));
}

class LifeMoodApp extends StatelessWidget {
  const LifeMoodApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Life Mood',
      theme: ThemeData(
        fontFamily: 'Pretendard',
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF8B5E3C)),
        useMaterial3: true,
      ),
      home: HomePage(),
    );
  }
}
