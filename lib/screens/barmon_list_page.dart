// 내 바몬 리스트 페이지 (스캔 버튼 포함)
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/user_barmon_provider.dart';
import '../widgets/barmon_card.dart';
import 'barmon_detail_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/barmon.dart';
import '../guest_barmon_provider.dart';
import '../providers/barmon_provider.dart';
import 'barcode_scan_page.dart';
import 'battle_arena_page.dart';
import 'base_page.dart';
import 'dart:math';
import 'package:shared_preferences/shared_preferences.dart';

class BarmonListPage extends ConsumerStatefulWidget {
  const BarmonListPage({super.key});
  @override
  ConsumerState<BarmonListPage> createState() => _BarmonListPageState();
}

class _BarmonListPageState extends ConsumerState<BarmonListPage> {
  final PageController _pageController = PageController();
  bool _initialized = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  String? get _userId => Supabase.instance.client.auth.currentUser?.id;
  bool get _isGuest => (ModalRoute.of(context)?.settings.arguments as Map?)?['guest'] == true;
  bool get _isGoogleUser {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) return false;
    final identities = user.identities;
    if (identities == null) return false;
    return identities.any((id) => id.provider == 'google');
  }

  Future<void> _logout() async {
    if (!_isGuest) {
      await Supabase.instance.client.auth.signOut();
    }
    if (!mounted) return;
    Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
  }

  void _openDrawer() {
    _scaffoldKey.currentState?.openDrawer();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized && !_isGuest && _userId != null) {
      Future.microtask(() => ref.read(userBarmonProvider.notifier).fetchUserBarmons(_userId!));
      _initialized = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    final barMons = _isGuest ? ref.watch(guestBarmonProvider) : ref.watch(userBarmonProvider);
    // 디버그: 각 바몬의 id와 imageUrl 출력
    for (final barMon in barMons) {
      debugPrint('BarMon id: \x1B[33m\x1B[1m\x1B[4m[33m[1m[4m${barMon.id}\x1B[0m, imageUrl: \x1B[36m${barMon.imageUrl}\x1B[0m');
    }
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: const Color(0xFFF7F7F7),
      drawer: Drawer(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final height = constraints.maxHeight;
            return Align(
              alignment: Alignment.topCenter,
              child: SizedBox(
                height: height * 0.8,
                child: SafeArea(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                        child: Row(
                          children: [
                            const Icon(Icons.account_circle, size: 32),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      _isGuest
                                        ? 'GUEST'
                                        : (Supabase.instance.client.auth.currentUser?.email ?? '알 수 없음'),
                                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  if (_isGuest)
                                    Padding(
                                      padding: const EdgeInsets.only(left: 8),
                                      child: OutlinedButton(
                                        onPressed: () {
                                          Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
                                        },
                                        style: OutlinedButton.styleFrom(minimumSize: const Size(0, 32), padding: const EdgeInsets.symmetric(horizontal: 12)),
                                        child: const Text('회원가입', style: TextStyle(fontSize: 13)),
                                      ),
                                    ),
                                  if (!_isGuest && _isGoogleUser)
                                    Padding(
                                      padding: const EdgeInsets.only(left: 4),
                                      child: Image.asset(
                                        'assets/images/google_signin_dark.png',
                                        height: 20,
                                        width: 20,
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const ListTile(
                        leading: Icon(Icons.menu),
                        title: Text('메뉴'),
                      ),
                      ListTile(
                        leading: const Icon(Icons.add),
                        title: const Text('바몬 추가(랜덤)'),
                        onTap: () async {
                          Navigator.of(context).pop(); // Drawer 먼저 닫기
                          final barMons = BarMonListNotifier.masterBarmonList;
                          final random = Random();
                          final randomBarMon = barMons[random.nextInt(barMons.length)];
                          if (_isGuest) {
                            await ref.read(guestBarmonProvider.notifier).addGuestBarmon(randomBarMon);
                            // 디버그: 추가 후 상태 출력
                            final guestList = ref.read(guestBarmonProvider);
                            debugPrint('[DEBUG] 게스트 바몬 추가 후 리스트:');
                            for (final b in guestList) {
                              debugPrint('  - ${b.id} / ${b.name}');
                            }
                            // SharedPreferences 저장값도 출력
                            final prefs = await SharedPreferences.getInstance();
                            final jsonStr = prefs.getString('guest_barmon_list');
                            debugPrint('[DEBUG] SharedPreferences guest_barmon_list: $jsonStr');
                          } else if (_userId != null) {
                            await ref.read(userBarmonProvider.notifier).addUserBarmon(randomBarMon, _userId!);
                          }
                        },
                      ),
                      const Spacer(),
                      if (!_isGuest)
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              icon: const Icon(Icons.link_off),
                              label: const Text('구글 계정 분리'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.orangeAccent,
                                foregroundColor: Colors.white,
                              ),
                              onPressed: _unlinkGoogleIdentity,
                            ),
                          ),
                        ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            icon: const Icon(Icons.logout),
                            label: const Text('로그아웃'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.redAccent,
                              foregroundColor: Colors.white,
                            ),
                            onPressed: _logout,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
      body: Stack(
        children: [
          PageView(
            controller: _pageController,
            scrollDirection: Axis.horizontal,
            children: [
              // 베이스 페이지(메인)
              BasePage(title: '메인', onMenu: _openDrawer),
              // 내 바몬 페이지
              MyBarmonPage(pageController: _pageController, onMenu: _openDrawer),
              // 배틀 아레나 페이지
              BattleArenaPage(onMenu: _openDrawer),
              // 바몬 스캔 페이지
              BarcodeScanPage(
                onScan: (barcode, scanType) async {
                  // 마스터 바몬 id 체크
                  final masterIds = BarMonListNotifier.masterBarmonIds;
                  if (!masterIds.contains(barcode)) {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('소환 불가'),
                        content: const Text('마스터 DB에 존재하지 않는 바몬입니다.'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: const Text('확인'),
                          ),
                        ],
                      ),
                    );
                    return;
                  }
                  final newBarMon = BarMon(
                    id: barcode,
                    name: '새 바몬',
                    engName: 'NewBarMon',
                    types: [BarMonType.normal],
                    level: 1,
                    exp: 0,
                    attack: 100,
                    defense: 100,
                    hp: 100,
                    speed: 0,
                    agility: 100,
                    luck: 100,
                    species: '야수형',
                    rarity: BarMonRarity.normal,
                    nature: '밸런스형',
                    trait: '기본',
                    potential: 50,
                    starGrade: 1,
                    attribute: '무',
                  );
                  if (_isGuest) {
                    await ref.read(guestBarmonProvider.notifier).addGuestBarmon(newBarMon);
                  } else if (_userId != null) {
                    await ref.read(userBarmonProvider.notifier).addUserBarmon(newBarMon, _userId!);
                  }
                  _pageController.jumpToPage(0);
                },
                title: '바몬 스캔',
                onMenu: _openDrawer,
              ),
            ],
          ),
        ],
      ),
    );
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
        await Supabase.instance.client.auth.refreshSession();
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
}

class _ScanEffect extends StatefulWidget {
  @override
  State<_ScanEffect> createState() => _ScanEffectState();
}

class _ScanEffectState extends State<_ScanEffect> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
    _animation = Tween<double>(begin: 0.1, end: 0.9).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final height = constraints.maxHeight;
        return Stack(
          children: [
            // 가운데 빨간 선
            Positioned(
              left: 0,
              right: 0,
              top: height / 2 - 1,
              child: Container(
                height: 2,
                color: Colors.redAccent,
              ),
            ),
            // 좌우로 움직이는 불빛
            AnimatedBuilder(
              animation: _animation,
              builder: (context, child) {
                return Positioned(
                  top: height * 0.15,
                  left: width * _animation.value,
                  child: Container(
                    width: 32,
                    height: height * 0.7,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.redAccent.withAlpha((255 * 0.0).round()),
                          Colors.redAccent.withAlpha((255 * 0.3).round()),
                          Colors.redAccent.withAlpha((255 * 0.0).round()),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }
}

// 내 바몬 페이지를 별도 위젯으로 분리
class MyBarmonPage extends ConsumerWidget {
  final PageController pageController;
  final VoidCallback onMenu;
  const MyBarmonPage({Key? key, required this.pageController, required this.onMenu}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final barMons = ref.watch(userBarmonProvider);
    // 게스트 모드일 때 guestBarmonProvider 사용
    final guestBarMons = ref.watch(guestBarmonProvider);
    final isGuest = (ModalRoute.of(context)?.settings.arguments as Map?)?['guest'] == true;
    final list = isGuest ? guestBarMons : barMons;
    debugPrint('[DEBUG] MyBarmonPage 빌드: 바몬 개수: ${list.length}');
    for (final b in list) {
      debugPrint('  - ${b.id} / ${b.name}');
    }
    return BasePage(
      title: '내 바몬',
      onMenu: onMenu,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.separated(
          itemCount: list.length,
          separatorBuilder: (context, index) => const SizedBox(height: 3),
          itemBuilder: (context, index) {
            final barMon = list[index];
            return BarMonCard(barMon: barMon, onTap: () {
              Navigator.of(context).push(
                PageRouteBuilder(
                  opaque: false,
                  barrierColor: Colors.transparent,
                  pageBuilder: (context, animation, secondaryAnimation) =>
                    Material(
                      color: Colors.transparent,
                      child: BarMonDetailSwiper(
                        barMons: list,
                        initialIndex: index,
                      ),
                    ),
                  transitionsBuilder: (context, animation, secondaryAnimation, child) {
                    return FadeTransition(
                      opacity: animation,
                      child: ScaleTransition(
                        scale: Tween<double>(begin: 0.95, end: 1.0).animate(
                          CurvedAnimation(parent: animation, curve: Curves.easeOut)),
                        child: child,
                      ),
                    );
                  },
                ),
              );
            });
          },
        ),
      ),
    );
  }
}
