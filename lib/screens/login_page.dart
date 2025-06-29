import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:logger/logger.dart';

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
  final Logger _logger = Logger();

  static const String _googleWebClientId = '673743326292-mbvjn4ltvmcjoi821vb8gnrp2c3vcu26.apps.googleusercontent.com';

  Future<void> _signIn() async {
    setState(() => _error = null);
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('is_guest');
      final response = await Supabase.instance.client.auth.signInWithPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );
      if (response.user != null) {
        if (!mounted) return;
        Navigator.of(context).pushReplacementNamed('/main');
      }
    } catch (e) {
      setState(() => _error = e.toString());
    }
  }

  Future<void> _showSignUpDialog() async {
    final emailController = TextEditingController();
    final passwordController = TextEditingController();
    final passwordConfirmController = TextEditingController();
    String? error;
    bool isLoading = false;
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (builderContext, setState) {
            return AlertDialog(
              title: const Text('회원가입'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: emailController,
                    decoration: const InputDecoration(labelText: '이메일(ID)'),
                    keyboardType: TextInputType.emailAddress,
                  ),
                  TextField(
                    controller: passwordController,
                    decoration: const InputDecoration(labelText: '비밀번호'),
                    obscureText: true,
                  ),
                  TextField(
                    controller: passwordConfirmController,
                    decoration: const InputDecoration(labelText: '비밀번호 확인'),
                    obscureText: true,
                  ),
                  if (error != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(error!, style: const TextStyle(color: Colors.red)),
                    ),
                  const SizedBox(height: 12),
                  InkWell(
                    onTap: () async {
                      Navigator.of(builderContext).pop();
                      await _signInWithGoogle();
                    },
                    child: Image.asset('assets/images/google_signin_dark.png', height: 40),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: isLoading ? null : () => Navigator.of(builderContext).pop(),
                  child: const Text('취소'),
                ),
                ElevatedButton(
                  onPressed: isLoading
                      ? null
                      : () async {
                          final email = emailController.text.trim();
                          final pw = passwordController.text;
                          final pw2 = passwordConfirmController.text;
                          if (!RegExp(r'^.+@.+\..+').hasMatch(email)) {
                            setState(() => error = '올바른 이메일 형식이 아닙니다.');
                            return;
                          }
                          if (pw.length < 6) {
                            setState(() => error = '비밀번호는 6자 이상이어야 합니다.');
                            return;
                          }
                          if (pw != pw2) {
                            setState(() => error = '비밀번호가 일치하지 않습니다.');
                            return;
                          }
                          setState(() { error = null; isLoading = true; });
                          try {
                            final response = await Supabase.instance.client.auth.signUp(
                              email: email,
                              password: pw,
                            );
                            if (response.user == null) {
                              setState(() { error = '회원가입 실패'; isLoading = false; });
                            } else {
                              if (!builderContext.mounted) return;
                              Navigator.of(builderContext).pop();
                              Navigator.of(builderContext).pushReplacementNamed('/barmon');
                            }
                          } catch (e) {
                            setState(() { error = e.toString(); isLoading = false; });
                          }
                        },
                  child: isLoading ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2)) : const Text('회원가입'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> _guestLogin() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('is_guest', true);
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
      final GoogleSignIn googleSignIn = GoogleSignIn(
        serverClientId: _googleWebClientId, // Web Application Client ID 지정
      );
      _logger.d('구글 로그인 시도');
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      _logger.d('googleUser: $googleUser');
      if (googleUser == null) {
        setState(() => _error = '구글 로그인 취소됨 또는 계정 선택 화면이 뜨지 않음');
        _logger.d('구글 로그인 실패: 계정 선택 화면이 뜨지 않음');
        return;
      }
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      _logger.d('googleAuth: $googleAuth');
      final idToken = googleAuth.idToken;
      final accessToken = googleAuth.accessToken;
      _logger.d('idToken: $idToken');
      _logger.d('accessToken: $accessToken');

      if (idToken == null || accessToken == null) {
        setState(() => _error = '구글 인증 토큰을 가져오지 못했습니다. 구글 콘솔/Supabase 설정을 확인하세요.');
        _logger.d('구글 인증 토큰 null');
        return;
      }

      final response = await Supabase.instance.client.auth.signInWithIdToken(
        provider: OAuthProvider.google,
        idToken: idToken,
        accessToken: accessToken,
      );
      _logger.d('supabase response: ${response.user}');
      if (response.user == null) {
        setState(() => _error = '구글 로그인 실패');
        _logger.d('supabase 로그인 실패');
      } else {
        setState(() => _error = null);
        if (!mounted) return;
        Navigator.of(context).pushReplacementNamed('/barmon');
      }
    } catch (e, stack) {
      setState(() => _error = e.toString());
      _logger.e('구글 로그인 예외: $e');
      _logger.e(stack);
    }
  }

  Future<void> _unlinkGoogleIdentity() async {
    try {
      final identities = await Supabase.instance.client.auth.getUserIdentities();
      final googleIdentity = (identities as List<UserIdentity?>?)
          ?.where((identity) => identity?.provider == 'google')
          .cast<UserIdentity?>()
          .firstOrNull;
      if (googleIdentity != null) {
        await Supabase.instance.client.auth.unlinkIdentity(googleIdentity);
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('구글 계정이 성공적으로 분리되었습니다.')),
        );
      } else {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('구글 계정이 연결되어 있지 않습니다.')),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('분리 실패: $e')),
      );
    }
  }

  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('is_guest');
    await Supabase.instance.client.auth.signOut();
    if (!mounted) return;
    Navigator.of(context).pushReplacementNamed('/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('로그인/회원가입 또는 GUEST')),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(controller: _emailController, decoration: const InputDecoration(labelText: '이메일')),
              TextField(controller: _passwordController, decoration: const InputDecoration(labelText: '비밀번호'), obscureText: true),
              const SizedBox(height: 8),
              InkWell(
                onTap: _signInWithGoogle,
                child: Image.asset('assets/images/google_signin_dark.png', height: 40),
              ),
              if (_error != null) Text(_error!, style: const TextStyle(color: Colors.red)),
              const SizedBox(height: 16),
              ElevatedButton(onPressed: _signIn, child: const Text('로그인')),
              ElevatedButton(
                onPressed: _showSignUpDialog,
                child: const Text('회원가입'),
              ),
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
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _unlinkGoogleIdentity,
                style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
                child: const Text('구글 계정 분리(임시)', style: TextStyle(color: Colors.white)),
              ),
              ElevatedButton(
                onPressed: _logout,
                style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
                child: const Text('로그아웃', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }
} 