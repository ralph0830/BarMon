// 내 바몬 리스트 페이지 (스캔 버튼 포함)
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/barmon_provider.dart';
import '../widgets/barmon_card.dart';
import 'barmon_detail_page.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

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

  void _onScan(String barcode) async {
    setState(() { _showCamera = false; });
    // 바몬 소환
    ref.read(barMonListProvider.notifier).addBarMonFromScan(
      barcode: barcode,
      accountId: 'demo_user', // 실제 서비스에서는 계정 정보 사용
    );
    // 소환 이펙트
    setState(() {
      _isSummoning = true;
      final barMon = ref.read(barMonListProvider).last;
      _summonName = barMon.name;
    });
    await Future.delayed(const Duration(seconds: 2));
    setState(() { _isSummoning = false; _summonName = null; });
    // 리스트로 이동
    _pageController.jumpToPage(0);
  }

  @override
  Widget build(BuildContext context) {
    final barMons = ref.watch(barMonListProvider);
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
                      child: ListView.builder(
                        itemCount: barMons.length,
                        itemBuilder: (context, index) {
                          final barMon = barMons[index];
                          return BarMonCard(barMon: barMon, onTap: () {
                              showDialog(
                                context: context,
                                barrierDismissible: true,
                                builder: (context) => Center(
                                  child: FractionallySizedBox(
                                    widthFactor: 0.9,
                                    heightFactor: 0.9,
                                    child: Material(
                                      color: Colors.transparent,
                                    child: BarMonDetailPage(barMon: barMon),
                                    ),
                                  ),
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
                        color: Colors.black.withOpacity(0.7),
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
                                  Text('바몬 소환!', style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold)),
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
                          Colors.redAccent.withOpacity(0.0),
                          Colors.redAccent.withOpacity(0.3),
                          Colors.redAccent.withOpacity(0.0),
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
