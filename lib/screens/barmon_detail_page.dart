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
  late Animation<double> _glowAnim;
  bool _hideInfoOverlay = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
    _glowAnim = Tween<double>(begin: 0.5, end: 1.0).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
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
      case BarMonRarity.epic:
        return 'SR';
      case BarMonRarity.legend:
        return 'SSR';
    }
  }

  Color get rarityColor {
    switch (widget.barMon.rarity) {
      case BarMonRarity.normal:
        return Colors.grey;
      case BarMonRarity.rare:
        return Colors.blue;
      case BarMonRarity.epic:
        return Colors.purple;
      case BarMonRarity.legend:
        return Colors.orange;
    }
  }

  @override
  Widget build(BuildContext context) {
    final barMon = widget.barMon;
    final typeColor = getTypeColor(barMon.types.first);
    final isSSR = barMon.rarity == BarMonRarity.legend;
    return Center(
      child: FractionallySizedBox(
        widthFactor: 0.9,
        heightFactor: 0.9,
        child: AnimatedBuilder(
          animation: _glowAnim,
          builder: (context, child) {
            final borderColor = isSSR
                ? typeColor.withOpacity(_glowAnim.value)
                : typeColor;
            return Container(
              decoration: BoxDecoration(
                border: Border.all(color: borderColor, width: 4),
                borderRadius: BorderRadius.circular(24),
                color: Colors.white,
              ),
              child: child,
            );
          },
          child: Stack(
            children: [
              // 상단 프레임/라인/등급
              Positioned(
                top: 0, left: 0, right: 0,
                child: _CardTopFrame(
                  name: barMon.name,
                  rarity: barMon.rarity,
                  color: typeColor,
                ),
              ),
              // 좌/우 세로 라인
              Positioned(left: 0, top: 0, bottom: 0, child: _SideLine(color: typeColor)),
              Positioned(right: 0, top: 0, bottom: 0, child: _SideLine(color: typeColor)),
              // 하단 배너/프레임
              Positioned(
                bottom: 0, left: 0, right: 0,
                child: _CardBottomBanner(
                  species: barMon.species,
                  star: _getStarGrade(barMon),
                  description: '이 바몬에 대한 설명이 없습니다.',
                  color: typeColor,
                  attribute: barMon.attribute,
                ),
              ),
              // 카드 내용(이미지, 능력치 등)
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 56, 0, 80),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // 고정 크기 1:1 이미지 + 오버레이
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
                              child: Image.asset(
                                barMon.imageUrl,
                                width: 320,
                                height: 320,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          // 잠재력, 성격, 성향 (이미지 하단 중앙 오버레이)
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
                      // 이미지와 능력치 표 사이 여백 최소화
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
            ],
          ),
        ),
      ),
    );
  }
}

class _CardTopFrame extends StatelessWidget {
  final String name;
  final BarMonRarity rarity;
  final Color color;
  const _CardTopFrame({required this.name, required this.rarity, required this.color});
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        gradient: LinearGradient(
          colors: [color.withOpacity(0.8), color.withOpacity(0.4)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            left: 20,
            top: 12,
            child: Text(
              name,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 24,
                letterSpacing: 1.2,
                fontFamily: 'GmarketSansTTFBold',
              ),
            ),
          ),
          Positioned(
            right: 20,
            top: 12,
            child: _RarityBadge(rarity: rarity),
          ),
          // 대각선 라인 효과
          Positioned(
            right: 0,
            top: 0,
            child: Transform.rotate(
              angle: -0.2,
              child: Container(
                width: 80,
                height: 12,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SideLine extends StatelessWidget {
  final Color color;
  const _SideLine({required this.color});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 8,
      margin: const EdgeInsets.symmetric(vertical: 40),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color.withOpacity(0.2), color],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }
}

class _CardBottomBanner extends StatelessWidget {
  final String species;
  final int star;
  final String description;
  final Color color;
  final String attribute;
  const _CardBottomBanner({required this.species, required this.star, required this.description, required this.color, required this.attribute});
  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: _BannerClipper(),
      child: Container(
        height: 80,
        color: color,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(species, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                Row(
                  children: List.generate(6, (i) => Icon(
                    i < star ? Icons.star : Icons.star_border,
                    color: Colors.amber,
                    size: 18,
                  )),
                ),
                const SizedBox(height: 2),
                Text(description, style: const TextStyle(color: Colors.white, fontSize: 12)),
              ],
            ),
            const Spacer(),
            // 속성 이모지 표시
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                getAttributeEmoji(attribute),
                style: const TextStyle(fontSize: 32),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

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
      case BarMonRarity.epic:
        label = 'SR';
        break;
      case BarMonRarity.legend:
        label = 'SSR';
        break;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.black12,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(label, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
    );
  }
}

class _StatInfoTile extends StatelessWidget {
  final String name;
  final int value;
  const _StatInfoTile({required this.name, required this.value});
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
  const _StatBar({required this.label, required this.value});
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

class _StarRating extends StatelessWidget {
  final int grade; // 1~5
  const _StarRating({required this.grade});
  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(5, (i) => Icon(
        i < grade ? Icons.star : Icons.star_border,
        color: Colors.amber,
        size: 20,
      )),
    );
  }
}

int _getStarGrade(BarMon b) {
  if (b.rarity == BarMonRarity.legend) return 5;
  if (b.rarity == BarMonRarity.epic) return 4;
  if (b.rarity == BarMonRarity.rare) return 3;
  if (b.attack + b.defense + b.hp > 300) return 2;
  return 1;
}

class _InfoChip extends StatelessWidget {
  final String label;
  final String value;
  const _InfoChip({required this.label, required this.value});
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

String _rarityLabel(BarMonRarity rarity) {
  switch (rarity) {
    case BarMonRarity.normal:
      return 'N';
    case BarMonRarity.rare:
      return 'R';
    case BarMonRarity.epic:
      return 'SR';
    case BarMonRarity.legend:
      return 'SSR';
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

