// 바몬 카드 위젯 (리스트용)
import 'package:flutter/material.dart';
import '../models/barmon.dart';

class BarMonCard extends StatelessWidget {
  final BarMon barMon;
  final VoidCallback? onTap;
  const BarMonCard({super.key, required this.barMon, this.onTap});

  // --- 유틸 함수: 속성별 색상, 어둡게/밝게 변환 ---
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

  Color getDarkTypeColor(BarMonType type) {
    final base = getTypeColor(type);
    final hsl = HSLColor.fromColor(base);
    return hsl.withLightness((hsl.lightness * 0.7).clamp(0.0, 1.0)).toColor();
  }

  Color getBrightTypeColor(BarMonType type) {
    final base = getTypeColor(type);
    final hsl = HSLColor.fromColor(base);
    // 화이트에 가깝게(명도 0.95)
    return hsl.withLightness(0.95).toColor();
  }

  @override
  Widget build(BuildContext context) {
    final isSSR = barMon.rarity == BarMonRarity.legendary;
    final type = barMon.types.first;
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        height: 110, // 카드 높이 명시 (기존 96 → 110)
        child: Stack(
          children: [
            // 1. 최외각 프레임(3px, 속성별 어두운색)
            Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: getDarkTypeColor(type),
                  width: 3,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            // 2. 프레임 배경(SSR: 메탈릭, 그 외: 단색/그라데이션)
            Positioned.fill(
              child: Container(
                margin: const EdgeInsets.all(3),
                decoration: BoxDecoration(
                  gradient: isSSR
                      ? LinearGradient(
                          colors: [
                            const Color(0xFFB0BEC5),
                            Colors.white.withAlpha((255 * 0.7).round()),
                            const Color(0xFF757575),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        )
                      : LinearGradient(
                          colors: [
                            getTypeColor(type),
                            getBrightTypeColor(type),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                  borderRadius: BorderRadius.circular(17),
                ),
              ),
            ),
            // 3. 내용(정보 영역)
            Positioned.fill(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // 왼쪽: portrait 이미지
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.asset(
                        barMon.imageUrl,
                        width: 64,
                        height: 64,
                        fit: BoxFit.cover,
                        alignment: Alignment.center,
                      ),
                    ),
                  ),
                  // 오른쪽: 정보 (아주 밝은 속성색상)
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
                      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                      decoration: BoxDecoration(
                        color: getBrightTypeColor(type).withAlpha((255 * 0.92).round()),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    barMon.name,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    style: TextStyle(
                                      color: isSSR ? Colors.black : getDarkTypeColor(type),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    ),
                                  ),
                                ),
                                Text(
                                  barMon.rarity.displayName,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  style: TextStyle(
                                    color: barMon.rarity.color,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                  ),
                                ),
                                const SizedBox(width: 6),
                              ],
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            barMon.species,
                            style: TextStyle(
                              color: getDarkTypeColor(type).withAlpha((255 * 0.7).round()),
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              _StatIconText(label: 'HP', value: barMon.hp, icon: Icons.favorite, iconColor: Colors.red),
                              const SizedBox(width: 12),
                              _StatIconText(label: '공격', value: barMon.attack, icon: Icons.gavel, iconColor: Colors.blue),
                              const SizedBox(width: 12),
                              _StatIconText(label: '방어', value: barMon.defense, icon: Icons.shield, iconColor: Color(0xFF145A32)),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // 4. SSR 하이라이트 효과(예시: 빛나는 효과)
            if (isSSR)
              const Positioned.fill(child: AnimatedGlow()),
          ],
        ),
      ),
    );
  }
}

class _StatIconText extends StatelessWidget {
  final String label;
  final int value;
  final IconData icon;
  final Color iconColor;
  const _StatIconText({Key? key, required this.label, required this.value, required this.icon, required this.iconColor}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: iconColor, size: 16),
        const SizedBox(width: 2),
        Text('$value', style: const TextStyle(color: Colors.black, fontSize: 13)),
      ],
    );
  }
}

// 빛나는 효과 위젯 (SSR 하이라이트)
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
