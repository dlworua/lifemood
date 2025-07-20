import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../view_model/auth_view_model.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  void _login() async {
    await ref
        .read(authViewModelProvider.notifier)
        .signIn(_emailController.text.trim(), _passwordController.text.trim());
  }

  void _goToRegister(BuildContext context) {
    Navigator.pushNamed(context, '/register');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("로그인")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: '이메일'),
            ),
            TextField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(labelText: '비밀번호'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(onPressed: _login, child: const Text("로그인")),
            TextButton(
              onPressed: () => _goToRegister(context),
              child: const Text("회원가입"),
            ),
          ],
        ),
      ),
    );
  }
}
