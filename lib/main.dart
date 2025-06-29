// Flutter 진입점: 내 바몬 리스트 → 상세 페이지 네비게이션
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'screens/login_page.dart';
import 'screens/barmon_list_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://bqjefeprwlhrhrqqqutd.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImJxamVmZXByd2xocmhycXFxdXRkIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTExMjA0MzMsImV4cCI6MjA2NjY5NjQzM30.z0TYKWWMQpuhZZ7tfXinPnW3Ez-dqbT3k-IApXQSPA8',
  );

  final prefs = await SharedPreferences.getInstance();
  final isGuest = prefs.getBool('is_guest') ?? false;
  final session = Supabase.instance.client.auth.currentSession;

  String initialRoute;
  Map<String, dynamic>? initialArgs;
  if (session != null) {
    initialRoute = '/main';
    initialArgs = null;
  } else if (isGuest) {
    initialRoute = '/main';
    initialArgs = {'guest': true};
  } else {
    initialRoute = '/login';
    initialArgs = null;
  }

  await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  runApp(ProviderScope(child: MyApp(
    initialRoute: initialRoute,
    initialArgs: initialArgs,
  )));
}

class MyApp extends StatelessWidget {
  final String initialRoute;
  final Map<String, dynamic>? initialArgs;
  const MyApp({required this.initialRoute, required this.initialArgs, super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Barcodian',
      initialRoute: initialRoute,
      routes: {
        '/login': (context) => const LoginPage(),
        '/barmon': (context) => const BarmonListPage(),
        '/main': (context) => const BarmonListPage(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}

class TitleScreen extends StatefulWidget {
  const TitleScreen({super.key});

  @override
  State<TitleScreen> createState() => _TitleScreenState();
}

class _TitleScreenState extends State<TitleScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacityAnim;

  // 배경 이미지 순환 관련
  final List<String> _bgImages = [
    'assets/images/title.jpg',
    'assets/images/title2.jpg',
    'assets/images/title3.jpg',
    'assets/images/title4.jpg',
  ];
  int _bgIndex = 0;
  double _bgOpacity = 1.0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);
    _opacityAnim = Tween<double>(begin: 1.0, end: 0.2).animate(_controller);
    _startBgFadeLoop();
  }

  void _startBgFadeLoop() async {
    while (mounted) {
      // Fade out
      setState(() { _bgOpacity = 1.0; });
      await Future.delayed(const Duration(seconds: 3));
      for (double o = 1.0; o >= 0.0; o -= 0.05) {
        await Future.delayed(const Duration(milliseconds: 30));
        if (!mounted) return;
        setState(() { _bgOpacity = o; });
      }
      // 이미지 변경
      setState(() {
        _bgIndex = (_bgIndex + 1) % _bgImages.length;
      });
      // Fade in
      for (double o = 0.0; o <= 1.0; o += 0.05) {
        await Future.delayed(const Duration(milliseconds: 30));
        if (!mounted) return;
        setState(() { _bgOpacity = o; });
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _goToMain() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const BarmonListPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: _goToMain,
      child: Stack(
        fit: StackFit.expand,
        children: [
          AnimatedOpacity(
            opacity: _bgOpacity,
            duration: const Duration(milliseconds: 300),
            child: Image.asset(
              _bgImages[_bgIndex],
              fit: BoxFit.cover,
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 300.0), // 기존 64.0에서 20px 위로
              child: FadeTransition(
                opacity: _opacityAnim,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                  decoration: BoxDecoration(
                    color: Colors.black.withAlpha(153),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: const Text(
                    'TAP TO START',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
