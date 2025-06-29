// 바코드 스캔 화면 (mobile_scanner 사용)
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/item_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'base_page.dart';

class BarcodeScanPage extends ConsumerStatefulWidget {
  final void Function(String barcode, String scanType) onScan;
  final String title;
  final VoidCallback onMenu;
  const BarcodeScanPage({super.key, required this.onScan, required this.title, required this.onMenu});

  @override
  ConsumerState<BarcodeScanPage> createState() => _BarcodeScanPageState();
}

class _BarcodeScanPageState extends ConsumerState<BarcodeScanPage> {
  DateTime? _lastAdScan;
  bool _isAdCameraOpen = false;
  bool _isItemCameraOpen = false;
  bool _isSpecialCameraOpen = false;

  String? get _userId => Supabase.instance.client.auth.currentUser?.id;

  Duration get _adCooldown {
    if (_lastAdScan == null) return Duration.zero;
    final passed = DateTime.now().difference(_lastAdScan!);
    return passed >= const Duration(hours: 1)
        ? Duration.zero
        : const Duration(hours: 1) - passed;
  }

  void _startAdCooldown() {
    setState(() {
      _lastAdScan = DateTime.now();
    });
  }

  void _onScanResult(String barcode, String scanType) {
    setState(() {
      _isAdCameraOpen = false;
      _isItemCameraOpen = false;
      _isSpecialCameraOpen = false;
    });
    widget.onScan(barcode, scanType);
  }

  @override
  Widget build(BuildContext context) {
    final userId = _userId ?? 'guest';
    final item = ref.watch(itemProvider(userId));
    final adCooldown = _adCooldown;
    final adAvailable = adCooldown == Duration.zero;
    final filmAvailable = item.film > 0;
    final specialAvailable = item.specialFilm > 0;
    return BasePage(
      title: widget.title,
      onMenu: widget.onMenu,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // 광고 스캔 카드
            _ScanCard(
              title: '광고 스캔',
              description: '광고를 시청하고 바몬을 소환하세요! (1시간 쿨타임)',
              icon: Icons.ondemand_video,
              color: Colors.redAccent,
              laserColor: Colors.red,
              buttonText: adAvailable ? (_isAdCameraOpen ? '카메라 닫기' : '광고 보고 스캔') : '쿨타임: ${_formatDuration(adCooldown)}',
              enabled: adAvailable,
              isCameraOpen: _isAdCameraOpen,
              onCameraClose: () => setState(() => _isAdCameraOpen = false),
              onScan: (barcode) => _onScanResult(barcode, 'ad'),
              onPressed: () {
                if (_isAdCameraOpen) {
                  setState(() => _isAdCameraOpen = false);
                } else {
                  _startAdCooldown();
                  setState(() {
                    _isAdCameraOpen = true;
                    _isItemCameraOpen = false;
                    _isSpecialCameraOpen = false;
                  });
                }
              },
            ),
            const SizedBox(height: 5),
            // 아이템 스캔 카드
            _ScanCard(
              title: '아이템 스캔',
              description: '바몬 필름을 사용해 스캔! (남은 수량: ${item.film})',
              icon: Icons.camera,
              color: Colors.blueAccent,
              laserColor: Colors.blue,
              buttonText: _isItemCameraOpen ? '카메라 닫기' : '필름 사용 스캔',
              enabled: filmAvailable,
              isCameraOpen: _isItemCameraOpen,
              onCameraClose: () => setState(() => _isItemCameraOpen = false),
              onScan: (barcode) {
                ref.read(itemProvider(userId).notifier).useFilm();
                _onScanResult(barcode, 'film');
              },
              onPressed: () {
                if (_isItemCameraOpen) {
                  setState(() => _isItemCameraOpen = false);
                } else {
                  setState(() {
                    _isAdCameraOpen = false;
                    _isItemCameraOpen = true;
                    _isSpecialCameraOpen = false;
                  });
                }
              },
            ),
            const SizedBox(height: 5),
            // 특수 스캔 카드
            _ScanCard(
              title: '특수 스캔',
              description: '특수필름을 사용해 스캔! (남은 수량: ${item.specialFilm})',
              icon: Icons.star,
              color: Colors.amber,
              laserColor: Colors.yellow,
              buttonText: _isSpecialCameraOpen ? '카메라 닫기' : '특수필름 사용 스캔',
              enabled: specialAvailable,
              isCameraOpen: _isSpecialCameraOpen,
              onCameraClose: () => setState(() => _isSpecialCameraOpen = false),
              onScan: (barcode) {
                ref.read(itemProvider(userId).notifier).useSpecialFilm();
                _onScanResult(barcode, 'special');
              },
              onPressed: () {
                if (_isSpecialCameraOpen) {
                  setState(() => _isSpecialCameraOpen = false);
                } else {
                  setState(() {
                    _isAdCameraOpen = false;
                    _isItemCameraOpen = false;
                    _isSpecialCameraOpen = true;
                  });
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  String _formatDuration(Duration d) {
    final h = d.inHours;
    final m = d.inMinutes % 60;
    final s = d.inSeconds % 60;
    return '${h.toString().padLeft(2, '0')}:${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}' ;
  }
}

class _ScanCard extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final Color color;
  final Color laserColor;
  final String buttonText;
  final bool enabled;
  final bool isCameraOpen;
  final VoidCallback onCameraClose;
  final void Function(String barcode) onScan;
  final VoidCallback onPressed;

  const _ScanCard({
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    required this.laserColor,
    required this.buttonText,
    required this.enabled,
    required this.isCameraOpen,
    required this.onCameraClose,
    required this.onScan,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: SizedBox(
            height: 160,
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 350),
              child: isCameraOpen
                  ? _CardCameraPreview(
                      laserColor: laserColor,
                      onScan: onScan,
                      onClose: onCameraClose,
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(icon, color: color, size: 36),
                            const SizedBox(width: 12),
                            Text(title, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: color)),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(description, style: const TextStyle(fontSize: 15, color: Colors.black87)),
                        const SizedBox(height: 16),
                        Center(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: enabled ? color : Colors.grey[300],
                              foregroundColor: Colors.white,
                              minimumSize: const Size(160, 44),
                              textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            onPressed: enabled ? onPressed : null,
                            child: Text(buttonText),
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        ),
      ),
    );
  }
}

class _CardCameraPreview extends StatefulWidget {
  final Color laserColor;
  final void Function(String barcode) onScan;
  final VoidCallback onClose;
  const _CardCameraPreview({required this.laserColor, required this.onScan, required this.onClose});

  @override
  State<_CardCameraPreview> createState() => _CardCameraPreviewState();
}

class _CardCameraPreviewState extends State<_CardCameraPreview> with SingleTickerProviderStateMixin {
  bool _scanned = false;
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final width = constraints.maxWidth;
          final height = constraints.maxHeight;
          return Stack(
            children: [
              SizedBox(
                width: double.infinity,
                height: double.infinity,
                child: MobileScanner(
                  onDetect: (capture) {
                    if (_scanned) return;
                    final barcode = capture.barcodes.first.rawValue;
                    if (barcode != null) {
                      setState(() => _scanned = true);
                      widget.onScan(barcode);
                    }
                  },
                ),
              ),
              // 가운데 깜빡이는 레이저
              AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  final opacity = 0.5 + 0.5 * (1 - (_controller.value - 0.5).abs() * 2); // 0~1 반복
                  return Positioned(
                    left: 0,
                    right: 0,
                    top: height / 2 - 2,
                    child: Opacity(
                      opacity: opacity,
                      child: Container(
                        height: 4,
                        decoration: BoxDecoration(
                          color: widget.laserColor,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                  );
                },
              ),
              // 좌우로 움직이는 하이라이트
              AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  final left = width * _controller.value;
                  return Positioned(
                    top: height * 0.15,
                    left: left,
                    child: Container(
                      width: 24,
                      height: height * 0.7,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            widget.laserColor.withAlpha(0),
                            widget.laserColor.withAlpha((255 * 0.3).round()),
                            widget.laserColor.withAlpha(0),
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  );
                },
              ),
              // 닫기 버튼
              Positioned(
                top: 8,
                right: 8,
                child: IconButton(
                  icon: const Icon(Icons.close, color: Colors.white, size: 28),
                  onPressed: widget.onClose,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
