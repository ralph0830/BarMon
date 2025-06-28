// 바몬 상세 페이지r
import 'package:flutter/material.dart';
import '../models/barmon.dart';

// 속성별 대표 색상 매핑 함수
Color getTypeColor(BarMonType type) {
  switch (type) {
    case BarMonType.grass:
      return const Color(0xFF78C850);
    case BarMonType.poison:
      return const Color(0xFFA040A0);
    case BarMonType.fire:
      return const Color(0xFFF08030);
    case BarMonType.water:
      return const Color(0xFF6890F0);
    case BarMonType.electric:
      return const Color(0xFFF8D030);
    case BarMonType.ground:
      return const Color(0xFFE0C068);
    case BarMonType.rock:
      return const Color(0xFFB8A038);
    case BarMonType.psychic:
      return const Color(0xFFF85888);
    case BarMonType.ice:
      return const Color(0xFF98D8D8);
    case BarMonType.bug:
      return const Color(0xFFA8B820);
    case BarMonType.dragon:
      return const Color(0xFF7038F8);
    case BarMonType.dark:
      return const Color(0xFF705848);
    case BarMonType.steel:
      return const Color(0xFFB8B8D0);
    case BarMonType.fairy:
      return const Color(0xFFEE99AC);
    case BarMonType.normal:
      return const Color(0xFFA8A878);
    case BarMonType.data:
      return Colors.blueGrey;
    case BarMonType.metal:
      return Colors.grey;
  }
}

class BarMonDetailPage extends StatefulWidget {
  final BarMon barMon;
  const BarMonDetailPage({super.key, required this.barMon});

  @override
  State<BarMonDetailPage> createState() => _BarMonDetailPageState();
}

class _BarMonDetailPageState extends State<BarMonDetailPage> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool _hideInfoOverlay = false;

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

  Color get mainColor {
    switch (widget.barMon.types.first) {
      case BarMonType.grass:
        return const Color(0xFFE8F5E9); // 밝은톤
      case BarMonType.poison:
        return const Color(0xFFF3E5F5);
      case BarMonType.fire:
        return const Color(0xFFFFEBEE);
      case BarMonType.water:
        return const Color(0xFFE3F2FD);
      case BarMonType.electric:
        return const Color(0xFFFFFDE7);
      case BarMonType.ground:
        return const Color(0xFFFFF8E1);
      case BarMonType.rock:
        return const Color(0xFFF5F5DC);
      case BarMonType.psychic:
        return const Color(0xFFFCE4EC);
      case BarMonType.ice:
        return const Color(0xFFE0F7FA);
      case BarMonType.bug:
        return const Color(0xFFF9FBE7);
      case BarMonType.dragon:
        return const Color(0xFFEDE7F6);
      case BarMonType.dark:
        return const Color(0xFFEEEEEE);
      case BarMonType.steel:
        return const Color(0xFFF5F5F5);
      case BarMonType.fairy:
        return const Color(0xFFFFF0F6);
      case BarMonType.normal:
        return const Color(0xFFF8F8F8);
      case BarMonType.data:
        return Colors.blueGrey.shade50;
      case BarMonType.metal:
        return Colors.grey.shade100;
    }
  }

  String get rarityLabel {
    switch (widget.barMon.rarity) {
      case BarMonRarity.normal:
        return 'N';
      case BarMonRarity.rare:
        return 'R';
      case BarMonRarity.superRare:
        return 'SR';
      case BarMonRarity.superSpecialRare:
        return 'SSR';
      case BarMonRarity.legendary:
        return 'SSR';
    }
  }

  Color get rarityColor {
    switch (widget.barMon.rarity) {
      case BarMonRarity.normal:
        return Colors.grey;
      case BarMonRarity.rare:
        return Colors.blue;
      case BarMonRarity.superRare:
        return Colors.purple;
      case BarMonRarity.superSpecialRare:
        return Colors.orange;
      case BarMonRarity.legendary:
        return Colors.orange;
    }
  }

  @override
  Widget build(BuildContext context) {
    final barMon = widget.barMon;
    final typeColor = getTypeColor(barMon.types.first);
    final isSSR = barMon.rarity == BarMonRarity.legendary;
    return Center(
      child: FractionallySizedBox(
        widthFactor: 1.0,
        heightFactor: 0.9,
          child: Stack(
            children: [
            // 프레임 전체 배경
            _CardFrameBackground(isSSR: isSSR, color: typeColor),
            // 내용(이미지, 능력치, 오버레이)
              Padding(
              padding: const EdgeInsets.fromLTRB(5, 56, 5, 80),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                    // 이미지 + 오버레이
                      Stack(
                        children: [
                        GestureDetector(
                          onTapDown: (_) => setState(() => _hideInfoOverlay = true),
                          onTapUp: (_) => setState(() => _hideInfoOverlay = false),
                          onTapCancel: () => setState(() => _hideInfoOverlay = false),
                          child: Container(
                            width: 320,
                            height: 320,
                            alignment: Alignment.center,
                            child: Hero(
                              tag: 'barmon_${barMon.id}',
                              child: Image.asset(
                                barMon.imageUrl,
                                width: 320,
                                height: 320,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                        if (!_hideInfoOverlay)
                          Positioned(
                            left: 0,
                            right: 0,
                            bottom: 0,
                            child: Center(
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    _InfoChip(label: '잠재력', value: barMon.potential.toString()),
                                    const SizedBox(width: 8),
                                    _InfoChip(label: '성격', value: barMon.nature),
                                    const SizedBox(width: 8),
                                    _InfoChip(label: '성향', value: barMon.trait),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      // 능력치 표
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _StatInfoTile(name: 'HP', value: barMon.hp),
                                _StatInfoTile(name: '공격력', value: barMon.attack),
                                _StatInfoTile(name: '방어력', value: barMon.defense),
                                _StatInfoTile(name: '민첩', value: barMon.agility),
                                _StatInfoTile(name: '행운', value: barMon.luck),
                              ],
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                children: [
                                  _StatBar(label: 'HP', value: barMon.hp),
                                  _StatBar(label: '공격력', value: barMon.attack),
                                  _StatBar(label: '방어력', value: barMon.defense),
                                  _StatBar(label: '민첩', value: barMon.agility),
                                  _StatBar(label: '행운', value: barMon.luck),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            // 상단바 텍스트/희귀도 Overlay
            Positioned(
              top: 0, left: 0, right: 0,
              child: Container(
                color: Colors.transparent,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
                    Text(
                      barMon.name,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 24,
                letterSpacing: 1.2,
                fontFamily: 'GmarketSansTTFBold',
              ),
            ),
                    _RarityBadge(rarity: barMon.rarity),
                  ],
                ),
              ),
            ),
            // 하단바 Overlay
            Positioned(
              left: 0, right: 0, bottom: 0,
              child: ClipPath(
      clipper: _BannerClipper(),
      child: Container(
        height: 80,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                  color: Colors.transparent,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                          Text(barMon.species, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                Row(
                  children: List.generate(6, (i) => Icon(
                              i < _getStarGrade(barMon) ? Icons.star : Icons.star_border,
                    color: Colors.amber,
                    size: 18,
                  )),
                ),
                const SizedBox(height: 2),
                          const Text('이 바몬에 대한 설명이 없습니다.', style: TextStyle(color: Colors.white, fontSize: 12)),
              ],
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                          getAttributeEmoji(barMon.attribute),
                style: const TextStyle(fontSize: 32),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// 메탈 그라데이션 유틸
LinearGradient metalGradient({double highlightX = -1}) {
  final stops = highlightX >= 0
      ? [0.0, (highlightX - 0.1).clamp(0.0, 1.0), highlightX.clamp(0.0, 1.0), (highlightX + 0.1).clamp(0.0, 1.0), 1.0]
      : [0.0, 0.5, 1.0];
  final colors = highlightX >= 0
      ? [
          const Color(0xFFB0BEC5),
          const Color(0xFFB0BEC5),
          Colors.white.withAlpha((255 * 0.8).round()),
          const Color(0xFFB0BEC5),
          const Color(0xFF757575),
        ]
      : [
          const Color(0xFFB0BEC5),
          Colors.white.withAlpha((255 * 0.5).round()),
          const Color(0xFF757575),
        ];
  return LinearGradient(
    colors: colors,
    stops: stops,
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}

// 1. 프레임 전체 배경 위젯
class _CardFrameBackground extends StatefulWidget {
  final bool isSSR;
  final Color color;
  const _CardFrameBackground({required this.isSSR, required this.color});
  @override
  State<_CardFrameBackground> createState() => _CardFrameBackgroundState();
}
class _CardFrameBackgroundState extends State<_CardFrameBackground> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _highlightAnim;
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(seconds: 2))..repeat();
    _highlightAnim = Tween<double>(begin: 0.0, end: 1.0)
      .animate(CurvedAnimation(
        parent: _controller,
        curve: const _HighlightPauseCurve(),
      ));
  }
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: AnimatedBuilder(
        animation: _highlightAnim,
        builder: (context, child) {
          return Container(
            decoration: BoxDecoration(
              gradient: widget.isSSR
                  ? metalGradient(highlightX: _highlightAnim.value)
                  : LinearGradient(
                      colors: [
                        widget.color.withAlpha(255),
                        widget.color.withAlpha(255),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
            ),
          );
        },
      ),
    );
  }
}

// 하단바 배너용 클리퍼 (ClipPath에서 사용)
class _BannerClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height - 20);
    path.quadraticBezierTo(size.width * 0.1, size.height, size.width * 0.2, size.height - 10);
    path.lineTo(size.width * 0.8, size.height - 10);
    path.quadraticBezierTo(size.width * 0.9, size.height, size.width, size.height - 20);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }
  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class _RarityBadge extends StatelessWidget {
  final BarMonRarity rarity;
  const _RarityBadge({required this.rarity});
  @override
  Widget build(BuildContext context) {
    String label;
    switch (rarity) {
      case BarMonRarity.normal:
        label = 'N';
        break;
      case BarMonRarity.rare:
        label = 'R';
        break;
      case BarMonRarity.superRare:
        label = 'SR';
        break;
      case BarMonRarity.superSpecialRare:
        label = 'SSR';
        break;
      case BarMonRarity.legendary:
        label = 'L';
        break;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: const BoxDecoration(
        color: Colors.black12,
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
      child: Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
    );
  }
}

class _StatInfoTile extends StatelessWidget {
  final String name;
  final int value;
  const _StatInfoTile({Key? key, required this.name, required this.value}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 24,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.black12,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(name, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
          ),
          const SizedBox(width: 8),
          Container(
            width: 28,
            height: 24,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text('$value', style: const TextStyle(fontSize: 14)),
          ),
        ],
      ),
    );
  }
}

class _StatBar extends StatelessWidget {
  final String label;
  final int value; // 0~100, 150 등
  const _StatBar({Key? key, required this.label, required this.value}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(label),
        SizedBox(
          width: 80,
          child: LinearProgressIndicator(
            value: (value / 150).clamp(0.0, 1.0),
            backgroundColor: Colors.grey[200],
            color: Theme.of(context).primaryColor,
          ),
        ),
        const SizedBox(height: 8),
      ],
    );
  }
}

int _getStarGrade(BarMon b) {
  if (b.rarity == BarMonRarity.legendary) return 5;
  if (b.rarity == BarMonRarity.superRare) return 4;
  if (b.rarity == BarMonRarity.superSpecialRare) return 3;
  if (b.attack + b.defense + b.hp > 300) return 2;
  return 1;
}

class _InfoChip extends StatelessWidget {
  final String label;
  final String value;
  const _InfoChip({Key? key, required this.label, required this.value}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final showLabel = label != '성격' && label != '성향';
    return Chip(
      label: Text(
        showLabel ? '$label: $value' : value,
        style: const TextStyle(fontSize: 12),
      ),
      backgroundColor: Colors.grey[200],
    );
  }
}

// 속성명에 맞는 이모지 반환 함수
String getAttributeEmoji(String attribute) {
  switch (attribute) {
    case '불':
      return '🔥';
    case '물':
      return '💧';
    case '땅':
      return '🌱';
    case '전기':
      return '⚡';
    case '얼음':
      return '❄️';
    case '독':
      return '☠️';
    case '철':
      return '⚙️';
    case '빛':
      return '🌟';
    case '어둠':
      return '🌑';
    case '야수형':
      return '🐾';
    case '비행형':
      return '🕊️';
    case '정령형':
      return '🧚';
    case '돌연변이형':
      return '🧬';
    case '식물':
      return '🌿';
    case '환상형':
      return '🦄';
    case '인공형':
      return '🤖';
    case '무속성':
      return '🔳';
    default:
      return '❔';
  }
}

// 빛나는 효과 위젯
class AnimatedGlow extends StatefulWidget {
  const AnimatedGlow({super.key});

  @override
  State<AnimatedGlow> createState() => _AnimatedGlowState();
}

class _AnimatedGlowState extends State<AnimatedGlow> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _anim;
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(seconds: 2))..repeat(reverse: true);
    _anim = Tween<double>(begin: 0.4, end: 1.0).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _anim,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            gradient: RadialGradient(
              colors: [
                Colors.amberAccent.withAlpha((255 * (_anim.value * 0.3)).round()),
                Colors.transparent,
              ],
              radius: 1.2,
              center: Alignment.center,
            ),
          ),
        );
      },
    );
  }
}

class _HighlightPauseCurve extends Curve {
  const _HighlightPauseCurve();
  @override
  double transform(double t) {
    if (t < 0.5) return 0.0; // 0~1초: 대기
    return (t - 0.5) * 2.0; // 1~2초: 0~1로 선형 증가
  }
}

// 바몬 상세 Swiper (PageView 기반)
class BarMonDetailSwiper extends StatefulWidget {
  final List<BarMon> barMons;
  final int initialIndex;
  const BarMonDetailSwiper({
    Key? key,
    required this.barMons,
    required this.initialIndex,
  }) : super(key: key);

  @override
  State<BarMonDetailSwiper> createState() => _BarMonDetailSwiperState();
}

class _BarMonDetailSwiperState extends State<BarMonDetailSwiper> {
  late PageController _controller;

  @override
  void initState() {
    super.initState();
    _controller = PageController(initialPage: widget.initialIndex, viewportFraction: 0.85);
  }

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      controller: _controller,
      itemCount: widget.barMons.length,
      itemBuilder: (context, index) {
        return AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            double value = 1.0;
            if (_controller.position.haveDimensions) {
              value = ((_controller.page ?? _controller.initialPage) - index).toDouble();
              value = (1 - (value.abs() * 0.15)).clamp(0.85, 1.0).toDouble();
            }
            return Center(
              child: Transform.scale(
                scale: value,
                child: BarMonDetailPage(barMon: widget.barMons[index]),
              ),
            );
          },
        );
      },
    );
  }
}

