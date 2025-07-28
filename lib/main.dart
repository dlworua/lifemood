import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lifemood/view/pages/auth/login_page.dart';
import 'package:lifemood/view/pages/auth/register_page.dart';
import 'package:lifemood/view/pages/feeling/feeling_editor_page.dart';
import 'package:lifemood/view/pages/home_page.dart';
import 'package:lifemood/view/pages/service/notification_service.dart';
import 'package:lifemood/view_model/auth_view_model.dart';
import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';

/// Navigator 전역 접근을 위한 key
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await initializeNotifications();

  setNotificationClickHandler(() {
    navigatorKey.currentState?.push(
      MaterialPageRoute(
        builder: (_) => FeelingEditorPage(selectedDate: DateTime.now()),
      ),
    );
  });

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

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
      navigatorKey: navigatorKey,
      routes: {'/register': (_) => const RegisterPage()},
      home: user == null ? const LoginPage() : const HomePage(),
    );
  }
}
