// 내 바몬 리스트 페이지 (스캔 버튼 포함)
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/user_barmon_provider.dart';
import '../widgets/barmon_card.dart';
import 'barmon_detail_page.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/barmon.dart';
import '../guest_barmon_provider.dart';

class BarmonListPage extends ConsumerStatefulWidget {
  const BarmonListPage({super.key});
  @override
  ConsumerState<BarmonListPage> createState() => _BarmonListPageState();
}

class _BarmonListPageState extends ConsumerState<BarmonListPage> {
  final PageController _pageController = PageController();
  bool _showCamera = false;
  bool _isSummoning = false;
  String? _summonName;
  bool _initialized = false;

  String? get _userId => Supabase.instance.client.auth.currentUser?.id;
  bool get _isGuest => (ModalRoute.of(context)?.settings.arguments as Map?)?['guest'] == true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized && !_isGuest && _userId != null) {
      Future.microtask(() => ref.read(userBarmonProvider.notifier).fetchUserBarmons(_userId!));
      _initialized = true;
    }
  }

  void _onScan(String barcode) async {
    setState(() { _showCamera = false; });
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
    setState(() {
      _isSummoning = true;
      _summonName = newBarMon.name;
    });
    await Future.delayed(const Duration(seconds: 2));
    setState(() { _isSummoning = false; _summonName = null; });
    _pageController.jumpToPage(0);
  }

  @override
  Widget build(BuildContext context) {
    final barMons = _isGuest ? ref.watch(guestBarmonProvider) : ref.watch(userBarmonProvider);
    // 디버그: 각 바몬의 id와 imageUrl 출력
    for (final barMon in barMons) {
      debugPrint('BarMon id: [33m[1m[4m${barMon.id}[0m, imageUrl: [36m${barMon.imageUrl}[0m');
    }
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      body: Stack(
        children: [
          PageView(
            controller: _pageController,
            scrollDirection: Axis.horizontal,
            children: [
              // 내 바몬 리스트 페이지
              Column(
                children: [
                  AppBar(
                    title: Row(
                      children: [
                        const Text('내 바몬'),
                        const Spacer(),
                        IconButton(
                          icon: const Icon(Icons.qr_code_scanner, color: Colors.black87),
                          tooltip: '바코드 스캔',
                          onPressed: () => _pageController.animateToPage(1, duration: const Duration(milliseconds: 300), curve: Curves.ease),
                        ),
                      ],
                    ),
                    backgroundColor: Colors.white,
                    elevation: 0,
                    foregroundColor: Colors.black87,
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: ListView.separated(
                        itemCount: barMons.length,
                        separatorBuilder: (context, index) => const SizedBox(height: 3),
                        itemBuilder: (context, index) {
                          final barMon = barMons[index];
                          return BarMonCard(barMon: barMon, onTap: () {
                            Navigator.of(context).push(
                              PageRouteBuilder(
                                opaque: false,
                                barrierColor: Colors.transparent,
                                pageBuilder: (context, animation, secondaryAnimation) =>
                                  Material(
                                    color: Colors.transparent,
                                    child: BarMonDetailSwiper(
                                      barMons: barMons,
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
                  ),
                ],
              ),
              // 바몬 스캔 페이지
              Stack(
                children: [
                  Column(
                    children: [
                      // 상단 30%: 카메라 영역 (닫힘/열림)
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 400),
                        curve: Curves.ease,
                        height: _showCamera ? MediaQuery.of(context).size.height * 0.3 : 0,
                        width: double.infinity,
                        child: _showCamera
                          ? Stack(
                              children: [
                                MobileScanner(
                                  onDetect: (capture) {
                                    final barcode = capture.barcodes.first.rawValue;
                                    if (barcode != null && !_isSummoning) {
                                      _onScan(barcode);
                                    }
                                  },
                                ),
                                // 스캔 이펙트: 가운데 빨간 선 + 좌우로 움직이는 불빛
                                _ScanEffect(),
                              ],
                            )
                          : null,
                      ),
                      // 스캔 버튼
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 32),
                        child: ElevatedButton.icon(
                          icon: const Icon(Icons.qr_code_scanner),
                          label: Text(_showCamera ? '카메라 닫기' : '스캔 시작'),
                          onPressed: () {
                            setState(() { _showCamera = !_showCamera; });
                          },
                        ),
                      ),
                      const Spacer(),
                      const Text('바코드를 스캔하면 새로운 바몬이 소환됩니다!', style: TextStyle(fontSize: 16)),
                      const SizedBox(height: 32),
                    ],
                  ),
                  // 소환 이펙트(간단한 FadeIn+Scale)
                  if (_isSummoning && _summonName != null)
                    Positioned.fill(
                      child: Container(
                        color: Colors.black.withAlpha((255 * 0.7).round()),
                        child: Center(
                          child: AnimatedScale(
                            scale: _isSummoning ? 1.2 : 0.8,
                            duration: const Duration(milliseconds: 600),
                            child: AnimatedOpacity(
                              opacity: _isSummoning ? 1.0 : 0.0,
                              duration: const Duration(milliseconds: 600),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(Icons.auto_awesome, color: Colors.amber, size: 80),
                                  const SizedBox(height: 24),
                                  const Text('바몬 소환!', style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold)),
                                  const SizedBox(height: 12),
                                  Text(_summonName!, style: const TextStyle(color: Colors.white, fontSize: 22)),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
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
