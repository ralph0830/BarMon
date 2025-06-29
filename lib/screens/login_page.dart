import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart' show Supabase, OAuthProvider;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  String? _error;
  bool _showGuestWarning = false;

  Future<void> _signIn() async {
    try {
      final response = await Supabase.instance.client.auth.signInWithPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );
      if (response.user == null) {
        setState(() => _error = '로그인 실패');
      } else {
        setState(() => _error = null);
        if (!mounted) return;
        Navigator.of(context).pushReplacementNamed('/barmon');
      }
    } catch (e) {
      setState(() => _error = e.toString());
    }
  }

  Future<void> _signUp() async {
    try {
      final response = await Supabase.instance.client.auth.signUp(
        email: _emailController.text,
        password: _passwordController.text,
      );
      if (response.user == null) {
        setState(() => _error = '회원가입 실패');
      } else {
        setState(() => _error = null);
        if (!mounted) return;
        Navigator.of(context).pushReplacementNamed('/barmon');
      }
    } catch (e) {
      setState(() => _error = e.toString());
    }
  }

  Future<void> _guestLogin() async {
    setState(() => _showGuestWarning = true);
  }

  Future<void> _confirmGuest() async {
    final prefs = await SharedPreferences.getInstance();
    String? guestId = prefs.getString('guest_id');
    guestId ??= DateTime.now().millisecondsSinceEpoch.toString();
    await prefs.setString('guest_id', guestId);
    if (!mounted) return;
    Navigator.of(context).pushReplacementNamed('/barmon', arguments: {'guest': true, 'guestId': guestId});
  }

  Future<void> _signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        setState(() => _error = '구글 로그인 취소됨');
        return;
      }
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final idToken = googleAuth.idToken;
      final accessToken = googleAuth.accessToken;

      final response = await Supabase.instance.client.auth.signInWithIdToken(
        provider: OAuthProvider.google,
        idToken: idToken!,
        accessToken: accessToken,
      );
      if (response.user == null) {
        setState(() => _error = '구글 로그인 실패');
      } else {
        setState(() => _error = null);
        if (!mounted) return;
        Navigator.of(context).pushReplacementNamed('/barmon');
      }
    } catch (e) {
      setState(() => _error = e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('로그인/회원가입 또는 GUEST')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(controller: _emailController, decoration: const InputDecoration(labelText: '이메일')),
            TextField(controller: _passwordController, decoration: const InputDecoration(labelText: '비밀번호'), obscureText: true),
            const SizedBox(height: 8),
            InkWell(
              onTap: _signInWithGoogle,
              child: Image.asset('assets/google_signin_dark.png', height: 40),
            ),
            if (_error != null) Text(_error!, style: const TextStyle(color: Colors.red)),
            const SizedBox(height: 16),
            ElevatedButton(onPressed: _signIn, child: const Text('로그인')),
            ElevatedButton(onPressed: _signUp, child: const Text('회원가입')),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: _guestLogin,
              style: ElevatedButton.styleFrom(backgroundColor: Colors.grey[700]),
              child: const Text('GUEST로 이용', style: TextStyle(color: Colors.white)),
            ),
            if (_showGuestWarning)
              AlertDialog(
                title: const Text('GUEST 모드 안내'),
                content: const Text('GUEST는 게임 진행 상황이 저장되지 않을 수 있습니다.'),
                actions: [
                  TextButton(onPressed: () => setState(() => _showGuestWarning = false), child: const Text('취소')),
                  ElevatedButton(onPressed: _confirmGuest, child: const Text('GUEST로 시작')),
                ],
              ),
          ],
        ),
      ),
    );
  }
} 